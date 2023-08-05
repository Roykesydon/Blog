---
title: "GNN 介紹"
date: 2023-08-04T00:27:55+08:00
draft: false
type: "post"
tags: ["deep-learning","machine-learning", "graph"]
categories : ["deep-learning"]
---

## 圖簡介

- Graph
    - 表示 Entity (nodes) 間的 relations (edges)
    - 組成
        - Vertex attributes (V)
        - Edge attributes and directions (E)
        - Global attributes (U)
        - 下文簡稱 U, V, E


- 可以表示成圖的範例
    - Images
        - 相鄰 pixel 建無向邊
    - Text
        - 詞和下一個詞建單向邊
    - Molecules
        - 分子的連接處建無向邊
    - Social networks
        - 人和人之間建無向邊

## 定義問題

- 種類
    - Graph-level
    - Node-level
    - Edge-level
- 個別講的是基於什麼東西做分類，比如對每個人（node）分類一個陣營，就算 Node-level

## 挑戰

- 儲存邊的關係
    - 鄰接矩陣
        - 在節點多的情況下佔用空間大，而且可能非常稀疏
        - 同一張圖，換個點的順序後鄰接矩陣看起來就會不同
            - 難以保證這些東西餵入神經網路後輸出相同
            - 可以用兩個 list，一個儲存邊的向量，另一個是 Adjacency list，依序紀錄邊的關係
    - 稀疏矩陣
        - 難以用 GPU 運算

## Graph Neural Network

- GNN 是對圖上所有屬性的 optimizable transformation，而且可以保持 graph symmetries (permutation invariances，把 node 排序後結果不變)

- 下文用的 GNN 是 message passing neural network
    - graph-in, graph-out
    - 不改變圖的 connectivity

### 最簡單的 GNN

- U, V, E 個別餵給不同的 MLP，組成一個 GNN 的 layer
    - MLP 單獨餵入每一個點，不考慮連接訊息，保持了 graph symmetries

#### 預測

- 假如要對每個頂點做預測，最後再加個全連接層分類

#### pooling

- 假如要對一個沒有向量的頂點做預測，我們可以用 pooling，蒐集相鄰邊和全局向量的資訊
- 對於沒有頂點資訊的圖，我們可以用 pooling layer 獲取全部點的資訊，再做分類
- 對於沒有邊資訊的圖，我們也可以用 pooling 去從相鄰點和全局向量獲得資訊
- 對於沒有全局向量的圖，我們可以用 pooling 去從全部的點或邊獲得資訊

#### 缺陷

- 中間的 layer 沒有利用圖的訊息，都是各自進入各自的 MLP 做轉換

### Passing messages

在做轉換前，先做一些 pooling

#### 匯聚頂點資訊
- 不是單單把點向量進行轉換，而是和相鄰的點一起做 aggregation 後再做轉換
    - 如果 aggregation 是加總，和卷積有一點像，只不過是權重一樣的版本

#### 匯聚頂點和邊的資訊
- 可以先把頂點匯聚給邊，再把邊匯聚回頂點，反之亦然
    - 順序不同會導致不同結果
    - 兩種方法可以一起同步做，交替更新

### 全局資訊
- 每次 layer 只看鄰居，要傳遞到遠的點須要走很多層
- 導入 master node (context vector)，他連接了所有的點和邊

### 相關主題

- 採樣
    - 考量到計算梯度可能需要儲存過多的中間資訊，可以考慮採樣一些點，只在子圖上做計算

- Batch
    - 每個點鄰居各數不同，使做 batch 成為有挑戰性的問題。

- Inductive Bias
    - graph symmetries

- Aggregation
    - 目前沒有一個最佳選擇

- Graph Convolutional Network
    - node 是根據鄰居 node 去做某種 aggregate，事後再做更新
    - 由於每次都看鄰居，假如有 k 層，可以把圖看做解 n 個子圖，每個子圖就是基於每個點去走 k 步所形成的

- Graph Attention Network
    - 用 attention 決定其它點的權重，而不像 GCN 一樣把鄰居加起來