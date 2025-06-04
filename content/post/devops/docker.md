---
title: "Docker 筆記"
date: 2024-05-31T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["container"]
categories : ["devops"]
---

# Docker 筆記

## 基本概念
- **Docker 是什麼？**  
  Docker 是一個開源的容器化平台，用來打包、發布、執行應用程式。容器提供一致的執行環境，解決「在我機器可以跑」的問題。

- **容器 vs 虛擬機（VM）**
  - 容器共用宿主機的核心，比虛擬機更輕量。
  - 容器啟動速度快，佔用資源少。

## Image（映像檔）

### 什麼是 Image？
Docker Image 是一個唯讀的範本，包含應用程式執行所需的程式碼、函式庫、環境變數與設定檔。  
可以把它想成是「容器的模版」，容器是從 image 實例化出來的。

### Image 是由 Layer 組成的
Docker Image 採用分層架構，每個層（Layer）是前一層的延伸，對應到 Dockerfile 中的每一條指令：
- 例如：`FROM`、`COPY`、`RUN` 都會產生一層
- Image 是唯讀的，執行成 Container 時會疊加一層可寫入層
- 分層的設計讓不同 image 可以共用基礎層，並加快建置速度

### Image 的來源
### 什麼是 Registry
**Registry 是 Docker 用來儲存與傳遞 Image 的集中倉庫系統。**

當你使用 `docker pull` 下載 image，或 `docker push` 上傳 image，其實就是透過 registry 進行操作。

#### Registry 的類型
- **Docker Hub（預設）**  
  官方公共 registry，提供大量開源與官方 image（例如：`nginx`, `ubuntu`, `mysql` 等）

- **私有 Registry（Private Registry）**  
  可用於企業或內部部署，確保 image 不公開  
  可用 Docker 官方提供的 image 自行架設

### 常見指令
```bash
# 從 Docker Hub 下載 image
docker pull ubuntu:20.04

# 查看本地 image
docker images

# 刪除 image
docker rmi <image_id>
```

### Dockerfile

#### 介紹
Dockerfile 是用來建立 Docker Image 的指令腳本檔案，定義了如何建構 image，例如要用什麼 base image、要安裝哪些套件、要執行什麼程式。

#### 範例
```Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "start"]
```

#### 常用指令說明

| 指令 | 功能 |
|------|------|
| `FROM` | 指定 base image，通常是第一行 |
| `WORKDIR` | 設定容器內的工作目錄 |
| `COPY` / `ADD` | 複製檔案進入 image（`ADD` 支援 URL 與解壓縮） |
| `RUN` | 執行指令（如安裝套件） |
| `ENV` | 設定環境變數（例如：PORT=3000） |
| `EXPOSE` | 宣告容器會開啟哪些 port（僅做說明，實際還需 -p） |
| `CMD` | 容器啟動時執行的預設命令 |
| `ENTRYPOINT` | 與 CMD 類似，之後我再確認一下差別 |
| `ARG` | 建構時可帶入的變數（與 ENV 不同） |

#### 建立 image
```bash
docker build -t my-node-app .
```

---

## Container（容器）

### 介紹
Container 是 Image 的執行實例。每個容器是獨立的執行環境，與主機隔離，但比虛擬機更輕量，啟動更快。

### 常見操作指令
```bash
# 建立並執行 container
docker run -it --name myapp ubuntu

# 查看所有 container
docker ps -a

# 進入正在執行的 container
docker exec -it myapp bash

# 停止、刪除 container
docker stop myapp
docker rm myapp
```

---

## Docker Compose

### 介紹
Docker Compose 是一個工具，用來定義並執行多個 container 的應用。使用 `docker-compose.yml` 來描述整個應用的服務、網路、volume 等設定。

當應用包含多個 container（如 Web + DB），用 Compose 可以一次啟動/關閉整組環境。

### 範例
以下是 `docker-compose.yml` 的基本結構範例：

```yaml
version: '3.9'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - .:/app
    depends_on:
      - db

  db:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

### Docker Compose 常用關鍵字說明
| 關鍵字       | 功能說明                                                                                  | 範例                                                |
|--------------|------------------------------------------------------------------------------------------|-----------------------------------------------------|
| `version`    | 指定 Compose 檔案版本，決定支援哪些語法，建議使用 `3.8` 或以上版本                       | `version: '3.9'`                                    |
| `services`   | 定義多個服務（容器），每個服務底下可設定 image、build、ports、volumes 等                  | `services:`                                         |
| `build`      | 指定要用哪個目錄或 Dockerfile 建構 image，支援路徑或設定 `context` 與 `dockerfile`        | `build: .` 或 `build: { context: ., dockerfile: Dockerfile.dev }` |
| `image`      | 指定服務要使用的 image（可從 registry 拉取）                                            | `image: nginx:latest`                               |
| `ports`      | 對應主機與容器的網路埠號，格式為 `"<主機埠>:<容器埠>"`                                   | `ports: - "8080:80"`                                |
| `volumes`    | 掛載資料卷或目錄，格式為 `"<主機路徑>:<容器路徑>"`，用於資料持久化或共用檔案               | `volumes: - ./data:/var/lib/mysql`                  |
| `environment`| 設定容器內的環境變數，支援 list 或 key-value 形式                                       | `environment: - NODE_ENV=production` 或 `environment: { NODE_ENV: production }` |
| `depends_on` | 指定服務間的啟動順序，確保依賴服務先啟動                                                  | `depends_on: - db`                                  |
| `networks`   | 設定服務所屬網路，允許自訂網路或使用預設網路                                            | `networks: - backend`                               |
| `command`    | 覆蓋容器啟動時執行的命令                                                                | `command: ["npm", "run", "start"]`                  |
| `restart`    | 設定容器重啟政策，如 `no`、`always`、`on-failure`                                       | `restart: always`                                   |

### 指令速查

| 指令 | 功能 |
|------|------|
| `docker compose up` | 啟動所有服務（加上 `-d` 可背景執行） |
| `docker compose down` | 停止並移除服務、網路、volume 等 |
| `docker compose build` | 手動建構所有服務 |
| `docker compose ps` | 查看服務狀態 |
| `docker compose logs` | 顯示容器日誌 |
| `docker compose exec <service> bash` | 進入指定服務容器內 |

### 搭配 `.env` 使用
`.env` 檔會**自動被 docker-compose 讀取**，不需要特別載入。可以放置常用變數如 image tag、port、密碼等。

---

## Mounts

Docker 用來管理容器資料掛載的機制稱為 **Mounts**，用以將資料從宿主機或 Docker 管理的存儲空間掛載到容器內部。主要有三種類型：

- **Volumes**  
  - 可已是 Docker 管理的命名卷（Named Volumes），也可以是匿名卷（Anonymous Volumes）
- **Bind Mounts**  
- **Tmpfs Mounts**

Volumes 是 Docker 用來**持久化和共享資料**的機制。因為容器本身是短暫的（ephemeral），容器內的檔案系統會隨容器刪除而消失，使用 Volumes 可以讓資料存放在容器外的地方，不會因為容器重啟或刪除而遺失。
Bind Mounts 直接將宿主機的檔案或目錄掛載到容器內。這種方式的資料位置不由 Docker 管理，適合開發時需要同步宿主機檔案。
Tmpfs Mounts 資料存放於記憶體（tmpfs），速度快但非持久化，容器停止時資料會消失。適合用於快取、暫存資料。

### 為什麼需要 Volumes？
- **資料持久化**：容器刪除不會影響資料
- **資料共享**：多個容器可以掛載同一個 volume 共享檔案
- **開發便利**：快速同步宿主機與容器檔案（Bind Mounts）


### Types of Mounts

| 類型        | 說明                                 | 範例                                  |
|-------------|------------------------------------|-------------------------------------|
| Volume | Docker 管理的 volume，名字自訂或由 Docker 自動產生 | `volumes: - db_data:/var/lib/mysql`  |
| Bind Mount   | 直接將宿主機目錄掛載到容器內        | `volumes: - ./app_data:/app/data`    |
| Tmpfs Mount  | 將資料放在記憶體中，容器停止資料消失。讀寫性能也較好 | 主要用於暫存或快取                   |

### 注意事項
- 使用 Bind Mount 時要注意權限問題，容器與宿主機的用戶權限可能不同
- Named Volume 適合資料庫、應用程式資料等重要資料持久化

---

## Docker Network（網路）

Docker 的 Network 用於讓容器彼此之間，或容器與宿主機之間進行通訊。當應用由多個服務組成（例如 Web + DB），透過 Docker 的網路功能可以讓它們安全而方便地互連。

### Network 的類型

| 類型 | 說明 |
|------|------|
| **bridge**（預設） | 適用於單一主機內的多個容器。容器會連到 Docker 自動建立的虛擬 bridge 網路，彼此可以用 container name 通訊 |
| **host** | 容器與宿主機共用網路，沒有網路隔離。Linux 限定，適用於需要效能或直接操作宿主機網路的情境 |
| **none** | 完全隔離，不配置任何網路介面 |
| **overlay** | 將多個 Docker daemons 連接在一起 |
| **macvlan** | 讓容器像一個實體主機，有自己的 MAC 位址與 IP |

### 為什麼 Docker Compose 的服務可以用名稱互連？

這是因為 Docker Compose 預設會建立一個 **user-defined bridge network**（不是預設的 `bridge` network），而 **user-defined bridge** 提供了以下額外能力：

- ✅ 支援 container 之間使用 container name（service name）進行 DNS 解析（例如用 `db` 連 db container）。
- ✅ 有隔離性，每個 Compose 專案的 network 名稱不同（預設為 `{project_name}_default`）。
- ❌ 而預設的 `bridge` network（即 `docker network ls` 看到的 `bridge`）**不支援 DNS 解析**，只能用 IP 連。