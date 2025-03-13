---
title: "UML 筆記"
date: 2023-03-09T14:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Class Diagram

### 類別關係 (Class Relationships)

#### 依賴 (Dependency)
- **描述**：「uses-a」關係，表示某個類別**暫時依賴**於另一個類別，通常體現在方法的參數或回傳值中。
- **符號**：虛線箭頭 `- - ->`
- **範例**：`Class A - - -> Class B`（A 使用 B，但 B 的變動不會影響 A）

#### 關聯 (Association)
- **描述**：「knows-a」關係，表示兩個類別彼此有關聯，可存取對方的屬性或方法。
- **符號**：實線 `-----`
- **額外資訊**：
  - **單向關聯**：A 知道 B，但 B 不知道 A
  - **雙向關聯**：A 和 B 彼此知道對方

#### 聚合 (Aggregation)
- **描述**：「has-a」關係，表示物件之間的組合，但子物件 (`child`) 可以獨立存在，不受 `parent` 影響。
- **符號**：空心菱形 `◊-----`
- **範例**：學校 (`School`) 擁有多個老師 (`Teacher`)，但學校刪除後，老師仍然可以存在。

#### 組合 (Composition)
- **描述**：「has-a」關係，強於聚合，表示 `child` 的生命週期依賴 `parent`，若 `parent` 被刪除，`child` 也會消失。
- **符號**：實心菱形 `◆-----`
- **範例**：房子 (`House`) 由房間 (`Room`) 組成，若房子被拆除，房間也會消失。

#### 繼承 (Inheritance)
- **描述**：「is-a」關係，表示子類別 (`subclass`) 繼承父類別 (`superclass`) 的屬性和行為。
- **符號**：實線箭頭 `-----▷`
- **範例**：`Dog` 是 `Animal` 的子類別 (`Dog -----▷ Animal`)

#### 實作 (Implementation)
- **描述**：「can-do」關係，表示類別實作 (`implements`) 介面 (`interface`)。
- **符號**：虛線箭頭 `- - - -▷`
- **範例**：`Bird` 實作 `Flyable` (`Bird - - - -▷ Flyable`)

### 額外特性 (Other Features)

#### 導向 (Navigation)
- 若兩個類別都能訪問對方，則使用無箭頭的關聯線 `-----`。
- 若只有一方能訪問對方，則使用箭頭 `----->`。

#### 角色名稱 (Role Name)
- 在關聯線旁標示角色名稱，表示該類別在關係中的角色。
- **範例**：`Person` 與 `Car` 之間的關係中，`Car` 可能有 `owner` 角色。

#### 多重度 (Multiplicity)
- 定義關聯物件的數量。
- **範例**：
  - `1`：只能有一個實例
  - `0..1`：最多一個
  - `*`：零個或多個
  - `1..*`：至少一個

#### 自關聯 (Self-Association)
- 當類別內部的物件彼此有關聯時，可用自關聯 (Self-Association)。
- **範例**：`Employee` 可能是另一個 `Employee` 的 `manager`。

### 存取修飾詞 (Access Modifiers)
在 UML 類別圖中，可以用 `+`、`-`、`#` 來表示不同的存取權限：

| 符號 | 存取修飾詞 | 說明 |
|------|-----------|------|
| `+`  | public    | 任何類別都可以存取 |
| `-`  | private   | 只有該類別本身可以存取 |
| `#`  | protected | 只有該類別與其子類別可以存取 |
| `~`  | package (default) | 只有相同 package 內的類別可以存取 |