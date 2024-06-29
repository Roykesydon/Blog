---
title: "Design"
date: 2024-06-27T00:00:17+08:00
draft: false
description: "紀錄有關 Design 的雜項"
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## Modularity
### Coupling
- type
  - Tight coupling
    - Content coupling
      - 一個模組依賴另一個模組的內部運作
      - ex: 一個模組直接存取另一個模組的變數，假設回傳的數值是公尺，如果另一個模組要修改成公分，就會影響到這個模組
        - 可以用 getter 抽象出 getMeter()，這樣就不會直接存取變數
    - Common coupling
      - 多個模組共同存取和修改同個 global data
      - ex: 一個模組錯誤修改會導致其他人都壞掉
    - External coupling
      - 多個模組直接存取同個 external I/O
      - ex: API 要改就會全部都影響到
  - Medium coupling
    - Control coupling
      - 一個模組影響另一個模組的內部邏輯（比如說透過參數）
      - ex: 參數要改個寫法就會影響一堆模組
    - Data-Sructure coupling
      - 多個模組共同存取同個 data structure
      - ex: Data structure 要改就會影響到其他模組
  - Loose coupling
    - Data Coupling
      - 兩個模組 share/pass 同樣的資料
    - Message Coupling
      - 多個模組間透過 message 或是 command 來溝通
      - 和 control coupling 的差別在於，並沒有去控制某個模組，只是叫他做某件事情
    - No Coupling
      - 不是好的設計
      - 模組間沒有關聯，或是有個超巨大的模組
### Cohesion
- type
  - Weak cohesion
    - Coincidental cohesion
      - 唯一的關聯是他們在同個檔案
      - ex: single file program
    - Temporal cohesion
      - 關聯的地方是他們在同個時間點被執行
      - ex: 「執行 shutdown  相關的活動」
    - Logical cohesion
      - 活動間可以被歸類在同個 general category
      - ex: Backup Controller，可能有很多地方需要 Backup
  - Medium cohesion
    - Procedureal cohesion
      - command 間存在執行順序
      - ex: Clean car module 可能包含噴水、填表格、擦乾等等
        - 但是 Clean car module 此處包含了操控財務資料的狀況
    - Communicational cohesion
      - 所有的 activities 都支援相同的 input/output
      - ex: 提取文章的作者、提取文章的標題、提取文章的內容
    - Sequential cohesion
      - 某個 activities 的輸出是另一個 activities 的輸入，且具有順序性
      - Procedureal cohesion 和 Communicational cohesion 的結合
      - 這個沒那麼糟糕
  - Strong cohesion
    - Functional cohesion
      - Module 只支援只和一個問題相關的 activities
    - Object cohesion
      - 所有的 activities 都只會修改一個 object
