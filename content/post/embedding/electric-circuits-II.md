---
title: "電路學 - II"
date: 2023-04-10T00:00:54+08:00
draft: false
description: ""
type: "post"
tags: ["electric-circuits"]
categories : ["embedded-system"]
---

## 分析方法
### 節點分析 (Nodal Analysis)

- 解節點電壓
    1. 選取一個節點做為參考節點 (reference node) 或已知節點 (datum node)，其他節點的電壓相對於它
        - 假設它電位為 0，稱為 ground
    2. 把 KCL 用在剩下的 n-1 個參考節點 (假設電流方向，可以隨便假設，只要一致，不要兩端電流都流入同個電阻)
    3. 求解聯立方程式，得到各節點電壓

### 包含電壓源的節點分析 (Nodal Analysis with Voltage Sources)
- 如果電壓源連接於兩個非參考節點間，可以把電壓源和這兩個節點和與其並聯的元件看做一個超節點 (supernode) 或廣義節點 (generalized node)，解決無法知道流過電壓源的電流的問題