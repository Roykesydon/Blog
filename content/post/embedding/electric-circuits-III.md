---
title: "電路學 - III"
date: 2023-04-12T00:00:54+08:00
draft: false
description: ""
type: "post"
tags: ["electric-circuits"]
categories : ["embedded-system"]
---

## 運算放大器 (Operational Amplifiers)

### 介紹
- 運算放大器 (Operational Amplifiers)
    - 特性
        - 類似於電壓控制電壓相依電源的電子元件
        - 主動電路元件
        - 用於執行加、減、乘、除、微分與積分等運數學運算的主動電路元件
        - 由電阻、電晶體、電容和二極體等所構成的電子元件，但因內部電路的討論已超出範圍，先看作是電路模組
    - 封裝形式
        - DIP
    - 輸出電壓 $v_O$
        - $v_O=Av_d=A(v_2-v_1)$
            - $v_2$ 是非反相輸入 (noninverting input)
            - $v_1$ 是反相輸入  (inverting input)
            - $A$ 是開迴路電壓增益 (open-loop voltage gain)
                - 是沒有任何從輸出到輸入的回授 (feedback) 時，運算放大器的增益
    - 回授
        - 負回授 (negative feedback)
            - 輸出回授至反相輸入端
        - 閉迴路增益 (closed-loop gain)
            - 如果存在由輸出到輸入的回授，輸出電壓與輸入電壓的比例稱為閉迴路增益
            - 對負回授電路而言，可以證明閉迴路增益和開迴路增益無關，因此運算放大器總是用於具回授的電路中
    - 工作模式
        - 正飽和區
            - $v_O=V_{CC}$
        - 線性區
            - $-V_{CC} \leq v_O = Av_d \leq V_{CC}$
        - 負飽和區
            - $v_O=-V_{CC}$
        - 符號
            - $v_O$ 是輸出電壓
            - $v_d$ 是輸入電壓差

### 理想運算放大器 (Ideal Op Amp)

- 假定運算放大器是理想的是符合實際的，因位目前絕大多數運算放大器都有很大的增益和輸入電阻
- 具有以下特性的運算放大器，稱為理想運算放大器
    - $A \simeq \inf$
        - 開迴路增益無窮大
    - $R_i \simeq \inf$
        - 輸入電阻無窮大
    - $R_O \simeq 0$
        - 輸出電阻為零
- 特性
    - 流入兩個輸入端的電流均為 0，因為輸入電阻無窮大，輸入端間開路
    - 輸入端間的電壓差等於零，$v_d=v_2-v_1=0$

### 反相放大器 (Inverting Amplifier)
- 對輸入信號放大的同時反轉極性
- 公式
    - $v_0=-\frac{R_f}{R_1}v_i$
        - $R_f$ 是回授電阻
        - $R_1$ 是進到負回授節點前的電阻

### 非反相放大器 (Noninverting Amplifier)
- 提供正電壓增益的運算放大器電路
- 公式
    - $v_0=(1+\frac{R_f}{R_1})v_i$

- 電壓隨耦器 (voltage follewer)
    - 又稱單位增益放大器 (unity gain amplifier)
    - 條件
        - $R_f=0 或 R_1=\inf 或 (R_f=0 且 R_1=\inf)$
    - 公式
        - $v_0=v_i$

### 加法放大器 (Summing Amplifier)
- 將多個輸入結合，在輸出產生輸入的加權總合
- 公式
    - $v_O=-(\frac{R_f}{R_1}v_1+\frac{R_f}{R_2}v_2+\frac{R_f}{R_3}v_3)$

### 差動放大器 (Difference Amplifier)
- 放大兩個輸入信號的差而抑制兩個輸入的共模信號 (Common-mode signal)
- 公式
    - $v_O=\frac{R_2(1+R_1/R_2)}{R1(1+R_3/R_4)}v_2-\frac{R_2}{R_1}v_1$

- 如果 $R_2=R_1$ 且 $R_3=R_4$，動差放大器為減法器 (subtractor)
    - $v_O=v_2-v_1$

### 串級運算放大器電路 (Cascaded Op Amp Circuits)
- 串級
    - 兩個以上的運算放大器首尾相接，前一級的輸出是下一級的輸入
    - 多個運算放大器串級時，每個電路都稱為一級 (stage)
    - 運算放大器的優點
        - 串級不會改變各自輸入-輸出
            - 因為理想的運算放大器輸入電阻無窮大，輸出電阻為 0
    - 總增益為個別增益的乘積
        - $A=A_1A_2A_3$

### 數位-類比轉換器 (Digital-to-Analog Converter, DAC)
- DAC 把數位信號轉成類比信號
- 實現方法
    - 二進位加權階梯電路 (binary weighted ladder)
        - 把權重設計成二進位的加法放大器
- 輸入
    - 最高位元 (most significant bit, MSB)
    - 最低位元 (least significant bit, LSB)

### 儀表放大器 (Instrumentation Amplifiers)
- 差動放大器的延伸

## 電容器與電感器

### 介紹
- 電容器與電感器是能儲存能量的儲能元件 (storage element)

### 電容器 (Capacitors)

