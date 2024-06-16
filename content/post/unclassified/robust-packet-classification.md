---
title: "論文閱讀：Robust Packet Classification with Field Missing"
date: 2024-06-02T00:00:01+08:00
draft: false
description: ""
type: "post"
tags: ["packet classification", "networking"]
categories : ["unclassified"]
---

paper: [Robust Packet Classification with Field Missing](https://ieeexplore.ieee.org/document/9843560)

## Abstract

隨著網路規模成長，由於資源限制，用戶有時候得放棄 packet classification 中的一些欄位。
此外，某些欄位在某些網路中並不總是可用。

如果某些欄位遺失，傳統的 packet classification 方法就很難處理分類任務。

本文提出了一個新穎的模型來建構一個 robust packet classification 系統。

在分類氣的部分，作者採用 Recursive Flow Classification 來同步處理各種欄位。
然後用一個新的 worflow 來處理遺失欄位的問題。

作者還設計了兩個 complementary bitmap model 來加速 packet 和 flow 的匹配，還有一個 buffer 機制來進一步提高分類準確度。

實驗表明，當 field missing 機率低於 0.3 時，模型可以用 94% ~ 99.5% 的準確度對 packet 進行分類。

## Introduction

Packet classification 是將 packet 對應到 ruleset 並確定下一步處理方案的過程。
會先根據分類要求提取 packet 的欄位，然後對這些欄位匹配到優先序最高的 rule。

然而，由於網路規模的增長，packet classification 變得越來越困難。

- field missing 的情境：
  1. 用戶主動放棄欄位
    - 比如，一個 protocol 包含了多個 field，而網路設備只關注齊中的某些 field。這樣就可以放棄某些 field 的提取和匹配，好得到更高的性能。
    - 某些協定中的 optional field 也會導致此問題。
  2. 不可用的欄位
    - 在一些 autonomous network 中，有些欄位可能來自外部設備（比如感測器）
    - 因為來源資訊不穩定，可能會導致某些 field value 是 illegal 的，比如 undefined 或者 -1
      - 比如一個 wireless receiver 可能會因為訊號干擾而無法取得訊號，所以把「訊號強度」設為 -1。對於網路設備，-1 會當作 legal，但我們無法用於分類。

上面的問題沒辦法被 router 偵測到，因為 packet 依然是 complete 和 legal 的。

有三種傳統的 packet classification 方法：
1. decision tree
2. tuple space
3. recursive flow classification (RFC)

許多後來的模型都基於這些演算法。

之前有學者意識到如今 packet classification 越來越困難，在考量 cost 以及 field 的可用性的情況下，他們嘗試用 flow information 去 recover packet，使製作一個 robust 且 flexible 的 packet classification 系統產生可能性。

然而，該分類器最後沒有實現並用於 online case。

考慮到 RFC 對於 field processing 有很明顯的獨立性，作者設計了一個基於 RFC 的 online robust packet classifier，可以處理 field missing 的情況。

首先，作者用 RFC 處理帶有 miss fields 的封包，並且記錄 complete packet 的 flow information。
然後作者會把 field-missing packet 給分類到這些 flow，去猜 missing field 的值。

差別在於，作者是用 bitmap 把 packet match 到 flow，並提出用兩個 bitmap model 來加速 packet 和 flow 的匹配。

此外，由於資訊損失，所以分類失敗是不可避免的。透過設計一個 buffer 機制，有很大一部分的封包有很高的機率在 re-classification 後可以成功分類。

最後本文設計了一些實驗去分析和評估參數。
在不同的的 field missing probability 下，作者的模型可以達到 93% ~ 99.5% 的準確度。

## Proposed Model

分為三個 module：
1. RFC processing module
2. packet recovery module
3. buffer module

### RFC Processing Module
RFC 演算法會把 packet 的每個 field 獨立分類，先對每個 field 做 single constraint matching，然後再對他們做 "&" operation。

對於 complete packet，把所有 fields 的結果組合在一起，可以得到 matching rule。

但是如果有 filed missing，一些 "&" operation 就沒有辦法執行，導致這個過程被中斷。

對於這種情況，作者會把中斷時有的所有 result 拿來組合出一個近似的結果，充分利用已知訊息，以便下一步可以更好地 recover packet。

![](/Blog/images/unclassified/robust-packet-classification/fig1.jpg)

Fig. 1 的 field C 是 missing 的，所以圖中 3 個灰色的方塊會沒辦法往下做 "&" operation。但是我們可以用這三個 result 做 "&" operation，得出 packet 可能會 hit rule 3。

### Packet Recovery Module
不管 packet 有沒有 missing field，RFC 的結果都是 bitmap (像是 0100100011)。bitmap 的 length 就是 ruleset 中 rule 的總數。第 i 個 bit 是 1，就代表當前的 constraint  可以 match 到第 i 個 rule。

差別在於，對於 complete packet，bitmap 是準確的，對應的 rule 一定可以被 match 到。
而有 field missing 的 packet 的 bitmap 只是近似的，因為缺乏訊息，所以 constraint 被放鬆，因此，這樣的 bitmap 可能會有 false positive。bitmap 說有 1 的可能與 packet match 或不 match。

不過如果有某個 bit 對應 0，則一定不可以 match。

幸運的是，packet 在現有的網路中總是出現在 flow 裡。一個 packet 會帶有一個 field value，是 flow sequence number，被標作 $Seq_{pkt}$。他被用在相關的 flow 中，好排序 packet。

屬於同一個 flow 中的 packet field value 應該要一樣。換句話說，當對 flow 中的 packet 分類的時候，他們的 RFC 輸出應該要一樣。

所以，我們可以用一個 bitmap 來表示一個 flow。在這種情況下，recover packet (flow matching) 就變成了 search of bitmap。

![](/Blog/images/unclassified/robust-packet-classification/fig2.jpg)

Fig. 2 示範了用 bitmap 來實現 flow matching。

field-missing packet 近似出的結果在第一行。

因為沒有 false negative，如果近似是 0，那有 1 的可以排除掉。

然而還有個問題，就是 bitmap comparison 是一個很耗時的操作。作者提出了兩個 bitmap model 來加速這個過程。

#### Tree Model

![](/Blog/images/unclassified/robust-packet-classification/fig3.jpg)

做 BFS。

如果 bitmap 遇到 1 的話就左右都要往下搜，如果遇到 0 的話就只需要往左搜。

更新的話就是根據 flow 的 bitmap 繪製路徑，然後把 flow sequence number 加入到 leaf node。

#### Table Model
這種 Model 被用來處理包含有大量的 1 的 bitmap。

![](/Blog/images/unclassified/robust-packet-classification/fig4.jpg)

只需要訪問那些是 0 的 index，然後表上有的 flow 都排除掉即可。

以 110100 為例，只需要訪問 3, 5, 6 這三個 index。
然後可以對應到 1, 2, 3, 4, 5, 8, 9 這些 flow。

所以代表我們有可能的 flow 只有 6, 7, 10 這些剩下的。

他的搜尋過程比更新過程慢得多。

當有一個 complete packet 出現時，兩種 Model 都會更新，但當出現 field missing packet 時，會根據「1」的數量去選擇一種 Model 來匹配。

它稍微增加了更新時間並顯著減少了匹配時間。

###  Buffer Mechanism
無論用哪種 Model，最後會有三種 Case：
1. 沒有 match 到任何 flow
   - 它可能是 flow 的第一個 packet，也可能是前面的 packet 都不完整，這種情況要放在 buffer 等待重新分類。
2. match 到一個 flow
   - 由於忽略了一些 constraint，所以只找到一個 flow 不代表它一定正確。
   - ![](/Blog/images/unclassified/robust-packet-classification/fig5.jpg)
   - 可能會有一些封包被誤分類，通常是某些 flow 的前幾個 packet 被過早分類造成的。為了盡可能消除這種因素，會導入「Initial Range」，把 sequence number 小於某個 threshold 的 packet 給放在 buffer。
   - $Seq_{pkt} < L_e$
3. match 到多個 flow
    - 這種情況可以視作分類失敗，但是 flow information 可以幫助我們進一步分類這些 packet。
    - 比如 $Seq_{pkt}$ 不能夠和該 flow 現有的封包中的 maximum sequence number 差很多
      - 如果 $Seq_{pkt}$ 是 64，三個 flow 的 maximum sequence number 分別是 108, 12, 60，那屬於第三個 flow 的機率比另外兩個高。
    - $|Seq_{max}-Seq_{pkt}|>\Delta$ 會被濾掉
      - $\Delta$ 是一個 predifined threshold
    - 如果處理後的情況屬於 Case 1 或 Case 2，那就處理，否則就放到 buffer。

每個 packet 都有「maximum number of waiting packets」和「maximum number of waiting flows」的限制。

當有新的 flow 被記錄，就會把 buffer 中的 packet 重新匹配。

如果 packet 因為答到限制而被刪除時，也會被重新匹配。

如果 packet 依然沒有命中任何 flow 或是有多種 flow，就會被丟棄，並記錄為匹配失敗。

## Experiments

作者從 Classbench 中選擇 1000 條 rule，並且每條 rule 選擇 100 個相關的 packet 用來生成 flow。

然後根據 field missing probability 隨機刪除一些 field。

Classification accuracy 是用正確分類的 packet 數量除以總 packet 數量。

Recovery accuracy 是指 packet recovery module 的成功率。
