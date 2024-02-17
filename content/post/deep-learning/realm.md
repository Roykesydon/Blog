---
title: "REALM 論文閱讀"
date: 2024-01-05T00:00:13+08:00
draft: false
description: "改進預訓練方法的 ORQA"
type: "post"
tags: ["nlp","deep-learning","machine-learning"]
categories : ["deep-learning"]
---

paper: [REALM: Retrieval-Augmented Language Model Pre-Training](https://arxiv.org/abs/2002.08909)

## Abstract

為了用更加模組化和可解釋的方式獲取知識，作者用 latent knowledge retriever 來加強語言模型的預訓練，latent knowledge retriever 允許模型檢索 large corpus 的 document，並在預訓練、微調和推理時使用。

## Introduction

![](/Blog/images/deep-learning/REALM/fig1.jpg)

在諸如 BERT 的語言模型中，學到的 world knowledge 隱式地儲存在神經網路的參數中，使其很難確定儲存了哪些知識以及儲存在何處。而且儲存空間受網路大小限制，但訓練更大的網路可能非常昂貴

本文為了以更加可解釋和模組化的方式獲取知識，提出了一個新穎的框架，Retrieval-Augmented Language Model (REALM) 預訓練，透過 learned textual knowledge retriever 來加強預訓練

和把知識儲存在參數中的模型相比，該方法顯示地揭示 world knowledge 扮演的角色，做法是要求模型在推理過程中決定哪些知識來 retrieve，並用在推理階段

在每次預測前，語言模型使用 retriever 在 large corpus 搜索文件，並用這些文件幫助預測

End to End 的學習需要考慮整個檢索步驟，好進行反向傳播

REALM 有個關鍵直覺，就是訓練 retriever 的時候用的是 unsupervised text 的 performance-based signal：

- 一個可以提高語言模型複雜性的檢索是有幫助，且該被獎勵的
- 資訊不足的檢索應該受到懲罰

比如圖 Fig.1 找到的文件就該獲得獎勵

作者將 retrieve-then-predict 的方法建模並視作 latent variable language model 並優化 marginal likelihood


但在預訓練期間要訓練大規模的 retrieval module 成為問題，因為 Retriever 得為每個預訓練步驟考慮數百萬個候選文檔，而且必須根據決策反向傳播。為了解決這問題，作者建構了 retriever，以便快取和非同步更新每個文件的計算，並將最佳文件的選擇表示為 Maximum Inner Product Search (MIPS)

透過在 Open-QA 任務上使用 REALM 預訓練的 model 來 finetune 進行評估，OpenQA 是最 knowledge-intensive 的任務之一

作者挑了三個流行的 Open-QA benchmark，比如 NaturalQuestions-Open、WebQuestions、CuratedTrec，並和 SOTA Open-QA model 比較

在三個基準都取得了 SOTA 的結果，absolute accuracy 明顯高於先前系統 4-16%

也展示了 REALM 的 qualitative benefit，比如可解釋性和模組化

## Background
### Open-domain question answering (Open-QA)

OpenQA 的 open 是指模型不會接收到包含答案的預提供文件，和傳統的閱讀理解不同

## Approach

![](/Blog/images/deep-learning/REALM/fig2.jpg)

### REALM’s generative process

預訓練做 masked language modeling，微調的任務是 Open-QA

### Model architecture

neural knowledge retriever 是 $p(z|x)$

knowledge-augmented encoder 是 $p(y|z,x)$

#### Knowledge Retriever 

$p(z|x)=\frac{\text{exp }f(x,z)}{\sum_{z'}\text{exp }f(x,z')}$

$f(x,z) = Embed_{input}(x)^T Embed_{doc}(z)$

$join_{BERT}(x)=[CLS]x[SEP]$

$join_{BERT}(x_1, x_2)=[CLS]x_1[SEP]x_2[SEP]$

$Embed_{input}(x)=W_{input}BERT_{CLS}(join_{BERT}(x))$

$Embed_{doc}(z)=W_{doc}BERT_{CLS}(join_{BERT}(z_{title}, z_{body}))$

#### Knowledge-Augmented Encoder

Finetune:

$p(y|z,x) \propto \displaystyle\sum_{s\in S(z,y)}exp(MLP([h_{START(s)};h_{END(s)}]))$

$h_{START(s)}=BERT_{START(s)}(join_{BERT}(x,z_{body}))$

$h_{END(s)}=BERT_{END(s)}(join_{BERT}(x,z_{body}))$

### Training

關鍵的計算挑戰是 $p(y|x)=\sum_{z\in Z}p(y|x,z)p(z,x)$，涉及到 Z knowledge corpus 中的 所有 document z，因此只取機率 $p(z|x)$ 最高的 top k 文件來求和，考量到多數文件的機率應該為 0，這是合理的

但是依然需要一個有效的方法來尋找前 k 個文件

前面的 $f(x,z)$ 是一個內積，可以用  Maximum Inner Product Search (MIPS) 演算法來尋找近似前 k 個文檔

為了用 MIPS，要先用一種 embedding 函式來幫 z encode，但是如果更新了這個函式，資料結構和 $p(z|x)$ 又會不一致

因此，每次對 embedding 函式更新後，search index 都會變 "stale" (陳舊)

每隔數百個訓練步驟非同步重新 embed 和 index 所有 document 來刷新 index

MIPS 的 index 在刷新之前會有點 stale，但它只用於挑選前 k 個文件

結果證明，只要在恰當的刷新率下，還是可以穩定 optimize

#### What does the retriever learn?

這裡展示了它如何獎勵提高預測準確性的檢索

$\triangledown \text{log }p(y|x)=\displaystyle\sum_{z\in Z}r(z)\triangledown f(x,z)$

$r(z)=[\frac{p(y|z,x)}{p(y|x)}-1]p(z|x)$

如果 $r(z)$ 是正的，會讓 f(x,z) 提高，否則減低

$r(z)$ 只有在 $p(y|z,x)>p(y|x)$ 的情況下才會是正的

$p(y|x)$ 是 $p(y|x,z)$ 在隨機取樣的情況下的期望值

只要文檔 z 好過預期，就會持續正面更新

### Injecting inductive biases into pre-training

在發展 REALM 的過程中，作者發現幾個額外策略，可以進一步引導模型進行有意義的檢索

#### Salient span masking

有一些 MLM span 只需要 local context，但作者想專注於 world knowledge

所以作者會 mask 一些 salient span，比如「英國」、「1969 年 7 月」

作者用在 CoNLL-2003 上訓練的 BERT-based tagger，來找出 named entities，並用正規表達式來找出日期

結果表明這顯著優於其他 mask 策略

#### Null document

雖然 Salient span masking 表現很好，但不是所有 mask 都需要 world knowledge

透過向前 top k 文檔中多加一個空的文檔，允許在不需要檢索有空白選項

#### Prohibiting trivial retrievals

如果 mask 的句子來自文件 z，可以透過查看 z 中 x 的 unmasked 版本來輕鬆預測 y，使 p(z|x) 出現較大的梯度，如果這種情況太頻繁，會使 retriever 最終學會的東西偏向 exact match，而不會捕獲其他形式的相關性

因此，在預訓練期間排除了 trivial candidate

#### Initialization

在訓練開始時，如果 input 和 document 各自的 Embedding function 沒有良好的效能，會使檢索到的 z 和 x 無關

會導致模型學習忽略檢索到的文件，檢索器就不會收到有意義的梯度，也無法改進

為了避免 cold-start problem，作者採用 warm-start 方案，先以  Inverse Cloze Task (ICT) 這種簡單的目標來處理兩個 embedding function，給定一個句子，訓練模型檢索句子來自的文檔

## Experiments

![](/Blog/images/deep-learning/REALM/table1.jpg)

![](/Blog/images/deep-learning/REALM/table2.jpg)

### Open-QA Benchmarks
本文將重點放在問題作者不知道答案的資料集，比較能反映現實中的問題

#### NaturalQuestions-Open
由自然發生的 google 查詢和答案組成，每個答案還帶有 answer type

本文只用屬於 "short answer type" 的問題，最多有 5 個 token

#### WebQuestions
從 Google Suggest API 收集的

#### CuratedTrec
從 MSNSearch 和 AskJeeves 等網站上真實使用者查詢中提取的問答

### Approaches compared
#### Retrieval-based Open-QA

最近的一些方法提出用 MIPS index 來實現可訓練的檢索

ORQA 與 REALM 類似

但 REALM 提出了更新穎的模型預訓練步驟，並反向傳播到 MIPS index 中，而不用固定的 index

上面指的應該是有關於非同步更新 index 的部分，還可以梯度更新

值得注意的是，REALM 和 OrQA 的預訓練都是用 ICT 初始化的

#### Generation-based Open-QA

Open-QA 的新興替代方案是將其建模為序列預測任務，只需對問題進行編碼，然後根據編碼逐個標記編碼答案

GPT2 可以透過 sequence to sequence 直接產生答案，而不需要給指定的上下文，但可能由於缺乏 finetune 而沒有競爭力

同時，T5 表明，直接生成答案而不從給定上下文中明確提取是可行的方法，但他們只在提供上下文文檔的閱讀理解任務上進行實驗

為了和最具競爭力的 baseline 比較，本文與針對 Open-QA finetune 的 T5 進行比較

### Implementation Details

#### Fine-tuning

文件被貪婪地分割成多達 288 個 BERT wordpieces 的 chunk，產生超過 1300 萬個 retrieval candidates

在微調推理過程中，考慮前五個候選者

#### Pre-training 

使用 BERT 的預設優化器在 64 個 Google Cloud TPU 上預訓練 20 萬步

MIPS 在 16 個 TPU 上並行

### Main results

REALM 在 table.1 明顯優於之前的所有方法

REALM 最直接的比較是 ORQA，微調設定、超參數和訓練資料都相通

REALM 對比 ORQA 的改進純粹是更好的預訓練方法

而且本文表明他們的預訓練方法可以用在 single-corpus setting 或 seperate corpus setting

兩者的差別在 X 和 Z 來源一不一樣

### Analysis

table.2 展現了去除 REALM 關鍵組件後的結果

還展現了 finetune 前 gold answer 出現在前五個檢索中的頻率

#### Masking scheme

salient span masking 在先前標準的 BERT 訓練中尚未被證明具有影響力，但對於 REALM 至關重要

#### MIPS index refresh rate

在預訓練期間，運行並行過程來重新 embed document 和重建 MIPS index

導致每大約 500 個訓練步驟刷新一次 index

為了證明頻繁刷新的重要性，也和較慢刷新率比較

table.2 顯示，stale index 可能會傷害模型，進一步減少這種過時性可以提供更好的最佳化

## Discussion and Related Work

### Scalable grounded neural memory

document index 可以被視為一種 memory，key 是 document embedding

從這角度來看，本文的工作和 product key memory 有共同的動機，它能夠在記憶體網路中實現低於線性的存取

一個主要的區別是本文的記憶體是有根據的，每個 memory 都和一個文檔相關聯，而不是和 unnamed value vector 相關聯

這種程度的可解釋性對 Open-QA 至關重要，在這些應用程式中，用戶需要出處才能使預測答案值得信賴

## Future Work