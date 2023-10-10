---
title: "STM32CubeIDE 基本開發使用"
date: 2023-04-02T00:32:54+08:00
draft: false
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu"]
categories : ["embedded-system"]
---

## 使用的板子
STM32L476RG

## 開發文件
開發前需要先去 ST 官網，根據你的板子載四個重要文件
- Datasheet
    {{< rawhtml >}}
        <embed src="/Blog/pdf/embedding/stm32cubeide/block-diagram.pdf" type="application/pdf" style="width:100%;height:50vh">
    {{< /rawhtml >}}
    上圖是其中的 block diagram

- Reference Manuals

- Programming Manuals

- Schematic

    ![](/Blog/images/embedding/stm32cubeide/IMG_2389.png)

## 創建 project

1. File -> New -> STM32 Project
2. Board Selector 搜索 NUCLEO-L476RG，選取並 Next
3. 設置 Project Name，其他不動，Next
4. Copy only the necessary library files，Finish

## ioc
專案會有個 .ioc 檔，可以透過 GUI 生成設定 pin 的程式碼

建議 Project Manager 的 Code Generator 勾選 Generate peripheral initialization as a pair '.c/.h' files per peripheral，開發起來比較方便

## Compile
點選上面的 hammer 

## Clock Configuration
ioc 那邊還可以設置 clock

- External clock
    ![](/Blog/images/embedding/stm32cubeide/ex-clock.jpg)

    LSE 和 HSE 是 (Low / High Speed External)，你有 oscillator 的話可以自己弄

    ![](/Blog/images/embedding/stm32cubeide/sys-peripheral.jpg)

    你可以調 sysclk 或 peripheral clock

## Programming
在 USER CODE section 寫上程式碼
這是由於生成程式碼的機制所致

選取的部分可以按 F3，看他是從哪邊來的，或看 macro 之類的

按下 ```alt + /``` 會出現自動補全的提示

## DEBUG
上面有個 BUG 符號的東西，旁邊的箭頭可以用 DEBUG 的設定

又建 STM32 C/C++ Application，可以 New 新設定

C/C++ Application 那邊選你 compile 的 elf 檔

Debugger 開啟 ST-LINK S/N，並且掃描，如果你的電腦有接上 MCU，應該會直接找到