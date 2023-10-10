---
title: "設計模式 Desing Pattern"
date: 2023-10-10T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Creational patterns

關於 object creation 的 patterns。

### Factory Method
將不同 Product 定義一個共有的 Interface，並由子類別實作，透過工廠類別來產生實體。

將建立 Product 的方法獨立出來，符合 Single Responsibility Principle。
可以輕易擴充新的 Product，而不用修改原本的程式碼，符合 Open-Closed Principle。

### Abstract Factory

相比 Factory Method，現在的情境是有多個 Product，而且每次都是使用同一系列的 Product。

### Builder

對於建構一個複雜且具備多種組合的產品，可以透過建構巨大的建構函式或是覆蓋所有可能的子類別來解決。

但都存在其問題，要不是大量的子類別，不然就是難以呼叫的建構函式。

把建立物件的每個 component 獨立出來，並且切成多個可分開執行的 step。

由 Builder 來負責生出每一個 component，Director 不是必需的，但有需要的話可以讓他幫忙調用 Builder 的 method，好在專案中重複使用。

### Prototype

使用在想要獲得某個對象的 clone 的情境。

把 clone 的責任交給對象本身，而不是交給 Client。由對象本身提供 clone method。

### Singleton

確保某個類別只有一個 instance，並且提供一個 global access point。

但是這樣違反了 Single Responsibility Principle，因為除了原本的功能外，還要負責管理自己的 instance。

## Structural patterns

探討如何組裝類別和物件成為更大的結構。

### Adapter

轉換某個對象的 interface 到另外一種 interface，讓另外一個 Object 可以理解他。
就像 XML 要轉到 JSON。

### Brdige

使用在需要在多個 orthogonal (independent) 的維度上擴展類別時的情境。
讓情況從難以計數的子類別數，變成多組功能聯合起來。

拆成 abstraction (high-level control) 和 implementation (實際工作)，
由 abstraction 來控制 implementation，比如 GUI 來控制底下的 API

### Composite

用在某些層級結構。

對於 Composite (Container)，不但實現 Component，也提供一個 list 來存放子 component。

對 Composite 的操作，會被委託給子 component，不需要 client 擔心。

就像指揮官只需要對高階軍官下命令。

### Decorator

當今天有多種同類型的東西，你可以能會同時用到多種子類別所形成的組合時，就可以用 Decorator。

比如多種類型的 notification，你可能同時想要 FB 和 TG 的，或是只想要其中一個。
或是多件衣服，有超級多種的穿搭。

但這是一層層的感覺，具有順序性。
Decorator 和 Component 都繼承同一個 interface。
就像是 ```Data data = new Encrypt(new Compress(new FileData()))```。  

存在很難從 stack 中刪除特定 decorator 的缺點。

### Facade

為複雜的一堆子系統提供一個 Class，讓 client 可以使用他們關心的功能。
實際怎麼調用 client 無須知道。

容易形成 god object。

### Flyweight

對於大量類似的物件，為求節省記憶體而誕生的 pattern。

把物件的內容分成 intrinsic 和 extrinsic，intrinsic 是不會改變的 (unique)，而 extrinsic 是會改變的 (repeating)。

讓 extrinsic 的東西用同一塊記憶體。

### Proxy

用在多個服務想要調用某個重量級資源的情境下。

存在多種 proxy 的應用類型，比如 cache 機制來加速資源的存取，並減少系統資源消耗。

## Behavioral patterns

### Chain of Responsibility

對於一系列檢查的情況，可以用這種作法，有兩種形式：

1. 一路檢查，檢查失敗則中斷請求。
2. 每個 Handler 自行決定要不要處理該請求，要的話則不會往下傳。
    - 這樣可能會最後沒人處理

就像網頁點擊事件，一層層元素往下問。

### Command
把請求獨立出來，讓該請求可以被用作參數、佇列、撤銷行為等。

比如多種不同的按鈕背後都執行同一個存檔功能。存檔就可以作為 command 獨立出來。
背後再根據這個 command 實施對應的業務邏輯。

### Iterator
用來需要遍歷集合中元素的情境，把不同種類的遍歷行為細節隱藏起來。

提供多種不同的 iterator，但遵循同一種 interface，讓使用者可以根據需要選擇 iterator。
對於不關心用哪種 iterator 的使用者，也能受益於 iterator 的 interface，而不必耦合於特定的演算法。

### Mediator

禁止多個 component 間的直接溝通，迫使他們透過 mediator 來溝通，避免複雜的關係。
所有人只能透過 notify mediator 來溝通，mediator 根據 sender 和 event，來做出相應處理。

### Memento

讓你可以儲存和復原到先前的狀態。

讓要儲存的對象自己生成 snapshot。

建議存在名為 momento 的 special object，這個 object 不能讓除了 producer 外的其他 object 直接存取。
其他 object 只能透過 limited interface 來取得 metadata。

這些限制讓 momento 可以交給其他 object 來管理，稱為 caretaker。

### Observer

定義 subscription 機制。

有 interesting state 的 object 稱為 subject，但由於他也會通知其他人，所以又稱為 publisher。追蹤它的人稱為 Subscriber。

### State
用在類似 Finite-State Machine 的情況。

該 pattern 把每個 state 獨立成一個 Class，把實際的行為委託給 state，而不是由 context (原始物件) 來控制。Context 只管切換 state。

### Strategy

把不同實現方法的演算法定義為遵循同一個 interface 的類別，讓使用者可以根據需要選擇演算法。

### Template Method
把演算法拆成多個步驟，讓子類別可以覆寫其中的步驟，但不改變演算法的結構。

### Visitor
讓我們可以把演算法從執行他們的 object 中分離出來。

假設我們要對一堆繼承 client 屬性的公司新增 sendEmail 功能，如果我們在 client 新增 sendEmail 並且 override 每個子 class，就會違反 Single Responsibility Principle 和 Open-Closed Principle。

要利用 Double-Dispatch，讓 Object 本身選擇該用的演算法。

雖然這樣依然會修改到子 class，但這屬於微不足道的改變，而且可以讓之後新增的一些功能不用再去修改這些子 class。