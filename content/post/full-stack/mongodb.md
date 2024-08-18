---
title: "MongoDB 筆記"
date: 2024-08-16T00:00:17+08:00
draft: false
description: 
type: "post"
tags: ["database", "nosql", "mongodb"]
categories : ["full-stack"]
---

## MongoDB
- 以 BSON (Binary JSON) 儲存資料
- composite index
  - prefix
    - 如果有一個 index 是 (a, b)，那麼 (a) 也是有效的 index
  - explain
    - 用來看 query 的 execution plan
    - cursor
      - BasicCursor
        - 會 scan 整個 collection，是個警訊
    - 掃描的文件數量
      - nscanned
        - 掃描的 index 數量
      - nscannedObjects
        - 掃描的 document 數量
      - n
        - 回傳的 document 數量
      - nscanned >= nscannedObjects >= n
    - scanAndOrder
      - 是否需要把文件都放在 memory 並排序
      - 還會一次性回傳資料
  - hint
    - 強制使用某個 index
  - optimizer 挑選索引
    - 第一階段 - 挑選最佳索引
      - 最佳索引
        - 包含所有的 filter 和 sort 的欄位
        - range filter 和 sort 的欄位必須在 equality filter 的後面
          - sort 的欄位必須在 range filter 的後面
        - 如果有多個最佳索引就會隨便選一個
    - 第二階段 - 透過實驗挑選索引
      - 沒有最佳索引就會實驗判斷要選哪個，看看誰先找到指定數量的文件
      - 換句話說，如果有多個索引，optimizer 會選 nscanned 最小的
- MMAPv1
  - Mongo 一開始用的 storage engine
  - _id 直接對應到 diskloc，也就是 disk 的偏移量
    - 查找速度驚人，但是更新就要維護偏移量很費時
  - 採用 database-level lock，Mongo 後來也只更新成 collection-level lock
- WiredTiger
  - MongoDB 收購的 storage engine
  - Document-level locking
  - 可以做到 compression
  - 5.2 之前
    - _id 會先被用來尋找 recordid，再用 recordid 去獲取 document
    - recordid 是 clustered index
  - 5.3
    - _id 變成 clustered index
    - 之前 recordid 只有 64 位，但現在 _id 作為 primary key 有 12 bytes
      - 對 secondary index 造成更大的負擔
      - Mongo 想達成跨機器和 shard 的唯一性