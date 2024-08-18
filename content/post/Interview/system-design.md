---
title: "System Design"
date: 2024-08-03T00:08:46+08:00
draft: false
type: "post"
tags: ["system-design"]
categories: ["Interview"]
description: "紀錄系統設計時可以考慮的事項"
---

## Architecture
### monolithic vs microservices
- monolithic: 
  - 優點: 
    - 簡單
    - single codebase
  - 缺點
    - 難以實施 modularity
    - 不好做 scale
      - auto-scaling 要整個 app scale，但有時候可能只是特定功能的需求比較大
    - all or nothing deployment
    - long release cycle
      - 要 build, test 整個 app
- microservices:
  - 優點:
    - polyglot
      - 可以用不同語言來實作不同的服務
    - independent

## Diagram tips
- User
  - 可以畫小人，和 service 有所區隔
  - 和 service 間可以用 dotted line 來畫出 protocol，區隔開來
- service
  - 可以作為 box 來呈現
  - 不見得要畫 load balancer，可以把 service 疊幾個 box 來表達
- database
  - 可以畫成 barrel
- asynchronous message
  - 可以畫倒著的 barrel 代表 queue，也可以考慮用虛線箭頭表示
- 箭頭
  - 盡量朝單向移動，往下或往右，不要同時往左又往右
    - ex: a service 調用 b, c service，不要把 b, c service 畫在左右兩邊
  - 盡量不要有 intersection
- Alignment
  - 盡量垂直和水平對齊

## Estimation
- 要評估的指標
  - latency
  - throughput
  - capacity
- Database 估計
  - 沒特別指定的話，可以預估 single relational database 可以處理 read & write 10K per second
  - single relational database 的容量可以抓 3 TB
  - redis 可以抓 100K，但是受限於 memory，可能抓 30GB

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

## CDN (Content Delivery Network)
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
    - 比較適合在有大量靜態資源的情況下使用
    - 第一個 user 會比較慢

## Caching
- 優點
  - 提高 read performance (減少 latency)
  - reduce load(減少 throughput)
- strategies
  - cache aside
    - 先問 cache，沒有的話再問 db，並把 db 回傳的資料放到 cache
    - 缺點
      - cache miss 的開銷大
      - data staleness
        - 可能 cache 裡的資料無法反應 db 裡的最新資料
  - read through
    - client 只能存取到 cache，如果沒資料，cache 會去 db 拿資料
    - 可能出現在 ORM，資料存在 memory
    - 缺點
      - cache miss 的開銷大
      - data staleness
  - write through
    - client 寫資料時，cache 會留一份資料，並把資料寫到 db
    - 解決 data staleness 問題
    - 缺點
      - write 成本很高
  - write behind
    - 和 write through 很像，但是不會立即寫到 db
    - 會等到有更多的資料時，才一次寫到 db
    - 優點
      - 沒有 write penalty
    - 缺點
      - 如果不夠常 flush，可能會有 inconsistency 的問題
- eviction policy
  - LRU (Least Recently Used)
    - 把最久沒用到的資料刪掉
    - 可能會把 popular 的資料刪掉
  - LFU (Least Frequently Used)
    - 每個資料有一個 counter，每次被存取時，counter + 1

## Maintain consistency
- 確保 unique
  - bloom filter
    - 因為存在 service 的 memory，有最高的 throughput，但是可能會有 false positive
    - 不好讓多個 service 共用
  - redis
    - 中規中矩的存取速度，但存取的量也受限制
    - 可以透過 sharded 減輕負擔
  - relational database
    - 速度比較慢，但是可以存很多

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
  - message durability
    - 就算 consumer down 了，message 還是會在 queue 裡
- 缺點
  - 現在無法知道 message 被處理的情況，sychronous 可以直接得知成功與否
  - 增加 latency
- model
  - message queue
    - 讓 queue 分配 message 給某個 consumer
  - publisher / subscriber (pub/sub)
    - 可能會有某個 event 想被 publish 給多個 consumer (subscribers)

- RabbitMQ
  - AMPQ (Advanced Message Queuing Protocol)
  - 預設 Message 會被儲存，直到有 consumer 提取
  - 被用來分配 heavy task
  - key concept
    - routing key
      - 所有的 message 都會有一個 routing key
      - 表示 message 要被送到哪個 queue
    - exchange
      - 用來接收 message，並且把 message 轉發到 queue
      - mode
        - direct
          - 根據 routing key 精確匹配來決定 message 要被送到哪個 queue
        - fan-out
          - 所有的 consumer 都會收到 message
          - 這個模式會執行 pub/sub
        - topic
          - 根據 routing key 的 pattern 來決定 message 要被送到哪個 queue
          - ex: 某個服務基於不同國家有不同的 queue
        - header
          - 和 topic 類似，但是是根據 header 來決定 message 要被送到哪個 queue
    - channel
      - consumer 會用 tcp 和 queue 建立連線
        - 可以用 threads 建立更多連線來更快消耗 message
      - RabbitMQ 可以在一個 tcp connection 上建立多個 channel，讓不同 thread 可以用同一個 connection 來消耗 message
        - 這樣可以減少建立 tcp connection 的 overhead
    - acknowledgement
      - consumer 可以告訴 RabbitMQ 已經處理完 message，再讓 RabbitMQ 刪除 message
        - 如果一送出去就刪除，consumer 如果 down 了，message 就會消失
      - 要自行在消耗速度以及 reliability 之間取得平衡

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
  - query language for APIs
  - 解決 REST 的 over-fetching, under-fetching 問題
    - over-fetching
      - 取得的資料比需要的多
    - under-fetching
      - 需要的資料要從多個 endpoint 取得
      - ex: 取得 user 資料，會回傳 posts 的 id，但要再去另一個 endpoint 取得 posts 的資料
  - 優點
    - client 可以自己決定要取得哪些資料
  - 缺點
    - cache 難以實作
      - GraphQL 用的是 POST，瀏覽器 cache 只能用 GET
      - 而且每個 user 可能會用不同的 field，cache 難以共用

## Store client data
- cookie
  - limitied size
  - not secure
- sticky session
  - 需要 ALB
  - 無法應對 instance down 的情況
- key-value store
  - 增加複雜度
    - 如果 redis 倒了？

## Architecture pattern
- CQRS
  - Command Query Responsibility Segregation
  - 把 read (query) 和 write (command) 分開
  - 一個 storage 針對 read 做 optimize，另一個 storage 針對 write 做 optimize
    - 準備一個 schedule job 來把 write 的資料同步到 read 的 storage
  - 如果 read storage 為了讀取效能需要加很多 index，要在裡面更新就可能會花的時間變很長，就可以用這種 pattern

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
        - 涉及地理類型的資料 (ex: 乘客和司機的位置)
          - 可以考慮用自訂幾何形來區分不同地區
      - 怎樣的切法可以讓 query 盡量不要跨 shard
  - 每個階段也可以探討 throughput
  - 開始根據情境設計不同的 service 來表達他們的交互

## Scene
- 叫車服務
  - 可以導入 geo index 來加快查找速度
  - 可以用地理劃區塊的方式來 hash 決定
- 聊天軟體
  - 可以考慮把寫入資料庫和傳給 user 兩件事情用非同步的方式做
- 網頁爬蟲
  - 從一個 URL 獲取內容，並且從內容中提取更多 URL，反覆執行
  - 可以考慮架設的離 DNS 越近越好，如果要爬取的網頁很多，Domain name 的轉換可能影響很大
  - 如果單純抓網頁，現在因為很多網頁都靠 JS 來 render，只會得到空的 html，可以考慮用 headless browser 來 render
    - headless browser
      - 沒有 user interface 的 browser
      - 但是依然有 rendering engine 和 js interpreter。可以用來得到最終的 html
- 拍賣
  - 可能要考慮把 bid 做 serialization
    - 把 bid 透過 queue 給 serializer，會無法回傳成功或失敗
    - 可以用 second queue，再讓 serializer 把結果放進去，傳回給 service
    - 如果有用 websocket，就可以考慮用這種做法
      - 用 polling 的話，就得去資料庫撈，除非 service 可以儲存住這些資料
- 短 URL 生成
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
  - 根據可以有多少種字元取長度的次方，即可判斷長度取到多長可以涵蓋我們想要儲存的 URL 數量
    - 如果我們想要可以儲存 30B 個 URL，那長度就要取 58 的 6 次方才會超過
    - 可以直接裁斷編碼後的結果
    - 或是不管 UUID，每個字元從 BASE58 的 char set 做 random
- 搶折價券系統
  - 有一定數量的折價券可以給一定數量的 user 搶，先搶先贏
  - 會有極大量的 user 在極短的時間湧入
  - 我們可以事先在資料庫建好指定數量的 coupon，就可以修改的時候只 lock 某個 row，不用 lock 整個 table
    - pre-populate
    - 如果是 insert，可能就得面臨要 lock 整個 table，避免多發 coupon
  - 可以在 server 做 cache 好處理 read，直接回傳沒有更多 coupon 的訊息
  - 考量到資料庫處理上限，我們勢必得做 sharding，導致我們可能會某個 database 的 coupon 空了，但另外一個還有
    - 不過系統不一定要公平，我們只需要發指定數量的 coupon 出去就好
- 社群平台
  - 可以在 cache 存放 timeline 減少 cache request 的次數
    - 但要考慮 influencer 可能要特別設計
      - 改成另外儲存，到 client 再合併
- 售票系統
  - 可以考慮把票設計 status，並用 aggregate function 來計算
- 雲端硬碟
  - 要思考現在的單一硬碟可以儲存多少，以及每台機器可以 mount 多少硬碟
  - 每個 User 可以使用的容量期望值？
  - 考慮在 client 端做壓縮減少負擔
  - Cyclic redundancy check (CRC)
    - 一般用在檢查封包是否有錯誤，但是我們也可以用來檢查某個檔案是否有被修改，好做 sync
  - Delta copying
    - 把檔案切小，只傳送修改過的部分
## Tips
- 每個 Phase 可以多和 interviewer 討論，確認走在正確的方向上
- 面對面試官給的數字可以嘗試為了好算向上抓一些
- 延遲任務
  - 如果遇到因為某些原因需要晚點才能做某個任務，可以用 queue 來處理
- Cache 除了用 cache 做，Server 自身也可以用 memory 來 cache
- 對於先搶先贏的系統不一定要追求公平，只要達成目標即可