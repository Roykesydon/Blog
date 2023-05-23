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

軟體要對 domain 做 Modeling，呈現出 domain 裡的核心概念，才能滿足使用者需求，因此不乏與領域專家的討論

寫這篇的時候我還沒嗑完 Eric 的聖經，可能嗑完了之後會回來修改

## 通用語言 Ubiquitous Language

鑒於程式開發人員與領域專家熟悉知識的差異，會產生交流困難

因此領域專家和開發團隊要訂定共同的語言，並且盡可能少用自己知道的術語

## UML

UML 適合用在小型模型上，它擅長表達類別間的關係，但對於抽象概念卻沒那麼好傳達

因此用 UML 建構模型時，理想上要添加額外的文字，傳達一些圖所不能表達的 behavior 和 constraint

並且不能一次寫過於複雜，而是分塊處理

## Layered Architecture

分為四個概念層，只會往下調用，可能會跨層

可以達到關注點分離 (separation of concerns)，提高各個方面的 cohesive

- User Interface (Presentation Layer)
    - 呈現給 user 的 UI，User 可能是另一個系統
- Application Layer
    - 不含 bussiness logic，指揮表達領域概念的物件來完成任務
- Domain Layer
    - 有關 domain 的資訊都在這裡，業務邏輯在此處理
    - 表達業務概念、狀態、規則
    - 劃分出這層是 Model-Driven Design 的關鍵
- Infrastructure layer
    - supporting library
    - 保存業務狀態的技術細節在此實作
    - 為前三個 layer 服務

## Entity 
- 具備 identity
- identity 在 status 經過改變後依然不變
- 追蹤 entity 需要高成本
- mutable

## Value Object
- 沒有 identity
- 只關心 obejct 的 value
- 可以輕易創建丟棄
- immutable (不變的)
    - 如果想修改數值就創新的
- 可被共用

## Service
- 有些動作不屬於某個 Entity 或 Value Object，因為它是跨物件的
- Stateless
    - 每個請求不互相影響

## Aggregate
- 把複雜關聯的物件圈在一起考量
- 確保 consistency 和 inveraints
    - consistency (一致性)
        - 相關物件的資料一致
    - invariants (不變量)
        - 資料改變時要維護的規則

### Aggregate root
- 具備 global identity，其他內部 entity 只有 local identity
- 通常是 entity 擔任
- 外部只能存取它，不能存取 aggregate 的其他 entity 或 value obejct

## Factory
- 若創建 aggregate、entity、value object 的過程很複雜，或是涉及專業知識，就該用 factory 包起來
- 對於不複雜的情況，或是想控制更多細節，可以只依賴於簡單的建構函式

## Repository

如果大家都直接存取資料庫的各種物件，會破壞原本精心設計的結構，破壞封裝性

Repositoy 用來存取物件，封裝了資料庫操作

## Domain event
- Domain 中重要的事情
- 可以用在其他物件和 aggrgate 訂閱，讓 aggregate 通知他們 domain event 的發生

## Anti-Pattern
- 應該避免的情形
- Smart UI
    - 超肥的萬能 UI
- Anemic Domain Model
    - 貧血模型
    - 只有 getter 和 setter，沒有業務邏輯的模型

## Subdomain

把 domain 切分成小塊，理想上 subdomain 和 bounded context 有 one-to-one 的關係

- Types
    - core subdomain
        - 和其他競爭者相比不同的部分，最核心的業務，比如搜尋引擎中的搜尋演算法
    - generic subdomain
        - 大家都會弄的部分，比如登入系統
    - supporting subdomain
        - 用來輔助 core subdomain 的部分，比如篩選網頁

## Bounded Context
- 劃出 boundary，確保 boundary 內用的概念、規則皆一致
- 同個名詞可能出現在不同的 context，但有不同意思

## Context Map
描述 BC 和 BC 間的關係
- 上下游 (U/D)
    - 上游提供下游 (下游依賴上游)
- Shared Kernel
    - 兩個 BC 共用的部份
    - 違反 BC 的基本原則，是一種例外設計
- Customer-Supplier
    - 一個子系統重度依賴另一個子系統
    - Conformist
        - Customer 完全配合 Supplier
- Partnership
    - 兩個 BC 互相合作，沒有以誰為主
    - 一起成功或一起失敗
- Anticorruption Layer (ACL)
    - 開發系統和外部系統的中間層
    - 可能出現在調用 legacy system
    - 常用到 Facade 和 Adapter
- Open Host Service (OHS)
    - 如果外部子系統要給一堆用戶端子系統調用，就得在所有用戶端子系統搞 ACL
    - 外部系統做為服務提供，常會搭配 Published Language (PL)
        - PL 是協定傳送資料的格式，比如 XML、JSON 或是 Protocol Buffer

## Pratical DDD
- The strangler migration 
    - 透過 Facade，把一些服務慢慢移植給新系統，最後取代 legacy