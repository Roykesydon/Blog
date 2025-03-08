---
title: "Clean Architecture"
date: 2023-05-22T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Hexagonal Architecture
- 也稱為 Ports and Adapters Architecture
- 把軟體分為兩個部分
  - 內部部分
    - 包含 domain logic
    - 會先被開發，並且不會受到外部系統的影響
  - 外部部分
    - 包含所有的 depending layers，不屬於你的軟體的部分，比如 UI、DB、或是你用的 framework

### Ports
- 一個 interface，定義了一個外部系統可以使用的方法

### Adapters
#### Primary Adapter
- 這個 adapter 會透過實現 input port 來達成 use case

#### Secondary Adapter
- 這個 adapter 會實作 output port，並且被 domain logic 調用

## Clean Architecture
- 希望讓 domain logic 與其他部分分離，好讓其他部分應用新技術的時候不會影響到。
- 將軟體分為不同的層次，並且讓這些層次互相獨立。dependency 只能往內部移動，不會往外部移動。
- 透過 DIP (Dependency Inversion Principle) 來達到這個目標。
  - DIP
    - 高層次模組不應該依賴低層次模組，兩者都應該依賴抽象。
    - 抽象不應該依賴細節，細節應該依賴抽象。
- 在常見的三層架構中，常會見到 Presentation Layer、Business Logic Layer、Data Access Layer
  - 這三層的依賴關係是 Presentation Layer -> Business Logic Layer -> Data Access Layer
  - Clean Architecture 則是會讓所有都依賴於 Business Logic Layer
### 優點
- 因為 domain logic 保持獨立，許多部分可以換新技術而不影響到 domain logic
  - 可以單獨替換掉 adapter
- 讓實作 dependencies 的部分可以被延遲到最後，因為 domain logic 不會依賴於他們，所以可以用 mock 來測試 domain logic

### 元件
#### Entities
- 核心的 Object，帶有 data 同時也包含 enterprise  business rules
  - 比如一個帳號的 entity 可能包含帳號的名稱、密碼、以及驗證密碼的方法
#### Use Cases
- 描述 application business rules，會再調用不同 entity 的 enterprise business rules
#### Interface Adapters
- 這裡會把 data 從最適合的格式轉換成 domain layer 可以使用的格式
#### Frameworks and Drivers
- 這裡會包含所有的 frameworks 和 infrastructure
