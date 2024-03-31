---
title: "論文閱讀：A Framework for Extended Reality System
Development in Manufacturing"
date: 2024-03-30T00:00:01+08:00
draft: false
description: "XR 系統在製造業的開發框架"
type: "post"
tags: ["extended-reality", "xr"]
categories : ["unclassified"]
---

## Abstract

本文想在 manufacturing context 下開發一個 XR (extended reality) 架構，想用 XR 整合並改善傳統工作流程。

該框架包含五個 iterative phase:
1. Requirement analysis
2. Solution selection
3. data preparation
4. system implementation
5. system evaluation

此實驗也強調了 user-centered 的方法在開發有關製造業的 XR 系統的重要性。

## Introduction
作者認為 XR 系統的整合對製造業的轉型很重要，有助於實現 Industry 4.0。

盡管研究顯示 XR 在製造業中有巨大潛力，但工程師在日常生活中用 XR 的系統很少，顯示出整合 XR 到製造業是困難且具備挑戰性的。

本研究想開發一個系統框架，支援未來 XR 系統在製造業的開發，而不是只停留在「wow effect」

## Frame of reference
### Extended Reality Classification
透過電腦實現的現實增強技術可以追溯到 1960s，在近年演變成多種子集，也因此產生不同術語，使人困惑。

本文說的 XR 被用作總稱，代指所有以電腦為媒介的 Reality Technologies。

區分不同系統的 XR 十分重要，這樣才能針對製造業中任何一個特定的應用作出正確的決策。

一種常見的方法是 reality-virtuality continuum，把現實世界和虛擬世界放在兩端，根據靠近哪端進行區分。

左端是現實世界，右端是虛擬世界。從左到右出現 augmented reality(AR)、mixed reality(MR) 和 virtual reality(VR)

- Augmented Reality (AR)
  - 最廣泛的定義，有以下三個特徵
    - 結合虛擬與現實
    - 要可以 real-time 的互動
    - 顯示在 3D 空間
  - 用戶要依然可以看到周遭環境，並與之互動，同時獲得諸如文字或圖片的增強體驗
  - 可透過 smart glass 或手機實現
- Mixed Reality (MR)
  - 可以定義為把現實世界和虛擬世界中的東西呈現在一起的應用程式，也就是 reality-virtuality continuum 上的任何位置
  - MR 比 AR 更進一步，不只希望虛擬物體疊加在現實世界上，還希望使用者可以像對待真實物體一樣和他們互動
  - 為了實現 MR，需要一台整合了電腦、半透明玻璃、和感測器的耳機
  - 某種意義上是更具沉浸感的 AR
- Virtual Reality (VR)
  - 使用者完全沉浸在虛擬世界中，無法看到現實世界
    - 有三種典型設定：獨立耳機、CAVE (房間是大型投影幕)、連接到電腦的頭戴式顯示器
      - 最後一種已佔據主導地位
### Hardware parameters for extended reality
深入了解硬體參數也很重要，會影響可用性

- Field of View (FOV)
  - 人類的 binocular FOV 大約是 114 度，XR 使用的螢幕具有類似的視野才會是理想的，確保用戶有無縫體驗
  - 通常 AR 和 VR 的 FOV 會小的多，只有 30-60 度，每次呈現有限的虛擬內容，當需要渲染大型虛擬物件時就會有問題
    - 由於 AR 和 MR 並不排斥現實世界，所以如果內容尺寸適當，不影響使用者感知
  - 現今的 VR 頭戴裝置 FOV 大得多，落在 90-110 度之間
    - 一些先進的模型甚至聲稱到 200 度，超過人類的 FOV
  - 具有較小 FOV 的耳機會因為「tunnel vision effect」而分散用戶的注意力
- Frame per Second (FPS)
  - 對於 MR 或 AR，30-60 FPS 就足夠了，VR 則建議爭取到 90
  - 由於使用者沉浸在電腦生成的內容，FPS 太低會導致 motion jitter，導致用戶產生 motion sickness
  - FPS 不單由硬體決定，也由軟體決定

### Software for extended reality
作者將其分為兩大類，基於「開放開發平台的方法」和基於「已有商業軟體的擴展方法」。開放式開發平台的優點是開發過程完全受控，可以根據個人需求訂製，但需要軟體工程方面的專業知識。

當今製造業使用的成熟商業軟體也在擴大對 XR 功能的支援，因此，現有用戶可以毫不費力創建 XR 體驗。然而，使用此類軟體來探索 XR 新功能的自由度有限，因為它依賴軟體供應商的更新。

- Open development platform
  - 兩大主要平台是 Unity3D 和 Unreal Engine 4
- Established commercial software
  - 範例
    - Siemens 的 Plant Simulation
    - 雖然缺乏更高程度的客製化自由度，但節省了創建通用功能的時間和成本

## Research Approach
本文為了開發一個可以提高未來 XR 系統的可用性和接受度的框架，選擇了六個案例。

它們各自採用了代表了不同公司製造活動的四個階段：design、training、operation、disruptive

## Framework development
XR 系統整合框架的開發採用了 SDLC，也被稱作 application development life cycle，常被用在開發各種 IT 系統。
描述了系統設計人員和開發人員為了確保開發品質，需要遵循的多個階段活動。

多年來，基於 SLDC 方法開發了各種模型和方法，比如瀑布式開發或是 Scrum。

本研究中採用的 SDLC 階段如下：
1. Identifying problems
2. Analyzing the needs
3. Designing the system
4. Developing and documenting
5. Testing the system
6. Implementing and maintenance

### Case 1
#### Background
要訓練人員維護機器
#### Resarch Process
有公司進行了案例研究，開發了一種支援小型工具箱維護任務的 AR 系統
#### Result and conclusion
文本教學容易被忽略，以吸引人的物件符號改進。
最後問卷持正面態度。
但還是有一些可改進的點，比如需要連接電腦，在實際工廠車間並不方便。

### Case 2 ~ Case 6
時間問題暫不補

## The proposed framework
針對上一節 SDLC 的案例總結和整合，結合了以使用者為中心的 XR 系統開發五步驟框架。

### Step 1: Understanding the requirements
聽起來很顯而易見，但實踐中常被跳過或淡化，導致不令人滿意的結果。
而且製造環境比一般用例場景更加複雜。

全面了解需求是成功開發 XR 系統的重要第一步。
以使用者為中心的設計方法中，採用的比如 observation、stakeholder workshop、contextual inquiry、storyboard、prototyping adopted 都被證明在是別需求方面是有效的。

應該要可以回答以下問題：
- What actions are taken?
- What support are used?
- What outcome are achieved?
- What main drawbacks are there?

回答上述問題後，就可以開發 storyboards 和 prototypes 了。

此外，不只是開發者和負責人，最終用戶也要可以參與評估和回饋，直到最終的需求被解決。

### Step 2: Solution selection
通常是根據公司現有硬軟體來選擇，而不是根據哪種解決方案最能滿足要求，使選方案是個困難的決定。

### Step 3: Data preparation

### Step 4: System implementation

### Step 5: System evaluation

### Iteration
在完成所以提出的步驟後可以迭代，以小量的改進進行迭代，直到達成特定需求。

## Framework validation
該框架被用於一個真實案例，用來評估適用性。
此外，他還與六項先前的研究進行驗證，這些研究部分與提出的框架一致。

### The empicial case

本文的框架被用於開發 VR 工具，好支援汽車公司的產品設計審查。

#### Requirement analysis
是一家分布全球的汽車公司，研發中心在瑞典，工廠在中國。

具體任務是對用於點焊的新型 fixtures 進行 design review。

目前的做法依賴 CAD 軟體分布在不同地點的不同團隊之間來傳達理念。

他還需要一個或多個原型，在最終安裝前進行驗證。

主要缺點是，和原型實體相關的溝通十分冗長。

此外，最終使用者 ( operators of fixtures) 缺發 CAD 設計的專業知識，導致他們無法參與設計。

因此，提出了具體要求：
- 適用於所有 stakeholder 的虛擬工具，可以直觀地視覺化新產品設計，並和新產品設計互動
- 多個 stakeholder 可以從不同的地點參與同一個 virtual session
- 所有 stakeholder 都可以口頭交流
- virtual session 可以用圖像或影片形式記錄
- 每個 stakeholder 都要有個人化虛擬代表
- 要有主持人、與會者和觀眾等角色相關功能

#### Solution selection
選 VR 和 Unity3D

#### Data preparation
#### System implementation
#### System evaluation
進行兩次迭代開發，評估 VR 系統是否可以補充或甚至取代現有作法的可行性
#### Outcome
開發了一個可以支援最多 20 個使用者從任何有網路的地方連線加入的應用程式。

### External Validation
作者挑了七篇有關的 XR 整合到製造業的研究，他們都採取了類似的方法，部分與提出的框架一致。

## Conclusion
本文第一個貢獻是根據案例結果提出的框架，由五個迭代階段組成：
1. Requirement analysis
2. Solution selection
3. Data preparation
4. System implementation
5. System evaluation

通過一個實際案例以及七項先前的研究進行了驗證，這些研究與提出的框架部分一致。

該研究還會工業從業者提供了知識，有利他們採用 XR 技術做為 工業 4.0 的一部分。