---
title: "嵌入式作業系統"
date: 2023-02-13T01:57:54+08:00
draft: true
description: ""
type: "post"
tags: ["linux","embedded-system"]
categories : ["embedded-system"]
---

# Introduce
## Cross-Platform Development
- Cross-Compiler
    - 能在某一種處理器架構跑，但是生成另外一種架構的 object code 的 compiler
        - Host: Intel(IA-32/IA-64)
        - Target: ARM/MIPS

## Essential Development Tools
- Connections between host and target system
    - serial interface
    - ICE: JTAG

- Programs including
    - system software
    - real-time operating system(RTOS)
    - kernel
    - application code

- steps
    - compiled programs into object code
    - linked together into an executable code

## Executable and linking format 
- Object file contains
    - General information
    - machine-architecture-specific binary instructions and data
    - symbol table and symbol relocation table
    - debug information
- Object file format
    - ways to organize above information
    - common formats
        - COFF(common object file format)
        - ELF(executable and linking format)
            - 取代 COFF

## Software storage
- 嵌入式系統的 code 存放在 ROM & NVRAM
    - Real-time OS
    - System software
    - Application software
- ROM
    - with non-volatile content
    - 不用額外電力
- RAM
    - 比 ROM 快很多
    - 需要額外電力 maintain 內容

## Memory Directive
- Defines types of physical memory on the target machine
- Defines address range occupied by each physical memory block
- ```
    Memory{
        ROM: org=0x0000h, len=0x0020h(32bytes)
        FLASH: org=0x0040h, len=0x1000h(4096bytes)
        RAM: org=0x10000h, len=0x10000h(65535bytes)
        ...
    }
    ```

## Section Directive
用來知道每個 object file 要怎麼連結
```
SECTION{
    .text :
    {
        ny_section
        *(.text)        
    }
    loader:> FLASH
    GROUP ALIGN(4):
    {
        .text,
        .data:{}
        .bss:{}
    }>RAM
}
```

## Why custom sections
- Module Upgradeability
- Memory Size Limitation
- Data protection

