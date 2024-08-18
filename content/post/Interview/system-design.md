---
title: "System Design"
date: 2024-08-03T00:08:46+08:00
draft: false
type: "post"
tags: ["system-design"]
categories: ["Interview"]
description: "紀錄系統設計時可以考慮的事項"
---

## Estimation
- 要評估的指標
  - latency
  - throughput
  - capacity
- Database 估計
  - 沒特別指定的話，可以預估 single relational database 可以處理 read & write 10K per second
  - single relational database 的容量可以抓 3 TB
  - redis 可以抓 100K，但是受限於 memory，可能抓 30GB
- 可以問的問題類型
  - 總共有多少用戶？
  - 有多少活躍用戶？
  - 每個用戶平均每天使用多久？

## Network
### Load Balancer
- type
  - application load balancer (ALB)
    - OSI layer 7 (Application layer)
    - 可以根據 request header, URL, query string 來做 routing
    - 可以 validate / terminate SSL
  - network load balancer (NLB)
    - OSI layer 4 (Transport layer)
    - 可以根據 protocol (TCP, UDP, IP..), destination port etc 來做 routing
    - 一般來說預設會 pass through SSL
    - 比較適合應付高流量
- strategy
  - round robin
    - 輪流
  - least connection
  - resource-based
    - 考慮每個 instance 的資源使用情況
  - weighted variants of the above
    - 可以把上面說的各種情況多加入 weight 的考量
  - random
- 優點
  - resilience
    - 可以關注到某個 instance down 了，自動把 request 轉到其他 instance
  - scalability
    - 後面的 instance 可以 horizontal scale
- 和 API Gateway 的差異
  - API Gateway 除了 load balancing 會有更多的功能，例如 rate limiting, authentication, authorization, request validation, caching, logging etc

### CDN (Content Delivery Network)
- 把靜態資源放到離使用者地理上比較近的地方，加速存取速度
  - html, css, js, image...
  - 這些資料不該頻繁改變
- 本質上是靜態資源的 cache
- types
  - push
    - 把新的資料推到 CDN
    - 如果靜態資源很多，開銷會很大
  - pull
    - lazy
    - 當有 request 進來時，且 CDN 沒有該資源，才會去 origin server 拉資源
    - 第一個 user 會比較慢

## Maintain consistency
- 確保 unique
  - bloom filter
    - 因為存在 service 的 memory，有最高的 throughput，但是可能會有 false positive
    - 不好讓多個 service 共用

## Queue / Messaging
- 如果系統是 synchronous，可能會有 scalability 的問題
  - 會被最慢的 component 所限制 (ex: payment service)
- role
  - producer
    - 產生 message
  - consumer
    - 處理 message
- 優點
  - buffer
  - 應對 request spike
- 缺點
  - 現在無法知道 message 被處理的情況，sychronous 可以直接得知成功與否
  - 增加 latency
- model
  - message queue
    - 讓 queue 分配 message 給某個 consumer
  - publisher / subscriber (pub/sub)
    - 可能會有某個 event 想被 publish 給多個 consumer (subscribers)

## Protocol & Send/Receive data
- TCP
- UDP
- http
- websocket
  - duplex (two-way) communication
  - 只會建立一次 TCP connection
  - load balancer 可以會遇到問題
- long polling
  - client 送 request 給 server，server 不會立刻 close connection，而是等待有新資料或 timeout 才回應
  - 某些不能用 websocket 的情況下，可以用 long polling 來模擬
  - 但是在一些框架或語言可能不好實作
- gRPC
  - RPC
    - remote procedure call
    - 把一些 service 包裝成像 local function 一樣，就可以像調用本地函式一樣使用 remote 的服務
  - google 開發的 RPC 框架
  - 用 protobuf 作為 IDL (Interface Definition Language)
    - binary protocol
      - 非 readable，需要 encode / decode
      - 但比 json 小
    - .proto file
      - 定義 message 的格式
      - 描述了 interface 長怎樣
    - protoc
      - 用來 compile .proto file，根據指定的程式語言，產生 client / server code
        - server 再實作 interface
  - 用 http/2 來傳輸
  - 不能用在 browser
  - 適合用在內部服務之間的溝通
- GraphQL

## 流程
- User perspective
  - 描述身為 user 期待看到什麼東西
  - 這裡可以先簡單介紹這個 app 的大概邏輯，之後 marketplace 再針對不同 role 探討資料和使用情境
  - 也可以詢問使用的平台
- Marketplace
  - 詢問要支援的用戶數量，以及活躍用戶數量
  - 如果有多種用戶，也要分開討論
    - ex: 叫車服務會有司機和乘客
    - 有更多角色後，可以開始根據角色討論他們的 perspective
  - 取得一些數字
    - 考慮 sotrage 以及 throughput
    - 叫車服務範例
      - 乘客總數量、活躍乘客數、每月乘客需求趟數
      - 司機總數量、活躍司機數、單趟平均時間
    - throuput
      - 活躍用戶
      - refresh rate
      - 每個 user 平均打開 app 的次數
      - 平均打開 app 會用多久
- Rough design
  - 探討資料的傳遞
    - 根據不同 role 去講他們應該傳送什麼資料，用什麼協定，request 的頻率 (request per second)
      - 討論的時候可以用 average，但是會有 peak time，可以考慮 X2, X4, X10
  - 探討資料的儲存
    - 要準備一些前提，比如假設單一資料庫每秒可以 insert 5K 筆資料
    - 可以討論不同的 sharding
      - 考慮怎樣存可以讓大小減少
      - 評估這樣分是否可能導致 sharding uneven
      - 怎樣的切法可以讓 query 盡量不要跨 shard
  - 每個階段也可以探討 throughput
  - 開始根據情境設計不同的 service 來表達他們的交互

## Tips
### 查找
- 能不能用地理資訊來做 hashing
- 能不能用 geo index

### 工具 & 技術
- headless browser
  - 沒有 user interface 的 browser
  - 但是依然有 rendering engine 和 js interpreter。可以用來得到最終的 html
- Cyclic redundancy check (CRC)
    - 一般用在檢查封包是否有錯誤，但是我們也可以用來檢查某個檔案是否有被修改，好做 sync
- CQRS (Command Query Responsibility Segregation)
  - 把 read 和 write 分開
  - 一個 storage 針對 read 做 optimize，另一個 storage 針對 write 做 optimize

### Unique ID
- UUID 是 random 且 human-readable（不會有相近的 char，比如 0 和 O）
  - 但是太長
  - 可以用不同的 encoding 壓縮長度
    - 因為 UUID 用的 charactor 是 0-9, a-f，所以可以用有更多種 charactor 的 encoding 來壓縮
    - BASE62
      - 包含 0-9, a-z, A-Z
    - BASE58
      - BASE62 但不包含容易混淆的 0, O, I, l
    - BASE64
      - BASE62 但多了 +, /

### Other
- 每個 Phase 可以多和 interviewer 討論，確認走在正確的方向上
- 面對面試官給的數字可以嘗試為了好算向上抓一些
- 延遲任務
  - 如果遇到因為某些原因需要晚點才能做某個任務，可以用 queue 來處理
- Cache 除了用專門的 cache database 做，Server 自身也可以用 memory 來 cache
- 對於先搶先贏的系統不一定要追求公平，只要達成目標即可
- 對於搶票機制可以做 pre-populate，事先在 database 生好指定數量的票，這樣就可以只 lock 某個 row，不用 lock 整個 table