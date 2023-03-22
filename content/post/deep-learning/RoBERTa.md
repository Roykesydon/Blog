---
title: "RoBERTa 論文閱讀"
date: 2023-03-22T01:08:46+08:00
draft: false
type: "post"
tags: ["deep-learning","machine-learning", "transformer", "attention", "self-attention"]
categories : ["deep-learning"]
---

paper: [RoBERTa: A Robustly Optimized BERT Pretraining Approach](https://arxiv.org/abs/1907.11692)

## Abstract

發現 BERT 訓練不足，並且作者的模型在 4/9 的 GLUE 任務, RACE 和 SQuAD 取得 SOTA。

## Introduction

自監督的訓練方法帶來了顯著的性能提升，但要確定這一堆方法中的哪些方面貢獻最大，具備挑戰性。

訓練的計算量是昂貴的，使 fine-tune 受限，而且通常都是用不同大小的 private training data，使評估模型更加困難。

作者提出了對 BERT 預訓練的 replication study，包括對超參數的調整，以及對訓練集大小的仔細評估。

作者發現 BERT 訓練不足，並提出了一種改進方法，稱為 RoBERTa，可以達到或超過所有 post-BERT 的方法。

修改如下:
1. 訓練模型的時間更長，batch 更大，用更多 data
2. 移除 next sentence prediction objective
3. 訓練更長的序列
4. 動態地改變用於訓練資料的 masking pattern

貢獻:
1. 提出一組重要的 BERT 設計選擇和訓練策略
2. 使用了新的 dataset，叫做 CCNEWS，並證明用更多的資料來預訓練，可以提高下游任務的表現
3. 訓練表明，在正確的設計選擇下，pretrained masked language model 和其他最近的方法比，具有競爭力

## Background
對 BERT 做回顧

### Architecture
- L layers
- A self-attention heads
- H hidden dimension

### Training Objectives

預訓練的時候，BERT 有兩個目標: masked language modeling 和 next sentence prediction

#### Masked Language Model (MLM)
BERT 隨機選擇 15% 的 token 進行可能的替換

80% 換成 [MASK]，10% 保持不變，10% 被選為一個隨便的 vocabulary token

#### Next Sentence Prediction (NSP)
分類第二句是不是下一句，是二元分類。

正例由提取連續的句子產生，負例由不同的片段配對產生。

正例和負例以相等機率產生。

#### Optimization
- Adam
- $\beta_1$ = 0.9, $\beta_2$ = 0.999, $\epsilon$ = 1e-6
- $L_2$ weight decay of 0.01
- Learning rate 前 10,000 step warm up 到 1e-4，然後 linear decay
- 全部的 layer 和 attention weight 都 dropout 0.1
- GELU 激活函數
- 1,000,000 次 update，batch size 256，序列長度 512

#### Data
BERT 在 BookCorpus 和 English Wikipedia 混和的資料集上訓練，共有 16GB 的未壓縮文本

## Experimental Setup
描述對於 BERT 的 replication study 的實驗設置

### Implementation
作者用 FAIRSEQ 重新實現了 BERT。

主要遵循 [Background-Optimization] 中的 BERT 原始超參數，但 peak learning rate 和 warmup step 除外，他們針對每個設置單獨調整。

作者發現訓練對 Adam epsilon 非常敏感。

作者發現設置 $\beta_2$ = 0.98，在大 batch size 的情況下，可以提高訓練時的穩定性。

用最多 512 個 token 預訓練。

作者不會隨機注入短序列，也不會為前 90% 的更新縮短輸入的長度。

作者只訓練 full-length 的 sequences。

### Data
BERT-style 的預訓練仰賴大量文本。

已有研究證明增加數據量可以提高 end-task 的性能。

已有一些研究，用比原始 BERT 更多樣更大的數據集，但不是所有的數據集都有公開。

本研究用了五個不同大小和領域的英文文本，共有超過 160 GB 的未壓縮文本。

使用以下數據集:
- BookCorpus + English Wikipedia
    - BERT 原本使用的。
    - 16 GB
- CC-News
    - 作者從 CommonCrawl News dataset 的英文部分中蒐集，包含了 2016 年 9 月到 2019 年 2 月的 6300 萬篇英文新聞。
    - 過濾後有 76 GB
- OpenWebText
    - WebText 的開源重建版，從 Reddit 上至少有 3 個 upvotes 的 shared URLs 提取出的 Web 內容。
    - 38 GB
- Stories
    - 包含 CommonCrawl data 的一個子集合，經過過濾，以匹配 story-like style of Winograd schemas
    - 31 GB

###  Evaluation

使用以下三個 benchmarks 評估預訓練模型

#### GLUE
- The General Language Understanding Evaluation 

- 用於評估自然語言理解的 9 個數據集的集合，任務被定義為 single-sentence 分類或 sentence-pair 分類任務。
- finetune 的流程遵循原始 BERT paper

#### SQuAD
- The Stanford Question Answering Dataset

- 提供一段 context 以及一個問題
- 具有兩個版本 V1.1 和 V2.0
    - V1.1
        - context 總是包含一個答案
        - 評估 V1.1 的時候，作者採用和 BERT 相同的 span prediction method
    - V2.0
        - 一些問題在提供的 context 中沒有回答，使任務更有挑戰性
        - 評估 V2.0 的時候，作者會用一個額外的二元分類器預測問題是否可以回答，在評估的時候，只預測被分類為可回答的

#### RACE
- The ReAding Comprehension from Examinations
- 大型閱讀理解數據集，有超過 28,000 篇文章 以及將近 100,000 個問題
- 從中國的英文考試蒐集的，這些考試是為國中生和高中生設計的
- 每篇文章都與多個問題相關聯
- 對每個問題，要從四個選項中選出一個對的
- context 比起其他閱讀理解的數據集要長，而且要推理的問題比例很大

## Training Procedure Analysis
探討哪些選擇對成功預訓練 BERT 很重要。

作者把架構固定，也就是訓練和$BERT_{BASE}$ (L=12, H=768, A=12, 110M params)一樣架構的 BERT models