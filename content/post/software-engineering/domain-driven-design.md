---
title: "領域驅動設計 Domain-Driven Design"
date: 2023-05-22T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 前言
- 是一種以領域知識為核心的軟體設計方法
- 目標是讓軟體模型能夠真實反映業務領域的行為與邏輯
- 強調與領域專家合作，使用通用語言來描述問題與解決方案

## 戰略設計（Strategic Design）

### Subdomain
將 Domain 拆分為多個子領域（Subdomain），每個 Subdomain 應對應一個 Bounded Context（理想情況下是一對一）。

#### Subdomain 類型
- **Core Subdomain**  
  - 公司競爭優勢所在，最核心的業務邏輯，例如搜尋引擎的搜尋演算法。
- **Supporting Subdomain**  
  - 輔助核心業務運作，例如電商網站的商品篩選功能。
- **Generic Subdomain**  
  - 非專屬的一般功能模組，例如帳號系統、報表系統。

### 限界上下文（Bounded Context）
劃定模型與語言的邊界，確保同一個上下文內的概念和規則保持一致。  
同一詞彙在不同上下文中可能代表不同的意義，這是 DDD 中解決語意混淆的關鍵手段。

### 上下文對應圖（Context Map）
描述各個 Bounded Context 之間的整合與關係模式。

#### 常見的關係模式
- **Shared Kernel**  
  - 兩個 BC 共享一部分模型（如共用類別或邏輯）。雖然不符合「BC 應明確隔離」的原則，但在某些情況下是實用的妥協。
- **Partnership**  
  - 兩個 BC 密切合作，成敗與共，沒有主從之分。通常需要雙方頻繁溝通與協調。

#### 上下游關係模式（Upstream-Downstream Relationships）
- **上下游關係（U/D）**  
  - 一個 Bounded Context 作為上游（Upstream）提供資料或服務，下游（Downstream）依賴這些資料或行為。

- **Customer-Supplier**  
  - 一個子系統（Customer）高度依賴另一個子系統（Supplier）提供的功能。
  - **Conformist**：Customer 必須完全配合 Supplier 所設計的模型與邏輯，無法進行修改或影響。

- **Anticorruption Layer（ACL）**  
  - 在開發系統與外部或遺留系統之間建立一層適配層，以防止外部模型滲透並污染內部模型。  
  - 常用設計模式包括：
    - **Facade**
    - **Adapter**

- **Open Host Service（OHS）**  
  - 上游系統提供統一的服務介面供下游調用，避免下游各自實作 ACL。  
  - 通常與 **Published Language（PL）** 搭配使用，PL 為溝通協議格式，如：
    - XML
    - JSON
    - Protocol Buffers


## 戰術設計（Tactical Design）

### Entity（實體）
具有唯一識別（identity）的物件，代表系統中可追蹤的個體。

- 擁有 **identity**：即使內部狀態改變，identity 不變。
- 通常是 **mutable**（可變的），但應透過業務邏輯來控制修改行為。
- 因為需要追蹤其變化，因此操作成本較高。

### Value Object（值物件）
不具有 identity，僅關心其值（value）的物件，代表系統中的一個描述。

- **沒有 identity**：以值來判斷相等。
- **Immutable**（不可變）：如需更改內容，應建立新的實例。
- 因不可變，因此可以 **安全共用**。
- 易於創建與丟棄，適合短暫使用。

### Service（服務）
封裝某些無法歸屬於任何單一 Entity 或 Value Object 的業務邏輯。

- 處理跨 Entity 或跨聚合的邏輯。
- **Stateless**：服務不保留任何狀態，每次呼叫彼此獨立。
- 應以 **動詞或動作為命名**，而非名詞。

### Aggregate（聚合）
由一組相關物件組成的邏輯整體，保證其內部一致性與不變規則。

- 封裝內部物件之間的關聯與規則，確保：
  - **Consistency（一致性）**：資料之間相互一致。
  - **Invariants（不變量）**：操作過程中需維持的邏輯約束。
  - 目前我不太確定上面這兩個有沒有差別，但反正至少就是要確保業務規則不會受影響就是了
- **Aggregate Root（聚合根）**
  - 為整個聚合的代表，外部只能透過它存取或操作內部其他物件。
  - 擁有全域 identity，而內部 Entity 僅具區域 identity。
  - 通常由 Entity 擔任。

### Factory（工廠）
- 用於封裝複雜的建立邏輯，適用於創建 **Aggregate、Entity、Value Object** 等：
  - 建立過程繁複。
  - 涉及領域知識或不應外洩的建構細節。
- 若建立邏輯簡單且需精細控制，可直接使用建構子。

### Repository（儲存庫）
- 封裝對持久性儲存的存取（如資料庫、API）。
- 提供介面讓應用程式以物件的方式存取 Aggregate Root，而非直接操作資料庫。
- 可避免基礎設施細節入侵業務邏輯，維護封裝性。

### Domain Event（領域事件）
- 表示領域中發生的「有意義的事件」。
- 可用來觸發其他邏輯（如：寄信通知、資料同步）。
- 讓 Aggregate 以「發佈事件」的方式與外部溝通，而不是直接呼叫。

## 通用語言 Ubiquitous Language
- 開發團隊與業務專家共享的語言
- 所有模型與程式碼都應使用一致的術語


## 分層架構（Layered Architecture）

Layered Architecture 將系統拆分為四個概念性層級，每層僅向下依賴（可跨層存取）。  
這種架構有助於達成 **關注點分離（Separation of Concerns）**，提高每層的 **內聚性（Cohesion）** 與整體系統的可維護性。

### 1. User Interface（使用者介面層／呈現層）
- 負責顯示資料與接收使用者輸入。
- 使用者可以是人或其他系統（例如 API 呼叫者）。
- 呼叫 Application Layer 以觸發業務流程。

### 2. Application Layer（應用層）
- 負責流程協調，定義應用程式的「用例（Use Cases）」。
- **不包含業務邏輯**，僅調用 Domain Layer 中的物件來完成操作。
- 可以處理工作流程、交易、授權驗證等流程性邏輯。

### 3. Domain Layer（領域層／核心層）⭐️
- 系統的核心，負責 **業務邏輯**、**業務規則**、**狀態管理**。
- 聚焦於問題領域中的概念與行為。
- 此層是 **Model-Driven Design 的關鍵**，聚合、實體、值物件、服務等戰術模式皆定義於此。

### 4. Infrastructure Layer（基礎設施層）
- 提供技術支援，例如：
  - 永久性儲存（資料庫）
  - 對外整合（REST API、訊息佇列）
  - 系統設定與底層資源管理
- 負責實作 repository、anti-corruption layer 等基礎技術細節。
- 為前三層提供必要支援，但不包含業務邏輯。


## 反模式（Anti-Patterns）

### Smart UI（萬能 UI）
- 所有邏輯都寫在 UI 層，導致：
  - 難以維護與測試。
  - 與業務無關的技術限制主導設計。

### Anemic Domain Model（貧血模型）
- 物件只有屬性與 getter/setter，缺乏行為與邏輯。
- 業務邏輯變成散落在其他層，違反物件導向封裝原則。



## 實務上的 DDD 應用（Practical DDD）

### The Strangler Migration（絞殺者移轉）
- 使用 Facade 包住舊系統，逐步將功能抽換為新的 Bounded Context。
- 新舊系統可並存，降低一次性重構的風險。
- 最終移除 legacy 系統。