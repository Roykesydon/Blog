---
title: "MongoDB 筆記"
date: 2024-08-16T00:00:17+08:00
draft: false
description: 
type: "post"
tags: ["database", "nosql", "mongodb"]
categories : ["full-stack"]
---

## MongoDB 基礎
- 以 BSON (Binary JSON) 儲存資料
  - BSON 是 JSON 的二進位版本，支援更多資料型別，如日期和二進位資料
- _id 欄位作為預設的主鍵
  - 若未指定，MongoDB 會自動生成一個 12 字節的 ObjectId
  - 用於確保文件中唯一性，特別在分散式系統中

## 和 RDB 比較
- 儲存結構
  - 具有彈性的 schema，資料結構可隨時變更
  - PostgreSQL 也有 JSON 結構的樣子，尚待我研究一下
- 水平擴展性
  - 原生分片 (sharding) 機制，支援水平擴展
  - 但是 RDB 也不是說就不能水平擴展，只是需要額外的工具
- Transaction
  - 原生是希望盡量避免 JOIN 以及 Transaction 的概念
  - MongoDB 4.0 開始支援多文件事務，但仍不如 RDB 的 ACID 支援完整
    - 好像可選的隔離級別也有限
- Denormalization
  - 鼓勵資料去正規化，將相關資料儲存在同一文件中
  - 但是可能有冗餘資料的問題

## 索引機制
### Composite Index
- 由多個欄位組成，例如 (a, b)
- Prefix 特性
  - 如果索引為 (a, b)，則 (a) 也可被單獨使用
  - 但 (b) 或 (a, b, c) 無法直接利用此索引
- Hint
  - 可強制 MongoDB 使用特定索引
  - 用於測試或避免 optimizer 選錯索引

### Explain 分析查詢
- 用來檢視查詢的執行計畫
- 重要欄位
  - cursor
    - BasicCursor 表示全表掃描，應避免
    - BtreeCursor 表示使用索引
  - nscanned
    - 掃描的索引數量
  - nscannedObjects
    - 掃描的文件數量
  - n
    - 最終返回的文件數量
  - 關係：nscanned >= nscannedObjects >= n
- scanAndOrder
  - 表示需要將文件載入記憶體並排序
  - 通常一次性返回所有結果，效率較低

### Optimizer 索引選擇
- 第一階段：尋找最佳索引
  - 最佳索引條件
    - 包含所有 filter 和 sort 的欄位
    - equality filter 必須在 range filter 之前
    - sort 欄位必須在 range filter 之後
  - 若有多個最佳索引條件符合條件，隨便選擇一個
- 第二階段：實驗性選擇
  - 若無最佳索引，會測試多個索引
  - optimizer 選擇 nscanned 最小的索引作為最終方案

## 儲存引擎
### MMAPv1
- MongoDB 早期的儲存引擎
- 特性
  - _id 直接對應 disk 偏移量 (diskloc)
    - 查詢速度快，但更新需維護偏移量，效能低
  - 鎖定機制
    - 初始為 database-level lock
    - 後期升級至 collection-level lock
- 已於 MongoDB 4.0 後棄用

### WiredTiger
- MongoDB 收購並採用的新儲存引擎
- 特性
  - Document-level locking，提升並發效能
  - 支援資料壓縮，減少儲存空間
- 版本演進
  - 5.2 之前
    - _id 用於查找 recordid
    - recordid 作為 clustered index，指向實際文件
  - 5.3 之後
    - _id 直接成為 clustered index
    - _id 為 12 字節 (ObjectId)，比原 64 位 recordid 更大
    - 影響
      - 對 secondary index 增加儲存負擔
      - 提升跨機器和 shard 環境中的唯一性
