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
- 常被用來和傳統的 REST API 比較，具備查詢更加靈活等特性
- 有在使用的公司
    - Facebook
    - GitHub
    - Twitter
    - ...

## 和 REST API 的主要差別

- Single Endpoint
    - 和 REST API 對於不同 resource 需要不同 endpoint 不同，GraphQL 對於所有 resource 都是從同一個 endpoint 進行存取
    - 但 GraphQL 不能輕易地用 HTTP caching，因為現在只剩一種 URL 了

- 解決 Under-fetching 和 Over-fetching 問題
    - Under-fetching
        - 一個 API call 沒辦法取得所有想要的資料，需要多次 API call
        - 假如要用 RESTful API 取得一個文章的作者，可能得先取得文章，再取得作者，這樣就需要兩次 API call
            - 但 GraphQL 可以在一次 API call 中取得文章和作者，透過 nested query

    - Over-fetching
        - 一個 API call 取得的資料比想要的還多，造成資源浪費
        - GraphQL 可以透過 query 定義只想取得的欄位

## 使用

和 RESTful API 不同，需要特別架個 GraphQL server，可以考慮用 Apollo Server

要定義不同 Data type 的 schema、relationship，以及寫對應不同 query 的 resolver

### Query

可能會是長這樣的東西

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
```

### Mutation

新增、修改、刪除資料都屬於這塊

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