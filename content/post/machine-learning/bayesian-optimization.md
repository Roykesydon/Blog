---
title: "Bayesian Optimization"
date: 2023-01-26T01:36:53+08:00
draft: false
description: "一種自動調參的方法"
type: "post"
tags: ["fine-tune", "deep-learning","machine-learning"]
categories : ["deep-learning"]
---

# 介紹

一種用於自動化找超參數的方法，用在採樣昂貴而且是黑盒子的情況

# 流程

1. 取樣一些資料點
2. 生出一個 Surrogate Model(可採用 Gaussian Process)
3. 反覆做以下事情
    - 用 Acquisition Function 挑選下一個要採樣的點
    - 重新評估 Surrogate Model

## Gaussian Process

最終的 prediction 是一個 distribution 而不是單一個數字
生成方法需借助 kernel function，常用 RBF(Radial Basis Function)

$K(x, x^{'}|\tau)=\sigma^2exp(-\frac{1}{2}(\frac{x-x^{'}}{l})^2)$

$\sigma$ 和 $l$ 是兩個可以調整的超參數

## Acquisition Function
可用超參數來調節 exploitation 和 exploitation

- UCB(Upper confidence bound)
- PI(probability of improvement)
- EI(Expected improvement)