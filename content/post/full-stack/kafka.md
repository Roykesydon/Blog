---
title: "Kafka 筆記"
date: 2024-08-17T00:00:17+08:00
draft: true
description: ""
type: "post"
tags: ["queue"]
categories : ["full-stack"]
---

## Kafka
- event streaming platform
- 專注在 publish / subscribe
- message 會在一段時間後被刪除，而不是等待 consumer 處理

## Topic
- 一個特定的 data stream
  - 一系列的 message
- 沒有限制 topic 的數量
- 由 name 來識別

### Topic replication
- 如果有一個 broker down 了，會有另一個 broker 繼續提供複本
- topic replication factor
  - 這個 factor 要大於 1
  - 常見的設定值是 3
  - 這個數值代表有幾個複本
    - 複本會被放在其他的 broker 上
  - 設為 n，可以承受 n-1 個 broker down
- 一個 partition 只會有一個 broker 作為他的 leader
  - 其他的有複本的 broker 被稱為 ISR (in-sync replica)
  - producer 寫入的時候，只能寫到 leader
  - consumer 預設也只會從 leader 讀取
    - 2.4 版本後，可以設定從 ISR 讀取
  

## Partition
- topic 通常會被分成多個 partition
- partiton 中的 message 是有序的
  - message 會獲得 id，他是 incremental 的
  - 這個 id 被稱為 offset
    - 只在特定的 partition 中有意義，不同的 partition 的 offset 是獨立的
  - 但不同 partition 的 message 是沒有順序的，只有在同一個 partition 中才有順序
- immutable
  - 一旦 message 被寫入，就不能被修改
- 通常 partition 的數量至少為 consumer 數量
  - 如果 partition 數量少於 consumer 數量，有些 consumer 會閒置
## Message
  - message 也被叫做 event
  - 構成
    - required
      - key, value, compression type, partition, offset, timestamp
        - key, value 可以是 null
        - timestamp 可以由系統設置
        - message 發給 kafka 後，會加上 partition, offset, timestamp
    - optional
      - header
  - retention
    - message 會在一段時間後被刪除
    - 預設 7 天，可以設定
### Message serialization / deserialization
- Kafka 會將 message 轉換成 bytes 才傳輸
- 用在 key 和 value
- 不支援的格式也可以用自訂的 serializer / deserializer
  - ex: JSON
- 優點
  - 可以用不同的語言來寫 producer 和 consumer
  - 減少資料大小
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

## CLI
- `kafka-server-start.sh <config file>`
  - 啟動 kafka server (broker)
  - 指定 config file
- `--bootstrap-server`
  - 指定 kafka server
  - 不推薦使用 `--zookeeper`
- `--command-config`
  - 指定 config file
  - 裡面會寫包含帳號密碼以及加密方式等安全設定
- `kaft-topics.sh`
  - `--partitions`
    - 指定 partition 數量
  - `--replication-factor`
    - 指定 replication factor
  - `--topic`
    - 指定 topic name
  - `--create`
  - `delete`
  - `--describe`
    - 描述 topic
      - `Replicas`
        - 顯示哪些 broker 有複本 (id)
      - `ISR`
        - 顯示哪些 broker 和 leader 同步
  - `--list`
    - 列出所有 topic
- `kaft-console-producer.sh`
  - `--topic`
    - 指定 topic
  - `--producer.config`
    - 指定 config file
  - `--producer-property`
    - 指定 producer property
    - `acks`
      - 指定 acks 模式
  - `--property`
    - 可以打許多次，每次指定一個 property
- `kaft-console-consumer.sh`
  - `--topic`
    - 指定 topic
  - `--from-beginning`
    - 不只是自打開 consumer 後的 message，而是從一開始的 message 開始
    - 如果同一個 group 有多個 consumer，這個選項只會對第一個 consumer 有用，offset 是看 group 的
  - `--consumer.config`
    - 指定 config file
  - `--property`
  - `--group`
    - 指定 consumer group
- `kafka-consumer-groups.sh`
  - `--list`
    - 列出所有 consumer group
  - `--describe`
    - 描述 consumer group
      - `CURRENT-OFFSET`
        - 目前 offset
      - `LOG-END-OFFSET`
        - 最後一個 offset
      - `LAG`
        - 落後的 offset