---
title: "Azure Devops 筆記"
date: 2024-07-20T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: []
categories : ["devops"]
---

## Pipeline
### 名詞
- Artifact
  - 你需要用到的檔案，可能是 build 出來的檔案，或是跑測試用的專案
  - ex: .jar, .war
### Type
- Build pipeline
- Release pipeline

### azure-pipelines.yml
- 可以 create pipeline，在專案中加入該檔案，Azure DevOps 會自動偵測並執行
- 用於 build pipeline
- trigger
  - 指定哪些 branch 有 push 時，要執行 pipeline
#### Variables
- 可以設定變數，用在 yaml 中
### Task
- 可以搜尋各種 task 來完成任務
  - copy files
  - publish build artifacts

### Release pipeline
- 把 build 出來的 artifact，部署到指定的環境
- artifact 上方的閃電，可以設置當有新的 artifact 時，自動觸發 release
- create release
  - 執行 CI/CD

### Agent pool
- 可以加入自己的 agent，也就是自己的 server

## Board
### Work item
- Epic
  - 一個非常 high level 的需求
- Issue
  - 把 Epic 拆成小的需求
  - 在敏捷也可以稱為 User Story
- Task
  - 再把 Issue 拆成更小的需求

### Backlog
- PO 創建的 Issue，會在 Backlog 中
- 可以把 Issue 拖拉到 sprint 中
- 可以結合 git repo，把 commit 或 branch 關聯到 Issue

### Sprint
- 在這可以新增 sprint
- 也有 task board，列出所有 task
  - 可以設置 task 的狀態以及指派人員