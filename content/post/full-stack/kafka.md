---
title: "Kafka 筆記"
date: 2024-08-17T00:00:17+08:00
draft: true
description: ""
type: "post"
tags: ["queue"]
categories : ["full-stack"]
---

## Kafka 基礎概述

- **定義與功能**
  - 一個分散式的事件串流平台 (event streaming platform)
  - 專注於訊息的發布與訂閱 (publish/subscribe)
  - 適用於高吞吐量、即時數據處理場景，例如日誌收集、數據管道、事件驅動架構
- **核心特性**
  - 訊息在一段時間後自動刪除，不等待消費者處理完畢
    - 預設保留期為 7 天，可自行配置
    - 適用於暫時性數據處理，避免無限增長
  - 高容錯性與可擴展性，支援多節點叢集運作
  - 提供有序訊息處理（在單一 partition 內）

## 核心概念

### Topic

- **定義**
  - 一個特定的數據流 (data stream)
  - 由一系列訊息 (message) 組成，用名稱來識別
  - 沒有限制 topic 數量，可根據業務需求自由創建
- **使用情境**
  - 用來分類不同類型的數據，例如 "訂單事件"、"用戶行為日誌"
- **複製機制 (Replication)**
  - **目的**
    - 確保高可用性，若某個 broker 故障，其他 broker 可提供複本繼續服務
  - **複製因子 (Replication Factor)**
    - 表示複本數量，常見設定為 3
    - 設為 n 可承受 n-1 個 broker 故障
    - 複本分佈於不同 broker，提升容錯能力
  - **運作細節**
    - 每個 partition 只有一個 broker 作為 leader
    - 其他持有複本的 broker 稱為 ISR (in-sync replica)
    - 生產者只能寫入 leader，消費者預設從 leader 讀取
      - 自 2.4 版起，可配置從 ISR 讀取以提升效能

### Partition

- **定義**
  - topic 被分割成多個 partition 以實現並行處理
  - partition 內的訊息是有序的，不同 partition 間無序
- **訊息特性**
  - 每個訊息分配一個遞增的 id，稱為 offset
    - offset 僅在單一 partition 內有效，不同 partition 獨立
  - 訊息不可變 (immutable)，一旦寫入無法修改
- **數量規劃**
  - partition 數量應至少等於消費者數量
    - 若少於消費者數量，部分消費者會閒置

### Message

- **定義**
  - 也被稱為 event，是 Kafka 的基本數據單元
- **組成**
  - **必要欄位**
    - key：用於決定訊息分配到哪個 partition，可為 null
    - value：訊息主體，可為 null
    - compression type：壓縮格式
    - partition：訊息所屬的分區
    - offset：訊息在 partition 內的序號
    - timestamp：訊息創建時間，可由系統自動設置
  - **選填欄位**
    - header：用於存放元數據，例如訊息來源或版本
- **保留機制 (Retention)**
  - 訊息保留一段時間後自動刪除
    - 預設 7 天，可配置為其他值，例如 1 小時或 30 天
    - 適用於控制儲存空間或處理即時數據
- **序列化與反序列化 (Serialization / Deserialization)**
  - **運作**
    - Kafka 將訊息轉為位元組 (bytes) 傳輸
    - 針對 key 和 value 進行序列化
  - **支援**
    - 對於不支援的格式，也可自定義序列化器
      - 例如 JSON、Avro
  - **優勢**
    - 跨語言相容，生產者與消費者可用不同程式語言實現
    - 壓縮數據，減少傳輸與儲存成本


### Message serialization / deserialization
- Kafka 會將 message 轉換成 bytes 才傳輸
- 用在 key 和 value
- 不支援的格式也可以用自訂的 serializer / deserializer
  - ex: JSON
- 優點
  - 可以用不同的語言來寫 producer 和 consumer
  - 減少資料大小

## Producer and Consumer

### Producer

- **定義**
  - 負責將訊息寫入 topic 的元件
  - 可指定訊息發送到哪個 partition
- **訊息發送機制**
  - 訊息帶有 key，決定分配邏輯
    - key 為 null 時，以 round-robin 方式分配到 partition
    - key 不為 null 時，經 hash function 分配到固定 partition
      - 預設使用 murmur2 演算法，由 Kafka partitioner 處理
  - 使用情境：利用 key 確保同類訊息有序，例如同一用戶的事件
- **確認機制 (Acknowledgement, acks)**
  - **acks=0**
    - 不等待 broker 回應
    - 最高效能，但可能丟失訊息
    - 適用於效能優先、非關鍵數據場景，例如即時監控數據
  - **acks=1**
    - 等待 leader 回應
    - 中等效能，可能因 leader 故障丟失訊息
    - 適用於平衡效能與可靠性的場景
  - **acks=all**
    - 等待所有 ISR 回應
    - 最低效能，但保證不丟訊息
    - 適用於高可靠性需求，例如金融交易記錄

### Consumer

- **定義**
  - 從 topic 讀取訊息的元件
  - 採用 pull 模式，主動拉取訊息
- **Push vs Pull**
  - **Push**
    - 無法確認消費者處理能力，可能導致訊息積壓
  - **Pull**
    - 消費者可依自身速度拉取
    - 若速度慢於生產者，可稍後補齊
    - 優勢：解耦生產者與消費者，適應不同處理速度
- **Consumer Group**
  - **定義**
    - 多個消費者組成群組，共享同一個 group id
    - 共同消費 topic 的訊息
  - **運作**
    - partition 以獨占方式分配給群組內消費者
      - 同 partition 不會分配給多個消費者
      - 若消費者數多於 partition，部分消費者閒置
  - **Group Coordinator**
    - 由 broker 負責管理群組
    - 分配 partition 並記錄 offset 至 __consumer_offsets topic
  - 使用情境：實現負載均衡，例如多個服務實例並行處理訂單
- **Offset 管理**
  - **定義**
    - 記錄消費者在 partition 中消費到的位置
      - 由 consumer commit offset
    - 儲存於 topic 的 __consumer_offsets
  - **提交策略 (Commit)**
    - **At Least Once**
      - 處理完訊息後 commit
      - 需確保處理具冪等性 (idempotent)，例如為訊息加唯一識別碼
    - **At Most Once**
      - 接收訊息後立即 commit
      - 可能漏處理訊息，適用於容忍少量丟失場景
    - **Exactly Once**
      - 確保訊息恰好處理一次
      - 需搭配事務支援，適用於嚴格一致性需求
  - 優勢：消費者如果 down，重啟後可從上次 offset 繼續，避免重複或遺漏

## 架構與管理

### Kafka Broker

- **定義**
  - Kafka 叢集中的單一伺服器
  - 多個 broker 組成叢集，提供分散式服務
- **特性**
  - 每個 broker 以整數 id 識別
  - 儲存部分 partition 數據
  - 也被稱為 bootstrap server
    - 連接到任一 broker 即可訪問整個叢集
    - Kafka 客戶端負責處理連線邏輯
- **叢集管理**
  - 叢集內選出一個 broker 作為 controller
    - 負責管理 broker、topic 和 partition
- **數量考量**
  - 儲存空間：依數據量規劃
  - 容錯：至少 3 個 broker 確保高可用性
  - 吞吐量：增加 broker 提升並行處理能力

### Zookeeper / KRaft

- **Zookeeper**
  - **作用**
    - 管理 Kafka broker 的元數據
    - 負責 partition 的 leader 選舉
  - **架構**
    - 分為 leader 和 follower 節點
  - **限制**
    - 增加運維複雜度
- **KRaft (Kafka Raft)**
  - **背景**
    - 自 3.0 引入，替代 Zookeeper
    - 4.0 後將完全移除 Zookeeper 支援
  - **優勢**
    - 簡化架構，無需額外 Zookeeper 叢集
    - 已準備好用於生產環境
  - **建議**
    - 新項目優先使用 KRaft
    - Kafka 客戶端應避免直接依賴 Zookeeper

## Producer
- producer 會將 message 寫入到 topic
- producer 會知道要寫入哪個 partition
- send message
  - 會帶有一個 key，可以是任何資料型態
    - 如果 key 是 null，會以 round-robin 的方式分配到 partition
    - 如果不是，同個 key 會被分配到同個 partition，因為有 hash function 來決定
      - kafka partitioner 會負責做 key hashing
      - 預設 hash function 是 murmur2

### Producer acknoledgement (ack)
- 有三種 ack
  - acks=0
    - producer 不會等待 broker 的回應
    - 這樣會有最高的效能，但是可能會有 message 丟失
  - acks=1
    - producer 會等待 leader 的回應
    - 這樣會有中等的效能，但是可能發生 leader down 的情況
  - acks=all
    - producer 會等待所有的 ISR 的回應
    - 這樣會有最低的效能，但是不會有 message 丟失

## Consumer
- consumer 會從 topic 中讀取 message
  - 是 pull 的方式
- 和 producer 解耦

### Push vs Pull
- push
  - 沒辦法知道 consumer 能不能 handle message
  - 如果 push 出去但 consumer 來不及消化會造成問題
- pull
  - 如果 consumer 速度比 producer 慢，可以之後慢慢補上

### Consumer group
- 一個 application 可以有多個 consumer，共同組成一個 consumer group
- 同個 consumer group 中的 consumer 會共同設置一個 group id
- consumer group 中的所有 consumer 會以 exclusive 的方式從 partition 中讀取 message
  - 不會有同一個 partition 被配給多個 consumer
  - 如果 consumer 比 partition 多，有些 consumer 會閒置
- group coordinator
  - 會負責管理 group 中的 consumer
  - 會負責分配 partition 給 consumer
  - 利用 __consumer_offsets 來記錄 consumer group 中的 consumer 的 offset
### Consumer offset
- kafka 會紀錄 consumer group 中的每個 consumer 消耗到哪裡了
- 會放在 topic 的 __consumer_offsets
- 當 group 中的 consumer 取得 message 後，會週期性的 commit offset，讓 kafka 更新到 ＿consumer_offsets
  - 這樣即使 consumer down 了，下次啟動時，也可以從上次消耗的地方繼續
- 三種 commit 策略
  - at least once
    - 會在處理完 message 後才 commit
    - 要確保處理方式是 idempotent
      - 可以幫 message 加上 primary key
  - at most once
    - 會在取得 message 後就 commit
  - exactly once

## Kafka broker
- kafka cluster 中的每個 server 都是 broker
- 多個連接在一起的 broker 組成一個 cluster
  - 會有一個 broker 是 controller
    - 負責管理 cluster 中的 broker
    - 也管 topic 和 partition
- 用 id 來識別，id 是整數
- broker 會包含某些 partition
- 也被叫做 bootstrap server
  - 一但連到某個 broker，就可以連到整個 cluster
    - kafka client 會處理
- broker 數量考量
  - 儲存空間
  - 容錯
  - throughput
## Zookeeper
- 被用來管理 kafka broker
- 可以拿來幫 partition 做 leader election
- Zookeeper 分成 leader 和 follower
- Kafka 3.0 之後，可以改用 Kafka Raft
  - 4.0 之後，會移除 zookeeper
- 該不該用
  - 現在似乎 KRaft 已經準備好上 production 了
  - 如果是 kafka client，應該盡量不使用 zookeeper

## 實務操作 (CLI)

### 常用命令總覽

- **啟動 Kafka 伺服器**
  - `kafka-server-start.sh <config file>`
    - 啟動 broker，指定配置文件
    - 配置文件包含 broker id、端口等設定
- **通用參數**
  - `--bootstrap-server`
    - 指定 Kafka 伺服器地址，例如 `localhost:9092`
    - 取代過時的 `--zookeeper` 參數
  - `--command-config <config file>`
    - 指定安全相關配置，例如帳號密碼、SSL 設定
### Topic 管理

- **命令**
  - `kafka-topics.sh`
- **參數與功能**
  - `--create`
    - 創建新 topic
    - 搭配 `--partitions` 指定分區數
    - 搭配 `--replication-factor` 指定複製因子
    - 搭配 `--topic` 指定 topic 名稱
    - 示例：`kafka-topics.sh --create --bootstrap-server localhost:9092 --partitions 3 --replication-factor 2 --topic my-topic`
  - `--delete`
    - 刪除指定 topic
  - `--describe`
    - 查看 topic 詳細資訊
    - 輸出欄位：
      - `Replicas`：顯示持有複本的 broker id
      - `ISR`：顯示與 leader 同步的 broker
  - `--list`
    - 列出所有 topic
- **使用情境**
  - 檢查 topic 狀態、分區分配，或快速創建測試用 topic
### 生產者操作

- **命令**
  - `kafka-console-producer.sh`
- **參數與功能**
  - `--topic`
    - 指定目標 topic
  - `--producer.config <config file>`
    - 指定生產者配置文件
  - `--producer-property`
    - 設定生產者屬性，例如 `acks`
      - 示例：`--producer-property acks=all`
  - `--property`
    - 多次使用以設置多個屬性，例如壓縮類型
- **使用情境**
  - 測試訊息發送，例如模擬日誌輸入
  - 示例：`kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic`

### 消費者操作

- **命令**
  - `kafka-console-consumer.sh`
- **參數與功能**
  - `--topic`
    - 指定消費的 topic
  - `--from-beginning`
    - 從 topic 開頭消費，而非僅接收新訊息
    - 注意：如果一個 group 有多個消費者，僅第一個消費者有效，offset 是看 group 級別的
  - `--consumer.config <config file>`
    - 指定消費者配置文件
  - `--property`
    - 設置消費者屬性，例如訊息格式
  - `--group`
    - 指定消費者群組名稱
- **使用情境**
  - 驗證生產者訊息是否正確送達
  - 示例：`kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning --group my-group`

### 消費者群組管理

- **命令**
  - `kafka-consumer-groups.sh`
- **參數與功能**
  - `--list`
    - 列出所有消費者群組
  - `--describe`
    - 查看群組詳細資訊
    - 輸出欄位：
      - `CURRENT-OFFSET`：當前消費到的 offset
      - `LOG-END-OFFSET`：最新訊息的 offset
      - `LAG`：落後的訊息數量
    - 示例：`kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-group`
- **使用情境**
  - 監控消費者群組的消費進度，排查延遲問題