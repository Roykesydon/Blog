---
title: "Database 一般筆記"
date: 2024-07-21T00:00:17+08:00
draft: false
description: "沒有另外被獨立出去一篇且有關 Database 的內容"
type: "post"
tags: ["database", "cache", "sql"]
categories : ["full-stack"]
---

## 資料庫核心概念

### 儲存結構
- **Table**
  - 資料庫中最基本的儲存單位，用來組織資料
- **Row_id**
  - 多數資料庫會維護一個唯一的 row_id，也稱為 tuple id，用來識別每一行資料
  - 例如 PostgreSQL 使用 OID 或 ctid，MySQL 則依賴主鍵
- **Page**
  - 多個 row 會被儲存在一個 page 中
  - 讀取時不會單獨讀取某個 row，而是以 page 為單位讀取一或多個 page
- **IO**
  - IO 操作指的是存取磁碟的操作
  - 一次 IO 可能讀取多個 page，也可能直接從 cache 中取得資料
  - 資料庫常利用 cache（如 buffer pool）來減少 IO
    - 若查詢速度很快，可能是因為資料已存在 cache 中
- **Heap**
  - 用來儲存整個 table 的資料，是一種無特定順序的結構
  - 若使用 clustered index 組織資料，則不會有獨立的 heap
    - 例如 MySQL InnoDB 的主鍵就是 clustered index，資料直接依主鍵排序儲存

### 資料儲存方式
- **Row-oriented (行導向)**
  - 每個 row 依序儲存，包含所有 column 的資料
  - 一次 IO 會讀取多個 row，每個 row 包含所有欄位
  - 適合 OLTP（線上交易處理），因為常需要存取整行資料
- **Column-oriented (列導向)**
  - 每個 column 依序儲存，同一 column 的資料連續存放
  - 壓縮效率高，且適合 aggregation 操作，因此常用於 OLAP（線上分析處理）

### 碎片化 (Fragmentation)
- **Internal Fragmentation (內部碎片)**
  - 一個 page 中有許多未使用的空間
  - 可能因為 row 刪除或大小不均導致，例如插入時預留空間過多
- **External Fragmentation (外部碎片)**
  - 多個 page 的儲存位置不連續
  - 即使剩餘空間足夠，因不連續而無法使用，需透過整理（如 vacuum）來解決


## 資料結構與索引

### 常用資料結構
- **B-Tree**
  - 一種平衡樹結構，適用於快速搜尋
  - 每個 node 同時儲存 key 和 value
  - 限制
    - 由於 node 儲存完整資料，空間利用率較低
    - range query 效率較差，因為需要多次隨機存取
- **B+Tree**
  - B-Tree 的改良版本，常用於資料庫索引
  - 特性
    - internal node 只儲存 key，leaf node 儲存 key 和 value
    - 因 internal node 只存 key，元素大小較小，一個 node 可容納更多 key，使存取的結點數變少，提升搜尋效率
    - leaf node 用 linked list 串聯，適合 range query
  - 通常一個 node 對應一個 DBMS 的 page
- **LSM-Tree (Log-Structured Merge-Tree)**
  - 設計為追加式寫入，資料加在尾端，不覆蓋原有資料
  - 優勢
    - 對 SSD 友好，因避免隨機寫入
    - 適合高寫入量的場景
  - 與 B-Tree 比較
    - B-Tree 為保持平衡會頻繁調整結構，導致隨機 IO

### 索引基礎
- **索引的作用**
  - 若欄位未建立索引，查詢需掃描整個 table
  - 索引透過 pointer 指向 heap 或資料位置，加速查詢
  - 索引本身也儲存在 page 中
- **搜索方法**
  - **Table Scan**
    - 掃描整個 table，適用於範圍過大或無索引的情況
    - 通常以 parallel 方式執行，提升效率
  - **Index Scan**
    - 利用索引定位資料，再從 heap 取值
  - **Index-only Scan (Covering Index)**
    - 若所需欄位已包含在索引中，無需存取 heap
    - 優勢
      - 速度快，因避免額外 IO
    - 注意
      - 索引過大可能佔用更多記憶體，甚至觸發磁碟 IO，降低效率
- **Composite Index**
  - 將多個 column 作為 key 建立索引
  - 特性
    - 在 PostgreSQL 中，若索引為 (a, b)，查詢 a 可使用索引，但單獨查 b 無法有效利用
    - 順序影響查詢效率，設計時需考慮常用條件
- **Non-key Column**
  - 可透過 include 將常用但非 key 的欄位加入索引
  - 促成 index-only scan，提升查詢速度

### 索引類型
- **Clustered Index (叢集索引)**
  - 資料依索引順序物理儲存，也稱 Index-Organized Table
  - 特性
    - 一個 table 只能有一個 clustered index，因資料只能按一種順序排列
    - 未指定時，primary key 通常作為 clustered index（如 MySQL InnoDB）
  - 優勢
    - 範圍查詢效率高，因資料已排序
- **Primary Key vs Secondary Key**
  - **Primary Key**
    - 通常用於 clustered index，資料圍繞其排序
    - 若查詢小範圍資料，因有序可減少 IO
    - 設計差異
      - PostgreSQL 不強制 clustered，primary key 只是唯一約束
      - MySQL InnoDB 則將 primary key 作為 clustered index
  - **Secondary Key**
    - 不在乎原本 table 的 order，而是根據自訂的 key 來排序
    - 會有另外一個結構去放 index，可以找到 row_id
    - 用途
      - 提供額外的查詢路徑
  - **設計差異**
    - **PostgreSQL**
      - 所有索引（包括 primary 和 secondary）直接指向 row
      - 優勢：secondary index 可直接取資料，不用再跳一層 primary key
      - 劣勢：更新 row 時，若 row_id 改變，所有索引需同步更新
    - **MySQL**
      - secondary index 指向 primary key，再由 primary key 指向 row
      - 優勢：row 更新時只需調整 primary key 的指向
      - 劣勢：查詢需多跳一次，增加 IO

## 資料模型與類型

### 資料類型
- **設計原則**
  - 設計 column 時，應先確認資料庫提供的資料類型，選擇最適合的類型以提升效能與儲存效率
- **以 PostgreSQL 為例**
  - **Numeric**
    - 整數 (integer)：如 smallint、integer、bigint
    - 浮點數 (float)：如 real、double precision
    - Serial：自動遞增（auto increment）的整數，常用於主鍵（如 serial、bigserial）
  - **Character**
    - char(n)：固定長度字串，空間不足時補空白
    - varchar(n)：可變長度字串，指定最大長度
    - text：無長度限制的字串，等同於未指定長度的 varchar
    - bpchar：好像就是 varchar，但是 document 有寫 blank trimmed
  - **Date / Time**
    - 如 date、time、timestamp，提供日期與時間儲存
  - **Boolean**
    - true/false 或 null
  - **Binary**
    - bytea：儲存二進位資料
  - **Geometric**
    - 提供點 (point)、線 (line)、多邊形 (polygon) 等類型
    - 應用：若需儲存二維平面座標，可用 point 替代兩個 float
  - **UUID**
    - 通用唯一識別碼，適合分散式系統生成唯一 ID
  - **Enum**
    - 自訂有限字串集合，按建立順序有序
    - 應用：狀態欄位（如 "pending"、"completed"）

### 分割 (Partitioning)
- **定義**
  - 將大 table 分成多個小 table，以提升效能或管理便利性
- **類型**
  - **Vertical Partitioning (垂直分割)**
    - 按 column 分割
    - 應用
      - 將不常用或大型欄位（如 blob）獨立出來
      - 可將這些欄位放在較慢的磁碟，保留常用欄位在 SSD
      - 減少不必要欄位進入 cache
  - **Horizontal Partitioning (水平分割)**
    - 按 row 分割
    - 應用
      - 根據範圍（如時間、地域）分割資料
- **優點**
  - 單一 partition 的單次查詢更快
  - 對 sequential scan 有幫助，因範圍縮小
  - 可將舊資料移至較便宜的儲存設備
- **缺點**
  - 跨 partition 移動資料效率低
  - 若查詢需掃描所有 partition，可能比未分割的 table 更慢
  - partition 大小可能不均（unbalance），需設計均衡策略

### 資料庫游標 (Database Cursor)
- **用途**
  - 處理大型結果集時，避免一次傳送所有資料給 client（因網路與記憶體限制）
- **類型**
  - **Server-side Cursor**
    - 伺服器分批傳送資料給 client
    - 優勢：減少 client 記憶體需求
    - 劣勢：多次網路往返可能增加總時間
  - **Client-side Cursor**
    - 一次傳送所有資料，由 client 分批處理
    - 優勢：減少伺服器負擔
    - 劣勢：需較大網路頻寬與 client 記憶體

## 分散式系統

### 分片 (Sharding)
- **定義**
  - 將 table 分成多個 shard，分散至不同資料庫伺服器
- **與 Horizontal Partitioning 的差異**
  - Horizontal Partitioning：分割後仍位於同一資料庫，由 DBMS 管理
  - Sharding：分割後分至不同伺服器，client 需自行處理資料位置
- **挑戰**
  - 交易 (transaction) 與 join 操作變得複雜，因資料分散
  - 需額外設計一致性與資料存取邏輯

#### 分片鍵 (Sharding Key)
- **類型**
  - **Hash**
    - 使用 hash function 決定資料分配
    - 優勢：分佈均勻
    - 劣勢：範圍查詢困難
  - **Range**
    - 根據某 column 的範圍（如時間、ID）分配
    - 優勢：支援範圍查詢
    - 劣勢：可能導致熱點（hotspot）
  - **Dictionary**
    - 根據離散值（如地區、類別）分配
    - 優勢：直觀且易管理
    - 劣勢：擴展性受限
- **設計考量**
  - **Cardinality**
    - 鍵值的種類數量，種類過少限制水平擴展
  - **Frequency**
    - 鍵值的分佈頻率，需避免單一 shard 負載過高
  - **Monotonicity**
    - 若鍵值單調遞增或遞減，可能導致新資料集中於某 shard
    - 解決方式：結合 hash 或隨機前綴

### 資料庫複製 (Database Replication)
- **目的**
  - 透過 redundancy 來提高 reliability, tolerance, accessibility
- **類型**
  - **Master / Backup Replication (主從複製)**
    - 單一 master 負責寫入，多個 backup（slave）負責讀取
    - 模式：一寫多讀
    - 應用：讀多寫少的場景（如內容管理系統）
  - **Multi-master Replication (多主複製)**
    - 多個 master 可同時寫入
    - 挑戰：需處理寫入衝突（如使用版本控制或衝突解決策略）
    - 應用：高可用性與分散式寫入需求
- **同步方式**
  - **Synchronous (同步)**
    - transaction 完成前需等待所有 backup 寫入確認
    - 變體：可設定等待前 N 個或任一完成
    - 優勢：資料一致性高
    - 劣勢：延遲增加
  - **Asynchronous (非同步)**
    - transaction 寫入 master 後即完成，後台同步至 backup
    - 優勢：寫入速度快
    - 劣勢：可能出現資料不一致（若 master 故障）
- **應用**
  - 常見於負載平衡與災難恢復設計


## 並發與交易管理

### 並發控制策略
- **Pessimistic (悲觀)**
  - 使用鎖定機制確保交易隔離
  - 適用於衝突頻繁的場景
- **Optimistic (樂觀)**
  - 不使用鎖，假設衝突少見，若發生衝突則交易失敗並重試
  - 適用於讀多寫少的場景

### 鎖定機制 (Lock)
- **類型**
  - **Shared Lock (共享鎖)**
    - 多個交易可同時持有，適用於讀取
    - 其他交易可再設置 shared lock
  - **Exclusive Lock (排他鎖)**
    - 僅一個交易可持有，適用於寫入
    - 禁止其他交易讀取或寫入
    - PostgreSQL 提供 `SELECT ... FOR UPDATE` 來取得 exclusive lock
- **相容性**
  - 若資料已持有一種鎖，其他交易無法設置另一種鎖
  - 例如：shared lock 下無法設置 exclusive lock，反之亦然

### 死結 (Deadlock)
- **定義**
  - 多個交易互相等待對方釋放鎖，導致無法繼續執行
- **處理**
  - 多數 DBMS 會檢測死結，並強制回滾最後造成死結的交易

### 兩階段鎖定 (Two-Phase Locking, 2PL)
- **目的**
  - DBMS 為了實現 isolation 需要保證 conflict serializability (CSR)，2PL 可以保證這一點
- **階段**
  - **Growing Phase (增長階段)**
    - 交易只能申請鎖
  - **Shrinking Phase (收縮階段)**
    - 交易只能釋放鎖
  - 限制：釋放任一鎖後，交易無法再申請新鎖
- **特性**
  - 一個交易釋放鎖後，無法再取得鎖
  - 保證一致性，但可能導致死結
  - 應用於多數關聯式資料庫的交易管理

## 實作與優化

### 資料庫引擎 (Database Engine)
- **定義**
  - 也叫 storage engine 或 embedded database，負責處理 CRUD 操作的核心庫
- **功能**
  - DBMS 基於引擎提供更高階功能（如查詢優化、交易管理）
- **範例**
  - MySQL 的 InnoDB（支援交易與外鍵）、MyISAM（高效讀寫但無交易）
  - SQLite 本身即為嵌入式引擎

### 物件關聯映射 (ORM)
- **載入策略**
  - **Eager Loading (積極載入)**
    - 一次載入所有相關資料
    - 範例：查詢 Teacher 時一併載入所有 Student
    - 優勢：減少後續查詢次數
    - 劣勢：可能載入過多不必要資料
  - **Lazy Loading (延遲載入)**
    - 僅在需要時載入相關資料
    - 優勢：節省初始載入時間與記憶體
    - 劣勢：可能導致多次 IO
- **Open Session in View (OSIV)**
  - 每個 http request 開啟一個資料庫 session
  - 用途：配合 lazy loading，確保 request 期間資料可隨時載入
  - 注意：可能延長 session 存活時間，增加資源占用
- **N+1 Problem**
  - 查詢主表後，對每個主表記錄再查詢子表，導致 N+1 次 IO
  - 範例：查詢 10 個 Teacher，再各查其 Student，共 11 次查詢
  - 解決方式：使用 join 或 eager loading 合併查詢

### 效能優化與實務建議
- **避免使用 Offset**
  - Offset + Limit 是簡單的 pagination 實現，但 offset 需讀取並丟棄前 n 筆資料
  - 替代方案：使用條件（如 `WHERE id > last_id`）追蹤分頁位置
- **連線池 (Connection Pool)**
  - 維護固定數量的資料庫連線，避免頻繁建立與關閉連線的開銷
- **等幂鍵 (Idempotency Key)**
  - 確保同一 request 只執行一次
  - 實現
    - 生成唯一鍵（如 ULID），隨 request 傳送並記錄
    - 重複鍵時拒絕執行
  - ULID 優勢
    - 包含時間戳記，可排序且集中於相近 page
    - 相較 UUID 的隨機性，減少 IO 與 buffer 壓力
- **一致性雜湊 (Consistent Hashing)**
  - 將 hash 結果映射至環狀結構，分配資料至伺服器
  - 優勢
    - 新增或移除伺服器時，僅影響部分資料重分配
    - 可針對負載高的伺服器動態調整
- **寫入放大 (Write Amplification)**
  - 實際寫入磁碟的資料量超出預期
  - 分很多不同 level，通常是在說 SSD 造成的
  - 原因
    - SSD 更新時，需將整個 block 搬移至新位置並標記舊 block 為 free
      - 想更新的時候，更新的 page 會被標記為不能使用。為了那些不能再被使用的空間搬整個 block
- **多型關聯 (Polymorphic Association)**
  - 單一欄位根據情況指向不同 table 的 id
  - 優勢：節省空間與表數
  - 劣勢：無法直接使用 foreign key，需額外邏輯處理
  - 替代方案：拆為多欄位或多表，增加明確性
