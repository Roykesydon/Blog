---
title: "LangChain 筆記"
date: 2023-12-18T00:08:46+08:00
draft: false
description: "幫助 LLM 結合外部資料以及做出決策"
type: "post"
tags: ["deep-learning"]
categories: ["deep-learning"]
---

## 介紹

- ChatGPT 的缺陷

  - 沒有一定時間後的資料 (當時)
  - 沒有辦法連結外部私人資料 (e.g. Google Drive)

- LangChain 的優點
  - Integration
    - 可以連結外部資料
  - Agency
    - 讓 LLM 可以和環境互動，做出決策

## Components

### 結構

#### Schema

- 對話
  - System: 對話的 context
  - Human: 你的詢問
  - AI: AI 的回答

#### Document

- 儲存一段文字以集 metadata 的結構

#### Embedding

- OpenAIEmbeddings
  - 可以把文字轉換成向量，預設是 1536 維
  - 但是有最大長度限制

### 文字處理

#### Output Parser

讓模型重生你想要的格式，並轉換成你想要的結構，比如 json

### 資料儲存

#### Indexes

- Document_loaders

  - 可以從不同的來源獲得資料

- text_splitter

  - 把大量的文字切成多個 chunks

- retriever

  - 用來找到相近的文件

- VectorStores
  - Chroma
    - local storage

### 交互

#### PromptTemplate

- 用來往 String Template 填入變數
- 有些 Component 會和這個用法組合，所以不適合直接換成 f-string
- FewShotPromptTemplate
  - 可以用自己準備的一些例子結合 PromptTemplate 來做 Few-shot learning
  - 可以透過 FAISS 來找到最相近的例子

#### Chain

- 用在有多個有序的問題的情況
- multi-step workflow
- VectorDBQA
  - 可以用在搜索 local 的向量資料庫

- Instruction 結合 context 的模式 (Summarize)
  | 模式 | Stuffing | Map Reduce |Refine|Map-Rerank |
  | ---- | ------------------------------------ | ------------------------------------------------------------------------------------------------ | --- |---|
  | 說明 | 直接把 context 和 query 結合 | 把 Document 切成多塊 ，把每塊交給 LLM，轉換成 summary，反覆從這些 summary 生 summary | 每次切一小塊，並且和先前的結果做 summary| 讓每個 chunk 和 query 去生答案，並要模型對自己的答案評分，最後選分數高的 |
  | 優點 | 只需 call 一次 API、涵蓋所有資料 | 可以餵入更大的文件、可以平行運算 | 可以餵入更大的文件 | 對於簡單的問題可能比較有效|
  | 缺點 | 容易達到 token 上限 | call 多次 API、summary 的過程中會流失資訊 | call 多次 API、summary 的過程中會流失資訊| 沒有辦法結合多個 Document 的資訊|

#### Agent

- 有些應用中，你可能不知道該遵循什麼流程來讓 LLM 完成任務，這時候你會需要讓 LLM 自行決定要採取哪些動作以及採取的順序
- 可以動態地利用 Chain
- verbose=True 的時候會印出思考過程
- Tools
  - 有比如 Google Search 之類的 Tool 可以結合應用

#### Memory

- ConversationChain
- 讓 Chain 和 Agent 可以保留之前的對話

