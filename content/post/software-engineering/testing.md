---
title: "Testing"
date: 2024-06-27T00:01:17+08:00
draft: false
description: "關於測試的基本概念"
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 測試常見名詞

| 名稱 | 說明 |
|------|------|
| **Test Data（測試資料）** | 作為測試輸入的資料，用來觸發系統特定行為。 |
| **Test Case（測試案例）** | 包含測試步驟、預期結果與輸入資料，用來驗證特定功能。 |
| **Oracle（預期輸出）** | 正確的預期結果，用來判斷實際執行結果是否正確。 |
| **Verification（驗證）** | 驗證系統是否「符合設計規格（specification）」，偏向技術層面，錯誤多源自開發問題。 |
| **Validation（確認）** | 確認系統是否「滿足使用者需求」，偏向需求層面，錯誤多來自需求理解錯誤。 |
| **Bug（臭蟲）** | 程式中的實作錯誤，導致偏離預期行為。 |
| **Error（錯誤）** | 開發時的程式錯誤（code issue），導致 failure。 |
| **Failure（失敗）** | 系統運行時表現出偏離預期的事件（event），例如錯誤輸出、崩潰等。 |
| **Fault（缺陷）** | 軟體內潛伏的錯誤，可能尚未被觸發，但會在特定條件下造成 failure。 |

## 常見測試輔助工具
| 工具 | 功能 |
|------|------|
| **Stub** | 用簡單實作代替尚未開發或複雜的元件，回傳硬編碼（hard-coded）結果。 |
| **Mock** | 類似 Stub，且能驗證被測元件是否以正確方式調用依賴物件。 |
| **Driver** | 用來呼叫（驅動）底層尚未整合的元件並進行測試的控制器。也就是由 Driver 調用要被測試的模組 |

## 測試層級（Testing Levels）
### 單元測試（Unit Testing）
- 測試程式的最小單位（smallest unit of software）
- 必須隔離外部依賴，常使用 mock、dummy objects
- 多配合白箱測試手法進行控制流程與資料流程的驗證


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

### 測試種類（Testing Types）
- **Functional Testing（功能測試）**
  - 確保系統功能符合需求
- **Regression Testing（回歸測試）**
  - 重新測試已驗證過的功能，確保新的修改沒有破壞舊的功能
- **Non-Functional Testing（非功能測試）**
  - 測試效能、安全性、可靠性等非功能性需求

## 測試方法（Testing Techniques）
### 黑箱測試（Black Box Testing）
- 不需要知道內部結構，透過輸入與輸出來驗證系統行為
- **常見測試方法**
  - **Equivalence Partitioning（等價類劃分）**
    - 將輸入資料劃分為有效與無效區間，只需針對每個區間挑選一個代表值測試。
  - **Boundary Value Analysis（邊界值分析）**
    - 測試邊界值與剛好超出範圍的輸入
  - **Cause-Effect Graph（因果圖測試）**
    - 透過輸入條件（cause）與對應結果（effect）建立測試案例，也稱為魚骨圖（fishbone diagram）
  - **Pair-Wise Testing（成對測試）**
    - 測試多參數組合的代表案例，降低測試數量但保證覆蓋率
    - 確保每一對參數的每種可能組合至少被測試一次，依據「大多數系統錯誤是由「兩個參數之間的交互作用」造成，而非三個以上」的假設
  - **State-Based Testing（狀態測試）**
    - 測試不同狀態下的輸入，確認狀態遷移是否正確
  - **Error Guessing（錯誤猜測）**
    - 根據經驗猜測容易出錯的地方進行測試，如除以零、空字串、極端值等。

### 白箱測試（White Box Testing）
- 需要理解程式內部結構，測試程式碼本身（比如邏輯、流程、變數操作）
- **常見測試方法**
  - **Line Coverage（行覆蓋率）**：實際執行的程式行數／程式總行數。
  - **Branch Coverage（分支覆蓋率）**：測試是否涵蓋所有條件分支（如 if/else、switch case 等）。
  - **Path Coverage**：測試是否涵蓋所有執行路徑，是覆蓋率中最細緻的一種，但成本也較高。舉個例子說明和 Branch coverage 的差別，如果有兩組 if-else，Branch coverage 只需要測試每個 if 的 true 和 false 就可以了，但 Path coverage 需要測試所有可能的路徑組合。
  - **Control Flow Testing（控制流程測試）**
    - 設計測試案例，使所有條件分支（branch condition）皆被執行
  - **Data Flow Testing（資料流測試）**
    - 測試變數的生命週期，如定義、使用及釋放
- **應用範圍**
  - **Unit Testing**
    - 最主要用於單元測試
  - **Integration Testing**
    - 確保模組間通訊與協調正確

## 持續整合與開發測試方法

### 持續整合（Continuous Integration, CI）
- 目標是讓開發團隊頻繁地（通常每日多次）將程式碼合併到主分支。  
- 每次提交後自動執行編譯、單元測試和靜態分析，盡早發現問題。  
- 有助於提升軟體品質與交付速度，降低整合風險。  
- 常用工具：Jenkins、GitLab CI、GitHub Actions、CircleCI 等。

### 測試驅動開發（Test-Driven Development, TDD）
- 開發流程：「先寫測試，再寫功能實作，最後重構」的循環。  
- 流程：
  1. 編寫一個失敗的單元測試（Red）。  
  2. 撰寫足夠代碼讓測試通過（Green）。  
  3. 重構代碼使結構更佳（Refactor），且測試持續通過。  
- 優點：確保測試覆蓋率高，設計更模組化且可維護。  
- 適用於單元測試與驅動核心邏輯的開發。

### 行為驅動開發（Behavior-Driven Development, BDD）
- 基於 TDD，但語言更貼近業務與用戶角度，強調「溝通與行為」。
- 測試範例使用自然語言編寫（如英文），容易讓開發者、產品經理與測試人員共同參與需求規格設計。
- 常使用 Gherkin 語法撰寫場景（Scenarios），格式為：

  ```gherkin
  Feature: 註冊帳號功能

    Scenario: 使用者成功註冊
      Given 使用者在註冊頁面
      When 使用者輸入有效的電子郵件與密碼
      And 點擊註冊按鈕
      Then 使用者應該會看到註冊成功訊息
      And 使用者帳號會被建立在資料庫中
  ```

#### 撰寫 BDD 的原則
- 易讀性（Readable）：使用非技術人員也能理解的自然語言。
- 行為導向（Behavior-Focused）：描述系統應有的行為，而不是內部實作。
- 單一行為（One Behavior per Scenario）：一個測試場景應聚焦於一個明確的行為。
- 明確的 Given-When-Then 結構：
  - Given：描述初始狀態與前提。
  - When：觸發的動作。
  - Then：預期結果。
- 避免實作細節：不提及按鈕的 CSS 或 API URL，只描述使用者與系統互動的結果。
- 可重複執行（Repeatable）：測試在任何環境下執行結果都應一致。

- 常見工具
  - Cucumber（Java, JS, Ruby）
  - Behave（Python）
  - SpecFlow（.NET）
  - Behat（PHP）