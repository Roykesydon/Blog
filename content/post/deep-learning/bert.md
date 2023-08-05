---
title: "BERT 論文閱讀"
date: 2023-08-05T00:08:46+08:00
draft: false
type: "post"
tags: ["deep-learning","machine-learning", "transformer", "attention", "self-attention"]
categories : ["deep-learning"]
---

paper: [BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding](https://arxiv.org/abs/1810.04805)

現在回頭寫 BERT 論文筆記感覺有點怪，之前已經寫過什麼 RoBERTa 之類的。

不過現在因應實驗室讀書會要求，還是看一下論文也寫一下筆記。

## Abstract

本文提出了 BERT，一種基於 Transformer Bidirectional Encoder 的語言表示模型。

BERT 旨在透過 unlabeled text 進行 pretrain。

因此，只需要一個額外的輸出層就可以對預訓練的 BERT 進行微調，在各種任務上取得 SOTA。

## Introduction

「語言模型做預訓練」已被證明可以有效改善多種 NLP 任務。

將預訓練模型應用在下游任務，有兩種策略：
1. Feature-based
    - 把 pretrained 的 representations 作為額外的特徵
2. Fine-tuning
    - 根據特定任務引入額外參數，並簡單地微調所有參數

這兩種方法在預訓練期間共用同個 objective function，並用單向語言模型來學習 representation。

作者認為當前的技術限制了預訓練的表示能力，特別是在 Fine-tuning 方法上。

主要的問題在於語言模型是單向的，限制了預訓練期間可以使用的架構的選擇。這種單向的架構可能在一些任務有害，特別是對於那些需要兩個方向的 context 的任務。

本文提出的 BERT 改善了現有的 Fine-tuning 方法，用 Transformer 的 Bidirectional Encoder 來訓練語言模型。

BERT 透過受到 Cloze task（填空）啟發的 masked language model(MLM)，作為預訓練目標。MLM 隨機地遮蔽一些輸入的一些 token，目標是根據上下文來回推原詞，使 representation 可以融合左右兩邊的 context。

除了 MLM，作者還利用 next sentence prediction（NSP）任務來訓練 BERT。

本文貢獻如下：

- BERT 證明了雙向預訓練對 representation 的重要性。

- BERT 展現出預訓練的 representation 減少了許多針對 NLP 任務精心設計架構的需求。 BERT 是第一個基於 Fine-tuning，在大量 sentence-level 和 token-level 任務上取得 SOTA 的模型。

- BERT 推進了 11 個 NLP 任務的 SOTA。

## Related Work

### Unsupervised Feature-based Approaches

學習廣泛適用的 representation of words 一直是活躍的研究領域，甚至在非神經網路的領域也是。

預訓練的 word embeddings 與從頭訓練的 embedding 相比，有顯著改進。

這些方法頁被推廣到 coarser granularities，像是 sentence embedding 或是 paragraph embedding。

有研究證明 cloze task 提高了生成模型的 robustness。

## BERT

框架有兩步驟：
1. Pre-training
    - 在不同的預訓練任務中，用 unlabeled data 來 fine-tune。
2. Fine-tuning
    - 使用預訓練的參數初始化，在利用下游任務的 labeled data 對所有參數微調。

BERT 的一個特點是他具備跨不同任務的統一架構，預訓練架構和下游任務最終架構差異不大。

- Model Architecture
    - 本文表示方法
        - L: Transformer 的層數
        - H: hidden size
        - A: self-attention heads 的數量

    - model size
        - BASE: L=12, H=768, A=12, 110M parameters
            - 和 GPT 相同
        - LARGE: L=24, H=1024, A=16, 340M parameters

- Input/Output Representations
    - Input representation 可以在 token sequence 中明確表示單個 sentence 和一對 sentence。
        - sentence 可以是連續文本的任意範圍，而不是實際的句子。
        - sequence 是輸入的 token sequence，可以是單個 sentence 或是一對 sentence。
        - 每個 sequence 的第一個 token 始終是特殊的分類 token -- [CLS]
        - 對於兩個句子放在一個序列的情況，用 [SEP] 隔開

    - Token Embeddings
        - 作者使用 WordPiece embeddings，有 30000 個詞彙。

    - learned embedding
        - 對每個 token 添加這個東西，表示屬於 sentence A 還 sentence B
    

###  Pre-training BERT

#### Masked LM

直觀上，有理由相信深度的雙向模型會比單像串連起來的淺層模型更強大。

不幸的是 standard condition language model 只能單向訓練，因為雙向會允許每個單詞「間接看到自己」。

為了訓練 deep bidirectional representations，本文隨機遮蔽了一定比例的 tokens，並預測這些 token，這種方法稱為 masked language model，或常被稱為 cloze task。

作者會用 [MASK] 做預訓練，但有個問題是 [MASK] 在 fine-tuning 期間不會出現，造成預訓練和微調之間的 mismatching，為了緩減這種情況，並不會總是用 [MASK] 替代 masked token。

要替換 token 的時候，有 80% 的時間是 [MASK]，10% 是隨機 token，10% 是原本的 token。

#### Next Sentence Prediction (NSP)

許多重要下游任務，比如 Question Answering (QA) 和 Natural Language Inference (NLI) 是基於兩個句子間的關係。

NSP 就是為了理解句子間的關係而用的。

每次挑句子 A 和 B 的時候，有 50% 的機會 B 是 A 的下一個句子，有 50% 是隨機的。

針對 NSP 的預訓練對 QA 和 NLI 都很有用。

#### 預訓練資料

用 BookCorpus 和 English Wikipedia 來訓練 BERT。

對於 English Wikipedia，只提取 text passages，忽略 lists, tables, headers。

為了提取長的連續序列，用 document-level 的 corpus 而不是打亂的 sentence-level corpus 非常重要。

## Ablation Studies

### Effect of Pre-training Tasks

- No NSP
    - 只有 MLM
- LTR & No NSP
    - Left-to-Right
    - 只看左邊的 context

發現刪除 NSP 會顯著傷害對 QNLI 等資料集的性能。

LTR 在所有任務上都比 MLM 差。

雖然可以像 ELMo 單獨訓練 LTR 和 RTL，並且把他們結合起來

但有以下缺點：
- 比單向模型貴兩倍
- 對 QA 任務不直觀，因為 RTL 無法根據問題給出答案
- 不如深度雙向模型強大，因為其可以直接在每一層看到左右的 context

### Feature-based Approach with BERT

作者也研究了用 feature-based 的效果，發現具備競爭力。

在他的實驗中，用預訓練 Transformer 的 top 4 隱藏層的 token 串街效果最好。