---
title: "機率論 - III"
date: 2023-02-02T15:18:41+08:00
draft: false
description: ""
type: "post"
tags: ["math", "probability"]
categories : ["math"]
---

# 隨機變數的函數

- 隨機變數 X 的任意函數 g(x) 也是一個隨機變數，常被稱為 Derived Random Variable

## 求 g(x) 的機率分佈
- X 是離散
    - 直接推 g(X) 的 PMF
        - X 是離散隨機變數，Y = g(X) 也是離散隨機變數
        - $p_{g(X)}(y) = \displaystyle\sum_{會讓g(x)=y 的所有x}p_X(x)$
- X 是連續
    - 先推 g(x) 的 CDF，再微分得 PDF
        1. 先算 g(X) 的 CDF
            - $F_{g(X)}(y)=P\lbrack g(X) \le y \rbrack$
        2. 若 g(X) 可以微分，再對 y 微分得 PDF
            - $f_{g(X)}(y)=\frac{d}{dy}F_{g(X)}(y)$

        - e.g. 若 Y=3X+2，請問 Y 的 PDF 與 $f_X(x) 的關係?$
            - $F_Y(y)=P(Y \le y)\\\\ 
            =P(3X+2 \le y)\\\\ 
            =P(X \le \frac{y-2}{3})\\\\ 
            =F_X(\frac{y-2}{3})$
            - $f_Y(y)=\frac{d}{dy}F_Y(y)\\\\ 
            =\frac{d}{dy}F_X(\frac{y-2}{3})\\\\ 
            =\frac{dF_X(\frac{y-2}{3})}{d(\frac{y-2}{3})} \cdot \frac{d \frac{y-2}{3}}{dy}\\\\ 
            =f_X(\frac{y-2}{3}) \cdot \frac{1}{3}$
    
        - 若 Y=aX+b
            - $f_Y(y)=\frac{1}{|a|}f_X(\frac{y-b}{a})$

# 條件機率分佈
- 若 X 是離散隨機變數，PMF 是 $p_X(x)$，某事件 B 已發生
    - PMF: $p_{X|B}(x)= x = \begin{cases}
   x \in B: & \frac{p_X(x)}{p(B)}, \\
   x \notin B: & 0
\end{cases}$
    - CDF: $F_{X|B}(x)\\\\ 
    =\displaystyle\sum_{u \le x}p_{X|B}(u)\\\\ 
    =\displaystyle\sum_{u \le x, u \in B} \frac{p_X(u)}{P(B)}$
- 若 X 是連續隨機變數，某事件 B 已發生
    - PDF: $f_{X|B}(x)\\\\ 
    =\begin{cases}
   x \in B: & \frac{f_X(x)}{P(B)}, \\
   x \notin B: & 0
\end{cases}$
    - CDF: $F_{X|B}(x)\\\\ 
    =\int_{-\infty \le u \le x, u \in B} \frac{f_X(u)}{P(B)} du$

## 條件期望值 Conditional Excpectation
- $E \lbrack X|B \rbrack\\\\ 
=\begin{cases}
\displaystyle\sum_{x=-\infty}^{\infty} x \cdot p_{X|B}(x) & 離散, \\\\ 
\int_{-\infty}^{\infty} x \cdot f_{X|B}(x)dx & 連續
\end{cases}$

- $E \lbrack g(X)|B \rbrack\\\\ 
=\begin{cases}
\displaystyle\sum_{x=-\infty}^{\infty} g(x) \cdot p_{X|B}(x) & 離散, \\\\ 
\int_{-\infty}^{\infty} g(x) \cdot f_{X|B}(x)dx & 連續
\end{cases}$

- $Var(X|B) = E\lbrack X^2 | B \rbrack - (\mu_{X|B})^2$

# 失憶性 Memoryless
- Geometric 和 Exponential 機率分佈都有失憶性
- 不管事情已經進行多久，對於事情之後的進行一點影響都沒有

# 聯合機率分佈
- joint probability distribution
- 同時考慮多個隨機變數的機率分佈

## Joint PMF
- X, Y 皆為離散，聯合PMF
    - $p_{X,Y}(x,y)=P(X=x, Y=y)$

- 性質
    - $0 \le p_{X,Y}(x,y) \le 1$
    - $\Sigma^{\infty}_{x=-\infty}\Sigma^{\infty}_{y=-\infty}
    p_{X,Y}(x,y)=1$
    - X, Y 獨立
        - $P_{X,Y}(x,y)\\\\ 
        =P(X=x,Y=y)\\\\ 
        =P_X(x)P_Y(y)$
    - 對任何事件 B
        - $P(B)=\Sigma_{(x,y)\in B}P_{X,Y}(x,y)$

## Joint CDF
- $F_{X,Y}(x,y)=P(X \le x, Y \le y)$

- 性質
    - $0 \le F_{X,Y}(x, y) \le 1$
    - 若 $x_1 \le x_2$ 且 $y_1 \le y_2$，則 $F_{X,Y}(x_1,y_1) \le F_{X,Y} (x_2, y_2)$
    - $F_{X,Y}(x, \infty) = F_X(x)$
    - $F_{X,Y}(\infty, y) = F_Y(y)$
    - $F_{X,Y}(\infty, \infty) = 1$
    - $F_{X,Y}(x, -\infty)\\\\ 
    = P(X \le x, Y \le -\infty)\\\\ 
    \le P(Y \le -\infty) \\\\ 
    = 0$
    - $F_{X,Y}(-\infty, y) = 0$
    - $P(x_1 < X \le x_2, y_1 < Y \le y_2)\\\\ 
    =F_{X,Y}(x_2,y_2)-F_{X,Y}(x_2,y_1)-F_{X,Y}(x_1,y_2)+F_{X,Y}(x_1,y_1)$

## Joint PDF
- $f_{X,Y}(x,y)= \frac{\partial^2F_{X,Y}(x,y)}{\partial x \partial y}$

- $F_{X,Y}(x,y) = \int_{-\infty}^{x} \int_{-\infty}^{y} f_{X,Y}(u,v)dv du$

- 性質
    - $f_{X,Y}(x,y) \ge 0$
    - $\int_{-\infty}^{\infty}\int_{-\infty}^{\infty}f_{X,Y}(x,y)dxdy=1$
    - 如果 X,Y 獨立
        - $f_{X,Y}(x,y)=f_X(x) \cdot f_Y(y)$
    - 對任何事件 B
        - $P(B)=\int\int_{(x,y)\in B}f_{X,Y}(x,y)dxdy$

## 邊際 PMF 
- Marginal PMF
- 已知聯合 PMF : $p_{X,Y}(x,y)$，求 $p_X(x), p_Y(y)$，稱為邊際 PMF
    - $p_X(x)=\displaystyle\sum_{y=-\infty}^{\infty}P_{X,Y}(x,y)$
    - $p_Y(y)=\displaystyle\sum_{x=-\infty}^{\infty}P_{X,Y}(x,y)$
- 已知聯合 PDF : $p_{X,Y}(x,y)$，求 $f_X(x), f_Y(y)$，稱為邊際 PDF
    - $f_X(x)=\int_{-\infty}^{\infty}f_{X,Y}(x,y)dy$
    - $f_Y(y)=\int_{-\infty}^{\infty}f_{X,Y}(x,y)dx$

# 雙變數期望值
- 聯合 PMF 下的期望值
    - $E\lbrack h(X,Y) \rbrack = \displaystyle\sum_{x=-\infty}^{\infty}\displaystyle\sum_{y=-\infty}^{\infty}h(x,y)\cdot p_{X,Y}(x,y)$
        - h(X,Y) 也可以只和 X 有關，比如它可以是 $x^2$
- 聯合 PDF 下的期望值
    - $E\lbrack h(X,Y) \rbrack = \int_{-\infty}^{\infty}\int_{-\infty}^{\infty}h(x,y)\cdot f_{X,Y}(x,y) dxdy$
    - e.g. 已知 $f_{X,Y}(x,y)=\begin{cases}
0.5, & \text{if } 0 \le y \le x \le 2, \\\\ 
0, & otherwise
\end{cases}$
        - $E \lbrack X + Y \rbrack \\\\ 
        = \int_{-\infty}^{\infty}\int_{-\infty}^{\infty}(x+y)\cdot f_{X,Y}(x,y) dxdy\\\\ 
        = \int_{0}^{2}\int_{y}^{2}(x+y)\cdot 0.5 dxdy$

- 期望值性質
    - $E\lbrack \alpha h_1(X,Y)+ \beta h_2(X,Y) \rbrack\\\\ 
    =\alpha E\lbrack  h_1(X,Y)\rbrack + \beta E\lbrack  h_2(X,Y) \rbrack$
    - 若 X,Y 獨立
        - $E\lbrack g(X)h(Y) \rbrack = E \lbrack g(X) \rbrack \cdot E \lbrack h(Y) \rbrack$
- Variance 性質
    - $Var(X+Y)=Var(X)+Var(Y)+2 \cdot Cov(X,Y)$
        - $Cov(X,Y)=E\lbrack (X-\mu_X)(Y -\mu_Y) \rbrack$
            - 如果 X, Y 獨立
                - $2E\lbrack (X-\mu_X)(Y -\mu_Y) \rbrack \\\\ 
                = 2E\lbrack (X-\mu_X) \rbrack  E\lbrack (Y -\mu_Y) \rbrack \\\\ 
                = 0$
