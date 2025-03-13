---
title: "STM32 UART 實驗"
date: 2023-04-09T01:32:54+08:00
draft: true
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu"]
categories : ["embedded-system"]
---

## 介紹
試用 STM32 UART 功能

會透過 RealTerm 和 STM32L476RG 溝通，並用 DMA 接收訊息

根據 User manual，USART2 預設會連接 ST-LINK，要連接外部設備的話要修改 solder bridge

## ioc 設置
- Connectivity 可以設置 USART2
- mode 從 disable 改選 Asynchronous
- Parameters Settings 可以設置各種資訊 
    - Baud Rate
    - Word Length
    - Parity
    - Stop Bits
- DMA Setting
    - Add 一個 RX
        - Mode 改成 circular，並打開 memory 的 increment address
            - increment address 是因為資料是用 array 存
            - circular 是當資料滿了後，會回到 zero position 
- NVIC Setting
    - 設置 DMA 應該就會自動設置一個 interrupt，檢查一下

## 程式碼
發送
```c
uint8_t myTxData[13] = "Hello World\r\n";
HAL_UART_Transmit(&huart2, myTxData, 13, 10);
```

接收
```c
UART_HandleTypeDef huart2; // generated code

uint8_t myRxData[20];
HAL_UART_Receive_DMA(&huart2, myRxData, 20); // 在 Init 後，在 main 中執行一次就好
```

interrupt

在 hal_uart.c 有
```c
__weak void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(huart);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_UART_RxCpltCallback can be implemented in the user file.
   */
}

```
當 DMA 滿了就會呼叫這個 function

## 實驗
```c
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(huart);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_UART_RxCpltCallback can be implemented in the user file.
   */
  HAL_UART_Transmit(&huart2, myRxData, 20, 10);
}
```
當 20 個 Bytes 儲存滿了就回傳資訊給電腦

### RealTerm
#### Display
- 勾選 Half Duplex
    - 發送的訊息會顯示綠色，接收的是黃色
#### Port
- 設置 Baud 和其他有的沒的
- 選 open
#### Send
- EOL 可以勾選 CRLF
- 打一些文字後按 Send ASCII

### 結果
![](/Blog/images/embedding/stm32-uart/result.jpg)

[程式碼](https://github.com/Roykesydon/STM32-Playground/tree/main/STM32-UART/uart_test)