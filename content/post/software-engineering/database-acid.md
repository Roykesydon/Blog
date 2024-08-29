---
title: "Database ACID"
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
- 就算在程式中沒顯式的寫 transaction，資料庫也會自動幫你包 transaction
- lifespan
  - begin
  - commit
  - rollback
## Atomicity
- 一個 transaction 要不全部執行，要不全部不執行
- 在 commit 前不管因為任何理由失敗，都該 rollback
## Consistency
- 符合當初制定的規則 (ex: 設置的 foreign key 指向的資料一定要存在)
  - referential integrity
    - 保證 primary key 和 foreign key 之間的關係
- Eventual consistency
  - 最後一定會 consistent
## Isolation
- 一個 transaction 的執行不應該影響其他 transaction
- read phenomena
  - dirty read
    - 一個 transaction 讀到了另一個 transaction 已經寫了但還沒 commit 的資料。這個資料有可能被 commit 也有可能被 rollback
  - non-repeatable read
    - 一個 transaction 兩次讀取同個資料時，得到的資料不一樣因是因為有其他 transaction 更新了這個資料（已經 commit 了）
    - 和 dirty read 不同的是，這個資料是已經 commit 的
  - phantom read
    - 也是第一次和第二次讀取的資料不一樣，第二次發現多了額外的資料，這次是因為有其他 transaction 寫入了新的資料（並且 commit 了）
    - 之所以要和 non-repeatable read 分開，是因為他這裡沒辦法簡單的靠鎖起來已經讀過的資料，因為你沒辦法鎖你本來看不到的資料
    - 系統設計遇到這問題可以考慮用 pre-populate 的方式，把所有可能的資料都先創好，就可以個別鎖住
  - lost update
    - 我更新了某筆資料，但是在 commit 之前，有其他 transaction 也更新了這筆資料，並且 commit。我再去讀取這筆資料時，發現我更新的資料就被覆蓋了
    - double booking problem
      - 當兩個 transaction 同時搶更新同個資源就有可能遇到該問題
      - example
        - 兩個 transaction 都先 select 再 update
        - 他們兩個 select 都先看到有空位，然後一前一後更新，就會造成 double booking
- Isoaltion level
  - 為了解決 read phenomena，資料庫提供了不同的隔離等級
  - 不會影響自身 transaction 前面所 write 的資料
  - read uncommitted
    - No isolation
    - 可以看到其他 transaction 還沒 commit 的資料
    - 所有的 read phenomena 都有可能發生
  - read committed
    - 只能看到其他 transaction commit 的資料
    - 許多資料庫的預設隔離等級
    - 除了 dirty read 之外，其他 read phenomena 都有可能發生
  - repeatable read
    - 確保同一筆資料在同一個 transaction 中讀取時，結果是一樣的
    - phantom read 還是有可能發生
  - snapshot
    - 保證 transaction 得到的資料是一致的
    - 只會看到 transaction 開始時的 snapshot
    - read phenomena 都不會發生
    - 好像不是所有資料庫都有這個隔離等級，也有些 repeatable read 就是用 snapshot 來實現的
      - 比如 PostgreSQL 就是用 snapshot 來實現 repeatable read
    - 但這不代表不會遇到問題，請參考 double booking problem
  - serializable
    - 最高隔離等級
    - 保證所有 concurrent transaction 執行起來會和依序執行的效果一樣
      - 如果 transaction 不會彼此影響，還是有可能會讓 transaction 並行執行
    - read phenomena 都不會發生
    - 和要求 exclusive lock 相比，有可能實現方法是遇到衝突會 fail
## Durability
- 一旦 transaction 完成，資料應該要 persistent
  - 完成的 transaction 會被記在 non-volatile storage
- durability technique
  - Write ahead log (WAL)
    - 先寫 log (寫你做了什麼操作，但不去真的改 disk 上對應的資料)，有空再修改
      - 這樣一些修改就可以改在 memory，如果 crash 了，可以用 log 來 recover
      - 而且考量硬碟限制，如果你想修改的資料遠小於硬碟可寫的最小單位，會很浪費
  - Asynchronous snapshot
    - 在後台把 snapshot 寫到 disk