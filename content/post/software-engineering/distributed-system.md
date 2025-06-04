---
title: "Distributed system 分散式系統"
date: 2025-05-26T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["database"]
categories : ["software-engineering"]
---


## 相關理論與模型
### CAP 定理
CAP 定理指出，分佈式系統無法同時滿足以下三個特性：

- **Consistency（一致性）**：所有節點在同一時間看到相同的資料。
- **Availability（可用性）**：每個請求都能在有限時間內收到回應（成功或失敗）。
- **Partition Tolerance（分區容忍性）**：系統能夠容忍任意網路分區的發生。

CAP 定理告訴我們，當網路分區發生時，系統只能在「一致性」與「可用性」之間選擇。

實務中的系統多會在以下兩種取捨中選擇其一：

- **CP 系統（如 HBase）**：強調一致性，犧牲可用性。
- **AP 系統（如 Couchbase, Cassandra）**：強調可用性，允許資料短暫不一致。

### BASE Model（Basically Available, Soft state, Eventual consistency）

BASE 模型是相對於傳統 ACID 的一種分散式系統設計哲學，用來處理**最終一致性**的情境：

- **Basically Available**：系統基本可用，允許部分功能降級或延遲響應時間，只要核心功能可以正常運作。
- **Soft State**：允許資料同步存在延遲，資料不需要立即一致。
- **Eventual Consistency**：最終一致性，資料需要在一段時間後達到一致，但短時間內允許不同步。

BASE 模型反映了分散式系統中「一致性不再是立即強制，而是最終達成」的設計理念。

### Quorum-based Replication（NWR 模型）

「Quorum」這個詞意思是「法定人數」，在分散式系統中代表「一個操作需要多少個節點參與，才能被認定為有效」。
Quorum-based Replication 就是利用「多數節點同意」的方式來決定一筆資料是否被正確寫入或讀取，是一種讓分散式資料副本保持一致的策略。
NWR 是一種應用於副本資料的一致性策略：

- **N (Number of Replicas)**
  - 一個分佈式系統中，總共有多少資料副本數
  - 在有些資料庫中就是所謂的 Replication Factor
- **W (Write Quorum)**：處理一次寫入，需成功寫入的副本數
- **R (Read Quorum)**：處理一次讀取，需成功讀取的副本數

只要滿足條件 `W + R > N`，即能保證讀取至少覆蓋到一個成功寫入的副本，達成**強一致性**。
你可以根據注重讀取還是寫入的需求，調整 W 和 R 的值。

#### W + W > N 的意義
若你希望**避免寫入衝突（Write-write conflict）**，則需要滿足條件：

> `W + W > N`

這樣可確保**任何兩次寫入操作的副本重疊部分不為空集**，即兩次寫入至少有一個共同的副本，從而讓新的寫入可以檢測舊的資料並避免覆蓋舊寫入造成不一致。

---

## 一致性模型（Consistency Models）

一致性模型定義了使用者或應用程式在存取分散式系統中資料時，能觀察到的行為與期望。

### 強一致性（Strong Consistency / Linearizability）

- 說明：每次讀取總是會返回最新寫入的值，就像所有操作都在單一時間線中發生。
- 適用場景：交易系統、帳務系統等需要嚴格一致性的場景
- 缺點：需要同步所有副本，延遲高，可用性下降

### 最終一致性（Eventual Consistency）

- 特殊的弱一致性：保證只要不再有新的更新，資料最終會收斂到一致狀態。
- 實作機制：透過定時同步、gossip protocol 等

### 因果一致性（Causal Consistency）

- 說明：若操作 A 導致操作 B，那麼所有觀察到 B 的節點必定也觀察到 A。
- 可用於：社群平台（例如推文與回覆、動態排序）
- 工具：vector clock 通常會用來追蹤因果關係

### Read-Your-Writes Consistency

- 說明：某用戶寫入資料後，自己在後續的讀取中會看到這次寫入。
- 實作情境：用於 session-based consistency，例如使用者更改密碼後立即看到變更成功。

### Monotonic Reads / Writes

- **Monotonic Reads**：保證後續讀取不會比先前的讀取結果舊
- **Monotonic Writes**：保證寫入順序不會被打亂

---
<!-- ## 核心挑戰

- **CAP 定理**
  - 一致性（Consistency）、可用性（Availability）、分區容忍性（Partition Tolerance）無法三者兼得
- **分佈式共識**
  - 如 Paxos、Raft 等演算法，確保節點間的一致決策
- **時鐘與同步**
  - Lamport clock、Vector clock、NTP -->

---

<!-- ## 微服務（Microservices）

微服務是一種架構風格，將單一應用程式劃分為一組小型服務，每個服務運行在自己的程序中，並且通常圍繞業務功能建構。每個微服務可以由獨立的團隊負責，使用不同的程式語言、資料庫和部署方式，透過輕量級的通訊協定（如 HTTP/REST 或 gRPC）協作。
### 缺點與挑戰

- **部署與維運變得複雜**  
  多個服務需要 CI/CD 管線、自動部署、版本控管、相依性管理等基礎建設。
- **分散式系統的挑戰**  
  包含網路延遲、服務間通訊錯誤、分散式交易、資料一致性等。
- **服務發現與治理**  
  需要額外機制處理服務註冊、發現、負載均衡與健康檢查（如 Service Mesh、Consul）。
- **資料一致性與交易處理困難**  
  無法使用傳統 ACID 交易，需改用 Eventual Consistency、Saga Pattern、Outbox Pattern 等替代方案。
- **觀測與除錯困難**  
  需要集中化的日誌、指標與追蹤（Logging/Monitoring/Tracing），如 ELK、Prometheus、OpenTelemetry。
- **開發與測試困難**  
  整合測試需要模擬或啟動多個服務，耗時又易失敗。


### 常見實作挑戰與對應解法（補充）

| 挑戰                     | 解法/技術                                                         |
|--------------------------|-------------------------------------------------------------------|
| 跨服務請求鏈錯誤難追蹤   | 分散式追蹤系統（如 Jaeger, Zipkin）                                 |
| 設定檔管理混亂           | 中央設定服務（如 Spring Cloud Config, Consul）                      |
| 不同語言 SDK 開發困難   | 使用 gRPC 定義 Interface，跨語言產生 client                         |
| 熱點服務壓力過大         | 設計 API Gateway + Rate Limiting + 快取層                            |
| 交易失敗無法回滾         | 使用 Saga Pattern 或補償交易（Compensating Transaction）             |
| 服務啟動順序不一致導致失敗 | 使用服務註冊/健康檢查 + 重試機制                                    | -->

## 順序與時鐘（Ordering and Clock）

### 順序（Ordering）
在單一節點上，事件容易形成全序，但在分散式系統中，因為難以確定事件的全域時間順序，因此只能實現偏序。
#### Causal Ordering（因果順序）
因果順序指的是事件之間存在「導致」或「影響」的關係。如果事件 A 的發生導致了事件 B 的發生，那麼我們說 A 因果地先於 B（A → B）。這種關係通常透過訊息傳遞來建立。
- 概念
  - 如果兩個事件在同一個節點中發生，它們的順序就是它們在節點中發生的順序。
  - 如果訊息 m 從事件 send(m) 發送，並在事件 receive(m) 接收，那麼 send(m) 因果地先於 receive(m)。
  - 傳遞性：如果事件 A 因果地先於 B，且事件 B 因果地先於 C，那麼事件 A 也因果地先於 C。
#### Partial Ordering（偏序）
- 非嚴格偏序定義
  - Reflexivity（自反性）：a ≤ a
  - Antisymmetry（反對稱性）：若 a ≤ b 且 b ≤ a，則 a = b
  - Transitivity（傳遞性）：若 a ≤ b 且 b ≤ c，則 a ≤ c
- 事件之間可能有部分順序，但不是所有事件都可以被排序
#### Total Ordering（全序）
- Parial Ordering 的特例，所有事件都可以被兩兩比較


### 時鐘（Clock）

分散式系統中沒有單一全域時鐘，節點的系統時間可能不一致，這會造成「事件先後順序不明」等問題，因此需要特殊的時間模型來推斷事件因果關係。

#### NTP（Network Time Protocol）

NTP 是一種網路協定，用於在電腦系統之間同步時鐘，使其與世界協調時間（UTC）保持一致。它旨在提供高精度的物理時鐘同步，通常在公共網路上可達到數十毫秒的精度，在局域網內在理想情況下可達到毫秒級甚至亞毫秒級的精度。

NTP 使用客戶端-伺服器模型（也可以是對等模式）來進行時間同步。其基本工作流程如下：

##### 分層結構 (Stratum)：
- NTP 採用分層（stratum）結構來組織時間源。
  - Stratum 0： 這些是高精度的參考時鐘源，例如原子鐘或 GPS 時鐘，它們是時間的「黃金標準」。
  - Stratum 1： 這些伺服器直接連接到 Stratum 0 時鐘。
  - Stratum 2： 這些伺服器從 Stratum 1 伺服器獲取時間，以此類推。數字越大，層級越低，精度可能略有下降。
##### 時間戳交換

- NTP 使用四個時間戳來計算時間偏移和延遲：
  - 客戶端向 NTP 伺服器發送一個 NTP 請求包。這個包會記錄客戶端發送時的時間戳 t1。
  - 伺服器收到請求後，記錄接收時的時間戳 t2。
  - 伺服器處理請求並準備回應，記錄發送回應時的時間戳 t3。
  - 客戶端收到回應後，記錄到達時的時間戳 t4。
-  計算時間差和延遲：
   - 往返延遲 (Round-trip Delay)： delay=(t4−t1)−(t3−t2)。這表示訊息從客戶端到伺服器再返回所花費的總時間（減去伺服器處理時間）。
   - 時間偏移 (Offset)： offset=((t2−t1)+(t3−t4))/2。這表示客戶端時鐘與伺服器時鐘之間的時間差。客戶端會根據這個偏移量來調整自己的時鐘。
##### 時鐘調整
客戶端會逐步調整自己的時鐘以匹配伺服器的時間，而不是突然跳變，以避免對應用程式造成影響。NTP 還會考慮網路延遲的不對稱性以及時鐘漂移等因素，使用複雜的演算法來選擇最準確的時間源並提高同步精度。

#### Lamport Clock（邏輯時鐘）

- 基於事件排序的邏輯時間，而非實際時間
- 每個節點有一個本地計數器，規則如下：
  - 每次事件發生時，將本地時間加一
  - 發送訊息時，將本地時間加一，附上時間戳
  - 接收訊息時，取接收到的時間戳與本地時間兩者最大值再加一

##### Happened-before 關係（happened-before relation）
1. 同一節點內的事件：如果 A 在 B 之前發生，則 A → B。
2. 不同節點間的訊息傳遞：如果 A 發送訊息給 B，則 A → B。
3. 遞移性（transitivity）：如果 A → B 且 B → C，則 A → C。

##### Lamport Clock 的特性
1. Causal Consistency：能夠確定事件的因果關係。
```text
如果 A → B，則 Lamport Clock(A) < Lamport Clock(B)
```
2. 不保證反向推導
```text
如果 Lamport Clock(A) < Lamport Clock(B)，不代表 A → B
兩者有可能是併發事件（concurrent events）
```

#### Vector Clock（向量時鐘）
每個節點維護一個向量，長度為節點數，用來記錄每個節點的邏輯時間。

- 每次事件發生時，將自己位置的時間 +1
- 傳送訊息時，將自己位置的時間 +1，並附上整個向量
- 接收時，取每個位置的最大值再加上自己的操作

```text
可以準確判斷兩事件的關係：
- $e_a \rightarrow e_b$
  - 對於任意節點 $i$，有 $V_a[i] < V_b[i]$
- $e_a \parallel e_b$
  - 對於任意節點 $i$，有 $V_a[i] \leq V_b[i]$ 且 $V_b[i] \leq V_a[i]$，但存在至少一個節點 $j$ 使得 $V_a[j] < V_b[j]$ 或 $V_b[j] < V_a[j]$
```

#### Hybrid Logical Clock（HLC）
混合實體時間與邏輯時間，用於在某些分散式系統（如 Spanner、Cassandra）中達成因果一致性
結合了物理時鐘 (Physical Clock) 和 邏輯時鐘 (Logical Clock) 的特性。
在可以呈現因果關係的情況下，讓邏輯時鐘和物理時鐘的數值保持相近。
而且不用像 Vector Clock 那樣維護一個向量，邏輯時鐘只需要一個整數即可。

因為演算法有點複雜，我之後理解過再補上。

## 分散式共識（Consensus）

在分散式系統中，**多個節點需要就某個值或狀態達成一致決策**，這就是所謂的「共識」。常見場景包括：選舉主節點、同步狀態機、複製日誌等。

#### Paxos

- 由 Leslie Lamport 提出，是最早期形式化定義共識的演算法。
- 將決策過程拆分為多輪提案與投票，並保證在大多數節點同意下達成一致。
- 雖具嚴格的安全性保證，但複雜難實作，實務上常用變形（如 Multi-Paxos）。

#### Raft

- 更易理解與實作的共識演算法，由 Diego Ongaro 提出。
- 三大角色：Leader、Follower、Candidate。
- 使用「心跳」來維持領導者權威，並透過日誌複製與 commit index 保證一致性。

Raft 的核心流程：

1. **Leader 選舉**：若 Follower 長時間沒收到心跳，轉為 Candidate 發起投票。
2. **日誌複製（Log Replication）**：Leader 接收寫入指令，廣播給 Follower。
3. **提交（Commit）**：當大多數節點確認日誌，Leader 才將其 commit，並通知其他節點。

Raft 兼顧安全性與可理解性，目前許多現代系統（如 etcd、Consul）都採用 Raft 作為核心共識機制。

#### Byzantine Fault Tolerance（拜占庭容錯）

- 處理節點「惡意作亂」的場景（如節點回傳錯誤訊息）。
- 常見演算法：PBFT（Practical Byzantine Fault Tolerance）。
- 使用於區塊鏈、軍事系統等安全需求高的情境。

---

<!-- ### 本地事務 + 可靠訊息最終一致（TCC 或 MQ 事務）

#### TCC（Try-Confirm-Cancel）

每個服務提供三個介面：
- **Try**：資源預留
- **Confirm**：執行操作
- **Cancel**：回滾預留資源

**優點：**
- 適用於強一致性要求場景
- 可精確控制補償操作

**缺點：**
- 業務邏輯需額外實作三段
- 開發負擔大 -->

---

<!-- #### 使用訊息佇列（Message Queue）確保最終一致性

**模式：**
1. 本地事務成功後發送訊息到 MQ
2. 消費者收到後執行自己的邏輯（例如更新另一筆資料）
3. 若失敗可重試或用補償邏輯處理

;;;text
常見關鍵詞：Outbox Pattern、事務訊息（Transactional Message）、最終一致性
;;;

**優點：**
- 效能好，可橫向擴展
- 容錯性佳，非同步處理

**缺點：**
- 實作補償邏輯較麻煩
- 不是真正的 ACID，僅保證最終一致 -->

## 常見 Pattern

### Two-Phase Commit（2PC，兩階段提交）
兩階段提交是一種協調器（Coordinator）與多個參與者（Participants）之間用來保證資料一致性的協議，常用於分散式資料庫中。

流程如下：

1. **準備階段（Prepare Phase）**
   - 協調者向所有參與者發送 `prepare` 請求。
   - 參與者回傳 `vote commit` 或 `vote abort`。
   - 若有任一參與者回傳 `vote abort`，則整個交易中止。

2. **提交/中止階段（Commit/Abort Phase）**
   - 若所有參與者回傳 `vote commit`，協調者發出 `commit` 命令。
   - 否則發出 `abort` 命令。
   - 所有參與者根據指令執行並回應結果。

**優點：**
- 一定程度保證一致性

**缺點：**
- 協調者單點失效會導致卡住（Blocking）
- 參與節點崩潰後重啟，可能不知狀態（Uncertainty）
- 無法處理網路分割（Partition）下的分歧決策。

---

### Three-Phase Commit（3PC，三階段提交）

為了解決 2PC 的 Blocking 問題，3PC 在兩階段中間多插入一個「預提交階段（Pre-commit）」。

流程如下：

1. **Can Commit 階段**：協調者詢問所有參與者是否可以提交（類似 2PC 的準備階段）。
2. **Pre-Commit 階段**：
   - 若所有參與者答應可以提交，協調者會發送預提交命令，並要求參與者進入等待提交狀態。
   - 參與者收到後回應 ACK 並寫入預提交日誌。
3. **Do Commit 階段**：
   - 協調者收到所有 ACK 後，才會發送正式 `commit` 指令。
   - 若在任何階段失敗，則協調者發送 `abort`。

優點：
- **非阻塞性**：參與者在等待過久時可根據超時做出預設決策。
- 更具容錯能力。

缺點：
- 複雜度更高，實務上使用較少，現代系統多以 Paxos / Raft 等替代。

---

### Outbox Pattern（事務外送箱模式）

Outbox 是一種確保資料一致性的模式，特別適用在資料庫與 Message queue（如 Kafka、RabbitMQ）之間，避免「資料寫入成功但訊息發送失敗」的問題。

---

#### 核心概念

**重點是「資料與事件寫在同一個資料庫交易中」，確保原子性。**

**流程：**
1. 在本地資料庫中寫入業務資料與一筆「事件資料」到 `outbox` table（在同一個 transaction 中）。
2. 有一個 background job 或 CDC（Change Data Capture）工具負責讀取 `outbox` table，把事件發送到訊息佇列。
3. 發送成功後將 `outbox` 中的該筆事件標記為已發送或刪除。

---

#### 好處

- 與本地事務綁在一起，**天然具有原子性**
- 無需使用分散式交易協定（如 2PC）
- 非同步、高擴展性

---

#### 缺點

- 需要額外的監控或 background job
- 如果有 background job 做 polling，需要處理性能與延遲問題
- 資料庫內部需要維護額外的事件資料表

---

#### 實作方式


你會：
- 在每次寫入業務資料時，同時寫入一筆相關的事件
- 之後透過：
  - 手寫 background service 去讀取並發送
  - 或使用 Debezium 等 CDC 工具搭配 Kafka Connect 自動發送

---

### Saga Pattern（補償式長事務模式）

Saga Pattern 是一種用來處理 **分散式長事務（Long-lived Distributed Transactions）** 的模式，它將一個跨多個服務的大事務，拆分為一系列的 **本地事務（Local Transactions）**，每個本地事務若成功後，才會進行下一個；若其中某個失敗，則需依序執行先前操作的 **補償操作（Compensation Actions）** 以回滾整體效果。

將一個大型事務拆分為多個本地事務，若中途某步驟失敗，需依序執行補償邏輯。

**方式：**
- **順序執行**：一步步提交，每步皆成功才繼續
- **補償動作**：若失敗，從當前往前執行每步的「反操作」

#### 核心概念

- 每個子事務都是獨立、可提交的本地事務。
- 每個子事務需設計一個補償操作來回滾。
- 達成「**最終一致性（Eventual Consistency）**」，而非強一致性。
- 避免使用 2PC 等阻塞式協議，提升可用性。

#### 兩大難點
##### **Compensation 設計**
每個子事務失敗時，如何正確回滾前面已成功的操作。
##### **事務缺乏 Isolation**
子事務之間可能會有競爭條件，需小心處理。

---

#### 兩種實作方式

**1. Choreography（協作式）**  
每個服務自行訂閱事件，決定自己何時執行下一步。

```text
流程範例：
1. Order Service 建立訂單後發出 `OrderCreated` 事件
2. Inventory Service 收到事件後扣庫存，發出 `InventoryReserved`
3. Payment Service 看到扣庫存成功，執行扣款
4. 若扣款失敗，再觸發 `InventoryCompensate` → 還原庫存
```

**優點：**
- 無集中式協調器
- 易於橫向擴展（scalable）

**缺點：**
- 工作流難以追蹤與可視化（traceability 差）
- 複雜的業務流程會讓事件流混亂（event spaghetti）

---

**2. Orchestration（編排式）**  
一個中央控制者（Saga Orchestrator）負責驅動整個工作流，發送命令並根據回傳結果決定後續行為。

```text
流程範例：
1. Orchestrator 呼叫 Order Service 建立訂單
2. 成功後呼叫 Inventory Service 扣庫存
3. 接著呼叫 Payment Service 扣款
4. 如果付款失敗，Orchestrator 呼叫 Inventory 補償（退還庫存），Order 補償（取消訂單）
```

**優點：**
- 控制集中，流程清晰
- 易於監控與除錯

**缺點：**
- Orchestrator 是邏輯核心，充滿大量複雜的業務邏輯

### CQRS（Command Query Responsibility Segregation，命令查詢責任分離）

CQRS 是一種架構模式，它將「修改操作（Commands）」與「查詢操作（Queries）」在應用程式層面明確分離。這種模式有助於提升系統的擴展性、維護性與彈性，特別適合用於 **複雜業務邏輯** 或 **讀寫負載不均** 的場景。
CQRS 可以套用到不同層面，比如應用程式層、資料庫層等等。

---

#### 核心概念

- **Command（命令）**
  - 修改系統狀態的操作，不會回傳資料，只回應成功與否。
    - 例如：`CreateOrder`, `CancelBooking`, `UpdateProfile`
  - 通常會包含業務邏輯與資料驗證，並可能觸發事件（Event）來通知其他系統或服務。

- **Query（查詢）**
  - 只負責讀取資料，不會更動系統狀態。
    - 例如：`GetOrderDetails`, `ListBookings`, `SearchProducts`

- 資料模型會依讀寫操作區分成兩套：
  - **Command Model**：針對業務邏輯與資料驗證進行優化
  - **Query Model**：針對查詢效率與展示進行優化，常會是反正規化（Denormalized）或快取

#### 架構圖解（邏輯概念）

```text
    +---------+       Command       +------------------+
    |  Client |  ---------------->  | Write Model/API  |
    +---------+                     +------------------+
                                        |
                                        | Domain Logic + Validation
                                        v
                                 +--------------------+
                                 |  Command Database  |
                                 +--------------------+

    +---------+       Query         +------------------+
    |  Client |  ---------------->  | Read Model/API   |
    +---------+                     +------------------+
                                        |
                                        v
                                 +--------------------+
                                 |   Read Database    |
                                 +--------------------+
```
#### CQS（Command Query Separation，命令查詢分離）

CQS 是 CQRS 的基礎思想，由 Bertrand Meyer 提出，原本是面向物件程式設計的設計原則。它主張：

> **每個方法要麼是命令（Command），負責改變物件狀態，不回傳資料；要麼是查詢（Query），回傳資料但不改變狀態。**

和 CQS 相比，CQS 的概念停留在單一物件或類別層面，而 CQRS 則將這個原則擴展到整個系統架構層面，將命令與查詢操作分離到不同的模型和服務中。

---

#### 定義

- **Command**：改變系統或物件內部狀態。應不回傳任何資料（可例外回傳成功與否等 metadata）。
  - 例如：`setName()`, `withdraw(amount)`

- **Query**：讀取系統或物件的狀態，不應有任何副作用。
  - 例如：`getName()`, `getBalance()`


#### 搭配 Event Sourcing 使用

##### Event Sourcing
Event Sourcing 是一種資料儲存模式，將系統狀態變更記錄為一系列不可變的事件（Event），而不是直接儲存當前狀態。這些事件可以用來重建系統的任何歷史狀態。

CQRS 可以與 **事件溯源（Event Sourcing）** 一起使用，可以強化以下能力：

- Command 儲存為不可變的事件（Event）
- Read Model 可由事件重建或即時更新
- 完整的歷史紀錄與回溯能力

<!-- ## 常見設計模式

- **API Gateway**
- **Service Registry & Discovery**
- **Circuit Breaker（斷路器）**
- **Retry / Backoff / Timeout 機制**
- **Event Sourcing**
- **CQRS（Command Query Responsibility Segregation）** -->


<!-- ## 關鍵技術與工具

- **容器化與部署**
  - Docker, Kubernetes
- **服務間通訊**
  - REST, gRPC, Kafka, RabbitMQ
- **監控與追蹤**
  - Prometheus, Grafana, OpenTelemetry, Jaeger
- **設定與組態管理**
  - Consul, etcd, Spring Cloud Config -->

---

<!-- ## 常見架構範例

- **單體 vs 微服務 vs 伺服器無伺服器（Serverless）**
- **Event-driven Architecture（EDA）**
- **Command-Driven Architecture（CDA）**
- **Lambda Architecture（針對資料處理）** -->



---

<!-- ## 理論基礎與經典論文

- **The Part-Time Parliament（Paxos）**
- **Raft: In Search of an Understandable Consensus Algorithm**
- **Impossibility of Distributed Consensus with One Faulty Process（FLP 不可能定理）**
- **The Google File System (GFS)**
- **MapReduce** -->

---
