---
title: "STM32 Timer / Counter 介紹"
date: 2023-05-04T01:32:54+08:00
draft: false
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu"]
categories : ["embedded-system"]
---

## 簡介

Timer 和 Counter 的差別是 Timer 是定期的數數

## Timing functions
- 定期對 CPU 發送 interrupt
- 產生準確時間的 delay
- 產生 pulses 或 periodic waveforms
    - PWM
- 量測 duration

## STM32 Timer / Counter

從 Basic 到 Advanced，追加更多功能

- Basic TImer (Simple Timer)
    - 16 bit auto-reload register 
    - programmable pre-scaler
    - 可以 output 到 DAC
    - update event
        - CNT=ARR(up-count)
        - CNT=0 (down-count)
        - reset CNT to 0 or ARR
        - set UIF flag in status register
    - update event interrupt
        - 如果 enabled (UIE=1)
        - UIF 被設置的時候發送訊號

    ![](/Blog/images/embedding/stm32-timer/rm-fig-367.jpg)
    ![](/Blog/images/embedding/stm32-timer/rm-fig-370.jpg)

    - $T_{EVENT}=Prescale \times Count \times T_{CK \\_ INT} \\\\
        =(PSC+1)\times(ARR+1)\times T_{CK \\_ INT}$
        - $T_{EVENT}$ 是兩次事件發生的間隔時間
        - PSC 是設定 (數值 - 1)，所以 Prescale 是 1 的話，要設 0

    - Control register
        - CEN
            - 是否啟用 counter
        - UDIS
            - 是否啟用 update event
        - URS
            - 設定產生 update event 的 source
        - OPM
            - 是否只算一次 counter 就停
        - ARPE
            - 關於中途改 ARR 的 reload 設定
        - UIF
            - interrupt

- General Purpose Timer

    ![](/Blog/images/embedding/stm32-timer/rm-fig-284.jpg)

    - 16-bit or 32-bit auto-reload register 
    - use for a variety of puposes
        - measuring lengths of input signals (Input Capture)
            - Input Capture
                - 測量 pulse width (高電位的時間) 或 period (一個週長)

        - generating output waveforms (Output Compare and PWM Generation)
            - one pulse mode output
    - Up to 4 independent channel
    - Interrupt / DMA generation
        - event
            - counter overflow / underflow
            - counter initialization
            - trigger event
            - input capture
            - output compare

- Advanced Control Timer
    - 16-bit auto-reload register 

- 特殊 timer
    - low power timer
        - 可以用在比如睡眠狀態

### 補充
- 24 bits system timer (SysTick)
- reload
    - 在 overflow 時回到 register 設定的數值

## STM32 Timer 差異
- 可以去 Datasheet 找每個 Timer 的功能

- Counter resolution
    - 16/32 bit
    - 決定能從 0 數到多少個

- Counter Type
    - 決定能往上數或往下數或都可以

- Prescaler factor
    - 可以把進來的數字先除以某個數，減緩速度

- DMA request generation
    - 能否用 DMA access 記憶體

- Capture / Compare channels
    - 一個 Timer 可能可以發多個訊號出去，並且經過多個 Compare register，比對不同 event
    - functions
        - Compare
            - 和比對 register，比到了就送 event
        - Capture
            - 紀錄下 channel 的值

- Complementary output
    - 有些馬達控制需要反向波，就要這個

- Max interface clock (MHz) and Max timer clock (MHz)
    - 進去和出來的速度

## System Clock - Clock tree
- Timer 源頭就是 clock
- 有四種來源幫忙驅動 system clock (SYSCLK)
    - HSI16 (high speed internal)
        - 16 MHz RC oscillator clock
    - MSI (multispeed internal)
        - RC oscillator clock
    - HSE (high speed external)
        - oscillator clock, from 4 to 48 MHz
    - PLL clock

- SYSCLK 往下接到 AHB，再接到 APB1、APB2

## Flash Read Access Latency
- 調整 clock 也要調整這部分

## Register
- TIMx_CR1
    - control register
- TIMx_PSC
    - 設定 prescale
- TIMx_ARR
    - auto-reload register
    
