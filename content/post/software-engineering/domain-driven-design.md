---
title: "領域驅動設計 Domain-Driven Design"
date: 2023-05-22T00:00:17+08:00
draft: true
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 前言

軟體要對 domain 做 Modeling，呈現出 domain 裡的核心概念，才能滿足使用者需求，因此不乏與領域專家的討論

## 通用語言 Ubiquitous Language

開發人員與領域專家熟悉的知識不同，容易產生交流困難。因此：
- 領域專家和開發團隊要訂定共同的語言，避免使用自己熟悉但對方不理解的術語。
- **確保這些語言在代碼、文件、溝通中保持一致**

## Layered Architecture

分為四個概念層，只會往下調用，可能會跨層

可以達到關注點分離 (separation of concerns)，提高各個方面的 cohesive

1. **User Interface (Presentation Layer)**  
   - 負責 UI 呈現（使用者可能是人或另一個系統）
2. **Application Layer**  
   - 不包含 **business logic**，負責協調 **domain object** 完成業務流程
3. **Domain Layer**（**核心**）  
   - 負責業務邏輯、業務規則、狀態管理。
   - **這一層的設計是 Model-Driven Design 的關鍵！**
4. **Infrastructure Layer**  
   - 負責技術支援（如資料庫存取、外部 API 連接）
   - 保存業務狀態的技術細節在此實作
   - 為前三層提供支援
## 主要概念
### Entity（實體）
- 具備 **identity**，即使 **state** 改變，identity 仍保持不變
- **Mutable**，但應該透過業務邏輯來控制修改方式
- 追蹤 **Entity** 需要較高的成本

### Value Object（值物件）
- **沒有 identity**，只關心 **Value**
- **Immutable**（不可變），如需修改，則應**創建新的值物件**
- 可以安全地**共用**
- 可以輕易創建丟棄

### Service
- 有些動作不屬於某個 Entity 或 Value Object，因為它是跨物件的
- **Stateless**（無狀態）：每個請求互不影響

## Aggregate（聚合）
- **把複雜關聯的物件聚合在一起**，確保 **consistency** 和 **invariants**
    - consistency (一致性)
        - 相關物件的資料一致
    - invariants (不變量)
        - 資料改變時要維護的規則
- **Aggregate Root**：
  - 具備 **global identity**，內部 Entity 只有 **local identity**
  - 通常是 entity 擔任
  - **外部只能透過 Aggregate Root 存取內部其他物件**

## 其他 Building Blocks

### Factory
- 若創建 aggregate、entity、value object 的過程很複雜，或是涉及專業知識，就該用 factory 封裝
- 若情況不複雜，或是需要更細的控制，可以直接使用建構函式

### Repository

- 若所有物件都直接存取資料庫，會破壞精心設計的結構，導致封裝性降低
- Repository 封裝了資料庫操作，提供物件存取的統一介面

### Domain event
- 代表 Domain 中的重要事件
- 其他物件或 aggregate 可以訂閱它，讓 aggregate 通知它們某個 domain event 發生

## Strategic Design

### Subdomain

- 將 domain 拆分為小塊，理想情況下 subdomain 和 bounded context 是一對一的關係
- **類型**
    - **Core Subdomain**  
        - 公司的競爭優勢所在，最核心的業務邏輯，例如搜尋引擎的搜尋演算法
    - **Generic Subdomain**  
        - 一般常見的功能，例如登入系統
    - **Supporting Subdomain**  
        - 輔助核心業務的部分，例如電商網站的商品篩選功能

### Bounded Context
- 劃定界線，確保同一個 bounded context 內的概念和規則保持一致
- 相同的名詞可能在不同的 context 中有不同的意義

### Context Map
描述 Bounded Context 之間的關係
#### Symmetric Relationship
- **Shared Kernel**  
    - 兩個 BC 共享某些部分  
    - 違反 BC 原則，是一種例外設計
- **Partnership**  
    - 兩個 BC 互相合作，沒有主次之分，成敗與共

#### Upstream-Downstream Relationship
- **上下游 (U/D)**  
    - 上游提供服務，下游依賴上游
- **Customer-Supplier**  
    - 一個子系統重度依賴另一個子系統  
    - **Conformist**：Customer 完全配合 Supplier
- **Anticorruption Layer (ACL)**  
    - 在開發系統與外部系統之間加一層適配，防止影響內部模型  
    - 常用到 **Facade** 和 **Adapter**
- **Open Host Service (OHS)**  
    - 外部系統提供統一的服務接口，避免每個用戶端都要自己實作 ACL  
    - 通常搭配 **Published Language (PL)**（PL 是協定傳送資料的格式，例如 XML、JSON、Protocol Buffer）

## Anti-Pattern
- 應該避免的情形
- Smart UI
    - 超肥的萬能 UI
- Anemic Domain Model
    - 貧血模型
    - 只有 getter 和 setter，沒有業務邏輯的模型

## Pratical DDD
- The strangler migration 
    - 透過 Facade，把一些服務慢慢移植給新系統，最後取代 legacy