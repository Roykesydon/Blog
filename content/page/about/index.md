---
title: About
description: 關於我
date: '2023-02-26'
lastmod: '2023-02-26'
menu:
    main: 
        weight: -90
        params:
            icon: user
---

Roykesydon
============

Education
---------

2023-2025 (expected)
:   **MSc, Computer Science and Information Engineering**; National Cheng Kung University

2019-2023
:   **BSc, Computer Science and Engineering**; National Taiwan Ocean University

Experience
----------

2020-2023
:   **Adjunct research assistants**; Advanced Computation Laboratory

Projects
--------------------

漁港即時漁船檢測
: 在漁港多處架設攝影機，透過 RTSP 取得攝影機畫面，達成自動化統計港口漁船的目標。後端結合 YOLOv4、FastAPI 以及一些影像處理的手法，將收到的攝影機畫面進行辨識。前端透過 Vue 來提供偵測的畫面結果，以及過往 48 小時的港口數據

船上漁工檢測
: 目的是想透過船上攝影機畫面的 ts 檔，自動化判斷哪些時間有漁工出現在畫面上，方便其他研究人員取得片中釣魚作業的片段。鑒於漁工衣著的特殊性，以及難以取得訓練資料，使用 pre-trained LightweightOpenPose model 結合各種過濾手段及 OCR 完成任務

購衣網站
: 個人 Side Project，透過 JWT 判斷權限。Nginx 負責反向代理及 web server。用 MariaDB 做 Replication，做 Master-slave 架構，最後用 Docker 把上述的東西和前後端包裝在各個 Container。

Competitive Programming Contest
----------------------------------------


2021 / 12
: 大學程式能力檢定 (CPE) - **解題: 7/7 題 (排名: 2/2459)**

2021 / 12 
: 2021 東華杯程式設計競賽大專組  - **第二名**


2021 / 10
: 2021 National Collegiate Programming Contest  - **第四名**

2020 / 12
: 2020 彰師大中區程式競賽  - **第三名**

2020 / 11
: The 2020 ICPC Asia Taipei-Hsinchu Site Programming Contest  - **銀牌 (排名: 13/101)**


Skills
---------------------
Language
: C、C++、Python、Javascript、Java、HTML、CSS、PHP、SCSS

Framework
: Vue、Laravel、Pytorch、Flask、FastAPI

Database
: MySQL、MongoDB

Others 
: Git、Docker、Node.js