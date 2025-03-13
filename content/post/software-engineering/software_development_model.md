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
- **Incremental**
  - 透過多個 **increment**（增量）逐步構建專案，每個增量都是可運行的部分功能，並在後續開發中持續擴充。
- **Iterative**
  - 建立 **prototype**（原型），然後反覆改進，每次迭代都基於上一版本進行調整與優化。

## Model Type
- **Linear/Predictive**
  - 適用於具備類似專案經驗的情境
  - 擁有明確的開發流程
  - 變更空間極小，需求需在開發前確定
- **Flexible/Adaptive**
  - 適用於新創概念或需求尚不明確的專案
  - 專案可能隨時間變更，因此需具備較高的靈活性

## Waterfall Model
- **像瀑布一樣，一個階段完成後才能進入下一個階段**
- 典型流程：
  - **Requirement** → **Design** → **Implementation** → **Testing** → **Deployment** → **Maintenance**
- **高度預測性**（Predictive），變更成本極高，彈性低
- **問題點：**
  - 若在 **Testing** 階段發現重大缺陷，可能需回溯至 **Requirement** 重新開始
  - 隨著進度推進，**修正成本（fix cost）將大幅增加**
  - 需要在每個階段做詳細規劃，以降低風險
  - **用戶直到後期才會看到可運行的成果**

## Incremental Model
- 在整個開發過程中，將系統劃分為 **多個增量（increments）** 來逐步開發與交付
- 每個增量都具備可運行的功能，並能獨立部署
- 各個增量的目標與功能範圍需事先定義，以確保最終整合

## Agile
- **一種思維方式，而非特定的開發模型**
- **Agile Manifesto（敏捷宣言）**
  - **Individuals and interactions over processes and tools**（個人與互動高於流程與工具）  
    - 若團隊決定使用新的工具，應優先考量團隊的需求，而非僅僅依賴過去習慣的工具  
  - **Working software over comprehensive documentation**（可運行的軟體高於完備的文件）  
    - 文件很重要，但單純依賴大量文件無法讓客戶提供有效回饋  
  - **Customer collaboration over contract negotiation**（與客戶合作高於合約談判）  
    - 強調持續與客戶溝通，以確保專案方向正確，而不是只關注合同上的條款  
  - **Responding to change over following a plan**（回應變化高於遵循計畫）  
    - 在變化快速的環境下，適應需求變更比僵化地執行既定計畫更重要  

### **瀑布式開發的缺點（Agile 解決的問題）**
- **技術環境變化迅速，Agile 讓開發更具適應性**  
  - 傳統開發方法往往因為考量成本，不容易應對變更 而 Agile 透過 **小的增量（increment）** 來持續調整方向，降低風險  
- **軟體需求無法 100% 預測**  
  - 早期規劃的需求可能與最終需求不符，因此 Agile 強調 **持續交付與回饋**  
- **系統可能不符合用戶需求**  
  - 透過 **迭代開發（iterative development）**，確保用戶能夠在開發過程中參與並提供反饋  
- **市場變化快速**  
  - Agile 強調 **MVP（最小可行產品）**，讓團隊能在短時間內推出核心功能，以快速測試市場反應  

---

## Kanban
- **以視覺化方式管理工作流程**
- **透過卡片（Kanban 卡）來追蹤工作項目**
- **能夠直觀地發現某個工作階段是否積壓過多任務**

### **核心屬性（Properties）**
- **Visualize workflow**（視覺化工作流）  
- **Limit work in progress**（限制在製作業務量）  
- **Manage flow**（管理工作流）  
- **Make process policies explicit**（明確定義流程規則）  
- **Improve collaboratively**（透過協作持續改進）  

### **核心原則（Principles）**
- **Start with what you do now**（從現有流程開始）  
- **Agree to pursue incremental, evolutionary change**（追求漸進式改變）  
  - 並非一次性顛覆整個流程，而是逐步優化  
- **Respect the current process, roles, responsibilities & titles**（尊重現有流程、角色、職責與職位）  
- **Encourage acts of leadership at all levels**（鼓勵各層級展現領導力）  
  - **Leadership** 不僅指管理職責，也包含主動解決問題、協助他人、激勵他人 

### **工作欄位（Work Columns）**
- **Backlog**（待辦事項）  
- **Analyze**（需求分析）  
- **Develop**（開發）  
- **Test**（測試）  
- **Release**（發布）  

## Scrum
### Scrum 核心概念
- **Scrum 是敏捷開發框架**，透過迭代式的開發方式，提高軟體交付的效率與適應性。
- 主要流程包括 **Sprint Planning、Daily Scrum、Sprint Review 和 Sprint Retrospective**。

### 角色與職責
#### 1. Product Owner
- **負責確保產品的價值最大化**
- **職責**：
  - 維護 **健康的 Product Backlog**（保持任務清晰、優先順序合理）
  - 與 **利害關係人** 溝通，確保開發方向符合需求
  - 定義 **Acceptance Criteria（驗收標準）**
  - 管理 **預算與 Release 計畫**
  
#### 2. Scrum Master
- **確保 Scrum 流程正確執行**
- **職責**：
  - 促成 **Daily Standup**，確保討論聚焦
  - **移除障礙**，幫助團隊專注於開發
  - 培養 **Scrum 文化**，確保團隊理解並實踐 Scrum 的價值觀
  - Servant Leader
        - 有一點領導，但和大家平等。促成團隊工作而不是指揮別人
#### 3. 開發團隊（Dev Team）
- 包括工程師、設計師、測試人員等
- **目標**：
  - 與 Product Owner **合作撰寫 User Stories**
  - 開發、測試、確保功能符合定義的需求
  - 參與 **技術設計、研究與原型開發**

### Scrum 流程
#### 1. Product Backlog
- 由 Product Owner 負責維護，內容包含：
  - **優先度**
  - **預估花費時間**
  - **負責的人**

#### 2. Sprint Planning Meeting
- 目標：將 **Product Backlog** 轉換為 **Sprint Backlog**
- **角色分工**：
  - **Scrum Master**
    - 確保會議高效進行
    - 如果有講太久的部分，可能稍後再排單獨會議
    - 確保一切都和 sprint goal 一致
  - **Product Owner**
    - 準備好 product backlog
    - 澄清 product backlog 的細節
    - 要準備好描述 acceptance criteria
      - 比如搜索速度要多快？
  - **Dev Team**
      - 拆解任務、估算工作量、選擇可完成的任務

#### 3. Sprint Backlog
- 本次 Sprint 需要完成的所有任務
- **開發人員自行選擇任務**，並在 **1-4 週內完成 Sprint**

#### 4. Daily Scrum
- 不能花太久，比如**限制 15 分鐘內完成**
- Scrum Master
  - 確保會議的進行，確保 timebox
  - 紀錄關於目前障礙的筆記，規劃時間移除
- Dev Team
  1. 昨天完成了什麼？
  2. 今天計畫做什麼？
  3. 有遇到什麼阻礙？

#### 5. Sprint Review（成果展示）
- 向 **Stakeholders** 展示這次 Sprint 交付的 **Product Increment**
- **討論改進方向，準備下一個 Sprint**

#### 6. Sprint Retrospective（回顧與改進）
- 探討 **這次 Sprint 哪些地方可以改進**
- **常見方法**：
  - **Start-Stop-Continue**
    - **Start**：開始做什麼？
    - **Stop**：應該停止什麼？
    - **Continue**：繼續保持哪些做法？
    - 每個人說出一個想開始做的事情，一個想停止做的事情，一個想繼續做的事情
      - 可以保持匿名

### 3-5-3 Structure（Scrum 的核心架構）
#### 3 大工件（Artifacts）
- **Product Backlog**
- **Sprint Backlog**
- **Product Increment**

#### 5 大事件（Events）
1. **Sprint Planning**
2. **Daily Scrum**
3. **The Sprint**
4. **Sprint Review**
5. **Sprint Retrospective**

#### 3 大角色（Roles）
- **Product Owner**
- **Scrum Master**
- **開發團隊（Dev Team）**

#### 其他補充：
- **Scrum 5 大價值觀 (Values)**：
  - **專注（Focus）**
  - **尊重（Respect）**
  - **承諾（Commitment）**
  - **勇氣（Courage）**
  - **開放（Openness）**
- **Scrum 3 大支柱 (Pillars)**：
  - **透明性（Transparency）**
  - **檢視（Inspection）**
  - **適應（Adaptation）**
- 可以利用 back-to-back testing 來確認沒有弄壞之前 sprint 的功能