---
title: "ARM GPIO 介紹"
date: 2023-03-30T00:00:54+08:00
draft: true
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu", "assembly"]
categories : ["embedded-system"]
---

## AMBA
Advanced Microcontroller Bus Architecture
- Advanced High-performance Bus(AHB)
    - ARM 的北橋
- Advanced Peripheral Bus(APB)
    - ARM 的南橋

## General-purpose inputs/outputs
- GPIO
- STM32L476 的 AHB2 上有 A~H GPIO port
    - 除了 H，每個 port 有 16 pins