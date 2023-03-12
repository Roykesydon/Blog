---
title: "PatentSBERTa 論文閱讀"
date: 2023-03-12T00:08:46+08:00
draft: true
type: "post"
tags: ["deep-learning","machine-learning", "transformer", "attention", "self-attention"]
categories : ["deep-learning"]
---

paper: [PatentSBERTa: A Deep NLP based Hybrid Model for Patent Distance and Classification using Augmented SBERT](https://arxiv.org/abs/2103.11933)

## Abstract

本研究提供了一個計算  patent-to-patent (p2p) technological similarity 的有效方法。

並提出一個 hybrid framework，用於把 p2p 相似性的結果應用於 semantic search 和 automated patent classification。

把 Sentence-BERT (SBERT) 用在 claims 上來作 embeddings。

為了進一步提升 embedding 的品質，使用基於 SBERT 和 RoBERT 的 transformer model，然後再用 augmented approach 在  in-domain supervised patent claims data(相對於 out-domain) 來 fine-tune SBERT。

用 KNN(Nearest Neighbors) 來根據 p2p similarity 分類模型。


## Conclusion

本文使用  augmented SBERT  獲得 SOTA 的專利文本 embedding。

介紹了一種 augmented 的方法，把 SBERT 微調到適合 patent claims 的 domain。

SBERT 的一個主要優點是可以有效率地獲得 embedding distance，使我們能夠為大的專利資料集建構 p2p similarity。

雖然基於文本 p2p similarity 的有用性已經在各種應用方面得到證明，但本文進一步證明作者的 transformer-based p2p similarity 可以被用在 SOTA 的專利分類。

而且使用簡單的 KNN 方法，檢查他們可以使模型決策具備 understandable 和 explainable。