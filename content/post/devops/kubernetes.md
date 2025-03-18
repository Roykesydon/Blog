---
title: "Kubernetes 筆記"
date: 2024-06-14T00:00:17+08:00
draft: true
description: ""
type: "post"
tags: ["container orchestration"]
categories : ["devops"]
---

## 基礎概念
### Container runtime
- CRI (Container Runtime Interface)
  - Kubernetes 用來和 container runtime 互動的 interface
  - 任何可以實現 CRI 的 container runtime 都可以用在 Kubernetes，比如 containerd
  - 以前有幫 Docker 特別實現一個 CRI，叫做 Docker shim
- OCI (Open Container Initiative)
  - 一個開放的 container image 和 runtime 的標準
  - 他定義了 container image 和 container runtime 的格式
- containerd
  - 一個 container runtime，docker 底下所使用的 container runtime，現在已經與 docker 單獨出來開發維護
  - 他實現了 CRI，所以可以用在 Kubernetes
  - CLI
    - ctr
      - 如果你只裝 containerd，沒有裝 docker，就可以用這個來操作 containerd
      - 能用的指令比較少
      - For Debugging
    - nerdctl
      - docker-like 的 CLI
      - 很多指令可以把 docker 的指令換成 nerdctl 的指令
      - For general purpose
- crictl
  - 用來操作符合 CRI 的 container runtime 的 CLI
  - For Debugging
### Node
- Kubernetes 集群中的一台機器
- 過去叫做 Minion
#### Cluster
- 由多個 Node 組成的集群

#### Node Type

##### Master
- 控制整個集群的 Node
##### Worker
- 其他非 Master 的 Node 叫做 Worker Node

##### Master vs Worker
- Master
  - 擁有的 Component
    - API Server
    - etcd
    - Controller
    - Scheduler
- Worker
  - 擁有的 Component
    - Container Runtime
    - Kubelet

### Component
- 安裝 Kubernetes，實際上是安裝以下幾個 Component
  - API Server
    - front-end of the Kubernetes
    - kubectl 是在和這裡溝通
  - etcd
    - distributed key-value store
    - 會實現 lock mechanism，確保沒有 conflict
    - 預設聽 2379 port
    - command line client
      - etcdctl
  - kubelet
    - 在每個 node 上運行的 agent
    - 負責確保 container 在 node 上如期運行
  - Container Runtime
    - 用來 run container 的 underlying software
  - Controller Manager
    - 當 node、container、endpoint 掛掉的時候，他要負責監控和回應
    - 底下有許多種的 Controller，負責監控還有作出應對處理
    - type
      - Replication Controller
        - 確保指定數量的 Pod 在任何時間都在運行
        - load balancing & scaling
        - 後來被 ReplicaSet 取代
      - Node Controller
        - 確保 node 在運行
        - 設定固定間隔監測 node 的健康狀態
  - Scheduler
    - 負責處理 node 間的 distributing work
    - 會尋找新創的 container，並分配到 node 
    - 嘗試幫每個 pod 挑選最適合的 node
    - two phase
      - Filter
        - 檢查 node 是否符合 pod 的需求
      - Rank
        - 給 node 一個分數，選擇最高分的 node

## Pod
- Kubernetes 的最小單位
- 一個 Pod 封裝一個應用程式，可能包含一個或多個 container

## ReplicaSet
- 新版本的 Replication Controller
- yaml
  - spec
    - `template`
      - 指定要創建的 Pod 的 template
      - 把 pod 的 metadata 和 spec 都放在這裡
    - `replicas`
      - 指定要創建的 Pod 的數量
    - `selector`
      - 指定要選擇的 Pod
      - 需要這個是因為 ReplicaSet 也可以管理那些不是他創建的 Pod
      - `matchLabels`
        - 指定要選擇的 Pod 的 label
- command
  - `kubectl scale --replicas=3 -f <file>`
    - scale up/down replicas
    - 這樣不會修改檔案，所以檔案的如果原本是 2，檔案依然會寫 2，只是 replicas 會變成 3
  - `kubectl scale --replicas=3 replicaset <name>`
    - scale up/down replicas
  - `kubectl edit replicaset <name>`
    - 想要 scale up/down replicas 也可以用這個，他會立刻生效
- 簡寫
  - rs

## Deployment
- 管理 ReplicaSet 和 Replica Controller
- yaml 和 ReplicaSet 很像，把 kind 從 ReplicaSet 改成 Deployment 就好
  - 會自動創建 ReplicaSet
- 使用情境
  1. Rolling update
    - 想要更新每個 Pod，但不是同時更新，而是一個一個更新，確保不會有 downtime
  2. Rollback
    - 如果更新失敗，可以回到之前的版本
  3. Pause and Resume
    - 當需要做 multiple changes，不想要一下指令就馬上做，可以先 pause，等所有指令下完再 resume
- rollout
  - 創建 Deployment 的時候，會自動創建一個 rollout
  - 創建一個 rollout 的時候，會自動創建一個 Deployment revision
- Deployment Strategy
  - Recreate
    - 先刪除所有舊的 Pod，再創建新的 Pod
    - 中間會有 Application downtime
  - Rolling Update
    - 一個一個更新 Pod
    - 這個是預設的 strategy
- command
  - `kubectl rollout status deployment <name>`
    - 查看 rollout 的狀態
  - `kubectl rollout history deployment <name>`
    - 查看 rollout 的 history (revision)
  - `kubectl rollout undo deployment <name>`
    - 回到上一個 revision
- 簡寫
  - deploy

## Service
- 讓不同 group 的 Pod 互相通信
- 像一個 virtaul server，可以連接到一個或多個 Pod
- 每個 Node 都有一個 kube-proxy，他會檢查有沒有新的 service，並維護 iptables
- type
  - NodePort
    - 會在每個 node 上開一個 port，讓外部可以連進來
    - default valid port range: 30000-32767
    - yaml
      - spec
        - `type`
        - `ports`
          - `port`
            - service 的 port
          - `targetPort`
            - pod 的 port
            - 如果不設置，會用 `port` 的值
          - `nodePort`
            - 如果不設置，會從 default port range 選一個
        - `selector`
          - 指定要連接的 Pod
    - 預設會用 load balancing，策略是 Random，像是一個內建的 load balancer
    - 如果有在同個 cluster 跨 node 的情況，不需要其他設定，就可以創建一個跨 node 的 service，會幫他們都設同一個 nodePort
  - ClusterIP
    - 只有在 cluster 內部可以連進來
    - 用來幫某一組的 pod 提供一個統一的界面並做轉發
    - 不能依賴 internal IP，因為每個 pod 都有可能會 down 或 up
    - yaml
      - `spec`
        - `type`
        - `ports`
          - `port`
          - `targetPort`
        - `selector`
    - service 可以用 cluster IP 或是 service name 來連接
  - LoadBalancer
    - 會在 cloud provider 上開一個 load balancer
    - nodePort 的 load balancer 是在 node 內部的，現在是要幫多個 node 做 load balancing
    - 這只有在 cloud provider 上才有
- name 很重要，因為其他的 Pod 會用這個 name 來連接 (就像 domain name)
- 簡寫
  - svc

## YAML
- Kubernetes 的配置文件
- root level properties
  - apiVersion
    - |kind|apiVersion|
      |---|---|
      |Pod|v1|
      |Service|v1|
      |ReplicaSet|apps/v1|
      |Deployment|apps/v1|
  - kind
    - Pod, Service, ReplicaSet, Deployment
  - metadata
    - `name`
    - `labels`
      - 可以加入任何 key-value pair
  - spec
    - specification section
    - pod
      - `containers`
        - `name`
        - `image`
        - `env`: list of environment variables
          - `name`
          - `value`

## Tool
### kubectl
- `kubectl`
  - 用來 deploy、inspect、manage application on a Kubernetes cluster
- commands
  - `kubectl run <name> --image=<image>`
    - 創建一個 Pod
  - `kubectl get pods`
    - 查看所有 Podllll
    - `-o wide`
      - 顯示更多資訊
    - column
      - READY
        - <running containers>/<total containers>
    - 也可以用 `kubectl get all` 來查看 Pod、Service、ReplicaSet、Deployment
  - `kubectl describe pod <name>`
    - 查看 Pod 的詳細資訊
    - 欄位
      - Node
        - Pod 在哪個 Node 上運行，包含了 Node 的 IP
      - IP
        - Pod 的 IP
  - `kubectl delete pod <name>`
    - 刪除 Pod
  - `kubectl create -f <file>`
    - 根據 YAML file 創建 resource
    - 如果 resource 已經存在，會報錯  
  - `kubectl apply -f <file>`
    - 根據 YAML file 創建 resource
    - 如果 resource 已經存在，會更新 resource
  - `kubectl replace -f <file>`
    - 根據 YAML file 創建 resource
    - 如果 resource 已經存在，會刪除舊的 resource，並創建新的 resource
  - `kubectl edit replicaset <name>`
    - 可以直接編輯 Replica Set 的 yaml 檔，但他不是一開始創建用的檔案，而是 Kubernetes 在 memory 暫時生成的
  - `kubectl set image deployment <name> <container-name>=<new-image>`
    - 更新 Deployment 的 image
    - 注意這裡是 Container name，不是 Pod name
  - `--record=true`
    - 會記錄每次的操作
    - 用在 rollout 的時候，可以看到每次的操作，不然會顯示 <none>

### minikube
- 用來在 local machine 上建立一個 single-node cluster

### kubeadm
- 用來在多個 node 上建立 cluster
- 在多個 node 上安裝 Kubernetes
  - 流程
    1. 安裝 container runtime
    2. 安裝 kubeadm
    3. 初始化 master node
    4. 建立 pod network
    5. 加入 worker node

## Networking
### Cluster Networking
- 每個 Pod 都有自己的 IP
- 兩個不同屬於同一個 cluster 的 Pod 可能會有相同的 IP
- Kubernetes 要求所有的 Pod 要可以在不用 NAT 的情況下互相通信
  - 所有的 container 和 node 都要可以在沒有 NAT 的情況下互相通信
- 可以用 Calico 等方案實現
  - 他會把每個 node network 都設成不同的，底下的 pod IP 自然就不會重複