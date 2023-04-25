---
title: "重構 Refactoring"
date: 2023-04-25T14:26:17+08:00
draft: false
description: ""
type: "post"
tags: ["software-engineering", "software-design"]
categories : ["software-engineering"]
---

## 重構

在不改變軟體行為的情況下，對軟體內部構造進行改善

## Code Smell
也稱 Bad Smell，代表程式碼中需要重構的部分

### Duplicated Code

- 重複程式碼
    - 在同個 Class
        - Extract Method
    - 在不同 Class
        - Extract Class

### Long Method
- 用 Extract Method 拆解過長的 function

### Long Parameter List
- Preserve Whole Object
    - 把來自同一物件的資料直接該物件取代
- Introduce Parameter Object
    - 把相關的資料包成一個 Object

### Large Class
- 一個 Class 有太多 fields / methods / lines

### Magic Number
- 特殊數值直接用數字表示，日後修改每個地方都要改

### Lack of Comments
- 加註解的好時機：寫程式前寫上

### Switch Statements
- 可利用「多型 (Polymorphism)」解決

### Divergent Change
- 一個類別有太多改變的原因
- 盡量讓其遵守 SRP

### Shotgun Surgery
- 某個責任被分散到大量的 Class 身上，使修改其時要大量修改

### Feature Envy
- 存取別的 Object 的 Data 的情形比自己的還頻繁
- 這方法可能應該屬於另一個 Object

### Data Clumps
- 常一起出現的資料群應該被單獨抽成一個 Class

### Primitive Obsession
- 過度使用基本類別，造成 Shotgun Surgery

### Message Chains
- Client 請求 A 物件，A 物件又請求 B 物件

### Lazy Class
- 把冗員類別移除

### Temporary Field
- Instance variable 只有在特殊情形才被使用，應該改為區域變數或參數

### Inappropriate Intimacy
- Classes 間頻繁讀取對方資料
- 理解程式要同時看懂兩者

### Alternative Classes with Different Interfaces
- 兩個 Class 具有功能相同、命名不同的 function
- 可汲取共同部分為 Super Class 來解決