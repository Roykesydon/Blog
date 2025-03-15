---
title: "GraphQL 簡介"
date: 2023-08-22T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: []
categories : ["full-stack"]
---

## 簡介

- Meta 在 2015 年公開的 API Query Language
- 相較於傳統的 REST API，具備更靈活的查詢能力
- 可讓客戶端精確地獲取所需的資料，避免多餘的請求和回應
- 被多家公司採用，如：
    - Facebook
    - GitHub
    - Twitter
    - ...

## GraphQL 與 REST API 的主要差異

- **Single Endpoint**
    - REST API 針對不同資源 (resource) 需要不同的 endpoint，而 GraphQL 透過單一 endpoint 存取所有資源
    - 但 GraphQL 由於僅有一個 URL，無法直接利用 HTTP caching 進行快取，而是依賴 client-side caching 或 persistent queries 來優化效能


- **解決 Under-fetching 和 Over-fetching 問題**
    - **Under-fetching**
        - 一個 API call 無法取得所有需要的資料，導致需要多次 API call
        - 例如，使用 RESTful API 取得一篇文章及其作者資訊，可能需要先請求文章資料，再請求作者資料
        - GraphQL 透過 nested query 可以在單次 API call 內獲取文章及作者資訊
    
    - **Over-fetching**
        - API 回應的資料超過實際所需，造成資源浪費
        - GraphQL 允許客戶端指定僅需要的欄位，避免傳輸過多無用資料

## GraphQL 的運作方式

GraphQL 需要特別架設 GraphQL server，可考慮使用 Apollo Server、Express + graphql 套件等方式實作

- 需定義 schema 來描述不同的資料類型 (Data type) 及其關聯 (relationship)
- 透過 resolver 來處理查詢和資料變更

### Query (查詢)

GraphQL 的查詢語法允許客戶端精確地獲取所需的資料，例如：

```graphql
query postQuery($id: ID!) {
    post(id: $id) {
        id
        title
        content
        author {
            id
            name
        }
    }
}

### Mutation (變更資料)

GraphQL 透過 Mutation 來處理新增、修改、刪除資料，例如新增文章的請求：

```graphql
query addPost($post: AddPostInput!) {
    addPost(post: $post) {
        id
        title
        content
        author {
            id
            name
        }
    }
}
```