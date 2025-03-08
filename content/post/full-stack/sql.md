---
title: "SQL 語法筆記"
date: 2024-08-25T00:00:17+08:00
draft: false
description: "記錄一些簡單常見的 SQL 語法"
type: "post"
tags: ["sql"]
categories : ["full-stack"]
---

## 邏輯上的執行順序
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. DISTINCT
6. SELECT
7. ORDER BY

## DDL
- Data Definition Language
- 用來定義資料庫的結構
### Create Database
```sql
CREATE DATABASE database_name;
```

### Create Table
```sql
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype,
   ....
);
```
- Data types: 
    - INTENGER, VARCHAR(size), TEXT, etc.
    - VARCHAR
      - Variable-length character string

### Constraints
- ```sql
  CREATE TABLE table_name (
      column1 datatype constraint,
      column2 datatype constraint,
      column3 datatype constraint,
     ....
  );
  ```
- Auto Increment
  - 用來自動增加一個數值
  - 通常用在 primary key
- Primary Key
  - 用來唯一識別一筆資料
- Foreign Key
  - 用來避免資料不一致
  - 必須是另一個 table 的 primary key
  - 可以是 NULL
  - 可以設置 reference action
    - 比如 `ON DELETE CASCADE`
- Not Null
  - 用來限制 column 不可以是 NULL
- Unique
  - 不像 primary key，可以有 null
- Check
  - 用來限制 column 的值，可以自己寫條件
  - 可以用在多個 column
## DCL
- Data Control Language
- 用來控制資料庫的存取權限

## DQL
- Data Query Language
- 用來查詢資料庫中的資料

### Select
```sql
SELECT column1, column2, ... FROM table_name;
```
- `*` 代表所有的 column

#### column
- column 也可以利用 operator
  - ```sql
    SELECT column1 + column2 FROM table_name;
    ```
- 可以使用 `AS` 來改變 column 的名稱
  ```sql
  SELECT column1 AS new_name FROM table_name;
  ```

#### WHERE
- 針對 row 的條件過濾
- ```sql
  SELECT column1, column2, ... FROM table_name WHERE condition;
  ```

##### ANY, ALL
- 用來比較子查詢的結果
- ```sql
  SELECT column1, column2, ... FROM table_name WHERE column1 > ANY (SELECT column1 FROM table_name);
  ```
- 如果用 > ANY subquery，而 subquery 沒有任何結果，那麼就會回傳 false，因為你的數值沒有比任何一人都高（要至少一人）
- 如果是 > ALL subquery，那麼就是要比所有人都高，所以如果 subquery 沒有任何結果，那麼就會回傳 true，你的數值比裡面的東西都高

#### JOIN
- 用來結合兩個 table
- ```sql
  SELECT column1, column2, ... FROM table1 JOIN table2 ON table1.column = table2.column;
  ```
- types
  - INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN

#### GROUP BY
- 用來將資料分組
- 針對 group 的條件過濾
- ```sql
  SELECT column1, column2, ... FROM table_name GROUP BY column1;
  ```
- select 的 column 必須是 group by 的 column 或是 aggregate function
##### HAVING
- 用來過濾 group by 的結果
- 要有 group by 才能使用
- ```sql
  SELECT column1, column2, ... FROM table_name GROUP BY column1 HAVING condition;
  ```

#### ORDER BY
- ```sql
  SELECT column1, column2, ... FROM table_name ORDER BY column1;
  ```
- 可以指定升冪或降冪
  - `DESC`, `ASC`

#### LIMIT & OFFSET
- 用來限制查詢結果的數量

#### DISTINCT
- 用來去除重複的資料

#### CASE
- 用來做條件判斷
- ```sql
  SELECT column1, column2, ... CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result
  END
  FROM table_name;
  ```

#### 查詢結果集合運算
##### UNION
- 用來結合兩個查詢結果
- ```sql
  (SELECT column1, column2, ... FROM table1)
  UNION
  (SELECT column1, column2, ... FROM table2);
  ```
- `UNION ALL` 會包含重複的資料
  - `UNION` 會自動去除重複的資料
- 限制
  - 每個查詢的 column 數量必須相同
  - 每個查詢的 column 的資料型態必須相同
  - column 的順序必須相同
##### INTERSECT
- 用來取兩個查詢結果的交集
##### EXCEPT
- 用來取兩個查詢結果的差集
##### ALL
- 要加這個才會包含重複的資料

#### Subquery
- select, from, where 等等都可以有 subquery
- 他可以視情況回傳一個值，也可以回傳一堆 row，或是一個 column（一維向量
- 可以用 outer query 的 column 來當作 subquery 的條件

##### Correlated Subquery
- 一個 subquery 用到 outer query 的 value
- 可能導致效能問題，比如每一筆資料都要執行一次 subquery
  - 像是兩層 for loop
- flattening
  - 寫成等效的 flat query
## DML
- Data Manipulation Language
- 用來操作資料庫中的資料

### Insert
```sql
INSERT INTO table_name (column1, column2, column3, ...) VALUES 
  (value1, value2, value3, ...),
  (value1, value2, value3, ...)
```
- 可以一次插入多筆資料

### Update
```sql
UPDATE table_name SET column1 = value1, column2 = value2 WHERE condition;
```

### Delete
```sql
DELETE FROM table_name WHERE condition;
```

## Operators
- Arithmetic Operators
- Comparison Operators
- Bitwise Operators
- String Operators

## Functions
- Math Functions
- Date Functions
- String Functions