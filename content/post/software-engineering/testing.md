---
title: "Testing"
date: 2024-06-27T00:01:17+08:00
draft: false
description: "關於測試的基本概念"
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

### 測試相關概念
- **Test Data**
  - 用來測試系統的輸入
- **Test Case**
  - 包含測試步驟、預期結果、測試資料
- **Oracle**
  - 理想的結果，作為判斷測試是否成功的標準
- **Verification（驗證）**
  - 確認系統是否符合規格（specification）
  - 若出錯，通常是開發或設計的問題
- **Validation（確認）**
  - 確認系統是否符合使用者需求
  - 若出錯，代表產品目標可能有誤

### Bug 與錯誤類型
- **Bug**
  - 程式中的錯誤或偏離預期的行為
- **Failure**
  - 偏離預期的事件（event），如系統崩潰或錯誤輸出
- **Error**
  - 導致 failure 的程式錯誤（code issue）
- **Fault（缺陷）**
  - 造成 failure 的設計或開發上的錯誤，可能潛伏在系統內直到被觸發

### 測試輔助工具
- **Stub**
  - 用來代替其他元件的簡單實作，會回傳硬編碼（hard-coded）值
- **Mock**
  - 類似 stub，但除了回傳預設值，還可驗證是否正確調用
- **Driver**
  - 負責執行測試指令並初始化變數的工具

## 測試覆蓋率（Test Coverage）
- **Line Coverage（行覆蓋率）**
  - 測試過的程式碼行數相對於總行數的比例
- **Branch Coverage（分支覆蓋率）**
  - 測試所有條件分支是否都被執行過，如 if、switch 內的所有可能路徑

## 測試類型（Testing Types）
### 單元測試（Unit Testing）
- 測試程式的最小單位（smallest unit of software）
- 需隔離（isolate）被測單元，避免外部依賴影響測試結果
  - 常使用 dummy value、mock 物件來替代外部依賴


### 整合測試（Integration Testing）
- 測試不同組件（components）之間的交互（communication）和架構（architecture）
- 測試方式
  - **Big Bang Testing（非漸進式測試）**
    - 一次測試所有 components，通常用於大型應用程式
  - **Incremental Testing（漸進式測試）**
    - 逐步新增模組進行測試，直到完整測試整個系統
    - **Top-Down Testing**
      - 從最上層開始，尚未開發的底層使用 stub 代替
    - **Bottom-Up Testing**
      - 從最底層開始，尚未開發的上層使用 driver 代替
  - **Back-to-Back Testing（對比測試）**
    - 比較已知良好版本與新版本的輸出
    - 若 output 相同，則新版本仍保有舊版本的正確功能 
    - 可作為 incremental testing 的一部分  

## 黑箱測試 vs 白箱測試
### 黑箱測試（Black Box Testing）
- 不需要知道內部結構，透過輸入與輸出來驗證系統行為
- **常見測試方法**
  - **Boundary Value Analysis（邊界值分析）**
    - 測試邊界值，如最大、最小、剛好超出範圍的數值
  - **Cause-Effect Graph（因果圖測試）**
    - 一種設計測試案例的方法，也稱為 **fishbone diagram**
    - 不同的輸入條件（cause）會導致不同的結果（effect）
  - **Pair-Wise Testing（成對測試）**
    - 測試多個參數的不同組合，減少測試案例數量的同時仍保證足夠覆蓋率
  - **State-Based Testing（狀態測試）**
    - 測試不同狀態下的輸入，確認狀態變更的正確性
- **測試種類**
  - **Functional Testing（功能測試）**
    - 確保系統功能符合需求
  - **Regression Testing（回歸測試）**
    - 重新測試已驗證過的功能，確保新的修改沒有破壞舊的功能
  - **Non-Functional Testing（非功能測試）**
    - 測試效能、安全性、可靠性等非功能性需求

### 白箱測試（White Box Testing）
- 需要了解內部結構，測試程式碼本身
- **常見測試方法**
  - **Control Flow Testing（控制流程測試）**
    - 設計測試案例，使所有條件分支（branch condition）皆被執行
  - **Data Flow Testing（資料流測試）**
    - 測試變數的生命週期，包括變數的定義（declaration）與使用（use）
- **應用範圍**
  - **Unit Testing**
    - 最主要用於單元測試
  - **Integration Testing**
    - 用於確保不同模組之間的溝通正確