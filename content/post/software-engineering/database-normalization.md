---
title: "Database Normalization"
date: 2023-03-14T10:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["database"]
categories : ["software-engineering"]
---

## Normalization 目的
- 避免 redundant information
  - 資料重複容易導致資料不一致
- 避免 anomalies
  - 避免資料不一致

隨著 1NF ~ 5NF，有更多的 safety guarantee

## Functional Dependency
- {X} -> {Y}
  - X 是 determinant，Y 是 dependent
  - Y is functionally dependent on X (Y depends on X)
  - X functionally determines Y

- 一個 attribute 的 value 可以決定另一個 attribute 的 value
  - ex: {playerID} -> {playerName}
  - 這代表 playerID 決定了 playerName
- 用箭頭表示，左邊是 determinant，右邊是 dependent
- 一個 attribute 可以有多個 dependent
- ex: {playerID} -> {playerName, playerAge}
- 一個 attribute 也可以是多個 attribute 的 dependent
- ex: {playerID, itemID} -> {itemName}

## 1NF
- 去除重複性
- 違反條件
    1. 用 row order 傳達資訊
    2. mixing data types in single column
        - 但 relational database 不會讓你這樣做
    3. 存在沒有 primary key 的 table
    4. repeating groups
        - 同一個 column 有多個數值，或是在同一個 row 存多個同類型的數值
          - 每個 column 的 value 都應該是 atomic
        - ex :
            |  player  |  item |
            |  :-  | :-  |
            | roy  | 1 item_1, 4 item_2|
            | star  | 4 item_4 |

            |  player  |  item_type1 | quantity1 | item_type2 | quantity2|
            |  :-  |  :- | :- | :- | :-|
            |  roy  |  item1 | 1 | item2 | 4|
            | star  | item_4 | 4| | |

## 2NF
- 去除 partial dependency
- 所有的 non-key attribute 都要 depend on 整個 PK
    - 非正式定義，有點細微差異
    - 如果是 composite key，不能 depend on PK 的其中一部分
    - functional dependency
        - ex: {playerID, itemID} -> {itemName}
    - 違反的例子
      - ex:
        |  playerID  |  itemID | itemName |
        |  :-  |  :- | :- |
        |  1  |  1 | item_1 |
        |  1  |  2 | item_2 |
        |  2  |  1 | item_1 |
        - 這裡的 PK 是 {playerID, itemID}，但 itemName 只 depend on itemID

## 3NF
- 去除 transitive dependency
  - transitive dependency
      - {A} -> {B} -> {C}
- 考慮到 functional dependency 有遞移性(Transitivity)
  - Transitivity
    - {A} -> {B}，{B} -> {C}，則 {A} -> {C}

- 所有 non-key attribute 都要 depend on the whole key，不能 depend on 其他 non-key attribute
- 違反的例子
    - ex:
        |  playerID  |  itemID | itemName | itemCategory |
        |  :-  |  :- | :- | :- |
        |  1  |  1 | item_1 | weapon |
        |  1  |  2 | item_2 | weapon |
        |  2  |  1 | item_1 | weapon |
        - 這裡的 PK 是 {playerID, itemID}，但 itemCategory 只 depend on itemName
        - 這裡的 itemCategory 是 transitive dependency
### Boyce-Codd Normal Form (BCNF)
- 3NF 的強化版，又稱 3.5NF
- 實務中大多做到 3NF
- 對於每個 functional dependency，左邊的 attribute 都是 super key
- 違反例子
  - ex:
    |  playerID  |  itemID | itemName | PlayerName |
    |  :-  |  :- | :- | :- |
    |  1  |  1 | item_1 | roy |
    |  1  |  2 | item_2 | roy |
    |  2  |  1 | item_1 | test |
    - 存在至少兩個 functional dependency
      - {itemID} -> {itemName}
      - {playerID} -> {playerName}
    - 但是 {playerID} 和 {itemID} 都不是 super key
      - 拆成三個表就可以解決


## 4NF
- 要先符合 BCNF
- 去除多值依賴(Multivalued Dependency)
  - multivalued dependency
      - 一個表格至少要有 3 個 column 才有可能有 multivalued dependency
      - 對於 {A} -> {B}，如果一個 A 可以對應到多個 B，也可以對應到多個 C，然後 B 和 C 獨立，則有 multivalued dependency
- 一個 table 中的所有 multivalued dependency 必須依賴於 key

## 5NF
- 又稱 Project-Join Normal Form (PJNF)
- 去除 join dependency
  - join dependency
      - 一個 table 可以表示成其他 table join 起來的結果
- 如果 JOIN dependency 存在，就拆分多個 table