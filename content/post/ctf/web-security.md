---
title: "Web Security"
date: 2024-06-28T00:00:17+08:00
draft: false
description: ""
type: "post"
tags: ["ctf", "security"]
categories : ["ctf"]
---

## Information Gathering
- Whois Lookup
  - get owner information of a domain
- Netcraft site report
  - get technology stack of a website
- Robtex DNS Lookup
  - get information of a domain
- Exploit database
  - search for exploits
- knockpy
  - subdomain enumeration
- dirb
  - web content scanner
  - 搜索隱藏的檔案
- maltego
  - data mining tool
  - 有大量套件，可以用來搜集各類資訊，而且有視覺化

## File Uploaded Vulnerability
- weevely
  - web shell
  - 可以遠端控制
  - 有些情況下就算上傳的檔案是 filename.php.jpg 依然可以執行
- Burp
  - proxy
  - intercept request
  - change request

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

## XSS (Cross Site Scripting)
- 允許攻擊者在網頁上執行 javascript code
- 執行在 client 端，不是 server 端
- Main types
  - Reflected XSS
    - 特別設計過的 URL
  - Persistent/Stored XSS
    - 存在 database 或是某個 page
    - 有些網站會替換掉引號，但也有其他方法不用引號，比如 fromCharCode
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

## Backdoor
- msfvenom
  - 產生 payload
    - payload 是指 backdoor 中用來執行各種操作的程式碼
  - 可生成的 payload 命名格式
    - platform/type/communication_channel
      - type
        - meterpreter
          - Metasploit 設計的
          - 會加密通訊
          - 提供豐富的功能
      - communication_channel
        - 通常是 direction_protocol
          - direction
            - reverse
              - 連到攻擊者的機器開的 port
            - bind
              - 開 port 等待連接
          - protocol
    - ex: windows/shell/reverse_http
      - 
        - 透過 http 連接

- msfconsole
  - Metasploit Framework
  - 搭配 msfvenom 開 port 監聽
    - `use exploit/multi/handler`
      - set payload
        - `set payload windows/metepreter/reverse_https`

### Anti-Virus
- Principle
  - Static Analysis
    - 和已知的 malware 比對
    - 可以利用 packers, encoders, abfuscators 來讓程式更加獨特
  - Dynamic(Heuristic) Analysis
    - 在 sandbox 中執行，看他的行為
    - 要幫程式增加安全的操作
    - 延遲 Payload 執行的時間