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
- **Test Data**  
  - 用來測試系統的輸入  
- **Test Case**  
  - 包含測試步驟、預期結果、測試資料  
- **Oracle**  
  - 理想的結果，作為判斷測試是否成功的標準  
- **Bug**  
  - 程式中的錯誤或偏離預期的行為  
  - 相關用詞  
    - **Failure**  
      - 偏離預期的事件（event）  
    - **Error**  
      - 導致 failure 的程式錯誤（code issue）  
    - **Fault**  
      - 造成 failure 的缺陷，通常是設計或開發上的錯誤  
- **Verification**  
  - 確認系統是否符合 specification  
  - 這裡出問題是工程師的錯  
- **Validation**  
  - 確認系統是否符合使用者需求  
  - 這裡出問題代表產品目標有錯  
- **Stub**  
  - 用來代替其他 component 的簡單實作，會回傳硬編碼（hard-coded）值  
- **Mock**  
  - 類似 stub，但除了回傳預先設定的值，還會檢查是否有正確調用  
- **Driver**  
  - 負責執行 commands 和初始化變數的測試工具  

## Test Coverage
- **Line Coverage**  
  - 計算測試過的程式碼行數相對於總行數的比例  
- **Branch Coverage**  
  - 測試所有條件分支是否都被執行過，包含 if、switch...  

## Testing Types
### Unit Testing
- 測試程式的最小單位（smallest unit of software）  
- 需隔離（isolate）被測單元，避免其他單元影響測試結果  
  - 常使用 dummy value、mock 物件來替代外部依賴  


### Integration Testing
- 測試不同組件（components）之間的交互（communication）和架構（architecture）  
- 測試方式  
  - **Non-Incremental Testing**  
    - 一次測試所有 components，通常用於大型應用程式  
    - 也稱為 **Big Bang Testing**  
  - **Incremental Testing**  
    - 每次新增一個 module 進行測試，逐步測試整個系統  
    - **Top-Down Testing**  
      - 從最上層開始，尚未開發的底層使用 stub 代替  
    - **Bottom-Up Testing**  
      - 從最底層開始，尚未開發的上層使用 driver 代替  
- **Back-to-Back Testing**  
  - 比較已知良好的版本和新版本的輸出  
  - 若 output 相同，則代表新版本仍保有舊版本的正確功能  
  - 可作為 incremental testing 的一部分  

## Black Box vs White Box Testing
- **Black Box Testing**  
  - 不需要知道內部結構  
  - 透過輸入和輸出來驗證系統行為  
  - **常見設計測試案例方法**  
    - **Boundary Value Analysis**  
      - 測試邊界值，如最大、最小、剛好超出範圍的數值
      - 測試 edge cases
    - **Cause-Effect Graph**  
      - 一種設計測試案例的方法，也稱為 **fishbone diagram**  
      - 不同的輸入條件（cause）會導致不同的結果（effect）  
      - 透過表格列出所有可能的輸入組合與對應的輸出  
    - **Pair-Wise Testing**  
      - 測試多個參數的不同組合，減少測試案例數量的同時仍保證足夠覆蓋率  
    - **State-Based Testing**  
      - 測試不同狀態下的輸入，確認狀態變更的正確性  
  - 種類
    - **Functional Testing**  
      - 測試系統是否符合需求
    - **Regression Testing**  
      - 重新測試先前已經測試過的功能，確保新的更動沒有破壞舊的功能
    - **Non-Functional Testing**
      - 測試非功能性需求，如效能、安全性、可靠性

- **White Box Testing**  
  - 需了解內部結構，測試程式碼本身  
  - **常見測試方法**  
    - **Control Flow Testing**  
      - 設計測試案例，使所有的條件分支（branch condition）皆被執行  
    - **Data Flow Testing**  
      - 測試變數的生命週期，包括變數的定義（declaration）與使用（use）  
  - 應用區域
    - Unit Testing
      - 最主要是用在這
    - Integration Testing
      - 用來確保不同模組之間的溝通正確