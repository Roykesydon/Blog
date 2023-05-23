---
title: About
description: 關於我
date: '2023-05-09'
menu:
    main: 
        weight: -90
        params:
            icon: user
---

<!-- Roykesydon -->
<!-- ============ -->

Education
---------

2023-2025 (expected)
:   ****MSc, Computer Science and Information Engineering****; National Cheng Kung University

2019-2023
:   ****BSc, Computer Science and Engineering****; National Taiwan Ocean University

Awards and Examination
----------------------------------------

2020 / 11
: Silver Medal (Rank: 13/101), The 2020 ICPC Asia Taipei-Hsinchu Site Programming Contest 

2021 / 12
: solved: 7/7 problems (Rank: 2/2459), 大學程式能力檢定 (Collegiate Programming Examination, CPE)

2021 / 10
: $4^{th}$ place, 2021 National Collegiate Programming Contest (NCPC)

2020 / 12
: $3^{rd}$ place, 2020 中區程式設計競賽 (Central Collegiate Programming Contest, CCPC)

2021 / 12 
: $2^{nd}$ place, 2021 東華杯程式設計競賽大專組 ( National Dong Hwa University Programming Contest)


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

Experience
----------

2020-2023
:   ****Adjunct research assistants****; Advanced Computation Laboratory

Working Experience
----------

Real-time Fishing Vessel Detection at the Fishing Port
: Multiple cameras are installed at the fishing port to obtain the camera images through RTSP and achieve the automated counting of fishing vessels at the port. The backend integrates YOLOv4, FastAPI, and some image processing techniques to recognize the received camera images. The frontend uses Vue as framework to provide detection results and harbor data for the past 48 hours.

Fisherman Detection on Fishing Boats
: The goal is to automatically identify the times when fishermen appear in the ts video files from the cameras on the fishing boats. This makes it easier for other researchers to obtain clips of fishing operations. Due to the clothing worn by fishermen is different from what is commonly worn by the general public, and the difficulty of obtaining training data, a pre-trained LightweightOpenPose model is used in combination with various filtering methods and OCR to complete the task.

Geospatial Data Visualization
: The original map production process is streamlined by using PyQGIS to write custom scripts, which results in a significant reduction of repetitive work in map production.

Side Projects
--------------------

RoyKesyShop
: This is an online clothing store that uses JWT to verify user permissions. Nginx is responsible for reverse proxying and web serving, while MariaDB is used for replication in a master-slave architecture. Finally, Docker is used to package the above components, along with the frontend and backend, into separate containers.

    ![](https://github.com/Roykesydon/RoyKesyShop/blob/main/demo_pictures/home_dark.png?raw=true)

    ![](https://github.com/Roykesydon/RoyKesyShop/blob/main/demo_pictures/shop_1.png?raw=true)


Roykestereo
: This is a cloud-based music player that offers the ability to upload music locally, as well as download and listen to music from the cloud. The backend uses Fourier transform and other processing techniques to compute the spectrum of music at each moment. In addition to basic features, there is also a chat room function supported by socket.io, and MongoDB is used for data access.

    ![](https://github.com/Roykesydon/Roykestereo/blob/main/demo/home.png?raw=true)

    ![](https://github.com/Roykesydon/Roykestereo/blob/main/demo/current_playing.png?raw=true)

StellarTrack
: This is a web frontend project without a backend, made using Three.js and Bootstrap, displaying the changing paths of the sun's rotation in different latitudes and regions

    ![](/Blog/images/about/StellarTrack-1.jpg)

    ![](/Blog/images/about/StellarTrack-2.jpg)

WeAreFamily
: This is a platform that allows people to find others to crowdfund with. The frontend is mainly composed of JavaFX, while the backend uses Flask as the framework. Users can post to find others to crowdfund with, or join other people's posts. Users can also send and receive chat messages in real time, with notifications appearing on their operating system.

    ![](/Blog/images/about/WAF-1.jpg)

    ![](/Blog/images/about/WAF-2.jpg)


