---
title: "STM32 GPIO 介紹"
date: 2023-04-26T01:32:54+08:00
draft: false
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu"]
categories : ["embedded-system"]
---

## Memory Map

- CPU 對 I/O 操作方法
    - Port I/O
        - 用特殊 CPU 指令
        - I/O 設備和記憶體不共享地址空間
    - Memory-Mapped I/O
        - I/O 設備和記憶體共享地址空間
        - 像一般控制記憶體

- 這塊記憶體具有四個責任
    - Command
    - Status
    - Output Data
    - Input Data




## GPIO 結構

![](/Blog/images/embedding/stm32-gpio/gpio-structure.jpg)

- GPIO mode
    - Open-Drain
        - 由外部電壓決定輸出電壓
        - Output Register 是 0 會啟用 N-MOS，1 的話靠外部電壓推 
            - 好處是外部電壓可以自己決定
    - Push-Pull
        - 由內部電壓決定輸出電壓
        - Output Register 是 0 或 1 會決定啟用 N-MOS 或是 P-MOS

### 有關 Register
- Clock enable register
    - AHB2 peripheral clock enable regisetr (RCC_AHB2ENR)
- Control register
    - GPIO port mode register
    - GPIO port output type register
    - GPIO port output speed register
    - GPIO port pull-up/pull-down register
- Data register
    - Output
    - Input

## 使用 GPIO
先去 Memory map 找 Boudary address

![](/Blog/images/embedding/stm32-gpio/gpio-structure.jpg)


根據 table 確認要設置的數值

![](/Blog/images/embedding/stm32-gpio/table-39-1.jpg)

![](/Blog/images/embedding/stm32-gpio/table-39-2.jpg)

設定 RCC enable

![](/Blog/images/embedding/stm32-gpio/rcc-en.jpg)

把上面說的各種 Control register 設定好

比如 PUPDR 
![](/Blog/images/embedding/stm32-gpio/PUPDR.jpg)

- BSRR
    - 修改 ODR 會一次改到整個 GPIO port，若只要改某個 pin，可以用 BSRR

- Delay
    - CPU 4 MHz
        - 1 cycle = 0.25$\mu$S
        - 可以查每個組合語言指令要幾個 cycle

- 機械按鈕會有 Bouncing
    - Debounce
        - Hardware method
            - 加上濾波電容
        - Software method
            - 讀取後等待一段時間才再次讀取
            - 連續讀取 N 次，看數值是否穩定改變

## 7-Segment

- COM 分共陽、共陰

- 8 個七段顯示器就要吃掉 8 * 8 個 GPIO 接腳，可以每次只顯示一個，那只需要 8 個 GPIO 接腳，快速閃過

- 也可用 Max 7219 控制，他有三個輸入 DIN、LOAD、CLK
    - DIN 輸入資料
    - CLK 上升的時候採樣，最多 10 MHz
    - LOAD(CS) 採用最後輸進去的 16 bits
        - 最早的是 MSB