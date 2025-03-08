---
title: "線性代數 - II"
date: 2023-02-21T15:42:47+08:00
draft: false
description: ""
type: "post"
tags: ["math", "linear-algebra"]
categories : ["math"]
---

# linear equation
- $a_1x_1+a_2x_2+...+a_nx_n = b$
    - $a$ 是 coefficient
    - $x$ 是 variables
    - $b$ 是 constant term

# Systems of linear equations
- m equations, n variables
- $a_{11}x_1+a_{12}x_2+...+a_{1n}x_n = b_1\\\\ 
a_{21}x_1+a_{22}x_2+...+a_{2n}x_n = b_2\\\\ 
...\\\\ 
a_{m1}x_1+a_{m2}x_2+...+a_{mn}x_n = b_m$
- solution
    - $[s_1~s_2~...~s_n]^T$ 是一組解，代換到 $x_1$~$x_n$ 後滿足所有 equation 的向量
- 所有 Systems of linear equations 都有
    - no solution
    - exactly one solution
    - infinitely many solutions
- consistent/inconsistent
    - 如果有一組以上的解就是 consistent
    - 無解就是 inconsistent
- equivalent
    - 如果兩組 Systems of linear equations 的 solution set 一樣，稱為 equivalent

- elementary row operations
    - 不會影響 solution set
    - types
        - Interchange
            - 兩 row 互換
        - Scaling
            - 某 row 乘某個 nonzero scalar
        - Row addition
            - 把某 row 乘某個 scalar 後加到某 row
    - property
        - 所有 elementary row operations 都是 reversible
    - 用來求解

- coefficient matrix
    - $a_{11}x_1+a_{12}x_2+...+a_{1n}x_n = b_1\\\\ 
a_{21}x_1+a_{22}x_2+...+a_{2n}x_n = b_2\\\\ 
...\\\\ 
a_{m1}x_1+a_{m2}x_2+...+a_{mn}x_n = b_m$
        - 可以拆為 $Ax=b$
        - $A=\begin{bmatrix}
a_{11}& a_{12}&...& a_{1n} \\\\ 
a_{21}& a_{22}&...& a_{2n} \\\\ 
...& ...&...& ... \\\\ 
a_{m1}& a_{m2}&...& a_{mn} 
\end{bmatrix}$
            - A 就是 coefficient matrix
        - $x=\begin{bmatrix}
        x_1\\\\ 
        x_2\\\\ 
        ...\\\\ 
        x_n
        \end{bmatrix}$
            - $x$ 是 variable vector

        - $[A|b]=\begin{bmatrix}
a_{11}& a_{12}&...& a_{1n} & b_1 \\\\ 
a_{21}& a_{22}&...& a_{2n} & b_2\\\\ 
...& ...&...& ... & ...\\\\ 
a_{m1}& a_{m2}&...& a_{mn} & b_m 
\end{bmatrix}$
            - 叫做 augmented matrix


