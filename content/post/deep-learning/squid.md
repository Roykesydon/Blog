---
title: "🦑SQUID🦑 論文閱讀"
date: 2024-03-31T00:27:55+08:00
draft: false
type: "post"
description: "非監督胸腔放射線成像異常檢測方法"
tags: ["computer-vision","deep-learning","machine-learning", "transformer", "attention", "self-attention"]
categories : ["deep-learning"]
---

paper: [SQUID: Deep Feature In-Painting for Unsupervised Anomaly Detection](https://arxiv.org/abs/2111.13495)

## Abstract

Radiography imaging protocols (放射線成像協定) 會專注於特定的身體區域，因此會在患者間產生大量相似的照片。

為了利用這種 structed information，作者提出了 Space-aware Memory Queues for In-painting and Detecting anomalies from radiography images (SQUID)，它可以把固有的人體結構分類為反覆出現的 pattern。

在推理狀態下，它可以識別圖片中的異常情況。

比較兩個 chest X-ray benchmark，SQUID 在非監督異常檢測上超越了 13 種 SOTA 方法至少 5 個百分點。

作者還創建了一個新的資料集 (DigitAnatomy)，該資料集結合了胸腔解剖學中的 spatial correlation 和 consistent shape 這兩個特性。

## Introduction
- 放射線成像和一般圖片的差別
    - 一般的 photographic imaging 和 radiography imaging 是不同的。一般的圖片物體，我們會假設 translation invariance (平移不變性)，無論貓在左右，都是貓。但是在放射線成像中，結構的相對位置和方向是辨別正常和異常的重要特徵。
    - 而且由於 radiography imaging protocols 以相當一致的方向評估患者，成像在不同的設備製造商、設施位置還有患者的情況下，都具有很大的相似性。像這樣反覆出現且一致的結構，有助於分析問題，是放射線成像的優勢。

有多項研究證明了許多先驗知識在增強深度學習模型性能上的優勢，比如添加 location features、修改目標函數還有約束相對於照片中 landmarks 的相對座標。

- 想解決的問題
    - 多達 80% 的臨床錯誤是由於放射科醫生漏掉異常而造成。
    - 本文想回答一個關鍵問題：有沒有辦法利用 anatomical patterns 的 consistency 和 spatial information，在沒有手動標註的情況下，加強深度學習模型的異常檢測能力？非監督的異常檢測只用健康的圖片進行訓練，不用疾病診斷或任何 label。

    

- SQUID 解決辦法
    - 本文不像先前的異常檢測方法，本文把 task 制定為 in-painting task (圖像修復)，好利用放射線成像的外觀、位置、布局。

    - 作者提出了 SQUID，在訓練過程中，模型可以透過空間中經常出現的 anoatomical patterns 來動態維護一個 visual pattern dictionary。

    - 由於解剖學的 consistency，健康成像中的身體區域會呈現類似的 visual pattern，使 unique pattern 的數量是可控的。

    - 在推理階段，由於 dictionary 不存在 anomaly pattern，因此如果存在異常，產生的放射線成像會和現實有所差距。因此，模型可以透過區分修復任務的品質來識別異常。

- 實驗假設
    - 異常檢測的成功基於兩個假設
        - 資料中很少異常圖片
        - 異常和正常有顯著不同

- 實驗
    - 在兩個大規模、公開的放射線成像資料集上實驗
      - ZhangLab
        - 在非監督方面贏 SOTA 超過 5 個百分點
      - Stanford CheXpert
        - 比最近的 13 種方法提高 10 個百分點

- 新資料集
  - 創建了 DigitAnatomy 資料集，闡明胸腔解剖結構的 spatial correlation 和 consistent shape。

- 貢獻總結
  - 在胸腔放射線成像的新非監督 SOTA 異常檢測方法
  - 新的綜合資料集
  - 發明新方法打敗主流非監督異常檢測方法

## Related Work
- Anomaly detection in natural imaging
    - 識別偏離正常資料分佈的罕見事件
    - 由於異常樣本的缺乏，後來的工作都制定為非監督學習問題
    - 大致分為兩類
      - reconstruction-based
        - 恢復原始輸入並分析重建誤差
      - density-based
        - 透過估計正常資料的分佈來預測異常
      - 不過這些方法都沒辦法解釋可能的異常，本文透過維護 visual pattern memory 來解決這個問題
- Anomaly detection in medical imaging
  - 基於監督學習的方法多半用於檢測特定種類的異常，比如腫瘤
  - 最近提出了一些無監督方法來檢測一般異常，和 GAN 有關，但是這些方法需要有關於異常種類的強大先驗知識和假設才能使增強有效
  - 和一般的照片不同，Radiography imaging protocols 生成具一致性的圖片，異常的變化比較微妙 (subtle)，檢測起來更具挑戰，作者利用放射線成像的特性，大大提高檢測性能。
- Memory networks
  - 過往有一些有關於把 Memory modules 納入神經網路的研究，其中有採用到 Memory Matrix。本文克服了 Memory matrix 的侷限性，並提出一種有效且高效率的的 memory queue。

## SQUID
### Overview
![](/Blog/images/deep-learning/SQUID/fig2.jpg)

- Feature extraction
  - 把圖片切成 N x N 個 non-overlapping patches，然後餵入一個 encoder 做特徵提取，這裡是用 CNN 提取，但要用其他 backbone 也可以

- Image reconstruction
  - 這裡會用 teacher 和 student generator
    - teacher
      - 直接用 encoder 的 feature 重建圖片
      - 本質上是 auto-encoder
      - 作為 regularizer 來避免 student generator 重複生成相同的正常圖片
    - student
      - 使用 in-painting block 增強後的 feature 來重建，最後會被用在 discrimination
    - 兩個 generator 會在每個 up-sampling level 用 knowledge distillation paradigm 來結合

- Anomaly discrimination
  - 在 adversarial learning 後，使用 discriminator 來區分正常和異常
  - 用 2 個 generator 來生成圖片，再用 discriminator 來區分，只有 student generator 會接收 discriminator 的梯度

### Inventing Memory Queue as Dictionary

- Motivation
  - Memory Matrix 被廣泛採用
    - Feature 會透過在 Memory matrix 做加權平均來強化
    - 缺點
      - 這樣的增強方法是對整張圖片的提出的特徵做的，丟棄了圖片中的 spatial information。導致他無法感知到放射線成像中的一致性結構
- Space-aware memory
  - 為了利用空間資訊，作者只將 patch 而不是整張圖片傳遞到 model，讓 patch 只能存取 Memory matrix 中對應到的區段，作者把這種策略稱為 Space-aware memory，而且還可以加快速度，因為不用存取整個 Memory matrix
- Memory queue
  - 在 learning-based Memory matrix 中，normal patterns 是由 matrix 中的 learned basis 組合而成，但組合出來的東西和現實照片的特徵總會有分佈差距，使後續的影像生成變得困難
  - 作者提出 memory queue，用來在訓練期間儲存真實的影像 feature，從而呈現和影像特徵相同的分佈。它在訓練期間會把先前看到的特徵直接複製到 queue
- Gumbel shrinkage
  - 控制 memory matrix 中 activated pattern 的數量是有利的，但如果用 hard shrinkage threashold 會無法處理找不到合適 entry 的情況。一種自然的解法是讓梯度流過前 k 個相似的 entry，其餘的不更新。但這樣又會導致未啟動的 entry 無法接收任何梯度並更新，因此提出了 Gumbel shrinkage schema
    - $w' = sg(hs(w,topk(w)) - \phi(w)) + \phi(w)$
      - $w$ 代表 feature 和 entry 的相似度
      - $sg(\cdot)$ 代表 stop-gradient，不計算輸入的梯度
      - $hs(\cdot, t)$ 代表 hard shrinkage，有個 threshold $t$
      - $\phi(\cdot)$ 代表 softmax
      - 這樣保留了 top k 作為 w 的最終結果，又用 softmax 對所有 entry 進行更新

### Formulating Anomaly Detection as In-painting
![](/Blog/images/deep-learning/SQUID/fig5.jpg)

- Motivation
  - Image in-painting 最初是用來恢復具有 neighboring context 的圖片區塊，因此根據此直覺，想把異常圖片修復成正常圖片來實現檢測
  - 在修復像素的時候，特別是用深度網路，容易有 boundary artifacts，在 pixel 級別的修復中，這些 boundary artifacts 會導致大量誤報
    - artifact 中翻好像是「偽影」，就是重建的時候會呈現有點像棋盤的效應
    - 作者選擇在 feature level 進行 in-painting，避開這問題
- In-painting block
  - 會先把每個 patch $F_{1,1}$ ~ $F_{w,h}$ 都先找到最接近的 normal patterns $N_{1,1}$ ~ $N_{w,h}$
  - 因為 N 是之前訓練資料中提取的特徵組成的，不受當前輸入影像的影響。為了導入輸入圖片的特徵，作者把 F 和 N 用 transformer block 來結合
    - 對於每個 patch $F_{i,j}$，會把其當作中心，用相鄰的 8 個 N patch 來重新定義 $F_{i,j}$，把這 8 個 N patch 作為 key 和 value，$F_{i,j}$ 作為 query
  - 最後會在 in-painting block 的前後做 point-wise convolution (1x1)
  
- Masked shortcut
  - 實驗結果表明，直接做 residual connection 會降低修復的性能，作者採用 random binary mask 在 training 期間 gate shortcut feature
    - $F'=(1-\delta)\cdot F + \delta \cdot inpaint(F)$
      - $\delta$~$Bernoulli(\rho)$
        - $\rho$ gating probability
  - 獲得 F' 後，原始的 F 會被更新進 memory
  - 在推論階段，會 disable shortcut，使 $F'=inpaint(F)$

### Anomaly Discrimination
- Discriminator 評估圖片現不現實，不現實表示異常
- 因為 Generator 只在正常圖片訓練，所以 Memory Queue 也只有 normal pattern
- 稍微總結
  - in-painting block 會把 patch 強化為相似的 normal feature
  - student generator 會根據 "normal" feature 重建出 "normal" image
  - 如果沒有異常的話，那 input 和重建的 image 在語意上應該相差很小
- 異常分數 $A$ 的算法
  - $A=\phi(\frac{D(G_s(E(I)))-\mu}{\sigma})$
    - $\phi(\cdot)$ 是 sigmoid function
    - $\mu$ 和 $\sigma$ 是根據 training samples 算出的異常分數的平均值和標準差

### Loss Function
- Generator
  - $\mathcal L_t = (I-G_t (E(I)))^2$
  - $\mathcal L_s = (I-G_s (E(I)))^2$
- Knowledge distillation
  - $\mathcal L_{dist} = \sum_{l}^{i=1} (F^i_t-F^i_s)^2$
    - $l$ 是 levels of features
- Adversarial loss
  - 類似 DCGAN
  - $\mathcal L_{gen} = log(1-D(G_s(E(I))))$
- Discriminator
  - $\mathcal L_{dis} = log(D(I)) + log(1-D(G_s(E(I))))$
  - 把 real image 機率拉高，把 fake image 機率拉低
- Total loss
  - minimize generative loss
    - $\lambda_t \mathcal L_t + \lambda_s \mathcal L_s + \lambda_{dist} \mathcal L_{dist} + \lambda_{gen} \mathcal L_{gen}$
  - maximize discriminative loss
    - $\lambda_{dis} \mathcal L_{dis}$

## Experiments
![](/Blog/images/deep-learning/SQUID/table1.jpg)
### New Benchmark
提出一個新資料集 - DigitAnatomy。。如果包含正確順序的阿拉伯數字 1~9 則視為正常，異常包括缺失、亂序、翻轉和 zero digit。

該資料集對於放射線成像尤其有利，原因如下:
1. spatial correlation and consistent shape
2. 放射線成像要標記需要專業知識，但數字容易 debug
3. 該資料集很容易就可以獲得模擬異常的 ground truth

### Public Benchmarks
- ZhangLab Chest X-ray
  - 包含健康和肺炎的影像
  - 訓練集
    - 1349 張正常
    - 3883 張異常
  - 測試集
    - 234 張正常
    - 390 張異常
  - 作者從訓練集隨機挑 200 張做為調整超參數的 validation set
  - 影像都調整為 128x128
- Stanford CheXpert
  - 對 front-view PA 影像進行評估，共有 12 種異常
  - 有 5249 張正常和 23671 張異常用作訓練
    - 使用和 ZhangLab 相同的超參數
  - 用訓練集的 250 張正常和 250 張異常進行測試

### Baselines and Metrics
考慮 13 個主要的 baseline
- 經典 UAD (unsupervised anomaly detection)
  - Auto-encoder、VAE
- 醫學影像的 SOTA
  - Ganomaly、f-AnoGAN、IF、SALAD
- 最近的 UAD
  - MemAE、CutPaste、M-KD、PANDA、PaDiM、IGD

除非有特別註明，不然都是從頭獨立訓練至少三次

## Results
### Interpreting SQUID on DigitAnatomy
![](/Blog/images/deep-learning/SQUID/fig6.jpg)

作者在 DigitAnatomy 的實驗中，故意注入異常到正常圖片中，測試模型是否可以重建正常圖片。

SQUID 重建出的圖片比其他 baseline 有更多有意義的訊息，主要歸功於 space-aware memory，其產生獨特的 pattern，而且和空間訊息相關聯。

一旦出現異常，in-painting block 會從字典中找出前 k 個相近的，把異常特徵增強到其對應的正常特徵，其他方法不具備此能力，所以他們重建出有缺陷的圖像。

GAN 傾向於重建訓練樣本平均得到的影像。
MemAE 受益於 Memory matrix，表現較好，但對於缺失數字的異常效果不佳。

### Benchmarking SQUID on Chest Radiography
#### Limitation
作者發現目前的 SQUID 沒辦法在像素層級精確定位異常。這可以理解，因為 SQUID 是一種非監督方法，不需要標註。

那些像素級別的異常檢測會遭遇放大雜訊的影響，但是由於 SQUID 是在特徵層級進行的，比像素級別更加 robust。

### Ablating Key Properties in SQUID
#### Component study
![](/Blog/images/deep-learning/SQUID/table2.jpg)

#### Hyper-parameter robustness
![](/Blog/images/deep-learning/SQUID/fig9.jpg)

#### Disease-free training requirement?
用於醫學異常檢測的非監督方法並不常見，因為所謂的 UAD 方法並不是「非監督」的，因為他們必須只在無疾病影像上作訓練。

在實踐中，要獲得健康圖片需要 manual annotation。

在訓練集中考慮 disease-free 從 100% - 50% 的情況，把 SQUID 的 robust 和另外三個 baseline 進行比較。

SQUID 的 memory queue 可以自動忽略少數的 anatomical patterns。

![](/Blog/images/deep-learning/SQUID/fig10.jpg)
