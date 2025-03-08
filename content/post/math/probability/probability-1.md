---
title: "機率論 - I"
date: 2023-01-31T15:18:41+08:00
draft: false
description: ""
type: "post"
tags: ["math", "probability"]
categories : ["math"]
---

# 集合論

## 名詞

- 子集合(Subset)
    - B 是 C 的子集(B 不能等於 C)
        - $B \subset C$
- 補集(Complement)
    - C 是 A 的補集
        - $C=A^C$
- 不相交(Disjoint)
    - $X \cap Y = \\{\\}$
- 互斥(Mutually Exclusive)
    - 一群集合 $X_1, X_2, ..., X_n$ 中任選兩個集合 $X_i, X_j$ 都不相交，則 $X_1, X_2, ..., X_n$ 這群集合互斥

## 公式

- De Morgan's Law
    - ${(A \cup B)}^C=A^C \cap B^C$

# 機率名詞
- Outcome (結果)
    - 實驗中可能的結果
- Sample Space (樣本空間)
    - 機率實驗所有可能的結果的集合，常以 $S$ 表示
- Event (事件)
    - 對於實驗結果的某種敘述
    - 事件可以看做是 outcome 的集合，也是 sample space 的子集
    - 機率是一個函數，其自變數是 event，故可看做是一個映射

# 公理 Axioms
1. 對任何事件 $A$ 而言, $P(A) \geq 0$
2. $P(S) = 1$
3. 事件 $A_1, A_2, ...$ 互斥 $\Rightarrow$ $P(A_1 \cup A_2 \cup A_3 \cup ...)$

    $=P(A_1)+P(A_2)+P(A_3)+...$

## 衍生公式

- Boole's 不等式
    - 對任意 $n$ 個事件 $A_1, A_2, ..., A_n$ 而言
        - $P(\cup^n_{i=1}A_i \leq \Sigma^n_{i=1}P(A_i))$

- Bonferroni's 不等式
    - 對任意 $n$ 個事件 $A_1, A_2, ..., A_n$ 而言
        - $P(\cap^n_{i=1} A_i) \geq 1 - \Sigma^n_{i=1} P(A^C_i)$

# 條件機率

## 公式
- $P(X|Y) = \frac{P(X \cap Y)}{P(Y)}$
    - $P(X \cap Y) = P(X|Y) * {P(Y)} = P(Y|X) * P(X)$

## 性質
1. $P(X|Y) \geq 0$
2. $P(Y|Y) = 1$
3. $A, B$ 互斥 $\Rightarrow P(A \cup B |Y) = \frac{P(A)}{P(Y)} + \frac{P(B)}{P(Y)} = P(A|Y)+P(B|Y)$

## 定理
- Total Probability 定理
    - 若 $C_1, C_2, ..., C_n$ 互斥且 $C_1 \cup C_2 \cup ... \cup C_n = S$，則對任意事件 $A$
        - $P(A) = P(A|C_1)P(C_1) +  P(A|C_2)P(C_2) + ... + P(A|C_n)P(C_n)$
- Bayes' Rule 貝式定理
    - 若 $C_1, C_2, ..., C_n$ 互斥且 $C_1 \cup C_2 \cup ... \cup C_n = S$，則對任意事件 $A$
        - $P(C_j|A)=\frac{P(A|C_j) * P(C_j)}{\Sigma^n_{i=1}P(A|C_i)*P(C_i)}$

            $= \frac{P(C_j \cap A)}{P(A)}$

# 獨立性 Independence
- 若兩事件 $A, B$ 之機率滿足
    - $P(A \cap B) = P(A) * P(B)$
    - 或以 $P(A|B) = P(A)$ 表示
    
    則 $A, B$ 兩事件稱為機率上的獨立事件

- 若事件 $A_1, A_2, ... A_n$ 滿足下列條件，則稱此 $n$ 事件獨立 $(n>2)$
    - 從中任選 $m$ 事件 $A_{i_1}, A_{i_2}, ... A_{i_m}$ 均滿足
        - $P(A_{i_1} \cap A_{i_2} \cap ... \cap A_{i_m}) = P(A_{i_1})P(A_{i_2})...P(A_{i_m}) , m=2, 3, ..., n$

# 排列組合

- 二項式係數(binomial coefficient)
    - $(^n_k)$
        - 有 $n$ 個異物，從中取出 $k$ 個
- 多項式係數(multinomial coefficient)
    - $\frac{n!}{n_1!n_2!...n_m!}$
        - 有 m 種異物，每次選物從中選一後放回，依序選 n 次，共有 $m^n$ 種 outcome，在所有實驗結果中，第一種出現 $n_1$ 次，以此類推，這樣的實驗結果有多少種

# 隨機變數 Random Variable, R.V.

- 用來把 outcome 數字化的表示方式
- 通常用大寫英文字母
- 是將 outcome 轉成對應數字的函數
    - $X: S \rightarrow R$
        - 從樣本空間映射到實數
- 隨機變數的函數，也是一個隨機變數

## 種類
- 離散隨機變數 (Discrete R.V.)
    - 值是有限個，或是「可數的」無窮多個

- 連續隨機變數 (Continuous R.V.)
    - 值有無窮多個，而且「不可數」

### 可數、不可數
- 可數
    - 包含的東西可一個個被數，總有一天會被數到
        - e.g. 正偶數集合
- 不可數的
    - 不管怎麼數，裡面一定有個東西會沒數到
        - e.g. 0~1 之間的所有數字

# 累積分佈函數 CDF
- cumulative distribution function
- 對任一個隨機變數 $X$，定義 CDF 為
    - $F_X(x) \overset{def}{=}P(X \leq x)$
        - 永遠用 $F$ 表示

- 常見用途
    - 算 X 落在某範圍的機率
    - $P(A < X \le b) = F_X(b)-F_X(a)$
        - $P(A \le X \le b) = F_X(b)-F_X(a)+P(X=a)$
        - $P(A < X < b) = P(A < X \le b^-)$

## 性質
- 離散隨機變數的 CDF
    - $F_X(x^+)=F_X(x)$
    - $F_X(x^-)=F_X(x)-P(X=x)$
- 連續隨機變數的 CDF
    - $F_X(x^-)=F_X(x)=F_X(x^+)$
- 共同
    - $F_X(- \infty)=P(X \le - \infty)=0$
    - $F_X(\infty)=P(X \le \infty) = 1$
    - $0 \le F_X(x) \le 1$

# 機率質量函數 PMF
- probability mass function
- 對任一個「離散」隨機變數 $X$，其 PMF 為
    - $p_X(x) \overset{def}{=}P(X=x)$

## PMF 和 CDF 的關係
- 對任何 $x$
    - $F_X(x) = \displaystyle\sum^{\lfloor x \rfloor}_{n=-\infty}p_X(n)$
        - $P_X(x)=F_X(x^+)-F_X(x^-)$

# 機率分佈(Probability Distribution)
- PMF 和 PDF 都是一種機率分佈
    - 將總和為 1 的機率分佈在點上

# 離散機率分佈

## Bernoulli 機率分佈
- 1 次實驗，2 種結果，在意某結果發生與否
- $X \text{\textasciitilde}Bernoulli(p)$
- PMF
    - $p_X(x) = \begin{cases}
   p & ,x=1 \\\\ 
   1-p & x=0 \\\\ 
   0 & ,otherwise
\end{cases}$
- CDF
    - $F_X(x) = \begin{cases}
   0 & ,x<0 \\\\ 
   1-p & 0 \leq x <1 \\\\ 
   1 & ,x \geq 1
\end{cases}$

## Binomial 機率分佈
- 實驗成功機率為 p，做 n 次實驗，X 表成功次數
- $X \text{\textasciitilde}BIN(p)$
- PMF
    - $p_X(x) = (^n_x)p^x(1-p)^{n-x}$
        - 成功 $x$ 次
- CDF
    - $F_X(x) = \displaystyle\sum^{\lfloor x \rfloor}_{m=-\infty} (^n_m)\cdot p^m \cdot (1-p)^{n-m}$

## Uniform 機率分佈
- 1 次實驗，n 種結果，各結果機率均等，在意某結果發生否
- $X \text{\textasciitilde}UNIF(a,b)$
- PMF
    - $p_X(x) = \begin{cases}
        \frac{1}{b-a+1} & ,x=a,a+1,...,b \\\\ 
        0 & ,otherwise
        \end{cases}$
- CDF
    - $F_X(x) = \begin{cases}
        0 & ,x<a \\\\ 
        \frac{\lfloor x \rfloor - a + 1}{b-a+1} & ,a \leq x< b\\\\ 
        1 & ,x \geq b
    \end{cases}$

## Geometric 機率分佈
- 若實驗成功機率為 p，到成功為止，做了 X 次嘗試
- 有失憶性
- $X \text{\textasciitilde}Geometric(p)$
- PMF
    - $p_X(x) = \begin{cases}
   (1-p)^{x-1} \cdot p & ,x=1, 2, 3, ... \\\\ 
   0 & ,otherwise
\end{cases}$
- CDF
    - $F_X(x) = \begin{cases}
   1-(1-p)^{\lfloor x \rfloor} & ,x \ge 1 \\\\ 
   0 & ,otherwise
\end{cases}$

## Pascal 機率分佈
- 若實驗成功機率為 p，到第 k 次成功為止，共做了 X 次嘗試
- $X \text{\textasciitilde}Pascal(k, p)$
- PMF
    - $p_X(x) = \begin{cases}
   \binom{x-1}{k-1}(1-p)^{x-k} p^k & ,x=k, k+1, ... \\\\ 
   0 & ,otherwise
\end{cases}$
- CDF
    - $F_X(x) = P(X \le x) \\\\ 
    = P(在 x 次實驗中 \ge k 次成功)\\\\ 
    = P(Y \ge k), Y~BIN (x,p) \\\\ 
    $
        - 故 Pascal 又稱 Negative Binomial

## Poisson 機率分佈
- 已知某事發生速率為每單位時間 $\lambda$ 次，觀察時間為 $T$ 時間單位，$X$ 為該觀察時間內發生該事的總次數。
- $X \text{\textasciitilde}POI(\lambda T)$
    - 有時候也會以 $\mu$ 來表示 $\lambda T$
- PMF
    - $p_X(x) = e^{-\lambda T} \cdot \frac{(\lambda T)^x}{x!}$
- CDF
    - $F_X(x) = \begin{cases}
   \displaystyle\sum^{\lfloor x \rfloor}_{n=-\infty}e^{-\lambda T} \cdot \frac{(\lambda T)^n}{n!} & ,x = 0,1,2,... \\\\ 
   0 & ,otherwise
\end{cases}$