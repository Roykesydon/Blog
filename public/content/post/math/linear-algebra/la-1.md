---
title: "線性代數 - I"
date: 2023-02-21T14:42:47+08:00
draft: false
type: "post"
tags: ["math", "linear-algebra"]
categories : ["math"]
---

# matrix
- a rectangular array of scalars
- size
    - m by n
    - 叫做 square if m = n

- equal
    - 兩個矩陣的 size 和每個 entry 都一樣

- submatrix
    - 從一個大矩陣刪掉 rows 或 columns

- addition
    - 兩個大小相同的矩陣，每個對應位置的 entry 兩兩相加

- scalar multiplication
    - 一個矩陣的所有 entry 乘以某個 scalar

- zero matrix
    - 所有 entry 都是 0，該矩陣常以 $O_{n \times m}$ 來表示
    - 性質
        - $A = O + A$
        - $0 \cdot A = O $

- subtraction
    - $A-B=A+(-B)$

- transpose
    - $A^T$ 的 $(i,j)$-entry 是 $A$ 的 $(j,i)$-entry
    - Properties
        - $(A+B)^T=A^T+B^T$
        - $(sA)^T=sA^T$
        - $(A^T)^T=A$

# vectors
- type
    - row vector
        - 只有 1 row 的 matrix
    - column vector
        - 只有 1 column 的 matrix

- components
    - the entries of a vector
    - 用 the $i$ th component 代表 $v_i$

- addition, scalar multiplication
    - 和 matrix 一樣

- 矩陣表示
    - 一個矩陣常被表示為 
        - a stack of row vectors
        - a cross list of column vectors

# linear combination
- $c_1u_1+c_2u_2+...+c_ku_k$
- scalars
    - $c_1,c_2,...,c_k$
    - 又被稱作 linear combination 的 coefficients
- vectors
    - $u_1,u_2,...,u_k$

- 如果 $u,v$ 非平行二維向量，則二維空間中所有向量皆是 $u,v$ 的 linear combination，且是 unique 的

# standard vectors
-   $e_1 = \begin{bmatrix}
    1 \\\\ 
    0 \\\\ 
    ... \\\\ 
    0
    \end{bmatrix}
,e_2 = \begin{bmatrix}
0 \\\\ 
1 \\\\ 
... \\\\ 
0
\end{bmatrix},...,
e_n = \begin{bmatrix}
0 \\\\ 
0 \\\\ 
... \\\\ 
1
\end{bmatrix}$

- $R^n$ 的任何一個向量都可以被 standard vectors 表示成 uniquely linearly combined
    
# 矩陣向量乘法
- $Av=v_1a_1+v_2a_2+...+v_na_n$

# Identity Matrix
- 對整數 n，$n \times n$ identity matrix
    - $I_n$
    - 每個 columns 是 standard vectors $e_1, e_2, ..., e_n$ in $R^n$

# Stochastic Matrix
- 對整數 n，$n \times n$ stochastic matrix
- 所有 entry 都必須非負
- 每個 column 的 entry 總和必須是 unity (相加為 1)

