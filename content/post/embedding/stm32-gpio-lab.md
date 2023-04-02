---
title: "STM32 GPIO 實驗"
date: 2023-04-02T01:32:54+08:00
draft: false
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu"]
categories : ["embedded-system"]
---

## 目的
本文會試用 GPIO output / input / interrupt

## GPIO 架構

![](/Blog/images/embedding/stm32-gpio-lab/gpio-structure.jpg)

## Output 介紹

在 ioc 那邊選個 pin，選 GPIO_Output

在左邊欄位 System Core 選擇 GPIO

有五個欄位可以設定

- GPIO output level
    - 初始電位

- GPIO mode
    - push pull 和 open drain
        - 位於架構圖下方那部分，push pull 可以用 PMOS 和 NMOS 來得到高低電位，open drain 會 disable PMOS，讓你可以在外面自己接上拉電阻
- GPIO Pull-up/Pull-down
- Maximum output speed
- User Label

用完記得 ctrl+s 讓他 generate code

```c
/*Configure GPIO pin : PtPin */
GPIO_InitStruct.Pin = RED_LED_Pin;
GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
GPIO_InitStruct.Pull = GPIO_NOPULL;
GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
HAL_GPIO_Init(RED_LED_GPIO_Port, &GPIO_InitStruct);

/*Configure GPIO pin Output Level */
HAL_GPIO_WritePin(RED_LED_GPIO_Port, RED_LED_Pin, GPIO_PIN_RESET);
```

```c
HAL_GPIO_WritePin(RED_LED_GPIO_Port, RED_LED_Pin, GPIO_PIN_RESET); // 低電位
HAL_GPIO_WritePin(RED_LED_GPIO_Port, RED_LED_Pin, GPIO_PIN_SET); // 高電位
HAL_Delay(1000); //等一秒
HAL_GPIO_TogglePin(RED_LED_GPIO_Port, RED_LED_Pin)
```

根據架構圖左側，你可以透過修改 BSRR 來修改 ODR，達到修改書出的效果，請見 Reference Manuals，實際上 ```HAL_GPIO_WritePin``` 也是這樣實現的
```c
void HAL_GPIO_WritePin(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin, GPIO_PinState PinState)
{
    /* Check the parameters */
    assert_param(IS_GPIO_PIN(GPIO_Pin));
    assert_param(IS_GPIO_PIN_ACTION(PinState));

    if(PinState != GPIO_PIN_RESET)
    {
        GPIOx->BSRR = (uint32_t)GPIO_Pin;
    }
    else
    {
        GPIOx->BRR = (uint32_t)GPIO_Pin;
    }
}
```

## Input 介紹
看架構圖上方，用 Schmitt trigger 取得高低電位資料，他有 upper threshold 和 lower threshold，而不是用 single threshold

```c
/*Configure GPIO pin : PtPin */
GPIO_InitStruct.Pin = GREEN_LED_INPUT_Pin;
GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
GPIO_InitStruct.Pull = GPIO_NOPULL;
HAL_GPIO_Init(GREEN_LED_INPUT_GPIO_Port, &GPIO_InitStruct);
```

```c
uint8_t green_led_input = HAL_GPIO_ReadPin(GREEN_LED_INPUT_GPIO_Port, GREEN_LED_INPUT_Pin);
```

## Interrupt

ioc 選個 pin，設定 GPIO_EXTI，這邊我選 B1(PC13)，也就是開發版上的藍色按鈕

可以選 GPIO mode，這邊選 Falling Edge Trigger，值得一提的是他的設計是上拉電阻，所以這樣不是放開後觸發，是按下後觸發。

![](/Blog/images/embedding/stm32-gpio-lab/b1.jpg)

ioc 的 System Core 的 NVIC 還要把 EXTI line[15:10] interrupts 給 enabled，然後 Code generation 打開 Generate IRQ handler，還有 Call HAL handler。

在 ```stm32l4xx_it.c``` 裡，
現在會有
```c
void EXTI15_10_IRQHandler(void)
{
  /* USER CODE BEGIN EXTI15_10_IRQn 0 */

  /* USER CODE END EXTI15_10_IRQn 0 */
  HAL_GPIO_EXTI_IRQHandler(B1_Pin);
  /* USER CODE BEGIN EXTI15_10_IRQn 1 */

  /* USER CODE END EXTI15_10_IRQn 1 */
}
```
這兩行各別是因為我們剛剛開的功能生的

```c
void HAL_GPIO_EXTI_IRQHandler(uint16_t GPIO_Pin)
{
  /* EXTI line interrupt detected */
  if(__HAL_GPIO_EXTI_GET_IT(GPIO_Pin) != 0x00u)
  {
    __HAL_GPIO_EXTI_CLEAR_IT(GPIO_Pin);
    HAL_GPIO_EXTI_Callback(GPIO_Pin);
  }
}

__weak void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(GPIO_Pin);

  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_GPIO_EXTI_Callback could be implemented in the user file
   */
}
```

__weak 代表有同名 function 的話，就會採用沒 __weak prefix 的

所以我們可以在 gpio.c 放下面的程式碼

```c
#include <stdbool.h>

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
    if(GPIO_Pin == B1_Pin){
        static bool prev_val = false;
        if(prev_val == false){
            HAL_GPIO_WritePin(RED_LED_GPIO_Port, RED_LED_Pin, GPIO_PIN_SET);
            prev_val = true;
        }
        else{
            HAL_GPIO_WritePin(RED_LED_GPIO_Port, RED_LED_Pin, GPIO_PIN_RESET);
            prev_val = false;
        }
    }
}
```

## 實驗
設定兩個輸入，一個輸出，一個 interrupt

- 當按下按鈕時，切換紅色 LED 的亮滅，並且讓板子上的綠色 LED 輸出和紅色 LED 相反的結果

- B1(PC13、藍色按鈕) 按下去的時候，會發出 interrupt，並讓 RED_LED(PC10) 輸出和上次相反的電位，讓麵包版上的紅色 LED 亮滅，正極那邊接一條杜邦線給 GREEN_LED_INPUT (PC12)，並且 LD2(PA5、板子上的綠色 LED) 會輸出和紅色 LED 相反的結果。

![](/Blog/images/embedding/stm32-gpio-lab/result1.jpg)

![](/Blog/images/embedding/stm32-gpio-lab/result2.jpg)

[程式碼](https://github.com/Roykesydon/STM32-Playground/tree/main/STM32-GPIO/gpio_testing)