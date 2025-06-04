---
title: "Database Transactions and ACID Properties"
date: 2024-07-21T00:00:17+08:00
draft: false
description: "Transaction 四大特性"
type: "post"
tags: ["database"]
categories : ["software-engineering"]
---


## Transaction
- 一個或多個操作的集合
- 一個 transaction 要不全部執行，要不全部不執行
- 即使程式中未顯式使用 transaction，資料庫也會自動為操作包裹一個隱式的 transaction
- lifespan
  - begin
  - commit
  - rollback
## Atomicity（原子性）
- 所有操作要麼全部執行、要麼全部不執行。
- 若中途失敗，資料庫會回滾（rollback）至交易開始前的狀態。
## Consistency
- 一致性是指資料交易執行前後，資料庫必須從一個合法狀態轉變為另一個合法狀態。
- 資料庫的完整性在事務開始前和結束後都不能配破壞。
- 交易需確保不會違反資料庫的約束（constraints），如主鍵、外鍵、檢查條件等。


### 資料庫的完整性約束（Integrity Constraints）
#### 實體完整性（Entity Integrity）
- 表必須有主鍵，主鍵欄位不能為 NULL，且必須唯一。
#### 參照完整性（Referential Integrity）
- 外鍵必須參考到存在的主鍵。
- 避免「孤兒資料」（Orphaned Records）。
  - Orphaned records
    - 指的是一個資料表中的某筆資料的外鍵欄位指向另一個資料表中不存在的主鍵值

#### 域完整性（Domain Integrity）
- 每個欄位值必須落在一組預先定義的允許數值組合下，符合資料型別、範圍、非空、檢查條件等限制。

## Isolation
- 多個交易（Transaction）併發執行時，應避免彼此干擾。
- 理想上，每筆交易的執行結果應與「系統只執行這筆交易」的情況一致。
- 資料庫透過隔離等級（Isolation Level）來控制併發交易的可見性。

## 交易中的讀取異常現象（Read Phenomena）

在併發交易下，可能出現以下幾種資料讀取異常情況：

### Dirty Read（髒讀）
- 讀取到其他交易**尚未 commit**的資料。
- 若該交易之後 rollback，會導致讀到「不存在」的資料。

### Non-repeatable Read（不可重複讀）
- 同一筆查詢在同一交易中，第一次與第二次查詢結果不同。
- 通常是因為另一筆交易在中間**更新了該筆資料**並 commit。

### Phantom Read（幻影讀）
- 同樣條件下的查詢，第一次與第二次結果筆數不同。
- 通常是因為另一筆交易**插入或刪除符合條件的資料**所致。
- 和 Non-repeatable Read 不同，這裡的差異是第二次查詢發現了新的資料（phantom），而不是更新了原有資料。因此沒辦法靠 lock 處理，因為無法 lock 自身看不到的資料。

## Serialization Anomaly
- The result of successfully committing a group of transactions is inconsistent with all possible orderings of running those transactions one at a time.
- 在成功提交一群交易後，結果與以所有可能的順序依序執行交易的結果都不一致。

### Write Skew（寫偏斜）
- 兩個交易在讀取彼此重疊但不同的資料後，根據讀到的資料做出條件判斷並各自寫入不同的資料列。
### Lost Update（更新遺失）
- 兩個交易同時讀取同一筆資料，修改後各自 commit，造成其中一次的修改被覆蓋。
### Double booking problem
- 兩個交易同時查詢某條件下的資料，然後更新資料，導致兩筆資料都符合原本的條件，但是有矛盾。
- 例如：兩個人同時預約同一個時間的會議室，兩邊初始檢查都判斷有空，最後各自下訂，但實際上只有一個人能使用該會議室。
- 可以用 lock（pessimistic）來避免這個問題，但這樣會降低併發性。
#### 解法 1. Pessimistic Locking（悲觀鎖）
透過 `SELECT ... FOR UPDATE` 來鎖定資料列，避免同時被其他交易修改。
PostgreSQL 可以用這樣把 row 加上 exclusive lock
#### 解法 2. Optimistic Locking（樂觀鎖）
透過在資料表中加入版本號（version number）或時間戳記（timestamp），在更新時檢查版本號是否一致，若不一致則拒絕更新。
- 當交易開始時，讀取資料的版本號。
- 在更新時，檢查資料的版本號是否與開始時一致。

## 資料庫隔離等級（Isolation Levels）

根據 SQL 標準（SQL92），隔離等級共分為四種，由低至高如下：

| 隔離等級              | 髒讀 (Dirty Read) | 不可重複讀 (Non-repeatable Read) | 幻影讀 (Phantom Read) |
|-----------------------|-------------------|-----------------------------------|------------------------|
| Read Uncommitted      | ❌ 可能發生        | ❌ 可能發生                         | ❌ 可能發生             |
| Read Committed        | ✅ 避免            | ❌ 可能發生                         | ❌ 可能發生             |
| Repeatable Read       | ✅ 避免            | ✅ 避免                             | ❌ 可能發生（MySQL 有時避免） |
| Serializable          | ✅ 避免            | ✅ 避免                             | ✅ 避免                 |

- ✅ 表示該現象「可被防止」。
- ❌ 表示該現象「可能發生」。

### Read Uncommitted
- 最低隔離等級，什麼 read phenomena 都可能發生。
### Read Committed
- 只能讀取其他交易已經 commit 的資料。
- 許多資料庫的預設隔離等級。

### Repeatable Read
- 確保同一筆資料在同一交易中讀取時，結果是一致的。
- 但 phantom read 還是有可能發生。

### Serializable
最嚴格的隔離等級，確保所有交易的執行結果等同於某種交易**逐一依序執行（serial order）**的情況。
可以避免所有類型的讀取異常（包括 dirty read、non-repeatable read、phantom read），也能避免 write skew。

## Durability
- **定義**: 持久性確保一旦事務提交成功，其對資料庫的修改就是永久性（persistent）的，即使系統發生故障（如斷電、系統崩潰），這些修改也不會丟失。
- **目標**: 確保資料的永久儲存和可恢復性。
- **相關技術**:
    - **寫入日誌 (Write-Ahead Logging, WAL)**:
        - 在資料庫實際修改資料文件之前，事務的所有修改操作會先被寫入到持久化的日誌文件（稱為 WAL）。
        - 主要是希望修改可以盡量停留在 memory，而不是直接寫入磁碟，有空再改。
        - 這些日誌包含了足夠的資訊，以便在系統恢復時重新應用這些修改，確保資料的一致性。
    - **快照（Snapshots）**:
        - 資料庫系統會定期創建資料的快照，這些快照可以用於故障恢復。
        - 這之間，資料可以在記憶體中進行修改，但快照確保了在某個時間點的資料狀態可以被恢復。
        - 發生崩潰的時候，可以搭配 WAL 使用，從最後一個快照和日誌中恢復資料。

- **例子**: 當你在網路上完成一筆訂單支付後，即使此時伺服器突然斷電，訂單資訊也應該被永久保存下來，不會因為斷電而丟失。這是因為支付事務提交後，其修改已經被寫入到日誌中，並且最終會被持久化到儲存設備上。
