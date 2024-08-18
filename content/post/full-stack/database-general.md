---
title: "Database 一般筆記"
date: 2024-07-21T00:00:17+08:00
draft: false
description: "沒有另外被獨立出去一篇且有關 Database 的內容"
type: "post"
tags: ["database", "cache", "sql"]
categories : ["full-stack"]
---

## Database internal
### Storage concept
- Table
- Row_id
  - 多數 database 會維護自己的 row_id
  - 也叫做 tuple id
- Page
  - 多個 row 會被存在一個 page
  - 讀取不會只讀一個 row，而是一個或多個 page
- IO
  - IO operation 指的是存取 disk 的操作
  - 一個 IO 可能會獲得多個 page，也可能只是用 cache 的資料
  - Database 常常會利用 cache 來減少 IO
    - 因此有些 query 很快，可能是因為有快取資料可用
- Heap data structure
  - 儲存整個 table 的資料
  - 有些 database 會用 clustered index 來儲存，就不會有 heap
- Index data structure (b-tree)
  - 一個有 pointer 來指向 heap 的資料結構
    - 較流行的是 b-tree
  - 可以對一個或多個 column 做 index
  - index 可以告訴你要查詢的資料在哪個 page
  - index 也會被儲存在 page
### Row-oriented vs Column-oriented
- Row-oriented database (row store)
  - 每個 row 接著下個 row 來儲存
  - 每次 IO 會獲得多個 row，每個都有所有的 column
- Col-oriented database (column store)
  - 每個 column 接著下個 column 來儲存
  - 比較好壓縮，也比較好做 aggregation，所以在一些分析資料的軟體會用到

### Data structure
- B-tree
  - Balanced data structure for fast search
  - 限制
    - node 中的 element 同時存了 key 和 value
    - range query 效率很差，因為要各別 random access
- B+Tree
  - B-tree 的變形，和 B-tree 很像，不過 internal node 只存放 key，只有 leaf node 會存放 value
    - internal node 因為現在只需要儲存 key，element size 比較小，所以可以存放更多 element
  - leaf node 會用 linked list 串起來
    - 適合 range query
  - 通常一個 node 是一個 DBMS page
- LSM-tree
  - Log-Structured Merge-Tree
  - 都加在尾端，不會覆蓋原本的資料，對 SSD 有利
  - B-Tree 為了平衡會頻繁修改
  - 有利於 insert

### Fragmentation
- 這裡是以 database 為出發點去看 fragmentation
- Internal fragmentation
  - 一個 Page 中有很多空間是空的
- External fragmentation
  - 多個 Page 存放不是連續的。剩下的空間夠儲存新的資料，但是因為不連續，所以不能用

### Database cursor
- 當資料庫有很大的結果集時，不可能一次把所有資料用網路傳給 client，用戶也沒有 memory 來存放所有資料
- Server side / client side cursor
  - Server side
    - 一次只傳一部分資料給 client
    - 但是要多次往返可能最後總時間會比較久
  - Client side
    - 一次把所有資料傳給 client
    - client 自己分批處理
    - 對 network bandwidth 要求較大
    - 可能沒有足夠的 memory

### Partitioning
- 把大 table 分成多個小 table
- Vertical vs Horizontal
  - Vertical
    - 根據 columns 拆成多個 partition
    - 可以把不太常用又大的 column (比如 blob) 放到另外一個 partition
      - 可以把他放在較慢的 disk，保留其他常存取的 column 在 SSD
      - 也可以讓比較不常用的資料比較不容易進入 cache
  - Horizontal
    - 把 rows 拆成多個 partition
- 優點
  - 用 single query 存取單一 partition 的速度更快
  - 對某些 sequential scan 有幫助
  - 可以把舊資料放在比較便宜的設備
- 缺點
  - 如果要從一個 partition 移動資料到另一個 partition，效率很慢
  - 對於效率很差的 query，可能會需要 scan 所有 partition，此時比掃描整個沒做 partition 的 table 還要慢
  - partition 可能會 unbalance

## Database indexing
- 如果需要搜索的欄位沒做 index，那麼就會需要 scan 整個 table，直到找到
  - 如果要求欄位做 `like` 之類的，那麼依然需要 scan 整個 table
- 搜索方法
  - table scan
    - 如果掃描的範圍過大，Database 可能就會選擇該方法
    - 通常會用 parallel 的方式搜尋，所以還是會快一些
  - index scan
  - Index-only scan
    - 也叫 covering index
    - 需要的欄位在 index 裡面就有了，在這種情況不用去 heap 取，可以加速很多
    - 但也要小心使 index 變得過大。如果 memory 不夠，又會用到 disk，拖垮效率
- non-key column
  - 可以用 include 把一些常常需要一起帶入的資訊放到 index 裡面
  - 可以促成 index-only scan
- composite index
  - 把多個 col 作為 key 做 index
  - 在 PostgreSQL ，如果有一個 index 是 (a, b)，用靠左的 index 可以做 index scan，但是用靠右的就不行
### Clustered index
- 也叫做 Index-Organized Table
  - 資料圍繞 index 來組織
  - 這也是為什麼 clustered index 只能有一個
- 沒特別指定的話，primary key 一般是 clustered index
### Primary key vs Secondary key
- primary key
  - clusering
    - 把 table 圍繞 primary key 來組織，但也有些 Database 不是這樣設計，比如 PostgreSQL
  - 需要維持 order，但是如果我要根據 PK 取得小範圍內的資料，和不顧排序相比，就可能不用多次 IO
- Secondary key
  - 不在乎原本 table 的 order，而是根據自訂的 key 來排序
  - 但是會有另外一個結構去放 index，可以找到 row_id
- 設計差異
  - PostgreSQL 的 index 都指向 row，不管是 primary 還是 secondary
    - 這樣 secondary index 就可以直接取資料，不用再跳一層 primary key
    - 但是如果更新 row，會更新 row id，連帶影響要更新所有 secondary index，不管修改的欄位有沒有在這 index
  - MySQL 的 secondary index 指向 primary key，primary key 指向 row
    - 這樣 secondary index 就要先找到 primary key，再找到 row

## Distributed database
### Sharding
- 把 table 拆成多個 table，分散在不同的 database
- 分散式會帶來很多問題，比如要怎麼做 transaction 和 join?
- Horizontal partitioning vs sharding
  - Horizontal partitioning
    - 一個 table 拆成多個 table，但是還是在同一個 database
  - 和 Horizontal partitioning 的差別
    - table 現在會分到不同的 database server
    - 做 partition，client 不用管資料具體在哪個 partition，交給 DBMS 去處理。但是 sharding 就要 client 自己去處理
### Database replication
- 透過 redundancy 來提高 reliability, tolerance, accessibility
- Master / Backup replication
  - 也叫 master-slave replication
  - 只有一個 master / leader，有一或多個 backup / standby
  - 一寫多讀
- Multi-master replication
  - 多個 master，可以同時寫入
  - 需要處理 conflict
- Sychronous vs Asynchronous replication
  - Synchronous
    - transaction 會被 blocked，直到所有的 backup 都寫入
    - 有些 database 可以設定 First N 或是 any 完成就好
  - Asynchronous
    - transaction 被寫入 master 後就算完成


## Concurrency control
- strategy
  - pessimistic
    - 用各種 lock 來保證 isolation
  - optimistic
    - 不用 lock，真的有 transaction 衝突時就 fail
- Lock
  - shared vs exclusive
    - shared lock 可以被多個 transaction 同時持有
      - 用在讀取，所以可以多個 transaction 同時讀取
      - 在有 shared lock  的條件下，其他 transaction 也可以設置 shared lock
    - exclusive lock 只能被一個 transaction 持有
      - 他人不能讀取或寫入
      - PostgreSQL 有一個 `SELECT ... FOR UPDATE` 來取得 exclusive lock
    - 當涉及的資料持有其中一種 lock 時，其他 transaction 都不能設置另外一種 lock
- Deadlock
  - 多個 transaction 互相等待對方釋放 lock
  - 多數 DBMS 會檢查 deadlock，並讓最後一個造成 deadlock 的 transaction rollback
- Two-phase locking (2PL)
  - DBMS 為了實現 isolation 需要保證 conflict serializability (CSR)，2PL 可以保證這一點
  - two-phase
    - growing phase
      - 取得 lock
    - shrinking phase
      - 釋放 lock
    - 強調一個 transaction 不能釋放 lock 後就再也無法取得
    - 有可能造成 deadlock

## Database Engine
- 也叫 storage engine 或 embedded database
- 負責處理 CRUD 的 library
- DBMS 基於 engine 來提供更多功能

## ORM
- Eager vs Lazy loading
  - Eager
    - 一次把所有相關的資料都讀取出來
    - 如果 Teacher 有很多 Student，可能會一次把所有 Student 都讀取出來
  - Lazy
    - 只有在需要的時候才讀取
    - 但是可能會有很多次 IO
- Open session in view (OSIV)
  - 一個 request 一個 database session
  - 可以配合 lazy loading 來用
- N+1 problem
  - 一個 query 取得所有資料，然後再用每個資料的 id 來取得相關資料
  - 這樣就會有 N+1 次 IO
    - 第一次是從主表拿清單
    - 接下來 N 次是從子表拿資料

## Tips
- 盡量不要使用 offset
  - 最 naive 的實現 pagination 的做法就是用 offset + limit。但是 offset 代表讀取並丟掉前面幾筆資料，所以他會多讀一堆沒用的資料
  - 可以讓用戶那邊保存 id，where 設置 id 要大於多少來規避 offset
- Connection pool
  - 維護一定數量的連接，避免每次都要建立連接
- Idempotency key
  - 用來確保一個 request 只會被執行一次
  - 會生成一個唯一的 key，並且在 request 中帶上這個 key。執行操作後會把這個 key 存起來，下次再收到這個 key 時就不會再執行操作
  - 可以用 ULID 而不用 UUID，因為 ULID 前面的 bit 有時間戳，可以用來排序
    - 輸入的資料集中在相近的 page，還都加在尾端，可以減少 IO (相較隨機的 UUID)
      - 不用被迫頻繁存取 disk。而且 UUID 的隨機性拉一堆 page 會導致 buffer 更容易被塞滿，而得強制寫入 disk
- consistent hashing
  - 把 hash function 的結果分散在一個 hash ring 上
    - 根據 hash function 的結果，看自己落在哪段範圍，配給指定的 server
    - 這樣的好處是追加或是移除 server 時，只會影響一台 server 的資料
    - 也可以追加到負載比較高的 server 附近
- write amplification
  - 寫入資料時，發現 disk 寫入的資料比你預期寫入的資料多很多
  - 分很多不同 level，通常是在說 SSD 造成的
  - 想更新的時候，更新的 page 會被標記為不能使用。會有另外一隻非同步程式定期處理這種
    - 但是他會把整個 block 寫到新的地方，再把原地方設為 free，就為了那些不能再被使用的空間搬整個 block