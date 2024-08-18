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
- immutable
  - 一旦 message 被寫入，就不能被修改
- 通常 partition 的數量至少為 consumer 數量
## Message
  - message 也被叫做 event
  - 構成
    - required
      - key, value, compression type, partition, offset, timestamp
        - timestamp 可以由系統設置
    - optional
      - header
  - 有保留的時間限制
    - 預設 7 天，可以設定

## Producer
- producer 會將 message 寫入到 topic
- producer 會知道要寫入哪個 partition
- send message
  - 會帶有一個 key，可以是任何資料型態
    - 如果 key 是 null，會以 round-robin 的方式分配到 partition
    - 如果不是，同個 key 會被分配到同個 partition，因為有 hash function 來決定
      - kafka partitioner 會負責做 key hashing
      - 預設 hash function 是 murmur2

### Kafka message serializer
- Kafka 會將 message 轉換成 bytes
- 用在 key 和 value

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
### Kafka message deserializer
- Kafka 會將 bytes 轉換成 message
- 一樣用在 key 和 value
### Consumer group
- 一個 application 可以有多個 consumer，他們組成一個 consumer group
- consumer group 中的所有 consumer 會以 exclusive 的方式從 partition 中讀取 message
  - 如果 consumer 比 partition 多，有些 consumer 會閒置
### Consumer offset
- kafka 會紀錄 consumer group 中的每個 consumer 消耗到哪裡了
- 會放在 topic 的 __consumer_offsets
- 當 group 中的 consumer 取得 message 後，會週期性的 commit offset，讓 kafka 更新到 ＿consumer_offsets
  - 這樣即使 consumer down 了，下次啟動時，也可以從上次消耗的地方繼續
- 三種 commit 策略
  - at least once
    - 會在處理完 message 後才 commit
    - 要確保處理方式是 idempotent
  - at most once
    - 會在取得 message 後就 commit
  - exactly once

## Kafka broker
- kafka cluster 中的每個 server 都是 broker
- 用 id 來識別，id 是整數
- broker 會包含某些 partition
- 也被叫做 bootstrap server
- 一但連到某個 broker，就可以連到整個 cluster
  - kafka client 會處理
### Zookeeper
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
- `command-config`
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