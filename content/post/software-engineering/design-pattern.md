---
title: "設計模式 Desing Pattern"
date: 2023-10-10T00:00:17+08:00
draft: false
description: "Creational, Structural, Behavioral"
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Creational patterns

關於 object creation 的 patterns。

### Factory Method
- 將不同 Product 定義一個共有的 Interface(以下簡稱 PI)，並由子類別實作，同時也幫不同工廠定義一個生成 product 的 interface(以下簡稱 FI)，透過不同的工廠類別實體來建立有共同 interface (PI)的不同 Product。
- 優點
    - 將建立 Product 的方法獨立出來，符合 Single Responsibility Principle
    - 可以輕易擴充新種類的 Product，而不用修改原本的程式碼，符合 Open-Closed Principle

### Abstract Factory

相比 Factory Method，現在的情境是有多個 Product 的同時，又會分不同系列，而且每次都是使用同一系列的 Product。
    - ex: 有一套家具，但是分多種不同的風格，每次都是使用同一風格的家具。

現在 Factory 會有一個共有的 interface，但是這個 interface 包含了建立一整套 product 的方法

### Builder

對於建構一個複雜且具備多種組合的產品，可以透過下面兩種方式其中之一解決：
  - 建構巨大的建構函式
  - 覆蓋所有可能的子類別

但都存在其問題，要不是大量的子類別，不然就是難以呼叫的建構函式。

把建立物件的每個 component 獨立出來，並且切成多個可分開執行的 step，再根據自己的需求調用需要的函式。

對於建置步驟可能需要不同時做的情況，定義一個 Builder interface，包含了建立物件的每個 component 的方法，然後由 Builder 的子類別來實作這些方法。

Client 可以根據自己的需要調用 Builder 中的方法（不用全部調用），就可以在同樣的建構程式碼下透過不同的 Builder 來建立不同的物件。

Director 不是必需的，但有需要的話可以讓他幫忙調用 Builder 的 method，好在專案中重複使用。

### Prototype

使用在想要獲得某個對象的 clone 的情境。如果直接照著外表複製，可能會因為看不到私有屬性而造成問題。

把 clone 的責任交給對象本身，而不是交給 Client。由對象本身提供 clone method。
支援 clone 方法的物像被稱為 prototype。

### Singleton

確保某個類別只有一個 instance，並且提供一個 global access point。

但是這樣違反了 Single Responsibility Principle，因為他現在要解決兩個問題：
 1. 要讓唯一的 instance 可以被全域存取
 2. 負責確保自己的類別只有一個 instance

而且會讓全域變數有的缺點轉移過來，比如不安全，因為別的程式碼可能也可能修改我們在用的變數

---

## Structural patterns

探討如何組裝類別和物件成為更大的結構。

### Adapter

轉換某個對象的 interface 到另外一種 interface，讓另外一個 Object 可以理解他。
就像 XML 要轉到 JSON。

### Brdige

把一個大類別分成兩個獨立的維度（抽象和實作），讓他們可以獨立變化。

#### Gura 舉的簡單例子
這例子可以被拿來想像具體實作可能長怎樣

使用在需要在多個 orthogonal (independent) 的維度上擴展類別時的情境。比如我們要生產的一堆 entity 有分不同的 shape 和 color。
如果有兩種 shape 和兩種 color，我們就會有 4 種子類別

目標是讓情況從難以計數的子類別數，變成多組功能聯合起來。可以透過把其中一個維度轉換成單獨的類別，然後用引用的方式獲取。

#### 作法

拆成 abstraction (high-level control) 和 implementation (實際工作)，
由 abstraction 來控制 implementation，比如 GUI 來控制底下的 API。
這樣的好處是兩邊都可以各自發展，以 GUI 和 API 舉例，GUI 可以開發不同方法調用事先說好的 API 介面（abstract），而根據 API 介面可以發展出不同的 implementation。

未來有更新的 GUI （繼承原有的 abstraction）也因為 implementation 是獨立的，不用擔心影響到他

### Composite

用在程式模型具有層級結構（像是表示成樹）的情況。比如說我現在有一個大盒子，每次拆開盒子裡面有可能是多個東西，然後東西可能是小一點的盒子，或是產品。

如果要確認全部的產品價格總和，就要層層展開所有盒子，直到看到所有產品。

#### 作法

假設盒子結構稱為 Composite，而裡面的東西稱為 Component。我們可以定義一個共同介面，以價格為例，可能是讓 composite 和 component 都有獲取價格的 method，但是當調用 composite 的價格時，他會往 child 調用獲取價格的 method，然後把價格加總起來。用遞迴的方式來處理。

對於 Composite (Container)，不但實現 Component，也提供一個 list 來存放子 component，以及加入和從 list 中移除的 method。

對 Composite 的操作，會被委託給子 component，不需要 client 擔心。

就像指揮官只需要對高階軍官下命令。

### Decorator

當今天有多種同類型的東西，你可以能會同時用到多種子類別所形成的組合時，就可以用 Decorator。

Guru 舉例，不同社群平台的 notification，你可能會想要有不同的 notifier，發到一些指定的社群平台。也有拿天冷穿衣服舉例，可以層層穿不同的衣服。

但這是一層層的感覺，具有順序性。
Decorator 和 Component 都繼承同一個 interface。
有兩種實作辦法，可以層層包裹但是在外部自行調用，也可以把包裹的功能放在 Decorator 裡面，讓他自己調用。
如果是第二種，可能就像下面這樣
就像是 ```data = new Encrypt(new Compress(new FileData(data)))```

存在很難從 stack 中刪除特定 decorator 的缺點。

### Facade

為複雜的一堆子系統提供一個外部介面 Class，讓 client 可以使用他們關心的功能。
實際怎麼調用 client 無須知道。

Guru 舉例，比如說你要轉換影片，可能要調用很多不同的子系統，比如說轉檔、壓縮、上傳等等，可以獨立出去一個新的 class 提供轉換影片的功能，然後內部調用這堆子系統，client 只需要調用這個新的 class 就好。

容易形成 god object。

### Flyweight

對於大量類似的物件，為求節省記憶體而誕生的 pattern。

把物件的內容分成 intrinsic 和 extrinsic，intrinsic 是不會改變的 (unique)，而 extrinsic 是會改變的 (repeating)。讓 extrinsic 的東西用同一塊記憶體。

可以透過一個可以儲存建立過共有物件的 factory 來建立物件。

### Proxy

用在多個服務想要調用某個重量級資源的情境下，可能只有很偶爾的情況需要用這 entity，但是如果平常就佔據著這個 entity，可能會消耗大量資源。

如果在服務和 entity 之間加上 proxy，就可以讓 proxy 來處理這些情況。可以用 proxy 的場景較多，下面以 cache 的場景為例子。

獲取某個靜態檔案可能非常花時間，但如果透過 proxy，第一個 service 想要這檔案的時候，proxy 可以去調用並暫存，其他 service 來要求的時候就可以直接回傳給他們。

---

## Behavioral patterns

探討物件或是演算法之間的溝通和分配職責。

### Chain of Responsibility

透過一連串可以串接起來的 handler，來處理請求。

對於一系列檢查的情況，可以用這種作法，有兩種形式：

1. 一路檢查，檢查失敗則中斷請求。
   - 常見的例子是用在網頁的 middleware，如果有一個 middleware 檢查失敗，就不會往下傳。
2. 每個 Handler 自行決定要不要處理該請求，要的話則不會往下傳。
    - 這樣可能會最後沒人處理
    - 就像網頁點擊事件，一層層元素往上問。

### Command
把請求獨立出來，讓請求可以被用各種方式調用。
比如說把業務邏輯從 GUI 中抽出來，讓 GUI 只負責呼叫 command，然後 GUI 就可以有多個地方呼叫同一個 command。

比如多種不同的按鈕或快捷鍵背後都執行同一個存檔功能。存檔就可以作為 command 獨立出來。
背後再根據這個 command 實施對應的業務邏輯。

### Iterator
用來需要遍歷集合中元素的情境，把不同種類的遍歷行為細節隱藏起來。

提供多種不同的 iterator，但遵循同一種 interface，讓使用者可以根據需要選擇 iterator。
對於不關心用哪種 iterator 的使用者，也能受益於 iterator 的 interface，而不必耦合於特定的演算法。

### Mediator

禁止多個 component 直接溝通，迫使他們透過 mediator 來溝通，避免複雜的關係。
所有人只能透過 notify mediator 來溝通，mediator 根據 sender 和 event，來做出相應處理。

所有的 component 都不知道最終會有哪些 component 處理自己的請求，同樣的，他們也不知道請求是誰造成的，彼此不知道對方的存在。

### Memento

讓你可以儲存和復原到先前的狀態。

讓要儲存的對象自己生成 snapshot。

建議存在名為 momento 的 special object，這個 object 不能讓除了 producer 外的其他 object 直接存取。

其他 object 只能透過 limited interface 來取得透過 producer 產生的 momento。

這些限制讓 momento 可以交給其他 object 來管理，稱為 caretaker，要復原的時候再把 momento 交還給 producer。

### Observer

定義 subscription 機制。

有 interesting state 的 object 稱為 subject，但由於他也會通知其他人，所以又稱為 publisher。追蹤它的人稱為 Subscriber。

Subscriber 如果想要在 Publisher 的狀態改變時被通知，就要訂閱 Publisher。然後 Publisher 維護一個 list 來存放所有訂閱者。

### State
用在類似 Finite-State Machine 的情況。

把物件可能的狀態給提取出去，建立一個 interface，interface 包含了所有在不同狀態下會表現行為不同的 method。

該 pattern 把每個 state 獨立成一個 Class，把實際的行為委託給 state，而不是由 context (原始物件) 來控制。Context 只管切換 state。

### Strategy

把不同實現方法的演算法定義為遵循同一個 interface 的類別，讓使用者可以根據需要選擇演算法。

原始的類別叫做 Context，client 可以把不同的策略傳給 Context，然後 Context 再根據策略來執行。

### Template Method
把演算法拆成多個步驟，讓子類別可以選擇性覆寫其中的一些步驟，但不改變演算法的結構。

原始的 template 可能有已經有預設實作或是 abstract method，就算有預設實作，子類別也可以選擇性覆寫。

### Visitor
如果今天有一堆有共同父類別的子類別，我想新增某個功能，並給他們所有人用，同時不太希望修改到既有的這些類別，這時候可以用 visitor（雖然還是會做微不足道的修改）。

Visitor 要解決的問題和 Double Dispatch 很像。

vistor 會把新功能放在名為 Visitor 的新 class 中，然後透過 double dispatch 來執行。

新功能會根據這些子類別提供不同的 method，然後透過這些 method 來執行新功能。

我們最終會在這些子類別中新增一個 accept method，這個 method 會接受一個 visitor，然後根據 visitor 來執行對應的 method。

雖然這樣依然會修改到子 class，但這屬於微不足道的改變，而且可以讓之後新增的一些功能不用再去修改這些子 class。

#### Single Dispatch
dispatch 是指決定在 runtime 要呼叫哪個 method 的過程。
大多數的物件導向程式語言都支持 single dispatch，比如說在執行時期，遇到多型的時候，選擇要執行什麼 method。（我不確定有沒有多型以外的情況）

#### Double Dispatch

這是一種技巧，讓我們可以在執行時期根據接收者（物件本身）和參數（傳進方法的物件）的類型決定要執行哪個 method。

好像也可以說是兩個參數的多型。

這是因為在編譯時期，看利用多型的程式碼，我們只能知道物件的多型型別，但是不知道他的實際型別，所以我們無法知道要執行哪個 method。

但是如果我們在執行時期，可以根據物件的實際型別來決定要執行哪個 method，這樣就可以達到我們想要的效果。

```java
public class A {
    public void accept(Visitor v) {
        v.visit(this);
    }
}

public class B {
    public void accept(Visitor v) {
        v.visit(this);
    }
}

public class Visitor {
    public void visit(A a) {  // visitor 不一定要用重名，這裏只是舉例
        System.out.println("A");
    }

    public void visit(B b) {
        System.out.println("B");
    }
}
```

調用的時候可能會像```a.accept(visitor)```

第一次調用發生在 accept method，根據 a 來決定要執行哪個 accept method

第二次調用發生在 visit method，根據 參數的類型 來決定要執行哪個 visit method