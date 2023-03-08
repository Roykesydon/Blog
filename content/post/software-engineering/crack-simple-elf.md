---
title: "軟體設計原則"
date: 2023-03-08T14:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

# UML 類別圖

## Relationship
- Dependency
    - "uses-a"
- Association
    - "knows-a"
- Composition
    - "has-a"
    - child 的存在依賴於 parent，若刪除 parent，child 也會隨之刪除
- Aggregation
    - "has-a"
    - child 的存在獨立於 parent，若刪除 parent，child 不會隨之刪除
- Inheritance
    - "is-a"
- Implementation
    - "can-do"
    - 實現 interface

### other features
- Navigation
    - 當兩個 class 都可以看到對方，就用沒箭頭的關聯線，否則有箭頭
- Role Name
    - 類別中的 Attribute
- Multiplicity
    - 關聯端點上可以寫數量，代表物件個數
- Self-Association
    - 同個類別的物件彼此有關係

# 軟體設計原則

## Encapsulate What Varies
- 把經常改變的程式碼封裝起來，使日後修改時不會影響其他區塊的程式碼
- 實際使用的情境，可以把常改變的東西放在 interface 後，使日後改變實作時不影響呼叫該 interface 的程式碼

## Favor Composition over Inheritance
- Composition(組合)在很多情境可以取代掉 Inheritance(繼承)，可藉由 Polymorphism(多型)來達成
- 只有當 is-a 的情境出現，才用繼承比較好
- Composition 使用起來更有彈性

# SOLID 設計原則

## Single Responsibility Principle, SRP
- 單一職責原則
- A class should have only one reason to change.
- 可以把一個複雜的 module 拆成多個

## Open-Close Principle, OCP
- 開放封閉原則
- You should be able to extend the behavior of a system without having to modify that system.
- 要可以擴充，同時不修改到原系統

## LiskovSubstitution Principle, LSP
- 里氏替換原則
- 父類別有的功能，子類別必須遵從，父類別的部分要可以直接替換成子類別

## Interface Segregation Principle, ISP
- 介面隔離原則
- No client should be forced to depend on methods it does not use
- 以 interface 來說，不該讓 module 實現它不需要的功能，可以把 interface 拆小

## Dependency Inversion Principle, DIP
- 反向依賴原則
- 高階模組不應該依賴低階模組，兩者都應依賴抽象層