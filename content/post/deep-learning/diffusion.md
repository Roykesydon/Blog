---
title: "Diffusion 入門"
date: 2023-10-23T00:27:55+08:00
draft: false
type: "post"
tags: ["computer-vision","deep-learning","machine-learning", "self-attention"]
categories : ["deep-learning"]
---

## 大致概念

屬於生成式 AI，一開始用在生成圖片，後來也有應用到諸如 NLP 等領域。

下文稱呼原圖為 sprite。

與 AutoEncoder 有點類似，先取得一張 sprite，隨著時間推進，每次都在圖片上加一層雜訊，反覆疊加，迭代多次後，就會得到一張難以看出原圖的雜訊。

從 sprite 到只能看出是一團雜訊並非是一步到位的過程。一開始沒有雜訊時可以看出原本的 sprite，一個迭代後可能可以勉強看出原本的 sprite，再幾個迭代後可能也還能看出原本的 outline，經過許多次後才會變成完全辨識不了的雜訊。

我們期望模型做的事情則是從 gaussian noise 逐步推回 sprite，同樣不是一步到位，而是讓模型預測上一個時間點的雜訊，相減後再逐步推回 sprite，這過程稱為 denoise。

## DDPM

實現 Diffusion 可能會有點 confusing，因為他實作上和上面說的不太相同。
在訓練的時候，我們會採樣三個東西：
1. 訓練圖片 (sprite)
2. 雜訊
3. 時間點 (t)

訓練階段的時候，我們會把「原始乾淨的圖片」和「雜訊」根據時間進行不同比例的相加 (混合)，t 越大，雜訊的比例越大。

模型預測的目標是前面 sample 出的雜訊。

這與前面說的概念相悖。按照前面的說法，對於時間點 t，應該是以一張加了 t-1 次雜訊的 sprite 作為輸入，再加上 t 所 sample 出的雜訊。

現在實作卻是原始乾淨的 sprite 直接根據時間點混和某個雜訊。

這背後的數學推導十分冗長，這裡不敘述，但需知道實作差異。

### Inference
在推論階段的時候，每次 denoise 後需要把圖片和額外 sample 的 noise 相加。這個 noise 和前面的 noise 一樣，都是從 mean=0, std=1 的 gaussian distribution 中 sample 出來的。

不加的話似乎還容易有 Mode Collapse 的現象。
看到一個說法是，模型喜歡吃圖片加上雜訊的圖像作為圖片，在圖片上加上 noise 似乎會更符合模型預期的輸入。

看了李弘毅的影片，也有基於隨機性的觀點。

生成式 Model 生成文章時永遠取機率最大的，不見得有更好的效果：

- 有研究是讓 Model 選機率最大的，結果容易生出反覆跳針的文章。

- 也有把人類寫的文章去餵給 Model 看，從他的角度看人類寫的下一個字的機率是多少，發現人類寫的文章很常出現一下機率高一下機率低的字。

- 某篇語音合成的文章需要在推論階段「啟用」dropout 才可以有好的結果。

Diffusion 也有可能成功的點是在於並非「一次到位」而是「N 次到位」。
從這樣的角度看，Diffusion 是 autoregressive 模型。

類似的作法也有 Mask-Predict，大致概念是從原本都是 Mask 的情境開始，將一些信心高的預測留住，信心低的保持為 Mask，一步步預測出所有資訊。

