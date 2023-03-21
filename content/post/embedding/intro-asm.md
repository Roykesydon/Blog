---
title: "ARM 組合語言介紹"
date: 2023-03-21T01:32:54+08:00
draft: false
description: ""
type: "post"
tags: ["embedded-system", "stm32", "mcu", "assembly"]
categories : ["embedded-system"]
---

## 開發環境
### IDE
- SW4STM32
    - 支援 STM32
    - GCC C/C++ compiler
    - GDB-based debugger

### 板子
- STM32 Bucleo Board
    - Cortex-M4
    - ST-LINK
        - debugger
    - Memories
        - 1MB Flash
        - 128KB SRAM

### Debug Interface
- JTAG
    - Joint Test Action Group
    - standard ASICs hardware debug interface
- SWD
    - Serial Wire Debug
    - 只從 JTAG 用 5 wires

## Bootup Code

1. Reset
2. Boot Loader
    - 0x00000000 的程式
    - 把 CPU 重置
3. Reset handler
    - Ststem initialization

4. C startup code
5. Application(main)

## Memory map

見官網 memory map

只用到 SRAM 的 128KB(SRAM)，還有 Code 的 1MB(Flash)

## Sections
- .data
    - 儲存資料
- .text
    - 儲存程式碼

同 section 會放在一塊是為了設定 read-only 方便，比如 .text 的要靠硬體實現 read-only

## 重要的額外文件
- Linker Script
    - 定義了不同 section 該存放的地方，以及 memory 相關定義
    ```assembly
    MEMORY
    {
        RAM (xrw)		: ORIGIN = 0x20000000, LENGTH = 96K
        ROM (rx)		: ORIGIN = 0x8000000, LENGTH = 1024K
    }

    SECTIONS
    {
    /* The program code and other data into ROM memory */
    .text :
    {
        . = ALIGN(8);
        *(.text)           /* .text sections (code) */
        *(.text*)          /* .text* sections (code) */
        *(.glue_7)         /* glue arm to thumb code */
        *(.glue_7t)        /* glue thumb to arm code */
        *(.eh_frame)

        KEEP (*(.init))
        KEEP (*(.fini))

        . = ALIGN(8);
        _etext = .;        /* define a global symbols at end of code */
    } >ROM

    .data : 
    {
        . = ALIGN(8);
        _sdata = .;        /* create a global symbol at data start */
        *(.data)           /* .data sections */
        *(.data*)          /* .data* sections */

        . = ALIGN(8);
        _edata = .;        /* define a global symbol at data end */
    } >RAM AT> ROM
    }
    ```
- Make File
    - 描述如何編譯和連接的規則
    - 把 startup 的 .s檔加進去
- startup_stm32.s
    - 編譯好後擺在 binary 頭的地方
    - vector table
        ```assembly
        /******************************************************************************
        *
        * The STM32L476RGTx vector table.  Note that the proper constructs
        * must be placed on this to ensure that it ends up at physical address
        * 0x0000.0000.
        *
        ******************************************************************************/
        .section .isr_vector,"a",%progbits
        .type g_pfnVectors, %object
        .size g_pfnVectors, .-g_pfnVectors


        g_pfnVectors:
        .word _estack
        .word Reset_Handler
        .word NMI_Handler
        .word HardFault_Handler
        .word	MemManage_Handler
        .word	BusFault_Handler
        .word	UsageFault_Handler
        .word	0
        .word	0
        .word	0
        .word	0
        .word	SVC_Handler
        ```

        - Reset_Handler
            ```
            Reset_Handler:
                ldr   r0, =_estack
                mov   sp, r0          /* set stack pointer */

                /* Copy the data segment initializers from flash to SRAM */
                ldr r0, =_sdata
                ldr r1, =_edata
                ldr r2, =_sidata
                movs r3, #0
                b LoopCopyDataInit

            LoopCopyDataInit:
                adds r4, r0, r3
                cmp r4, r1
                bcc CopyDataInit
                
                /* Zero fill the bss segment. */
                ldr r2, =_sbss
                ldr r4, =_ebss
                movs r3, #0
                b LoopFillZerobss

            LoopFillZerobss:
                cmp r2, r4
                bcc FillZerobss

                /* Call the clock system intitialization function.*/
                bl  SystemInit
                /* Call static constructors */
                bl __libc_init_array
                /* Call the application's entry point.*/
                bl main
            ```

## ARM Register
- ARM 的可存取暫存器為 R0-R15
    - r13: Stack Pointer
    - r14: Link Register
    - r15: Program Counter
    - r0~r7 是 low register r8~r15 是 high register

- 狀態暫存器
    - CPSR (Current Processor Status Register)
        - 用來儲存各種狀態，包含 condition flag，比如 negative, zero, carry, overflow
            - carry: 無符號加法操作是否溢出
            - overflow: 有符號加法操作是否溢出
            - 當兩個都為 1 或都為 0 代表運算沒問題

- 有多種模式，有些模式有自己獨立的 r 暫存器，並有 SPSR，用來在中斷發生時，把 CPSR 的資訊 copy 過去

- Special-purpose registers
    - APSR, IPSR, EPSR

## Assembly syntax
- UAL: Unified Assembler Language
- 自己去翻 instruction set

### Instructions class
- Branch instructions
    - B, BL, BX,...
- Data-processing instructions
    - MOV, ADD, SUB, MUL,...
- Load and store instructions
    - LDR, STR,...
- Status register access instructions
    - MSR, MRS,...
- Miscellaneous instructions
    - Memory Barrier instructions
    - Exception-Related instructions
    - Pseudo instructions

### examples
- ```MOVS R0, #0x12```
    - R0=0x12
- ```MOVS R1, #`A` ```
    - R1=A(ASCII)

- ```NVIC_IRQ_SETEN  EQU  0xE000E100```
    - 宣告常數 NVIC_IRQ_SETEN，賦值 0xE000E100
- ```LDR R0,=NVIC_IRQ_SETEN```
    - 放 0xE000E100 進 R0
    - 這不能改成 ```MOVS R0, #0xE000E100 ```，因為每個 instruction 只有 32 個 bits，這勢必塞不下，必須從記憶體 load 進來

- ```NVIC_IRQ0_ENABLE  EQU  0x1```
    - 宣告常數 NVIC_IRQ0_ENABLE，賦值 0x1
- ```MOVS R1, #NVIC_IRQ0_ENABLE```
    - R1=0x1

- ```STR R1, [R0]```
    - 把 0x1 存到 0xE000E100，這裡可以 enable external interrupt IRQ#0

- ```LDR rn [pc, #offset to literal pool]```
    - load register n with one word from the address [pc + offset]
    - 最後的形式

### Operand2
- 共有 12 bits
    - 設計成 4 bits for rotate, 8 bits for Immediate

### ARM instrcution formats
- ADD vs ADDS
    - 有 S 代表會去更新 status
- cond
    - 根據之前的執行情況，判斷指令要不要執行
    - suffix

### Reverse Ordering Operations
- REV (Byte-Reverse Word)
    - 把 4 個 Byte 全數反轉，用在一個是 Little-Endian 一個是 Big-Endian 的情況

### Load and Store Instructions
- examples
    - ```LDR r0, [r1]```
        - r0 = [r1]
    - ```LDM r0, {r1, r2}```
        - r1 = [r0]
        - r2 = [r0+4]
    - ```STM r0, {r1, r2}```
        - [r0] = r1
        - [r0+4] = r2

### Status Register Access Instructions
- 一般來說不太會用到，因為用 suffix 就可以看條件
- MRS: Register = Status Register
    - ```MRS r0, IPSR```
- MSR: Status Register = Register
    - ```MSR APSR, r0```

### If-Then-Else

- 用 CMP 和 conditional branches
- Example
    - ```
        CMP R0, #10   ;compare r0 to 10
        BLE incr_counter ; if less or equal, then branch to incr_counter
        ```

### Branch Instructinos
能跳的距離受限於 operand 長度

- B-Branch
    - 能跳 PC 的 +/- 2046 bytes
- BL-Branch and Link
    - 能跳 PC 的 +/- 254 bytes
    - Branch to subroutine 的時候，會把下一行指令放到 Link register
    - 沒有 push 到 stack，所以要特別小心，register 是共用的，
    可能要視情況自己放到 stack
        - 比如要進兩層 function，可以用 ```push {r4-r6, LR}``` 和 ```POP {R4-R6, PC}``` 這種做法來保留參數
- BX-Branch and exchange
    - return

### Stack memory access
- PUSH
    - SP = SP - N*4
- POP
    - SP = SP + N*4

- Ascending/Descending
    - stack 往哪個方向長
- Empty/Full
    - stack 指向下一個空的位置，還是最後一個 item
- 預設且常見的是 fully descending

- STM 和 LDM 可以透過 suffix 來存到 stack
    - example
        - ```STMFD r13!, {r4-r7}```
        - 把 r4 到 r7 push 到 stack

### Memory Barrier Instructions
- DMB, SDB, ISB
- 在下個指令前 sync memory data

## Function Call and Parameter Passing

- caller 和 callee 誰負責 backup 和 restore
    - caller 負責
        - 不管 callee 怎樣亂搞都行
        - 但不知道 callee 要用哪些參數，全 backup 可能多此一舉
- 怎麼傳遞參數給 callee
    - 常放在 stack，但這樣要透過 memory，相較 register 慢
- 怎麼 return value 給 caller
    - 和上個問題差不多

### ARM Procedure Call Standard
又稱 APCS，講不同的 register 的一種使用規範
- r0-r3 用來當參數和回傳
- r4-r11 用來 local variable，callee 使用前可以先 backup
- r12-r15 特殊用途，沒事別亂動