---
title: "Requirements & Specifications"
date: 2024-06-26T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## definition
### Requirement
- 找出系統目標的過程
- 系統需求的 non-technical definition
- 應該要可以被任何人理解
### Specification
- 系統需求的 technical definition
- 盡量保持簡單，不是要 design

### Functional / Non-Functional Requirement
- Functional Requirement
  - 系統應該要做什麼 (What)
- Non-Functional Requirement
  - 系統應該要怎麼做 (How)
  - 專注在 user experience

## WRSPM
- 用來理解 requirements, specifications 和 real world 之間的關聯的 reference model
- part
  - World
    - 現實世界的假設
    - ex: 有沒有網路？網速多快？使用者會自備 1 吋照片？
  - Requirements
  - Specifications
  - Program
    - code 本身
  - Machine
    - 硬體
- WRSPM Variables
  - Eh (Environment hidden)
    - Environment 中的元素，對 system 是不可見（隱藏）的
    - ex: ATM 卡本身
  - Ev (Environment visible)
    - Environment 中的元素，對 system 是可見的
    - ex: ATM 卡的晶片
  - Sv (System visible)
    - System 中的元素，對 environment 是可見的
    - ex: ATM 機的螢幕（UI）
  - Sh (System hidden)
    - System 中的元素，對 environment 是不可見的
    - ex: ATM 機連接的後端系統
- WRSPM visual model
  - 分成 Environment 和 System，中間交界是 Interface
    - Environment
      - World
      - Requirements
      - Eh
    - Interface
      - Specifications
      - Ev
      - Sv
    - System
      - Program
      - Machine
      - Sh