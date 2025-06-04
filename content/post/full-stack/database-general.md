---
title: "Database 一般筆記"
date: 2024-07-21T00:00:17+08:00
draft: false
description: "沒有另外被獨立出去一篇且有關 Database 的內容"
type: "post"
tags: ["database", "cache", "sql"]
categories : ["full-stack"]
---

## 基本概念

### 資料庫與資料表
- 資料庫（Database）：儲存資料的容器。
- 資料表（Table）：由欄位（Columns）與列（Rows）組成的結構，用於儲存資料。
- 每一列代表一筆紀錄（Row/Record）。
- 每一欄代表一個欄位（Field/Column），資料型別通常固定。

### 主鍵與外鍵
- 主鍵（Primary Key）：唯一識別一筆紀錄的欄位，不能為 NULL。
- 外鍵（Foreign Key）：引用另一個資料表的主鍵，用來建立表格之間的關聯。
#### Primary Key 與 Secondary Index 討論
- **Primary Key**
  - 資料唯一性保證。
  - MySQL（InnoDB）：primary key 作為 clustered index，資料儲存依其排序。
    - locality：資料儲存與索引結構緊密結合，查詢效率高。
  - PostgreSQL：primary key 為唯一約束，索引與資料儲存分離。

- **Secondary Index**
  - 非主鍵欄位所建之索引，用來提供其他查詢條件的效能。
  - 差異：
    - **MySQL InnoDB**
      - secondary index 指向 primary key，需多跳一次（再去查 clustered index tree）才能找到資料位置（稱為「回表」）。
      - 優勢：row 移動時只需更新 clustered index tree。
    - **PostgreSQL**
      - secondary index 直接指向實際資料位置（tuple ID, TID）。
      - 優勢：查詢不需透過 primary key
      - 劣勢：若 row 被移動，所有指向該 row 的索引都需更新。

### 資料儲存方式
- **Row-oriented（行導向）**
  - 每筆資料（row）整行儲存在一起，一次 I/O 通常會載入多行
  - 適合 **OLTP（Online Transaction Processing）**：操作大量單筆交易，常讀寫整行資料

- **Column-oriented（列導向）**
  - 每個欄位的值會連續儲存，有利於聚合（aggregation）查詢
  - 適合 **OLAP（Online Analytical Processing）**：資料分析、報表、聚合查詢等場景


### 資料庫引擎 (Database Engine)

- **定義**
  - 又稱 storage engine 或 embedded database，是處理 CRUD 操作的核心元件
  - 提供儲存資料、讀寫記錄、索引管理、鎖機制、快照等低階功能

- **功能與架構**
  - DBMS 透過引擎完成底層操作，再加上：
    - 查詢最佳化器（Query Optimizer）
    - 執行計劃管理（Execution Plan）
    - 交易控制（Transaction Manager）
    - 緩衝區管理（Buffer Pool）

- **常見範例**
  - **InnoDB（MySQL）**
    - 支援 ACID 交易與外鍵
    - 預設引擎，適用一般應用系統
  - **MyISAM（MySQL）**
    - 效能佳但不支援交易與外鍵
    - 適用於大量讀取為主的系統
  - **SQLite**
    - 輕量、嵌入式資料庫，適合行動裝置或小型應用
    - 整個引擎封裝於一個檔案中

## 資料儲存與 IO 操作
### Row ID
- 多數資料庫會為每筆資料維護一個唯一的 row identifier，又稱為 tuple ID。
- **PostgreSQL** 使用 `ctid`（而非過去的 `OID`，預設不會開啟），代表 row 在資料頁的位置。
  - `ctid` 是一個 tuple 的位置標識符，包含 `(blockid, itemid)`

### Page（資料頁）
- 資料不以「row」為單位讀取，而是以「page」為單位。
- 一個 page 通常大小為 8KB（依資料庫設定而異），可包含多筆 row。
- 查詢時，會讀取一個或多個 page 到記憶體中。

### IO 操作
- IO 指的是磁碟存取操作，代價高昂。
- 若資料已在記憶體中（如 buffer pool），可省下 IO 時間。
- 資料庫系統設計了 **cache 機制（如 buffer pool）** 來減少 IO 操作，提高效率。

### Heap 儲存結構
- 資料表的實體儲存可以是 heap 結構：無特定順序。
- 若資料表建立了 **clustered index（叢集索引）**，則資料實體會依索引順序儲存，等於沒有獨立 heap。
  - 例如 **MySQL InnoDB** 使用主鍵作為 clustered index，資料直接依主鍵順序儲存。
  - PostgreSQL 預設使用 heap 儲存，即使建立 index，也不會重排資料；可用 `CLUSTER` 指令強制重排一次，但非持續維護。

### 資料庫游標 (Database Cursor)

- **用途**
  - 用於查詢結果需要逐筆處理或資料量過大時，避免一次傳送所有資料給 client
  - 常見於報表產生、大型資料遷移、批次處理等場景
  - 解決網路傳輸、記憶體限制與處理效能問題

#### 游標類型
- **Server-side Cursor**
  - 游標在資料庫伺服器中開啟，client 每次請求一批資料
  - 優點：
    - 減少 client 記憶體使用
    - 適用於大量資料逐筆處理
  - 缺點：
    - 需要多次網路來回，整體延遲可能較高
    - 游標在 server 端長時間開啟，可能佔用資源

- **Client-side Cursor**
  - 一次將所有查詢結果傳回 client，由 client 管理游標與處理資料
  - 優點：
    - 查詢後無需與 server 維持連線（資料已在 client）
    - 降低 server 資源消耗
  - 缺點：
    - 傳輸時需要足夠的網路頻寬
    - 需足夠的 client 記憶體儲存整個結果集

### 常用資料結構
- **B-Tree**
  - 一種平衡搜尋樹結構，適用於隨機讀取與插入。
  - 每個 node 儲存 key 與對應的資料（value 或 pointer）。
  - 限制：
    - 範圍查詢（range query）效率雖然不差，但因 leaf node 非線性串聯，可能需多次隨機 IO。

- **B+Tree**
  - B-Tree 的優化版本，許多關聯式資料庫的索引都基於此結構（如 MySQL InnoDB、PostgreSQL B-tree index）。
  - 特性：
    - Internal node 僅儲存 key 與 child pointer，不儲存資料。
    - Leaf node 儲存 key 與對應的資料位置，並以 linked list 串接，利於範圍查詢（range query）。
    - node 大小設計上通常對應資料庫的 page（例如 8KB）。

- **LSM-Tree (Log-Structured Merge-Tree)**
  - 主要用於寫入密集的系統（如 RocksDB、Cassandra），較少見於傳統關聯式資料庫。
  - 特性：
    - 所有寫入都先進入記憶體內的 log 結構（如 memtable），後續批次寫入磁碟，減少隨機 IO。
    - 資料都追加在尾端（append-only），不覆蓋原有資料
    - 查詢需從多層（memory + 磁碟）結構中合併搜尋，造成讀取成本增加。
    - 常需 background compaction 來合併資料，避免過多層。
    - 對 SSD 優化良好，因為避免隨機寫入。
    - 也避開了 B-Tree 為了保持平含頻繁調整結構導致 IO 的情形
    - 存在讀取放大（read amplification）和寫入放大（write amplification）相對較嚴重的問題。

### Write-Ahead Logging (WAL)
這裡以 PostgreSQL 為例說明 WAL 機制。
- **定義與目的**
  - PostgreSQL 使用 WAL 機制來確保交易的持久性與資料一致性（ACID 的 Durability 特性）
  - WAL 是一種「先寫入日誌再執行資料修改」的機制，確保即使系統當機，也能透過日誌恢復資料
  - 透過該方案，不用每次修改資料時都直接寫入磁碟，而是先寫入日誌，然後更新資料頁（data page），這樣可以減少磁碟寫入次數，提高效能

- **運作流程**
  - 當有資料變更時，系統**先將變更記錄寫入 WAL log**（順序寫入）
  - 等 WAL 寫入磁碟後，才會進行實際資料頁（data page）的修改

- **Crash Recovery**
  - 若 PostgreSQL 意外關閉，重啟時會透過 WAL 還原未完成的交易或完成的寫入
  - 能夠將資料恢復到一致狀態（即使資料頁尚未同步到磁碟）

- **Checkpoint**
  - 為了避免重啟時重播過多 WAL，系統會定期執行 checkpoint，將記憶體中已修改的資料頁（dirty pages）同步至磁碟
  - checkpoint 發生後，WAL 可標記為「已持久化資料」的安全點


## 時間與空間效率問題

### 碎片化（Fragmentation）

- **定義**
  - 指儲存空間未被有效使用的現象，影響查詢效率與空間使用率

- **Internal Fragmentation（內部碎片）**
  - 資料頁（page）內存在大量未使用空間
  - 成因：
    - 刪除資料後未即時回收空間
    - 欄位長度不定，導致空間配置不均
    - 插入資料時預留空間（Fill Factor）設太高
  - 結果：儲存效率下降，需掃描更多 page

- **External Fragmentation（外部碎片）**
  - 資料頁在磁碟上的位置不連續，導致無法順序讀取
  - 成因：
    - 更新資料導致頁面移動
    - 長期 insert / delete 操作未重組
  - 結果：影響 sequential scan 效能，IO 次數增加

- **解法**
  - 定期執行重組工具（如 `VACUUM` / `OPTIMIZE TABLE` / `REORGANIZE`）
  - 使用合適的 fill factor 減少內部碎片

### 寫入放大（Write Amplification）

- **定義**
  - 為了寫入一筆資料，實際需要對儲存層進行多次寫入的現象

- **成因**
  - **Page-based 更新**：僅修改部分欄位也需整頁覆寫
  - **MVCC**（多版本控制）：更新會寫入新版本而非覆蓋原資料
  - **WAL（Write-Ahead Logging）**：
    - 為確保資料一致性，寫入前需先寫 log 檔（多一次 IO）
  - **壓縮 / 索引更新**：
    - 更新資料同時需更新索引、維護壓縮區塊

- **結果**
  - 增加磁碟壽命負擔（特別是 SSD）
  - 寫入延遲上升

- **解法**
  - 減少不必要更新（ex: 避免 dummy update）
  - 善用批次寫入（batch write）

### 讀取放大（Read Amplification）

- **定義**
  - 為了讀取一筆資料，實際需要讀取更多資料頁甚至多層結構

- **成因**
  - **索引結構（如 B-tree）**：
    - 查詢需經過多層 node 才能取得資料
  - **資料與索引分離存放**：
    - 需先查索引頁，再跳轉資料頁（I/O 次數加倍）
  - **壓縮或合併格式（如 LSM-tree）**：
    - 同一筆資料可能存在於多層檔案中
    - 查詢需同時掃描多層（Level 0~N）

- **結果**
  - 增加查詢延遲與 CPU 負擔
  - 特別在 LSM-based 系統中更明顯

- **解法**
  - 建立合適的索引，避免不必要的 full scan
  - 使用 bloom filter、cache 等加速讀取

#### Pagination（分頁）

- **Offset-Based Pagination**
  - 傳統分頁方式：`OFFSET n LIMIT m`
  - 查詢時仍需掃描並跳過前 `n` 筆資料，成本高
  - 對於大型結果集與高頁碼情況，效能明顯下降

- **原因**
  - 資料庫仍需讀取前面 `n` 筆資料後，才返回第 `n+1` 筆開始的 m 筆結果
  - 無法使用 index 節省前面資料的掃描成本

- **Keyset Pagination / Cursor-Based pagination**
  - 使用唯一遞增欄位（如主鍵 id 或 timestamp）
  - 範例：
    ```sql
    SELECT * FROM posts
    WHERE id > :last_seen_id
    ORDER BY id
    LIMIT 10;
    ```
  - 優勢：
    - 可利用索引快速定位位置
    - 效能穩定、適合大型資料集

- **限制**
  - 無法直接跳轉到第 N 頁
  - 結果排序需穩定，適用於時間序列、流水號等資料

## 資料類型
### 整數與數值 (Numeric)
- **整數**
  - `smallint`：2 bytes，範圍 -32,768 ~ 32,767
  - `integer`：4 bytes，範圍 -2^31 ~ 2^31-1
  - `bigint`：8 bytes，適合大量資料或需要大範圍整數時使用
- **浮點數**
  - `real`：單精度 (4 bytes)
  - `double precision`：雙精度 (8 bytes)
  - 適用於儲存近似值，例如感測器資料
- **精確數值**
  - `numeric(p, s)` / `decimal(p, s)`：可精確表示小數，常用於金額與精度要求高的欄位
- **Serial / Auto Increment**
  - `serial`、`bigserial`：整數自動遞增，常用於主鍵

### 字串類型 (Character)

- **定長與變長字串**
  - `char(n)`：固定長度，不足會以空白補齊
  - `varchar(n)`：可變長度，限制最大長度
  - `text`：無長度上限的字串，實際儲存與 `varchar` 相似，但無長度限制
- **bpchar**
  - PostgreSQL 對 `char(n)` 的內部實作名，代表 "blank padded char"
  - `bpchar` 在查詢時會自動去除尾端空白（blank trimmed）

### 時間類型 (Date / Time)
- `date`：僅日期（YYYY-MM-DD）
- `time`：僅時間（HH:MM:SS）
- `timestamp`：日期與時間
- `timestamptz`：含時區的 timestamp，建議預設使用以避免時區混淆

### 布林值 (Boolean)
- `boolean`：`true`、`false` 或 `null`
- 通常以 1 bit 儲存（視實作而定）

### 二進位資料 (Binary)
- `bytea`：可儲存任意二進位資料
  - 應用：圖片、檔案、加密值

### 幾何類型 (Geometric)
- 內建支援幾何資料類型，例如：
  - `point`：表示 (x, y)
  - `line`、`lseg`：線段
  - `polygon`、`box`、`circle`
- 應用：可使用 `point` 儲存二維座標，節省兩個 float 欄位

### 枚舉 (Enum)
- `enum`：自訂固定集合的字串值
  - 優點：資料驗證容易、儲存效率高
  - 注意：儲存順序固定，無法隨意變更定義順序
- 應用：狀態欄位（如 `"pending"`、`"approved"`、`"completed"`）

### UUID
- `uuid`：128 位元的通用唯一識別碼
- 適用於分散式系統、避免碰撞的識別碼生成
- PostgreSQL 支援內建的 `gen_random_uuid()` 等函數

## 索引（Index）

- 提升查詢效率
  - 若欄位未建立索引，查詢需掃描整個 table
- 注意：過多索引會影響插入與更新效率。

### 索引欄位
- **單欄位索引（Single-column Index）**
  - 僅以一個欄位作為索引 key。
  - 適合查詢主要集中於該欄位的情況。

- **複合索引（Composite Index）**
  - 以多個欄位組成索引 key，例如 `(a, b)`。
  - 使用限制：
    - 僅能有效利用最左前綴欄位。例如查詢 `a=1` 或 `a=1 AND b=2` 可使用索引，但單查 `b=2` 則無法。
    - 欄位順序設計需依實際查詢條件頻率規劃。

- **包含欄位（Included Columns）**
  - 某些資料庫（如 PostgreSQL）支援在索引中加入非 key 欄位，方式如：`CREATE INDEX ON table(a) INCLUDE (b, c)`。
  - 優勢：
    - 提供 index-only scan 支援，避免多次 heap lookup。
    - 不影響索引排序與結構。

### 索引結構層級
- **Clustered Index（叢集索引）**
  - 資料實際儲存順序與索引排序一致。
  - 特性：
    - 一張表最多只能有一個 clustered index。
    - 範圍查詢效能佳，因資料連續排列。
  - MySQL InnoDB：primary key 即為 clustered index。
  - PostgreSQL：不強制資料儲存順序與索引一致，但可使用 `CLUSTER` 手動排序。

- **Non-clustered Index（非叢集索引）**
  - 索引結構獨立於資料表，僅儲存 key 與資料位置。
  - PostgreSQL 所有索引皆為 non-clustered，但效率仍高因 index 可直接指向 tuple。


### 資料存取方式
- **Table Scan（全表掃描）**
  - 直接讀取整個資料表。
  - 適用於：
    - 無可用索引。
    - 查詢需處理大部分資料。
  - PostgreSQL 支援 parallel sequential scan 來提高效率。

- **Index Scan（索引掃描）**
  - 透過索引找出符合條件的 key，再從資料表中定位實際資料（heap tuple）。
  - 若命中多筆資料，每筆需額外一次 heap lookup。

- **Index-only Scan（覆蓋索引掃描）**
  - 若查詢所需欄位皆存在於索引中，則無需讀取 heap。
  - 條件：
    - 查詢欄位需包含於索引（或 included column）。
    - PostgreSQL 中，對應 tuple 必須在 visibility map 中標記為「all-visible」。
      - Visibility map 是一種 bitmap，標記哪些頁面中的 tuple 對所有事務都是可見的。
      - 和 MVCC（Multi-Version Concurrency Control）有關
      - 如果沒有被標記為 all-visible，則需要額外的 heap lookup 來確認 tuple 對當前事務的可見性，變回了 index scan。
  - 優勢：
    - 減少 IO，提高查詢效率。
- **Bitmap Index Scan（位圖索引掃描）**
  - 將一或多個索引查詢結果轉換為 bitmap（位圖），再一次性讀取符合條件的資料頁（heap page）。
    - 在 PostgreSQL 中，這是透過 `Bitmap Index Scan` 和 `Bitmap Heap Scan` 兩個步驟完成的。
    - 一個 bit 對應一個 page，若該 page 中有符合條件的 tuple，則該 bit 為 1，否則為 0。
  - 特性：
    - 適合多個條件需結合評估的查詢，如 `a = 1 AND b = 2 AND c = 3`。
    - 不像 Index Scan 每找到一筆就做 heap lookup，Bitmap Scan 是「**批次處理**」，提升效率。
    - 通常搭配 `Bitmap Heap Scan` 一起使用：前者決定哪些頁面要讀，後者實際讀取。
  - 使用時機：
    - 多個條件分別對應不同索引。
    - 命中資料多、Index Scan 隨機 IO 成本高時。
  - 流程：
    1. 每個條件建立對應的 bitmap（由索引產生）。
    2. 系統對 bitmap 做 AND / OR 合併。
    3. 執行 Bitmap Heap Scan，依據位圖讀取需要的頁面，再從頁面中挑出符合條件的 tuple。

## Planner / Optimizer

計劃器/優化器的任務是產生一個最佳執行計劃

- Planner/Optimizer 的任務是建立一個最好的執行計畫。一個 SQL 查詢可以用多種不同方式執行，都會產生相同結果，如果計算可行，Optimizer 會檢查每個可能的執行計畫，最後執行預期可以最快的計畫
  - 由於找出所有可能的執行方式太耗資源，當 join 的數量超過一定 threshold 後，PostgreSQL 會利用基因演算法
- 會考慮可用的索引，產生使用索引與不使用索引的多種查詢方式。
- 根據索引的類型（單欄位、複合、Clustered）及查詢條件產生不同的 plan。
  - 但總會有一個全表掃描（Table Scan）作為 plan 之一。其他就是看 index 是否符合查詢條件
- 單表掃描計畫
  - Index Scan（使用索引依序讀取）
  - Bitmap Index Scan（結合多個索引條件）
  - Index Only Scan（僅使用索引，不需回表）
  - Sequential Scan（全表掃描）
- optimizer 會先為每一個 table 產生計畫，如果需要 JOIN 多個 table，也是在找到每個 table 的所有可行掃描計畫後才開始考慮 JOIN
- JOIN 策略
  - Nested Loop Join（嵌套迴圈連接）
    - 對於左邊的 table 每一行，對右邊的 table 做一次掃描
  - Merge Join（合併連接）
    - 先對兩個 table 的 join key 做排序，再同步掃描兩個 table，把符合條件的合併成連接結果
    - 每個 table 都只掃描一次
  - Hash Join（雜湊連接）
    - 先把右表建立 Hash Table，把 JOIN 的屬性作為 Hash Key。再掃描左表，用 Hash Table 找出符合條件的行



## 併發（Concurrency）
### 並發控制（Concurrency Control）
- **悲觀控制（Pessimistic Concurrency Control）**
  - 假設交易間容易產生衝突，因此在讀/寫資料前會先加鎖以避免其他交易修改
  - 優點：能有效避免衝突導致的資料錯誤
  - 缺點：可能造成等待與死結

- **樂觀控制（Optimistic Concurrency Control）**
  - 假設交易間衝突少，交易不加鎖，提交時再驗證是否有衝突
    - 可能使用版本號或時間戳記來檢查資料是否被修改
  - 優點：執行效率高，適合低衝突環境
  - 缺點：若驗證失敗需回滾與重試

### 鎖定機制（Lock）

資料庫為了確保交易的隔離性（Isolation），會對資料加鎖來避免同時存取導致的不一致問題。

#### 鎖的分類

- **依鎖定範圍**：
  - 行鎖（Row Lock）
  - 頁鎖（Page Lock）
  - 表鎖（Table Lock）

- **依操作目的**：
  - Shared Lock（共享鎖）：允許多個交易讀取資料
  - Exclusive Lock（排他鎖）：只允許單一交易修改資料

- **依顯示與隱式加鎖方式**：
  - 顯式鎖（Explicit Lock）：使用 SQL 語句主動加鎖，如 `SELECT ... FOR UPDATE`
  - 隱式鎖（Implicit Lock）：由資料庫系統在交易期間自動加鎖，無需開發者手動指定

- **意圖鎖（Intent Lock）**：
  - 用於多層級（如表與行）鎖時的協調機制，幫助系統判斷是否允許加鎖
---


#### Shared Lock （共享鎖）與 Exclusive Lock（排他鎖）

##### Shared Lock（共享鎖）
- 適用於**讀取操作**
- 多個交易可同時持有（允許共享）
- PostgreSQL 可使用 `SELECT ... FOR SHARE` 來取得共享鎖

##### Exclusive Lock（排他鎖）
- 適用於**寫入操作**
- 只能有一個交易持有，其他交易無法讀寫
- PostgreSQL 可使用 `SELECT ... FOR UPDATE` 來取得排他鎖
---

#### Multiple Granularity Locking（多層級鎖定, MGL）
資料庫系統通常會使用多層級鎖定來提高效能與靈活性，允許在不同層級（如行、頁、表）上加鎖。

##### 意圖鎖（Intention Lock）

當使用**多層級鎖（如：表鎖＋列鎖）**時，為了讓上層資源（如整張表）知道下層（如某列）是否已被加鎖，會使用意圖鎖來進行協調。
這樣可以避免一個交易對表加鎖時與其他交易在列上的鎖發生衝突。也可以避免逐列檢查鎖的狀態，提升效能。

常見的意圖鎖種類：
- **Intent Shared (IS)**：表示交易打算在某些子資源上加共享鎖
- **Intent Exclusive (IX)**：表示交易打算在某些子資源上加排他鎖
- **Shared and Intent Exclusive (SIX)**：表層加共享鎖，某些子資源加排他鎖（S+IX，對表上 S 鎖的同時，會更新某些行）

---

#### 鎖的相容性表


|        | IS | IX | S  |  X  |
|--------|----|----|----|----|
| **IS** | ✔  | ✔  | ✔  | ✘  |
| **IX** | ✔  | ✔  | ✘  |  ✘  |
| **S**  | ✔  | ✘  | ✔  |  ✘  |
| **X**  | ✘  | ✘  | ✘  |  ✘  |

---

#### 鎖衝突說明

- 若某筆資料已有 **Shared 鎖（S）**，其他交易可再加 S 鎖，但不能加 X 鎖
- 若已有 **Exclusive 鎖（X）**，其他交易無法加任何鎖
- 若在列上已有 X 鎖，表層無法再加表級 S 鎖，因為需要 IX 或 IS 協調


#### 死結（Deadlock）

- **定義**
  - 多個交易互相等待對方釋放鎖，導致無限等待
- **處理方式**
  - 多數 DBMS 具備死結偵測機制
    - 一旦發現死結，會中止其中一個交易並回滾，以解除死結

#### 兩階段鎖定（Two-Phase Locking, 2PL）

- **目的**
  - 保證交易之間的操作順序達到 Conflict Serializability（CSR，衝突序列化），以實現交易隔離（isolation）。
    - CSR 保證交易的執行結果與某個將事物按照特定順序下執行的結果一致

- **階段**
  - **Growing Phase（增長階段）**
    - 交易可以申請鎖 (acquire locks)，但不能釋放鎖
  - **Shrinking Phase（收縮階段）**
    - 交易可以釋放鎖 (release locks)，但不能再申請任何新鎖

- **特性**
  - 一旦進入收縮階段，無法再加鎖
  - 符合 2PL 的交易保證衝突序列化
  - 缺點：仍可能導致死結

### 多版本並發控制（MVCC, Multi-Version Concurrency Control）
#### 概念介紹
MVCC 是一種資料庫的並發控制機制，主要目的是解決多個交易（transaction）同時存取資料時的衝突，提升讀取效率與整體性能。MVCC 允許資料庫同時保有多個資料版本，讀取和寫入不會阻塞彼此。
PostgreSQL 即使是透過 Serializable Snapshot Isolation (SSI) 來實現最嚴格的 isolation 也可以保證讀寫不互阻塞。 

#### PostgreSQL 中的 MVCC

PostgreSQL 用 MVCC 來維護一致性，和許多用 lock 進行併發控制的資料庫不同
PostgreSQL 採用 MVCC 來實現高效的多用戶並發控制。其核心思想是資料列（row）在被修改時，資料庫不直接覆蓋舊資料，而是產生一個新的版本，並且利用系統欄位追蹤該版本的可見性。
PostgreSQL document 提及「PostgreSQL 雖然提供了表格層級（table-level）和資料列層級（row-level）的鎖定功能，給那些不太需要完整交易隔離（full transaction isolation）、而是偏好自己手動處理資料衝突的應用程式使用。但一般來說，如果正確地使用 MVCC（多版本並發控制，Multi-Version Concurrency Control），效能會比直接用鎖來得更好。」
不曉得是不是在指善用隔離等級

#### MVCC 實作細節

- **資料版本保存**  
  每一筆資料列都包含兩個系統欄位（Transaction IDs）：  
  - `xmin`：該資料列的建立交易 ID（transaction ID）  
  - `xmax`：該資料列被刪除或取代的交易 ID 

- **可見性判斷**  
  PostgreSQL 的交易在讀取資料時，根據自身的 transaction ID 和資料列的 `xmin`、`xmax` 以及 CLOG，判斷該版本是否對該交易可見。  
  - 如果交易 ID 在 `xmin` 之後且在 `xmax` 之前，則版本對交易可見。  
  - 這樣能確保交易只能看到自己開始前已提交的版本，避免讀到未提交或未決定的資料。

- **行為示例**  
  - 讀取時，交易看到的是當前時間點有效的版本，並不會被其他交易的未提交變更阻塞。  
  - 寫入（UPDATE、DELETE）時，不是直接修改舊版本，而是產生新版本，舊版本標記為過期（設定 `xmax`）。  
  - 因此，PostgreSQL 實際上是「新增」了一筆新資料，舊資料依然存在直到垃圾回收。

- **CLOG (Commit Log)**  
  - CLOG 紀錄每個 transaction 的狀態

#### MVCC 的優點
- **非鎖定讀取（Non-blocking reads）**  
  - 讀取操作不會阻塞寫入，避免讀寫競爭造成的效能瓶頸。
    - 避免 shared lock 影響 update 操作。
- **避免死鎖與鎖等待**  
  由於讀取不需要加鎖，降低死鎖機率。  
- **可支援快照隔離（Snapshot Isolation）**  
  每個交易看到的資料是一個一致的「快照」，提升交易一致性。  

#### MVCC 的挑戰與缺點
- **存儲空間開銷**  
  多版本資料持續存在，可能造成磁碟空間膨脹。  
- **VACUUM 清理機制**  
  PostgreSQL 需要定期執行 `VACUUM` 來回收不再需要的舊版本，避免空間浪費與查詢效能下降。  
- **寫入放大**  
  更新不是覆寫，而是新增資料版本，會產生較多寫入操作。

## 資料分散
### 分割 (Partitioning)

- **定義**
  - 將一個資料表拆分成多個較小的單元（partition），以提升效能或便於管理，所有 partition 仍在同一資料庫內，由 DBMS 自行管理

#### 類型

- **Horizontal Partitioning（水平分割）**
  - 按 row 進行分割，每個 partition 儲存部分資料列。
  - 應用：
    - 根據時間、地區等條件分割資料
    - 舊資料可存於便宜儲存裝置
    - 加速範圍查詢，減少掃描量

- **Vertical Partitioning（垂直分割）**
  - 按 column 進行分割，不同欄位儲存於不同表格
  - 應用：
    - 不常用或大型欄位（如 BLOB）獨立出來
    - 可將冷資料放在慢速磁碟，熱資料保留於快取中
    - 減少不必要欄位進入記憶體

#### 優點
- 範圍查詢效率提升（尤其是水平分割）
- 有助於儲存資源利用：冷熱資料可分別處理
- 增加維運彈性（如將特定 partition 歸檔）

#### 缺點
- 查詢若跨越多個 partition，效能反而下降
- Partition 不均衡可能導致熱點或儲存空間浪費

### Sharding（分片）
與 partitioning 類似，但資料被分散到「不同伺服器」上，常用於實現水平方向的可擴展性。

#### 與 Partitioning 差異
| 比較項目        | Partitioning                | Sharding                         |
|-----------------|-----------------------------|----------------------------------|
| 分割位置        | 同一資料庫                 | 多個資料庫（不同伺服器）        |
| 管理者          | DBMS 管理                  | 應用層自行處理（如查詢轉發）   |
| 複雜性          | 較低                        | 較高（需考慮跨庫一致性）        |

#### 分片鍵設計（Sharding Key）

- **Hash 分片**
  - 使用 hash function 將資料均勻分配
  - ✅ 避免熱點  
  - ❌ 難以進行範圍查詢
  - **Consistent Hashing**
    - 將 hash 結果映射至環狀結構，分配資料至伺服器
    - 優勢
      - 新增或移除伺服器時，僅影響部分資料重分配
      - 可針對負載高的伺服器動態調整

- **Range 分片**
  - 根據欄位範圍（如 ID、時間）分配資料
  - ✅ 易於執行範圍查詢  
  - ❌ 資料可能集中於某些分片造成熱點

- **Dictionary 分片**
  - 根據類別等離散值進行分配

- **Geographic 分片**
  - 根據地理位置（如國家、城市）分配資料
  - ✅ 減少使用者延遲
  - ❌ 可能不均衡

#### 設計考量

- **Cardinality（基數）**
  - 描述了鍵值的可能值，決定了分片最大數量。鍵值種類需足夠多，否則無法有效分散負載

- **Frequency（頻率分布）**
  - 需避免熱門鍵值集中在單一 shard 上

- **Monotonic change（單調性）**
  - 若鍵值隨時間單調遞增，容易造成尾部熱點 
    - ex: 使用用戶購買次數作為分片鍵，隨時間增長，業務增長後，用戶容易集中在最後一個 shard 
  - 解法：加入隨機前綴或 hash 平衡分布

### Database Replication（資料庫複製）
為了提升可靠性與可用性，資料會同步到一個以上的節點，達成容錯與讀寫分離。

#### 類型

- **Master/Backup（主從複製）**
  - 單一主節點處理寫入，從節點只讀取
  - 常見於讀多寫少的系統（如 CMS）

- **Multi-master（多主複製）**
  - 多個節點皆可寫入，需處理資料衝突問題
  - 適用於分散式、全球部署場景

#### 同步策略

- **Synchronous（同步）**
  - 寫入主節點後，需等待所有備份節點完成才算成功
  - ✅ 資料一致性高  
  - ❌ 效能較差，延遲高

- **Asynchronous（非同步）**
  - 主節點寫入後立即回應，備份節點稍後同步
  - ✅ 延遲低、效能佳  
  - ❌ 若主節點故障，資料可能遺失

#### 實務應用
- **讀寫分離**
  - 寫入集中於主節點，查詢則分散至備份節點以提升吞吐量
- **災難備援**
  - 若主節點故障，可快速轉移至備份節點維持服務不中斷

## 物件關聯對應 (Object-Relational Mapping, ORM)

- **目的**
  - 將資料表映射為程式中的物件，簡化資料存取邏輯
  - 抽象 SQL 操作，使開發更符合物件導向習慣

### 載入策略（Loading Strategy）

- **Eager Loading（積極載入）**
  - 一次查詢即載入所有相關資料
  - 優點：減少查詢次數、避免多次 I/O
  - 缺點：資料量大時效能不佳

- **Lazy Loading（延遲載入）**
  - 初次查詢只載入主資料，關聯資料延後觸發查詢
  - 優點：初始開銷小
  - 缺點：關聯資料多時會造成多次查詢

### N+1 問題
- 問題：查詢主表 N 筆後，對每筆資料各進行一次子查詢
  - 範例：查詢 10 個 Teacher，然後對每個 Teacher 查詢其 Student
- 結果：產生 N+1 次資料庫請求，效能極差
- 解法：
  - 使用 eager loading 預先載入關聯
  - 使用 join 查詢合併主子表資料

### Open Session in View（OSIV）
- 定義：一個 HTTP request 維持一個資料庫 session，直到 view render 結束
- 優點：配合 lazy loading 可於 view 中動態存取資料
- 缺點：
  - 延長 session 時間，增加資源使用
  - 難以追蹤潛在的多次查詢與延遲效能問題
- 建議：
  - 可依專案需求開關 OSIV 機制
  - 若關閉，可使用 DTO 或明確 eager loading 取代