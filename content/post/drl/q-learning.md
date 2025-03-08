---
title: "Q-learning"
date: 2023-02-20T16:21:23+08:00
draft: false
type: "post"
tags: ["deep-learning","machine-learning","reinforcement-learning"]
categories : ["deep-learning"]
---

# RL 方法
- Policy-based
    - learn 做事的 actor
- Value-based
    - 不直接 learn policy，而是 Learn critic，負責批評
    - Q-learning 屬於這種

# Critic
- 不直接決定 action
- 給予 actor $\pi$，評估 actor $\pi$ 有多好
- critic 的 output 依賴於 actor 的表現

## State Value Function

- State value function $V^{\pi}(s)$
    - 用 actor $\pi$，看到 s 後玩到結束，cumulated reward expectation 是多少

### 評估方法
- Monte-Carlo(MC) based approach
    - critic 看 $\pi$ 玩遊戲
    - 訓練一個 network，看到不同的 state ，輸出 cumulated reward(直到遊戲結束，以下稱為 $G_a$)，解 regression 問題
- Temporal-difference(TD) approach
    - MC 的方法至少要玩到遊戲結束才可以 update network，但有些遊戲超長
        - TD 只需要 {$s_t,a_t,r_t,s_{t+1}$}
    - $V^{\pi}(s_t)=V^{\pi}(s_{t+1})+r_t$

- MS v.s. TD
    - MC
        - Larger variance
            - 每次的輸出差異很大
    - TD
        - smaller variance
            - 相較 $G_a$ 較小，因為這邊的 random variable 是 r，但 $G_a$ 是由很多 r 組合而成
        - V 可能估得不準確
            - 那 learn 出來的結果自然也不准
        - 較常見

## Another Critic
- State-action value function $Q^\pi(s,a)$
    - 又叫 Q function
    - 當用 actor $\pi$ 時，在 state s 採取 a 這個 action 後的 cumulated reward expectation
        - 有一個要注意的地方是，actor 看到 s 不一定會採取 a

    ![](/images/drl/q-learning/q-function.png)

    ![](/images/drl/q-learning/how-to-use-q.png)

    - 只要有 Q function，就可以找到"更好的" policy，再替換掉原本的 policy
        - "更好的"定義
            - $V^{\pi^{'}} \ge V^{\pi}(s), \text{for all state s}$
        - $\pi^{'}(s)=arg \underset{a}{max}Q^{\pi}(s,a)$
            - $\pi^{'}$ 沒有多餘的參數，就單純靠 Q function 推出來
            - 這邊如果 a 是 continuous 的會有問題，等等解決
            - 這樣就可以達到"更好的"policy，不過就不列證明了

# Basic Tip
## Target network
- 在 training 的時候，把其中一個 Q 固定住，不然要學的 target 是不固定的，會不好 train

![](/images/drl/q-learning/target-network.png)

## Exploration
- policy 完全 depend on Q function
- 如果 action 總是固定，這不是好的 data collection 方法，要在 s 採取 a 過，才比較好估計 Q(s, a)，如果 Q function 是 table 就根本不可能估出來，network 也會有一樣的問題，只是沒那麼嚴重。

### 解法
- Epsilon Greedy
    - $a=\begin{cases}
arg \underset{a}{max}Q(s,a), & \text{with probability } 1-\varepsilon \\\\ 
random, & otherwise
\end{cases}$
    - 通常 $\varepsilon$ 會隨時間遞減，因為你一開始 train 的時候不知道怎麼比較好
- Boltzmann Exploration
    - $P(a|s)=\frac{exp(Q(s,a))}{\sum_a exp(Q(s,a))}$

## Replay Buffer
- 把一堆的 {$s_t,a_t,r_t,s_{t+1}$} 存放在一個 buffer
- {$s_t,a_t,r_t,s_{t+1}$} 簡稱為 exp
- 裡面的 exp 可能來自於不同的 policy
- 在 buffer 裝滿的時候才把舊的資料丟掉
- 每次從 buffer 隨機挑一個 batch 出來，update Q function

### 好處
- 跟環境作互動很花時間，這樣可以減少跟環境作互動的次數
- 本來就希望 batch 裡的 data 越 diverse 越好，不會希望 batch 裡的 data 都是同性質的

### issue
- 我們要觀察 $\pi$ 的 value，混雜了一些不是 $\pi$ 的 exp 到底有沒有關係?
    - 理論上沒問題，但李老師沒解釋

## Typical Q-learning 演算法
- 初始化 Q-fucntion Q，target Q-function $\hat{Q}=Q$
- 在每個 episode
    - 對於每個 time step t
        - 給 state $s_t$，根據 Q 執行 action $a_t$ (epsilon greedy)
        - 獲得 reward $r_t$，到達 $s_{t+1}$
        - 把 {$s_t,a_t,r_t,s_{t+1}$} 存到 buffer
        - 從 buffer sample {$s_t,a_t,r_t,s_{t+1}$}(通常是一個 batch)
        - Target $y=r_i+\underset{a}{max}\hat{Q}(s_{i+1},a)$
        - Update Q 的參數，好讓 $Q(s_i,a_i)$ 更接近 y(regression)
        - 每 C 步 reset $\hat{Q}=Q$