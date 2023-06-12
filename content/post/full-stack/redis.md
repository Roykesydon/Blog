---
title: "Redis"
date: 2023-06-05T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["database", "nosql", "cache"]
categories : ["full-stack"]
---

## Use Cases
1. Cache
    - 把常用的資料回傳，省略長時間的 IO 操作
1. Shared Session
    - 在 stateless server 間共享 session
1. Distributed lock
    - 用在程式間想共用某種資源的時候
    - 用 ```setnx``` (set if not exists)
        - atomic
1. Rate Limiter
    - 用 increment 和 expiration 實現

## Feature
- NoSQL
- In-memory
- Key-Value

## Basic Command
- ```redis-server```
    - default port: 6379
- ```redis-cli```

### Access data
- ```set <key> <value>```
    - Pretty much everything stored in Redis is going to be a type of string by default
- ```get <key>```
- ```del <key>```

- ```exists <key>```

- ```keys <pattern>```
    - find keys with certain pattern
    - ```keys *```
        - get all keys

- ```flushall```
    - get rid of everything

### Expiration

- ```ttl <key>```
    - show time to live
        - "-1" for no expiration
        - "-2" already expired

- ```expire <key> <second>```

- ```setex <key> <seconds> <value>```
    - set with expiration

### Data Structure
#### List
- ```lpush/rpush <key> <value>```
- ```lrange <key> <start index> <end index>```
    - ```<end index>``` can be -1
- ```lpop/rpop <key>```
#### Set
- ```sadd <key> <value>```
- ```smembers <key>```
- ```srem <key> <value>```
    - remove

#### Hash
Key-value in Key-value
- ```hset <key> <field> <value>```
- ```hget <key> <field>```
- ```hgetall <key>```
    - get everything about ```<key>```
- ```hdel```
- ```hexists <key> <field>```
- Redis doesn't support nested hash struct

## 刪除過期 key

### 定期刪除
在固定間隔時間隨機抽 key 檢查並刪除

### 惰性刪除
在訪問 key 的時候發現過期就刪除

## maxmemory-policy (Eviction)
可以設定這些 policy，在記憶體依然額滿的情況下做對應的處理

- noeviction
- allkeys-lru
- allkeys-lfu
- volatile-lru
- volatile-lfu
- allkeys-random
- volatile-random
- volatile-ttl

## 快取情境問題
### 快取雪崩 Cache Avalanche
- 某個時刻大量 cache 失效，使資料庫需要承擔很大的流量。
- 解法
    - 幫 cache 加上額外的隨機過期時間

### 快取擊穿 Hotspot Invalid
- 某個 hotspot 的 cache 失效，使大量請求跑到資料庫
- 解法
    - 讓 hotspot 永不過期
    - 查詢資料庫的部分加上 lock


### 快取穿透 Cache Penetration
- client request 不存在的資料，因為同時不存在於 cache 和資料庫中，所以直接跑到資料庫
- 解法
    - 在 application 先過濾掉非法請求
    - Bloom Filter 布隆過濾器

## Persistence

### RDB
- 固定時間對所有資料做快照，memory dump 出來
- recovery 比 AOF 快
- ```save```、```bgsave```

### AOF
- 紀錄操作流程
- 檔案比較肥

#### Rewrite
當 AOF 太大，Redis 會生一個新文件取代舊的，用最少操作生出目前的資料

### 混合
在 AOF 重寫的時候也利用 RDB
前面是 RDB，後面是 AOF

## Availability

### 主從同步
一主多從，把讀取壓力分擔到 slave 上

### 哨兵模式 Sentinel
會有哨兵不斷地 Ping 主從伺服器，確認是否有異常

如果哨兵是集群，有哨兵檢測到異常，會判斷某伺服器主觀下線，當有一定數量的哨兵投票認為伺服器不可能用，就會變成客觀下線，進行 failover

### Cluster
分擔寫入壓力

Redis 有 16384 個 slot，透過 hash 分配 key 到不同的 slot

預設會另外用 port 16379 來讓節點間溝通

可以混和主從同步達到高可用

