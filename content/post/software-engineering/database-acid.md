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
- 交易的提交結果與將這些交易逐一執行的所有可能順序不一致。

### Write Skew（寫偏斜）
- 交易基於過時資料進行更新，導致邏輯不一致。過時是指讀取的值已經因為併發事務的提交而變得過時。
- 兩個交易同時讀取多筆資料，修改後各自 commit，導致某些資料的更新邏輯不一致。
#### Lost Update（更新遺失）
- 兩個交易同時讀取同一筆資料，修改後各自 commit，造成其中一次的修改被覆蓋。
- 是 write skew 的一種特殊情況。
#### Double booking problem
- 兩個交易同時查詢某條件下的資料，然後各自更新同一筆資料，導致兩筆資料都符合原本的條件，但是有矛盾。
- 例如：兩個人同時預約同一個時間的會議室，兩邊初始檢查都判斷有空，最後各自下訂，但實際上只有一個人能使用該會議室。
- 可以用 lock（pessimistic）來避免這個問題，但這樣會降低併發性。


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

## Durability
- 一旦交易提交，其對資料的修改會被永久保存（persistent），即使系統崩潰或斷電也不會丟失。
  - 完成的 transaction 會被記在 non-volatile storage
- durability technique
  - Write ahead log (WAL)
    - 先寫 log (寫你做了什麼操作，但不去真的改 disk 上對應的資料)，有空再修改
      - 這樣一些修改就可以改在 memory，如果 crash 了，可以用 log 來 recover
      - 而且考量硬碟限制，如果你想修改的資料遠小於硬碟可寫的最小單位，會很浪費
  - Asynchronous snapshot
    - 在後台把 snapshot 寫到 disk