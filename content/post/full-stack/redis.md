---
title: "Redis"
date: 2023-06-05T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["database", "nosql", "cache"]
categories : ["full-stack"]
---

## 基本介紹

### 功能特性
- NoSQL 資料庫
- 記憶體式存儲 (In-memory)
- 以鍵值對 (Key-Value) 形式存儲資料
- 支援多種資料結構，如列表 (List)、集合 (Set)、雜湊 (Hash) 等
- 高性能，適合需要快速讀寫的場景

### 使用場景
- **快取 (Cache)**  
  儲存常用資料，減少長時間的 IO 操作，提升回應速度
- **共享會話 (Shared Session)**  
  在無狀態 (stateless) 的伺服器間共享會話資料
- **分散式鎖 (Distributed Lock)**  
  用於多個程序共享資源時，透過 ```SETNX``` (set if not exists) 實現原子性鎖定
- **速率限制 (Rate Limiter)**  
  利用計數器 (increment) 和過期時間 (expiration) 實現請求限制

## 基本操作

### 啟動與連線
- ```redis-server```  
  啟動 Redis 服務，預設埠為 6379
- ```redis-cli```  
  進入 Redis 命令列介面

### 資料存取
- ```SET <key> <value>```  
  設定鍵值對，預設值為字串類型
- ```GET <key>```  
  獲取指定鍵的值
- ```DEL <key>```  
  刪除指定鍵
- ```EXISTS <key>```  
  檢查鍵是否存在
- ```KEYS <pattern>```  
  查找符合模式的鍵，例如 ```KEYS *``` 可列出所有鍵
- ```FLUSHALL```  
  清空所有資料

### 過期機制
- ```TTL <key>```  
  查看鍵的剩餘存活時間，單位為秒  
  - "-1" 表示永不過期  
  - "-2" 表示已過期
- ```EXPIRE <key> <second>```  
  設定鍵的過期時間
- ```SETEX <key> <seconds> <value>```  
  設定鍵值對並同時指定過期時間

### 支援的資料結構
- **列表 (List)**  
  - ```LPUSH/RPUSH <key> <value>```  
    從左/右端推入值  
  - ```LRANGE <key> <start index> <end index>```  
    獲取指定範圍的值，```end index``` 可為 -1 表示到最後  
  - ```LPOP/RPOP <key>```  
    從左/右端彈出值  
- **集合 (Set)**  
  - ```SADD <key> <value>```  
    加入值到集合  
  - ```SMEMBERS <key>```  
    列出集合所有成員  
  - ```SREM <key> <value>```  
    移除集合中的值  
- **雜湊 (Hash)**  
  - ```HSET <key> <field> <value>```  
    設定雜湊欄位的值  
  - ```HGET <key> <field>```  
    獲取指定欄位的值  
  - ```HGETALL <key>```  
    獲取雜湊所有欄位與值  
  - ```HDEL <key> <field>```  
    刪除指定欄位  
  - ```HEXISTS <key> <field>```  
    檢查欄位是否存在  
  - 注意：Redis 不支援巢狀雜湊結構

## 快取機制

### 常見快取策略
- **Cache Aside**  
  先查詢快取，若無資料則查詢資料庫，並將結果存入快取
- **Read Through**  
  用戶端僅存取快取，若快取無資料，由快取負責從資料庫取回
- **Write Through**  
  寫入資料時，快取保留一份並同步寫入資料庫
- **Write Behind**  
  與 Write Through 類似，但不會立即寫入資料庫，而是累積資料後批量寫入

### 快取情境問題與解法
- **快取雪崩 (Cache Avalanche)**  
  大量快取同時失效，導致資料庫瞬間承受高流量  
  - **解法**  
    為快取加上隨機過期時間，避免集中失效  
- **快取擊穿 (Hotspot Invalid)**  
  熱點快取失效，大量請求直接衝擊資料庫  
  - **解法**  
    設定熱點資料永不過期，或在查詢資料庫時加鎖控制流量  
- **快取穿透 (Cache Penetration)**  
  用戶請求不存在的資料，快取與資料庫皆無結果，直接衝擊資料庫  
  - **解法**  
    在應用層過濾非法請求，或使用布隆過濾器 (Bloom Filter) 預先檢查

## 記憶體管理

### 過期鍵刪除策略
- **定期刪除**  
  每隔固定時間隨機抽樣檢查部分鍵，若過期則刪除  
- **惰性刪除**  
  訪問鍵時檢查是否過期，若過期則立即刪除  

### 記憶體淘汰策略 (maxmemory-policy, Eviction)
當記憶體使用達到上限時，根據設定的策略處理資料  
- **noeviction**  
  不淘汰任何鍵，記憶體滿時拒絕新寫入  
- **allkeys-lru**  
  對所有鍵使用最近最少使用 (LRU) 算法淘汰  
- **allkeys-lfu**  
  對所有鍵使用最不常用 (LFU) 算法淘汰  
- **volatile-lru**  
  僅對設有過期時間的鍵使用 LRU 淘汰  
- **volatile-lfu**  
  僅對設有過期時間的鍵使用 LFU 淘汰  
- **allkeys-random**  
  從所有鍵中隨機淘汰  
- **volatile-random**  
  從設有過期時間的鍵中隨機淘汰  
- **volatile-ttl**  
  優先淘汰剩餘存活時間 (TTL) 較短的鍵

## 持久化

### RDB (Redis Database)
- 以固定時間間隔對記憶體中的資料進行快照 (memory dump)  
- 優點：恢復速度快，適合大規模資料備份  
- 缺點：若伺服器故障，可能丟失最後一次快照後的資料  
- 相關命令  
  - ```SAVE```  
    同步生成快照，會阻塞主進程  
  - ```BGSAVE```  
    異步生成快照，不影響主進程  

### AOF (Append Only File)
- 記錄每一次寫入操作的流程，類似操作日誌  
- 優點：資料一致性高，丟失風險低  
- 缺點：檔案較大，恢復速度比 RDB 慢  
- **AOF 重寫 (Rewrite)**  
  當 AOF 檔案過大時，Redis 會生成新檔案，  
  用最少的操作重建當前資料狀態，取代舊檔案  

### 混合模式
- 結合 RDB 和 AOF 優勢  
- 在 AOF 重寫時，前段使用 RDB 格式快照，後段附加 AOF 操作日誌  
- 兼顧恢復速度與資料完整性

## 高可用性 (High Availability)

### 主從同步
- 一主多從架構，主節點負責寫入，從節點分擔讀取壓力  
- 從節點會即時同步主節點的資料  
- 提升讀取效能，但主節點故障需手動切換  

### 哨兵模式 (Sentinel)
- 部署哨兵進程監控主從伺服器的運行狀態  
- 哨兵持續 Ping 伺服器，檢測異常  
- 若為哨兵叢集：  
  - 單一哨兵檢測異常時，標記伺服器為主觀下線  
  - 多數哨兵同意後，判定為客觀下線，觸發故障轉移 (failover)  
  - 自動選出新主節點，確保服務可用  

### 叢集模式 (Cluster)
- 將資料分片儲存，分散寫入壓力  
- Redis 預設提供 16384 個槽 (slot)，透過雜湊函數分配鍵到不同槽  
- 節點間使用預設埠 16379 進行通訊  
- 可結合主從同步實現高可用性  
- 適用於大規模資料與高併發場景
