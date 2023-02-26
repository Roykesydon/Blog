---
title: "機率論 - II"
date: 2023-02-01T15:18:41+08:00
draft: false
description: ""
type: "post"
tags: ["math", "probability"]
categories : ["math"]
---

# 機率密度函數 PDF
- probability density function
- PMF 在 連續R.V. 上，假如 $X\text{\textasciitilde}[0,1)$，$p_X(0.7)$ = 0，因為有無窮多個數字

## 公式
- $f_X(x)=\lim\limits_{\Delta x \rightarrow 0} \frac{P(x \le X \le x + \Delta x)}{\Delta x} \\\\ 
= \lim\limits_{\Delta x \rightarrow 0} \frac{F_X(x+\Delta x) - F_X(x)}{\Delta x} \\\\ 
= F^{\prime}_X(x)
$

### 和 CDF 的關係
- $CDF: F_X(x) = PDF: f_X(x)$
    - $\int^x_{-\infty}$ 可以從 PDF 轉到 CDF
    
    - $\frac{d}{dx} 可以從 CDF 轉到 PDF$

## 跟機率的關係
- $P(a < X \le b) = F_X(b) - F_X(a) \\\\ 
= \int^b_{-\infty} f_X(x)dx - \int^a_{-\infty} f_X(x)dx \\\\ 
= \int^a_b f_X(x)dx$
- $f_X(x)=\lim\limits_{\Delta x \rightarrow 0} \frac{P(x \le X \le x + \Delta x)}{\Delta x}$
    - 當 $\Delta x$ 很小時
        - $P(x \le X \le x + \Delta x) \approx f_X(x) \cdot \Delta x$

## 性質
- $f_X(x) = F^{\prime}_X(x)$
- $F_X(x)=\int^x_{-\infty}f_X(u)du$
- $P(a \le X \le b)=\int^b_a f_X(x) dx$
- $\int^{\infty}_{-\infty}f_X(x)dx=1$
- $f_X(x) \ge 0$
- $f_X(x)$ 可以比 1 大

# 連續機率分佈

## Uniform 機率分佈
- $X \text{\textasciitilde}UNIF(a,b)$
- PDF
    - $f_X(x) = \begin{cases}
        \frac{1}{b-a} & ,a \le x \le b \\\\ 
        0 & ,otherwise
        \end{cases}$
- CDF
    - $F_X(x) = \begin{cases}
        0 & ,x \le a \\\\ 
        \frac{x-a}{b-a} & ,a < x \le b\\\\ 
        1 & ,x > b
    \end{cases}$

## Exponential 機率分佈
- 有失憶性(memoryless)，常被用來 model 有這種性質的事情
- $X \text{\textasciitilde}Exponential(\lambda)$
- PDF
    - $f_X(x) = \begin{cases}
        \lambda e^{-\lambda x} & ,x \ge 0 \\\\ 
        0 & ,otherwise
        \end{cases}$
- CDF
    - $F_X(x) = 1-e^{-\lambda x}$


## Erlang 機率分佈
- Gamma Distribution
- $X \text{\textasciitilde}Erlang(n,\lambda)$
- PDF
    - $f_X(x) = \begin{cases}
        \frac{1}{(n-1)!}\lambda^n x^{n-1} e^{-\lambda x} & ,x \ge 0 \\\\ 
        0 & ,otherwise
        \end{cases}$
        - $f_X(x)=(\lambda e^{-\lambda x}) * (\lambda e^{-\lambda x}) * ... * (\lambda e^{-\lambda x})$
            - 自己和自己做 n 次 convolution
- CDF
    - $F_X(x) = \begin{cases}
        1 - \Sigma^{n-1}_{k=0}\frac{(\lambda x)^k}{k!}e^{-\lambda x} & ,x \ge 0 \\\\ 
        0 & ,otherwise
    \end{cases}$

### 常見用法
- 用來 model 一件有多個關卡事情的總時間，而每個關卡所需時間是隨機的
    - 關卡數: n
    - 每關卡所需時間之機率分佈 $Exponential(\lambda)$
    - e.g. 打電動過三關所需時間
        - $Erlang(3, \lambda)$

## Normal 機率分佈 (常態分佈)
- 在自然界常出現
- 常被用做「很多隨機量的總和」的機率模型
- 又稱 Gaussian 機率分佈
- $X \text{\textasciitilde}Gaussian(\mu,\sigma)$
    
- PDF
    - $f_X(x)=\frac{1}{\sqrt{2\pi}\sigma}e^{-\frac{(x-\mu)^2}{2\sigma^2}}$

- 也常用 $X \text{\textasciitilde}N(\mu,\sigma^2)$
    - 注意 $\sigma$ 不一樣

- CDF
    - 太難算，積不出來
        - 針對某組特別的 $\mu, \sigma$ 的 CDF 建表，把其他常態分佈的 CDF 和這組產生關聯

    - 標準常態分佈
        - $Z \text{\textasciitilde}N(0,1)$
            - $f_Z(z)=\frac{1}{\sqrt{2 \pi}}e^{-\frac{z^2}{2}}$
        - CDF 表示為 $\Phi(z)$
            - $\Phi(z)=\int^z_{-\infty}\frac{1}{\sqrt{2\pi}}e^{-\frac{u^2}{2}}du$
                - 積不出來，以數值方法近似出來後建表給人家查
                    - 查 standard normal table

            - e.g. $F_Z(1.325)=?$
                - 查表 $F_Z(1.32)=0.9066$，$F_Z(1.33)=0.9082$
                    - 用內插約略得 0.9074
            
            - 性質
                - $\Phi(-z) = 1 - \Phi(z)$

    - 任意  $\mu, \sigma$ 的 CDF
        - 對任何 $X \text{\textasciitilde}N(\mu,\sigma^2)$
            - $\frac{X-\mu}{\sigma}\text{\textasciitilde}N(0,1)$
            - $F_X(x)=\Phi(\frac{x-\mu}{\sigma})$

# 期望值 
- Expectation
- 大數法則
    - $P(A)=\lim\limits_{N \rightarrow \infty}\frac{N_A}{N}$
- 基本上期望值是利用大數法則算的 mean 值，雖然平均值是 R.V.，但當實驗無窮多次時，會收斂到常數，因此以這為估算值
- Mean 值又稱做期望值
## 離散隨機變數
- $E\lbrack X \rbrack=\mu_X=\displaystyle\sum^{\infty}_{x=-\infty}x \cdot P_X(x)$

### 離散隨機變數的函數的期望值
- 對離散隨機變數 X 而言，其任意函數 g(x) 也是一隨機變數，也有期望值
    - $g(X)$ 的期望值定義為
        - $E \lbrack g(X) \rbrack=\displaystyle\sum^{\infty}_{x=-\infty}g(x)\cdot P_X(x)$

### 性質
- $E\lbrack \alpha g(X) \rbrack = \alpha \cdot E \lbrack g(X) \rbrack$
- $E\lbrack \alpha g(X) + \beta h(X) \rbrack \\\\ 
=\alpha \cdot E \lbrack g(X) \rbrack + \beta \cdot E \lbrack h(X) \rbrack$
- $E\lbrack \alpha \rbrack = \alpha$
### 常見隨機變數函數的期望值
- $X$ 的 $n^{th} moment$
    - $E \lbrack X^n \rbrack = \displaystyle\sum^{\infty}_{x=-\infty}x^n \cdot P_X(x)$
- X 的變異數(variance)
    - $E \lbrack (X-\mu_X)^2 \rbrack = \displaystyle\sum^{\infty}_{x=-\infty} (x-\mu_X)^2 \cdot P_X(x)$

### 變異數 Variance
- Variance 通常符號表示為 $\sigma^2_X=E \lbrack (X-\mu_X)^2 \rbrack$
- 隱含隨機變數 X 多「亂」的資訊
    - variance 大的話，X 不見得接近 $\mu_X$
- 變異數開根號是標準差(standard deviation)
    - $\sigma_X = \sqrt{Variance} \ge 0$

#### 算法
$\sigma^2_X=E \lbrack X^2 \rbrack - \mu^2_X\\\\ 
\Rightarrow E \lbrack X^2 \rbrack = \sigma^2_X + \mu^2_X$

### 常見離散分佈的期望值 / 變異數
- $X\text{\textasciitilde}Bernouli(p)$
    - $\mu_X=1 \cdot p + 0 \cdot (1-p) \\\\ 
    = p$

    - $\sigma^2_X = E \lbrack X^2 \rbrack - \mu^2_X \\\\ 
    = \displaystyle\sum^1_{x=0}x^2\cdot p_X(x)-\mu_X^2 \\\\ 
    =1^2 \cdot p + 0^2 \cdot (1-p) - p^2\\\\ 
    =p(1-p)$
- $X$~$BIN(n,p)$
    - $\mu_X = np$

    - $\sigma^2_X = np(1-p)$
- $X$~$GEO(p)$
    - $\mu_X = \frac{1}{p}$

    - $\sigma^2_X = \frac{(1-p)}{p^2}$
- $X$~$PASKAL(k,p)$
    - $\mu_X = \frac{k}{p}$

    - $\sigma^2_X = \frac{k(1-p)}{p^2}$

- $X$~$POI(\alpha)$
    - $\mu_X = \alpha$

    - $\sigma^2_X = \alpha$

- $X$~$UNIF(a,b)$
    - $\mu_X = \frac{a+b}{2}$

    - $\sigma^2_X = \frac{1}{12}(b-a)(b-a+2)$

## 連續隨機變數
對連續的隨機變數 X 而言，將 X 的值以 $\Delta$ 為單位無條件捨去來近似，以隨機變數 Y 表示(當 $\Delta \rightarrow$ 0 時，$X \approx Y$)，然後再當做 PMF 處理。
- $E \lbrack X \rbrack = \int^{\infty}_{-\infty}xf_X(x)dx$
### 連續隨機變數的函數的期望值
- 對連續隨機變數 X 而言，其任意函數 g(x) 也是一隨機變數，也有期望值
    - $g(X)$ 的期望值定義為
        - $E \lbrack g(X) \rbrack=\int^{\infty}_{-\infty}g(x)\cdot f_X(x)dx$
### 性質
- $E\lbrack \alpha g(X) \rbrack = \alpha \cdot E \lbrack g(X) \rbrack$
- $E\lbrack \alpha g(X) + \beta h(X) \rbrack \\\\ 
=\alpha \cdot E \lbrack g(X) \rbrack + \beta \cdot E \lbrack h(X) \rbrack$
- $E\lbrack \alpha \rbrack = \alpha$

### 常見隨機變數函數的期望值
- $X$ 的 $n^{th} moment$
    - $E \lbrack X^n \rbrack = \int^{\infty}_{-\infty}x^n \cdot f_X(x)dx$
- X 的變異數(variance)
    - $E \lbrack (X-\mu_X)^2 \rbrack = \int^{\infty}_{-\infty} (x-\mu_X)^2 \cdot f_X(x)dx$

### 變異數 Variance
- 和離散隨機變數的資訊一樣

### 常見連續分佈之期望值/變異數
- $X$~$Exponential(\lambda)$
    - $\mu_X = \frac{1}{\lambda}$

    - $\sigma^2_X = \frac{1}{\lambda^2}$
- $X$~$Erlang(n, \lambda)$
    - $\mu_X = \frac{n}{\lambda}$

    - $\sigma^2_X = \frac{n}{\lambda^2}$

- $X$~$Gaussian(\mu,\sigma)$
    - $\mu_X = \mu$

    - $\sigma^2_X = \sigma^2$

- $X$~$UNIF(a,b)$
    - $\mu_X = \frac{a+b}{2}$

    - $\sigma^2_X = \frac{1}{12}(b-a)^2$