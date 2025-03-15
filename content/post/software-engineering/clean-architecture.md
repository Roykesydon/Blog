---
title: "Clean Architecture"
date: 2023-05-22T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Hexagonal Architecture (Ports and Adapters Architecture)
- 目標是讓應用程式的核心邏輯與外部系統解耦
- 把軟體分為內部部分與外部部分
  - **內部部分**
    - 包含 domain logic
    - 先被開發，不受外部系統影響
  - **外部部分**
    - 包含所有的依賴層 (dependency layers)
    - 不屬於應用程式的部分，如 UI、資料庫 (DB)、或應用框架 (framework)

### Ports
- 介面 (interface)，定義外部系統可以使用的方法
- 兩種類型
  - **Input Ports**：由內部應用程式暴露給外部使用，定義應用程式的行為
  - **Output Ports**：由內部應用程式呼叫外部系統，如資料庫或 API

### Adapters
- 用來實作 Ports，轉換外部請求到應用程式內部邏輯

#### Primary Adapter
- 實作 Input Port，負責接收外部輸入並調用 Use Case
- 例如 Web Controller 或 CLI Handler

#### Secondary Adapter
- 實作 Output Port，負責將 Use Case 的結果傳遞到外部系統
- 例如資料庫存取層 (Repository) 或 API 呼叫

---

## Clean Architecture
- 目標是讓 domain logic 與其他部分分離，使系統可以隨時更換技術而不影響核心邏輯
- 透過 **DIP (Dependency Inversion Principle)** 達成
  - **高層次模組不應依賴低層次模組，兩者應依賴抽象**
  - **抽象不應依賴細節，細節應依賴抽象**
- 將軟體分為不同層次，並確保依賴方向只能往內部流動

### 常見架構比較
- **傳統三層架構 (Three-Tier Architecture)**
  - 依賴關係：`Presentation Layer -> Business Logic Layer -> Data Access Layer`
  - 這種架構會導致 Business Logic 依賴 Data Access，影響可測試性與可維護性

- **Clean Architecture**
  - 所有外部層次都應依賴 **Business Logic Layer (Use Cases)**
  - 依賴方向為 `Frameworks & Drivers -> Interface Adapters -> Use Cases -> Entities`

### 優點
- **技術可替換性高**
  - domain logic 獨立於技術實現，允許更換 UI、資料庫、框架等技術
  - 只需替換 Adapters，不影響核心邏輯
- **測試方便**
  - domain logic 不依賴外部系統，可以使用 mock 測試
  - 減少整合測試的負擔
- **更容易擴展與維護**
  - 避免不同技術層相互耦合，讓系統更具彈性

---


## Clean Architecture 的層次結構
### Entities
- **核心物件**，負責企業規則 (Enterprise Business Rules)
- 只關心應用程式的核心邏輯，與技術無關
- 例如帳戶物件：包含帳號名稱、密碼、驗證密碼的方法

### Use Cases
- **應用程式規則 (Application Business Rules)**，定義具體業務邏輯
- 負責協調 Entities，確保業務流程正確
- 例如處理使用者登入、交易等邏輯

### Interface Adapters
- **負責資料轉換**，讓資料符合不同層的需求
- 例如 View Model 轉換、DTO 轉換、Repository 轉換

### Frameworks and Drivers
- **包含所有技術相關的部分**，如 Web 框架、資料庫、第三方 API
- 這些技術可以隨時替換，不影響 Use Cases 和 Entities
