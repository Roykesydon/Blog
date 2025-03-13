---
title: "重構 Refactoring"
date: 2023-04-25T14:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 重構

在不改變軟體行為的情況下，對軟體內部構造進行改善

## Code Smell
也稱 Bad Smell，代表程式碼中需要重構的部分

## Bloaters
程式碼（類別、方法）過於龐大

### Long Method
- 部分解法
  - 用 Extract Method 拆解過長的 function
  - 用 Replace Temp with Query 取代暫存變數

### Large Class
- 一個 Class 有太多 fields / methods / lines
- 部分解法
  - Extract Class
  - Extract Subclass
    - 把部分功能移到新建的子類別

### Long Parameter List
- 部分解法
  - Preserve Whole Object
      - 把來自同一物件的資料直接該物件取代
  - Introduce Parameter Object
      - 把相關的參數包成一個 Object

### Data Clumps
- 不同的程式碼區域出現相同的變數組（Guru 舉的例子是連接資料庫用的參數）
- 常一起出現的資料群應該被單獨抽成一個 Class
- 部分解法
  - Extract Class
  - Introduce Parameter Object

### Primitive Obsession
- 過度使用基本類別（primitives），造成 Shotgun Surgery
- Magic Number 也是一種 Primitive Obsession
- 部分解法
  - Replace Data Value with Object
  - Replace Type Code with Class

---

## Object-Orientation Abusers
亂用物件導向程式設計原則

### Switch Statements
- 有非常複雜的 Switch Case 或是 if-else
- 部分解法
  - Replace Conditional with Polymorphism
  - Replace Type Code with Subclasses
    - 直接把多種狀態個別建立子物件，並把相關行為放進去，用多型處理
  - Replace Type Code with State/Strategy
    - 用一個 state 物件來取代 type code


### Temporary Field
- 指那些只在特定情況下才會被使用的 field，平時都是 null
- 通常是因為存在需要大量參數的 function，但是這些參數被選擇放到 field
- 部分解法
  - Extract Class
    - 把這些 field 和會用到的 function 抽成一個 Class
  - Introduce Null Object
    - 用一個 Null Object 來取代 null，他可以提供一些預設的行為

### Alternative Classes with Different Interfaces
- 兩個 Class 具有功能相同、命名不同的 function
- 部分解法
  - Rename Method
  - Extract Superclass
    - 把兩個 Class 的共同功能抽成一個父類別
---

## Change Preventers
一處改變會導致多處程式碼改變

### Divergent Change
- 對一個類別的修改會導致類別的多處也需要修改
- 部分解法
  - Extract Class

### Shotgun Surgery
- 某個責任被分散到大量的 Class 身上，使修改其時要大量修改
- 對多個類別進行同一種修改
- 部分解法
  - Move Method
  - Move Field

---

## Dispensables
不必要的程式碼

### Duplicated Code
- 多個程式碼片段幾乎相同
- 部分解法
  - Extract Method

### Lazy Class
- 沒什麼用的冗餘 Class
- 部分解法
  - Inline Class
    - 把這個 Class 的 feature 全部移到另一個 Class
  - Collapse Hierarchy
    - 子類別和父類別功能差不多，可以把子類別和父類別合併
---

## Couplers
導致類別之間高度耦合


### Feature Envy
- 存取別的 Object 的 Data 的情形比自己的還頻繁
- 這方法可能應該屬於另一個 Object
- 部分解法
  - Move Method
    - 把這個方法移到另一個 Class
  - Extract Method
    - 如果只有一部分有這種情況，可以把這部分抽出來
### Message Chains
- Client 請求 A 物件，A 物件又請求 B 物件，以此類推
- 部分解法
  - Hide Delegate
    - 情境是 client 從 A 物件取得 B 物件，然後又呼叫 B 物件的方法
    - 解法是把 B 物件的方法轉移給 A 物件
  - Extract Method & Move Method
    - 把最終的方法抽出來，放到開頭的物件

### Inappropriate Intimacy
- 一個類別使用另一個類別的內部欄位或方法
  - 不單是存取私有變數，應該說依賴於另外一個類別的實作細節，比如出於某些原因知道要以特定順序呼叫方法
- 和 Feature Envy 相比，損害了其他類別的封裝性
- 部分解法
  - Move Method / Move Field
    - 如果該類別確實不需要這些東西可以考慮
  - Extract Class
    - 把這些方法和欄位抽成一個 Class
---











