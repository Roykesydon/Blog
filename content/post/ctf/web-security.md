---
title: "Web Security"
date: 2024-06-28T00:00:17+08:00
draft: true
description: "常見的 Web attack 和防禦方法"
type: "post"
tags: ["ctf", "security"]
categories : ["ctf"]
---

## File Uploaded Vulnerability
### 防禦方法
- 不要允許使用者上傳任何可執行的檔案
- 檢查 file type 和 file extension
  - file type 指的是 header 的 Content-Type
- 用某些套件分析檔案，並重新創建和重新命名檔案

## Code Execution Vulnerability
- 允許攻擊者執行 OS command

### 防禦方法
- 不要使用危險的 function
- 透過 filter 檢查輸入
  - 比如利用 regex

## File Inclusion Vulnerability
### LFI (Local File Inclusion) Vulnerability
- 攻擊者可以讀取伺服器上的任何檔案（包含 /var/www 外的檔案）
- 透過輸入讀其他檔案的時候沒有檢查檔案路徑
- 可以用來讀 /proc/self/environ，可能會存在一些可以透過 request 修改的變數。植入PHP 程式碼便有可能被執行

### RFI (Remote File Inclusion) Vulnerability
- 和 LFI 類似，但是檔案來自外部
- 可以在當前 server 執行其他 server 的 php 程式碼
- 可以在其他 server 以 .txt 存 php file

### 防禦方法
- 避免 remote file inclusion
  - php 的話可以關掉 allow_url_fopen 和 allow_url_include
- 避免 local file inclusion
  - 用 static file inclusion，不要透過變數去取得檔案位置

## SQL Injection
### 防禦方法
- 使用 prepared statement

## XSS (Cross Site Scripting)
- 允許攻擊者在網頁上執行 javascript code
- 執行在 client 端，不是 server 端
- Main types
  - Reflected XSS
    - 用 URL 攻擊
  - Persistent/Stored XSS
    - 攻擊的程式碼存在 database 或是某個 page
  - DOM-based XSS
    - 利用前面的方法，透過開發者不當操作 DOM 來攻擊
    - ex: 攻擊者透過 .innerHTML 放入 script tag

### Exploitation
- BeEF Framework
  - 可以把目標 hook 到 beef
  - 可以透過 beef 對被 hook 的目標做各種操作

### 防禦方法
- 盡量避免讓 user 的輸入直接顯示在網頁上
- 在 insert 到網頁前，escape 所有不信任的輸入
  - 把這些 character 轉換成 HTML 用的格式
    - ex: `<` -> `&lt;`

## CSRF (Cross Site Request Forgery)
### 防禦方法
- Anti CSRF token
  - 生表單的時候也生一個 token，並記住，request 要帶上這個 token
  - unpredictable
  - can't be reused
  - 前後端分離
    - 後端生
      - CORS 不要接受所有來源，讓前端取得 token
    - 前端生
      - 要發 request 的時候把 cookie 改成和 token 一樣的值


## Backdoor
- msfvenom
- msfconsole

## Anti-Virus
- Principle
  - Static Analysis
    - 和已知的 malware 比對
    - 可以利用 packers, encoders, abfuscators 來讓程式更加獨特
  - Dynamic(Heuristic) Analysis
    - 在 sandbox 中執行，看他的行為
    - 要幫程式增加安全的操作
    - 延遲 Payload 執行的時間