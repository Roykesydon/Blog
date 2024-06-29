---
title: "Testing"
date: 2024-06-27T00:01:17+08:00
draft: false
description: "關於測試的基本概念"
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 通用術語
- Test data
  - 用來測試系統的輸入
- Test case
- Oracle
  - 理想的結果
- Bug
  - error 或是偏離預期的行為
  - 用詞
    - failure
      - 偏離預期的 event
    - error
      - 導致 failure 的 code part
    - fault
      - outcome

## Verification and Validation
- Verification
  - 確認系統是否符合 specifcation
  - build the system right
- Validation
  - 確認系統是否符合使用者需求
  - build the right system

## Unit Testing
- 專注在測試 smallest unit of software
- 要 isolate unit，避免其他 unit 影響測試結果
  - 用 dummy value

## Integration Testing
- 專注在測試 communication 和 architecture
- type
  - non-incremental
    - 一次測試所有 component，測試整個應用程式
  - incremental
    - 每次新增一個 module，做一些測試，反覆執行
    - Top-Down Testing
      - 用詞
        - Stub
          - 將要實現的 model 的 template，通常是 hard-coded value
      - 從最上層開始，下面調用的部分用 stub 代替
    - Bottom-Up Testing
      - 用詞
        - Driver
          - 用來執行 commands 還有初始化變數的 template
      - 從最底層開始，上面呼叫的部分用 driver 代替
- Back-to-Back Testing
  - 把已知良好的版本和新版本比較
  - 如果 output 一樣，就代表新版本舊的功能是正確的
  - 可以是 incremental testing 的一部分

## Black Box vs White Box Testing
- Black Box Testing
  - 不需要知道內部結構
  - 用 input 和 output 來測試
  - Boundary Value
    - 測試高低邊界值，過了就假設中間都過了
  - Cause-Effect Graph
    - 不同的 cause 會導致不同的 effect
  - Pair-wise Testing
    - 多個參數一起測試好確認所有條件
  - State-based Testing
    - 測試輸入，確認 state 改變的情形
- White Box Testing
  - 知道內部原理，嘗試測試程式碼本身
  - Control Flow Testing
    - 寫涵蓋所有 branch condition 的 test case
  - Data Flow Testing
    - test case 要涵蓋所有的變數，包含 declaration 和 use
