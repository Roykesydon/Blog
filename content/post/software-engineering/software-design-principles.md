---
title: "軟體設計 - Low Level"
date: 2023-03-08T14:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 軟體設計原則

### Encapsulate What Varies
- 封裝經常改變的程式碼，以避免影響其他區塊的程式碼，提升維護性
- 具體做法包括將變動部分抽象為 `interface`，讓實作細節與使用方解耦
- 例如，在策略模式（Strategy Pattern）中，將變動行為封裝於獨立類別，並透過 `interface` 進行交換

### Favor Composition over Inheritance
- `Composition`（組合）在許多情境下可取代 `Inheritance`（繼承），並能達成 `Polymorphism`（多型）
- 只有在符合 `is-a` 關係時才應考慮使用繼承，例如「貓是動物」
- `Composition` 透過組合物件的方式擴展功能，通常比繼承更具彈性，且能降低耦合度
- 比如有 `Engine` 類別，`Car` 可以有一個 `Engine` 的物件，而不是繼承 `Engine`

## SOLID 設計原則

### Single Responsibility Principle (SRP) - 單一職責原則
- **A class should have only one reason to change**
- 每個類別應該只負責一項功能，避免職責過於複雜
- **實踐方式**：
  - 把一個複雜的模組拆成多個獨立的類別
  - 例如，把「資料庫存取」與「商業邏輯」分開，避免單一類別同時負責多種功能

### Open-Closed Principle (OCP) - 開放封閉原則
- **You should be able to extend the behavior of a system without having to modify that system**
- 系統應該**對擴充開放，對修改封閉**
- **實踐方式**：
  - 使用**抽象類別**與**介面**，讓新功能可以透過擴展來新增，而不是直接修改原始碼
  - 例如，在 `Shape` 介面下定義 `draw()`，新增 `Circle`、`Rectangle` 只需實作該介面，而無需修改原有 `Shape` 相關程式碼

### Liskov Substitution Principle (LSP) - 里氏替換原則
- **子類別應該能替換父類別，且不影響程式的正確性**
- 確保繼承時不破壞原有功能，避免發生「使用父類別時正常，但換成子類別就出錯」的情況
- **實踐方式**：
  - 避免子類別重寫父類別方法時，改變原有的行為或拋出例外
  - 例如，如果 `Bird` 有 `fly()` 方法，而 `Penguin` 繼承 `Bird`，但企鵝不會飛，則應改用 `CanFly` 介面來區分，而非讓 `Penguin` 繼承 `Bird` 而空實作 `fly()`

### Interface Segregation Principle (ISP) - 介面隔離原則
- **No client should be forced to depend on methods it does not use**
- 避免讓一個介面擁有過多功能，導致實作該介面的類別需要實作不必要的功能
- **實踐方式**：
  - 把大介面拆分為多個小介面，使類別只需實作與自身業務相關的介面
  - 例如，`Worker` 介面包含 `work()`、`eat()` 方法，則應將其拆成 `Workable` 介面（包含 `work()`）與 `Eatable` 介面（包含 `eat()`），避免機器人類別被迫實作 `eat()`

### Dependency Inversion Principle (DIP) - 依賴反轉原則
- **高階模組不應該依賴低階模組，兩者都應依賴抽象層**
- **抽象不應依賴具體實現，具體實現應依賴抽象**
- **實踐方式**：
  - 透過 `interface` 或 `抽象類別` 來解耦高階與低階模組
  - 例如，`OrderService` 依賴 `PaymentProcessor` 介面，而不是直接依賴 `PayPalProcessor` 或 `StripeProcessor`，這樣未來更換支付方式時無需修改 `OrderService`

## Modularity
### Coupling（耦合）
**模組間的依賴程度，耦合越鬆散，模組的獨立性越高，維護與擴展性越好**

#### Tight Coupling（緊密耦合）
- **Content Coupling（內容耦合）**
  - 一個模組直接存取或修改另一個模組的資料或內部邏輯
  - **範例**：一個模組直接存取另一個模組的變數（假設變數表示長度，單位是公尺）
    - 若另一個模組改變單位為公分，則所有存取該變數的模組都會受到影響
    - **解法**：透過 `getter` 提供 `getMeter()` 方法，而不是直接存取變數

- **Common Coupling（公共耦合）**
  - 多個模組共用同一個全域變數或全域資源
  - **範例**：多個模組使用相同的全域變數，當其中一個模組錯誤修改該變數時，其他模組可能會出錯

- **External Coupling（外部耦合）**
  - 多個模組依賴外部的系統介面或硬體裝置（例如第三方 API）。
  - **範例**：所有模組直接呼叫相同的 API，若 API 變更，所有模組都需修改

#### Medium Coupling（中等耦合）
- **Control Coupling（控制耦合）**
  - 一個模組控制另一個模組的流程，例如傳入控制參數來決定邏輯分支
  - **範例**：函式 `process(data, mode)` 內部邏輯依賴 `mode` 參數，若 `mode` 值的定義變更，所有呼叫該函式的地方都需同步修改

- **Data-Structure Coupling（資料結構耦合） 也叫 Stamp Coupling**
  - 多個模組共用相同的 `data structure`
  - **範例**：若所有模組都依賴一個 `dict` 來存取資料，當 `dict` 結構變更時，所有模組都會受到影響

#### Loose Coupling（鬆散耦合）
- **Data Coupling（資料耦合）**
  - 模組之間僅透過資料交換（參數或回傳值）來溝通
  - **範例**：函式 `calculateTax(amount)` 接受 `amount` 參數，而不依賴全域變數

- **Message Coupling（訊息耦合）**
  - 模組之間透過訊息或指令進行溝通，而不是直接影響彼此的邏輯
  - **範例**：一個模組透過 `event bus` 發送 `order_created` 訊息，另一個模組根據訊息執行相應動作（而不依賴具體的函式呼叫）

### Cohesion（內聚）
**衡量模組內部功能的相關性，內聚度越高，模組的單一性越強，功能更專注且更易於維護**

#### Weak Cohesion（弱內聚）
- **Coincidental Cohesion（偶然內聚）**
  - 模組內的功能沒有關聯，只是被放在同一個檔案內
  - **範例**：單一檔案內包含不相關的函式，如 `calculateTax()` 和 `generateReport()`

- **Temporal Cohesion（時間內聚）**
  - 功能的唯一關聯是它們在相同時間執行
  - **範例**：`Initializer` 類別內包含 `initDatabase()`、`initCache()`、`initLogger()`，這些功能只在初始化時執行，內聚度較低

- **Logical Cohesion（邏輯內聚）**
  - 模組內的功能可以被歸類為相同的類別
  - 因為他們作用相似所以被歸在一起
  - **範例**：`BackupController` 負責多種不同類型的備份，沒有專注於單一職責

#### Medium Cohesion（中等內聚）
- **Procedural Cohesion（程序內聚）**
  - 模組內的功能需要以特定順序執行
  - **範例**：`Sender` 類別內包含 `connect()`、`sendData()`、`disconnect()`，這些功能需要按照順序執行，內聚度較高

- **Communicational Cohesion（通信內聚）**
  - 模組內的功能都圍繞在某個特定資料結構上
  - **範例**：`ShoppingCart` 類別內包含 `addItem()`、`removeItem()`、`calculateTotal()`，這些功能都圍繞在 `items` 屬性上
- **Sequential Cohesion（順序內聚）**
  - 某個函式的輸出作為另一個函式的輸入，且具有執行順序
  - **範例**：`readData()` → `processData()` → `saveData()`，內聚度相對較高，但仍可能包含非核心功能

#### Strong Cohesion（強內聚）
- **Functional Cohesion（功能內聚）**
  - 模組中的各部分都對模組中單一明確的目標有貢獻
  - **範例**：`CalculateCircleArea` 類別僅包含 `calculateArea()` 方法，專注於計算圓形面積
