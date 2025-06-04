---
title: "JWT vs Session"
date: 2025-05-30T00:00:17+08:00
draft: false
description: "JWT 和 Session 的比較"
type: "post"
tags: ["security"]
categories : ["security"]
---

## 簡介

在 Web 認證中，JWT（JSON Web Token）與 Session 是常見的兩種狀態管理方式。它們皆可用於儲存用戶登入狀態，避免每次請求都需重新登入。

因為有些 Session 是 Client-Side Session，將 Session 資料儲存在客戶端，所以這邊特別說下面說的都是 Server-Side Session。

## 基本差異

| 項目         | Session                              | JWT                                 |
|--------------|---------------------------------------|--------------------------------------|
| 儲存位置     | 伺服器端                             | 客戶端 |
| 擴充性       | 相對不易橫向擴展（需共享 session store） | 容易橫向擴展                          |
| 安全性       | 安全，session ID 不應被竊取          | 資料公開，需妥善簽名與加密             |
| 無狀態性     | 有狀態（server 儲存資料）            | 無狀態（token 本身攜帶資訊）           |
| 登出控制     | 容易：刪除伺服器端 session            | 困難：需另設黑名單或縮短 token 期限     |

## 優點與缺點

### Server-Side Session

- ✅ 優點：
  - 不會在客戶端暴露使用者資料
  - 可以在 server 端強制失效（例如 logout）
- ❌ 缺點：
  - Server 需儲存每位用戶的 session（可導致記憶體負擔）
  - 多伺服器時需使用 Shared Session Store（如 Redis）

### JWT

- ✅ 優點：
  - 無狀態，伺服器不需儲存 session 資料
  - 易於水平擴展
- ❌ 缺點：
  - Token 無法強制失效（需依賴過期或黑名單）
  - 如果 token 泄露，容易被濫用
  - 資料容易過大，導致請求肥大

## 使用 JWT 時機建議

- 用作一次性 token。
  - 假如 A server 上有 Auth Service，B server 上有 Resource Service，A server 可以提供短期的 JWT 給 B server，B server 只需驗證 JWT 是否有效即可。
  - 如果簽章使用的是非對稱加密（如 RSA），則 B server 只需知道 A server 的公鑰即可驗證 JWT。不用擔心 A server 的私鑰被其他 server 洩漏。

- 如果想取代 session，幾乎不存在什麼好處
  - 唯一有的只有 stateless 在分散式架構下的優勢
  - 但是 session 也可以透過 Redis 等方式實現 shared session

## JWS and JWE
根據 RFC 7519：
```
JWT 是一種 compact claims representation format。
JWT 把要傳輸的 claims 編碼成 JSON 物件，可用作 JWS 結構的 payload，或是 JWE 結構的 plaintext。
JWT 總是以 JWS Compact Serialization 或 JWE Compact Serialization 表示
```

- **JWS (JSON Web Signature)**
  - 常說的 JWT 就是 JWS 但是 payload 限定為 JSON 格式。
  - 一種 JWT 的實作，透過簽名來確保資料的完整性和來源。
- **JWE (JSON Web Encryption)**
  - 一種 JWT 的實作，透過加密來保護資料的機密性。
  - 如果需要在 JWT 中儲存敏感資料，建議使用 JWE 來加密這些資料。