---
title: "機率論 - IV"
date: 2023-02-05T15:18:41+08:00
draft: false
description: ""
type: "post"
tags: ["math", "probability"]
categories : ["math"]
---

# 隨機變數之和
- Z=X+Y

- $p_Z(z)=\displaystyle\sum_{x=-\infty}^{\infty}p_{X,Y}(x,z-x)\\\\ 
=\displaystyle\sum_{y=-\infty}^{\infty}p_{X,Y}(z-y,y)$
- $f_Z(z)=\int_{-\infty}^{\infty}f_{X,Y}(x,z-x)dx\\\\ 
=\int_{-\infty}^{\infty}f_{X,Y}(z-y,y)dy$

- 如果 X, Y 獨立
    - 離散
        - $p_Z(z)=\displaystyle\sum_{x=-\infty}^{\infty}p_{X}(x)\cdot p_Y(z-x)\\\\ 
    =\displaystyle\sum_{y=-\infty}^{\infty}p_{X}(z-y)\cdot p_Y(y)$
            - 這兩個等式是 discrete convolution
            - $=p_X(z) * p_Y(z)$
    - 連續
        - $f_Z(z)=\int_{-\infty}^{\infty}f_{X}(x) f_Y(z-x) dx\\\\ 
    =\int_{-\infty}^{\infty}f_{X}(z-y) f_Y(y) dy$
            - 這兩個等式是 continuous convolution
            - $=f_X(z) * f_Y(z)$

    - 如果有 n 個獨立隨機變數
        - $X=X_1+X_2+...+X_n$
            - 如果 $X_1,...,X_n$ 獨立
                - $p_X(x)=p_{X_1}(x) * p_{X_2}(x) * p_{X_3}(x) * ... * p_{X_n}(x)$
                    - 連續做 convolution
                - $f_X(x)=f_{X_1}(x) * f_{X_2}(x) * f_{X_3}(x) * ... * f_{X_n}(x)$
                    - 連續做 convolution

# MGF
- moment generating function
- convolution 很難算

- 流程
    - 如果有多個連續 convolution 也適用下面流程，全部一次一起相乘
    1. 給定 $p_{X_1}(x), p_{X_2}(x)$，目標是求 $p_{X_1}(x) * p{X_2}(x)$
    2. 轉換到 MGF
        - $\phi_{X_1}(s)=E \lbrack e^{sX_1} \rbrack\\\\ 
        = \displaystyle\sum_{x=-\infty}^{\infty}e^{sx}\cdot p_{X_1}(x)$

        - $\phi_{X_2}(s)=E \lbrack e^{sX_2} \rbrack$

    3. 相乘
        $\phi_{X_1}(s) \cdot \phi_{X_2}(s)$

    4. 逆轉換
        - 查表

- $\phi_X(s)$ 定義
    - $\phi_X(s)=E \lbrack e^{sX} \rbrack = \begin{cases}
\displaystyle\sum_{x=-\infty}^{\infty} e^{sx} \cdot p_{X}(x) & 離散, \\\\ 
\int_{-\infty}^{\infty} e^{sx} \cdot f_{X}(x)dx & 連續
\end{cases}$

- 性質
    - Y = aX + b
        - $\phi_Y(s) = e^{sb} \cdot \phi_X(as) $

- 常見離散機率分佈的 MGF
    - $X$~$Bernoulli(p)$
        - $\phi_X(s)=1-p+pe^s$
    - $X$~$BIN(n, p)$
        - 作 n 次實驗成功次數等於個實驗室成功次數的總和
        - $X = X_1 + X_2 + ... + X_n, X_i 獨立, Xi$~$Bernoulli(p)$
        - $\phi_{X_i}(s)=1-p+pe^s$
        - $\phi_{X}(s)=\lbrack 1-p+pe^s \rbrack ^n$
    - $X$~$Geometric(p)$
        - 自行推導
    - $X$~$Pascal(k,p)$
        - 看到第 k 次成功，花的總實驗室次數等於第 1 號成功花多少次 + 第 2 號 +...+ 第 k 號
        - $X = X_1 + X_2 + ... + X_n, X_i 獨立, Xi$~$Gemetric(p)$
    - $X$~$Exponential(\lambda)$
        - 自行推導
    - $X$~$Erlang(n,\lambda)$
        - $X = X_1 + X_2 + ... + X_n, X_i 獨立, Xi$~$Exponential(\lambda)$

# 多個隨機變數之和

## 獨立隨機變數之和
- $X_1, X_2, ...$獨立，且各自有一模一樣的機率分佈
    - { $X_i$ } $I.I.D.$
        - Independently and Identically Distributed
    - $X = X_1+X_2+...+X_n$，n 為常數，請問 X 的機率分佈
        - $p_X(x)=p_{X_1}(x) * p_{X_1}(x) * p_{X_1}(x) * ... * p_{X_1}(x)$
        - $f_X(x)=f_{X_1}(x) * f_{X_1}(x) * f_{X_1}(x) * ... * f_{X_1}(x)$
            - 因為他們機率分佈一模一樣，所以底下都是 $X_1$
        - $\phi_X(s)=\lbrack \phi_{X_1}(s) \rbrack ^n$

    - e.g. 假設壽司理想重量是 13g，抓飯量是常態分佈，期望值是 14，標準差是 3，每天要作 100 個，每天飯量的機率分佈是?
        - $X_i$ : 第 i 個壽司的飯量，{ $X_i$ } I.I.D.
        - $X_i$~$N(14,9)\\\\ 
        \Rightarrow \phi_{X_i}(s)=\phi_{X_1}(s)\\\\ 
        =e^{\mu S + \frac{\sigma^2}{2}s^2} = e^{14 s + \frac{9}{2}s^2}$
        - $X=X_1+X_2+...+X_{100}$
        - $\phi_X(s)=\lbrack \phi_{X_1}(s) \rbrack^{100}\\\\ 
        =e^{1400 s + \frac{900}{2}s^2}$
            - 這個東西是 $X$~$N(1400,900)$ 的 MGF，所以可以逆推回來機率分佈

## 隨機變數之獨立隨機變數和
- $X_1,X_2,...I.I.D.$
- $X = X_1 + X_2 + ... + X_N$
- N 本身也是隨機變數，其機率分佈已知

- $\phi_X(s)=\phi_N(ln(\phi_{X_1}(s)))$        

# 中央極限定理
- central limit theorem(CLT)
- 若 $X_1,X_2,...,X_n$ 為 $I.I.D.$，當 n 趨近於無窮大時
    - $X=X_1+X_2+...+X_n$~$N(\mu_{X_1+X_2...+X_n}, \sigma^2_{X_1+X_2+...+X_n})$
    - $\mu_{X_1+X_2+...+X_n}=\mu_{X_1}+\mu_{X_2}+...+\mu_{X_n}=n\mu_{X_1}$
    - $\sigma^2_{X_1+X_2+...+X_n}=\sigma^2_{X_1}+\sigma^2_{X_2}+...+\sigma^2_{X_n}=n\sigma^2_{X_1}$

- 應用
    1. 要處理多個獨立的隨機變數的和時，可以用 CLT 將其機率分佈近似為常態分佈後計算機率
        - 比如雜訊常當作常態分佈
    2. 如果某機率分佈等於多個獨立隨機變數的和，此機率分佈可以用常態分佈近似，再算機率
        - e.g. $X$~$BIN(100,0.3)$
            - $X=X_1+X_2+...+X_100$
            - {$X_i$} $I.I.D., X_i$~$Bernoulli(0.3)$

- 範例
    1. 天團粉絲有 0.2 的機率買 CD，共有100萬個粉絲，發售 CD 超過 200800 張的機率為何
        - $X$~$BIN(1000000,0.2)$
        - $P(X>200800)=\displaystyle\sum_{x=200801}^{10^6}(\overset{1000000}{x})0.2^x0.8^{10^6-x}$
            - $(\overset{1000000}{x})=\frac{1000000!}{200801!799199!}$
            - 算不出來
        - $X=X_1+X_2+...+X_{1000000}, X_i$~$Bernoulli(0.2)\\\\ 
        \Rightarrow \mu_{X_1}=0.2, \sigma_{X_1}^2=0.16$
        - By CLT $\Rightarrow X$~$N(200000,160000)$
            - $P(X>200800)\\\\ 
            =P(\frac{X-200000}{400} > \frac{200800-200000}{400})\\\\ 
            =P(Z>2)
            =Q(2)
            \approx0.023$

## De Moivre - Laplace Formula
- 如果是離散的隨機變數和，可以算的更精確
- $P(k_1 \le X \le k_2) \approx \Phi(\frac{k_2+0.5-n\mu_{X_1}}{\sqrt{n}\sigma_{X_1}}) - \Phi(\frac{k_1-0.5-n\mu_{X_1}}{\sqrt{n}\sigma_{X_1}})$