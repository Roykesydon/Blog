---
title: "Software Development Model"
date: 2024-06-27T02:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Terms
### Incremental vs Iterative
- Incremental
  - 隨時間一步一步完成
- Iterative
  - 建立 prototype，然後不斷改進

## Model type
- Linear/Predictive
  - 有類似的專案經驗
  - 有明確的流程
  - 沒什麼可以改動的空間
- Flexible/Adaptive
  - 專案屬於 new idea
  - 專案很有可能隨時間改變

## Waterfall Model
- 像瀑布一樣，一個階段完成後才能進行下一個階段
- Requirement -> Design -> Implementation -> Testing -> Deployment -> Maintenance
- 非常 predictive，沒有彈性
- 如果在 Testing 發現重大問題，可能要從 Requirement 重新開始
- 隨著進度推進，fix 成本增長很快
- 每一步都得考慮周密
- 用戶很晚才能看到結果

## Incremental Model
- 在整個開發過程中多次完成軟體開發過程
- 每個子開發過程都有明確的目標

## Agile
- 一種思維方法，不是模型
- Manifesto
  - Individuals and interactions over processes and tools
    - 如果一組人決定要用一組新的工具，那他們應該有更高的優先權
    - 過往的做法可能偏向使用過的工具
  - Working software over comprehensive documentation
    - document 很重要，但是只有大量的 document 沒辦法讓客戶給出反饋
  - Customer collaboration over contract negotiation
    - 強調和客戶的合作，而不是只在意合同上的項目
  - Responding to change over following a plan
- 瀑布式開發的缺點
  - 現在的技術環境變化太快，Agile 希望在開發過程中能夠快速適應
    - 傳統的開發方法考量到金錢損失，不太可能辦到。但透過小的 increment，可以在每個 increment 中朝正確的方向前進
  - 軟體系統不可能被 100% 預測
  - 系統可能不符合用戶要求
  - 市場變化很快，Agile 可以在短時間內推出最小可行產品，先行推向市場

## Kanban
- 會存在多張卡片
- 可以直觀看到某個欄位是否堆積大量工作
- Properties
  - Visualize workflow
  - Limit work in progress
  - Manage flow
  - Make process policies explicit
  - Improve collaboratively
- Principles
  - Start with what you do now
  - Agree to pursue incremental, evolutionary change
    - 並非試著立刻改變所有事情
  - Respect the current process, roles, responsibilities & titles
  - Encourage acts of leadership at all levels
    - 這裡的 leadership 不一定指領導他人，也可以是激勵他人
- 欄位
  - Backlog
  - Analyze
  - Develop
  - Test
  - Release

## Scrum
- 可以利用 back-to-back testing 來確認沒有弄壞之前 sprint 的功能
- roles
  - Product Owner
    - 決定要用什麼方式完成什麼事
    - 與外部世界溝通的人，和利害關係人溝通
    - 目標
      - 最大化產品價值
        - 價低成本、提高收益
    - 職責
      - 維護 open, healthy product backlog
      - 回答產品相關問題
      - 管理預算、release schedule
      - 確保團隊價值，找出問題
  - Scrum Master
    - 確保團隊遵守 Scrum 的規則，促成會議、解決衝突
    - Servant Leader
      - 有一點領導，但和大家平等。促成團隊工作而不是指揮別人
    - 目標
      - 促成 Daily Standup
      - 移除障礙
      - 確保大家的心情
      - 確保 Scurm values
      - 團隊的調解人
  - Dev Team
    - 包含工程師、設計師等等
    - 目標
      - 和 Product Owner 合作，create user stories
      - 寫 code 和測試，確保符合預期
      - research, design, prototype
      - 
- 流程
  - product backlog
    - 待完成的事情
    - 可能的欄位
      - 優先度
      - 預計花費時間
      - 誰來執行
  - spring planning meeting
    - 決定要在這個 sprint 完成的事情
    - 時間點會是 sprint 的第一天
    - 目標
      - 把 product backlog 轉換成 sprint backlog
    - 職責
      - Scrum Master
        - 促成會議
        - 確保和準備會議地點
        - 確保會議有在持續推進，好達成 timebox
          - 如果有講太久的部分，可能稍後再排單獨會議
        - 確保一切都和 sprint goal 一致
      - Product Owner
        - 準備好 product backlog
        - 澄清 product backlog 的細節
        - 要準備好描述 acceptance criteria
          - 比如搜索速度要多快？
      - Dev Team
        - 協助判斷哪些任務可達成且符合 sprint goal
  - sprint backlog
    - 這個 sprint 要完成的事情
    - 開發人員去自己選擇要做的事情
    - 然後就會花 1-4 週完成一個 sprint
  - Daily Scrum (Daily standup)
    - 不該花太久，比如最多 15 分鐘
    - 職責
      - Scrum Master
        - 確保會議的進行，確保 timebox
        - 紀錄關於目前障礙的筆記，規劃時間移除
      - Dev Team
        - 回答問題
          - 做了什麼
          - 計畫做什麼
          - 遇到什麼問題
  - sprint review
    - 找 stakeholders 來看看這個 sprint 的成果
    - 秀出 product increment
      - product increment 意味著他本身就是一個完成的產品，經過測試且準備 release
    - 任務
      - review sprint result
        - 回顧那些任務做得好和不好
          - 如果有事情沒完成，要解釋為什麼推遲
        - 這個 sprint 有沒有達到目標
      - Discuss and demonstrate work
        - product owner 全程記錄筆記
      - Update status of the project
      - Collaborate on the plan ahead
  - sprint retrospective
    - 團隊討論這個 sprint 的問題，並且改進
    - 常見方法
      - start-stop-continue
        - 每個人說出一個想開始做的事情，一個想停止做的事情，一個想繼續做的事情
        - 可以保持匿名

### 3-5-3 Structure
- 3 artifacts
  - Sprint Backlog
  - Product Backlog
  - Product Increment
- 5 events
  - Sprint Planning
  - Daily Scrum
  - The Sprint
  - Sprint Review
  - Sprint Retrospective
- 3 roles
  - Product Owner
  - Scrum Master
  - Dev Team
- 可以再加上
  - 5 values
    - Focus
    - Respect
    - Commitment
    - Courage
    - Openness
  - 3 pillars
    - Transparency
    - Inspection
    - Adaptation

