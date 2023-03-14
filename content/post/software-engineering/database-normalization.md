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
- 避免 redundent information
- 更容易 understand、enhance、extend
- 避免 anomalies

隨著 1NF ~ 5NF，有更多的 safety guarantee

## 1NF
- 違反條件
    - 用 row order 傳達資訊
    - mixing data types in single column
        - 但 relational database 不會讓你這樣做
    - 存在沒有 primary key 的 table
    - repeating groups
        - 同一個 column 有多個數值，或是在同一個 row 存多個同類型的數值。
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
- 所有的 non-key attribute 都要 depend on 整個 PK
    - 非正式定義，有點細微差異
    - functional dependency
        - ex: {player_id, item_type} -> {item_Quantity}

## 3NF
- transitive dependency
    - {A} -> {B} -> {C}
- 所有 non-key attribute 都要 depend on the whole key，不能 depend on 其他 non-key attribute
### Boyce-Codd Normal Form
- 所有 attribute 都要 depend on the whole key，不能 depend on 其他 non-key attribute


## 4NF
- multivalued dependency
    - 不像 functional dependency，箭頭後方的那項可以有多個 value
    - {Model} $\twoheadrightarrow$ {Color}
- 一個 table 中的所有 multivalued dependency 必須依賴於 key

## 5NF
- 沒有 Join Dependency
    - table 不能表示成其他 table join 起來的結果