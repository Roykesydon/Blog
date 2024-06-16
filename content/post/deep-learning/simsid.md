---
title: "SimSID 論文閱讀"
date: 2024-04-13T00:27:55+08:00
draft: false
type: "post"
description: "簡化 SQUID 的 in-painting block，把 Memory Queue 改成 Memory Matirx"
tags: ["computer-vision","deep-learning","machine-learning", "transformer", "attention", "self-attention"]
categories : ["deep-learning"]
---

paper: [Exploiting Structural Consistency of Chest Anatomy for Unsupervised Anomaly Detection in Radiography Images](https://arxiv.org/abs/2403.08689)

## 個人前言
這篇文章提出了許多在 SQUID 論文有出現過的的內容，特別是有關於放射線成像的描述等等，建議先看過 SQUID，重複的論點不再提及。

## Abstract

提出一種簡單的 Space-aware Memory，用於修復放射線成像的異常。

將異常檢定制定為 image reconstruction task，用 space-aware memory matrix 和 in-painting block 組成。

## Related Work

### Our Previous Work

相對於 SQUID，本文有以下四點改進：
1. 引入了新的符號、公式和圖表，以及詳細的方法說明及學習目標
2. 刪除 Memory Queue 和 Masked shortcut，簡化框架，還提高了效能
3. 在三種放射線成像任務勝過其他 21 種 SOTA 方法
4. 研究了 SimSID 對於 desease-free (訓練集中對異常資料的容忍) 的穩健性

## SimSID
![](/Blog/images/deep-learning/SimSID/fig2.jpg)

### Developing Space-aware and Hierarchical Memory

#### Space-aware memory
<!-- $\hat{z}_{i,j}= \sum^{N}_{k=1} G(s^{k})M^k_{i,j}$ -->
$\hat{z}_{i,j}$ (augmented feature) 

$=\displaystyle\sum^N_{k=1}G(s^{k})M^k_{i,j}$

$s^k$ 是做內積算出來的相似度

$G(\cdot)$ 是 Gumbel-softmax (用 SQUID 的 Gumbel Shrinkage)

$Memory Matrix$ 被拆成多個 block，才有 $M_{i,j}$

#### Hierarchical memory

在 encoder 最深處使用一個 memory matrix (in-painting block) 不足以重建具有細節的高品質圖像。

為了捕捉不同尺度的 anatomic patterns，提出在 generator 的多個 level 放置 space-aware memory。

研究發現，太多的 memory 會導致過度的 information filtering，還會 degrade 模型，導致他只會保留最具代表性的 normal pattern，而不是所有需要的 pattern。

這個問題可以透過添加 skip connection 來解決。

從經驗發現三個 memory matrix 就已足夠。

## Results
![](/Blog/images/deep-learning/SimSID/fig7.jpg)
### Benchmarking SimSID on Three Public Datasets
對於正常的情況， SimSID 可以在 memory 中找到相似的匹配，然後順利重建。

對於異常，將偽造的正常特徵強加到異常特徵，就會產生矛盾。

圖 7 繪製 Discriminator 的 heatmap 來指示出重建效果不佳的部分。
