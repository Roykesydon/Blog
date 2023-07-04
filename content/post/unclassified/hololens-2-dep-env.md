---
title: "Hololens 2 開發環境設置"
date: 2023-07-03T00:00:01+08:00
draft: false
description: ""
type: "post"
tags: ["unity", "mr", "mrtk", "hololens"]
categories : ["unclassified"]
---

## 前言

要弄 Hololens 2 的開發環境要一堆有的沒的麻煩東西，紀錄一下避免之後要重裝

原本很怕版本對不上很麻煩，但實際用起來好像還好

注意，這不是最小安裝，有些東西我不確定是不是必要的，但我怕麻煩就裝了

後續請參考微軟的教學

## 計畫版本紀錄 (2023/07/03)
- Unity
    - 2020.3.48f1 (LTS)
- MRTK
    - 2.8.3
- Mixed Reality OpenXR Plugin
    - 1.8.0

## 我個人的版本紀錄 (2021/07/03)
- Unity
    - 2021.3.27f1 (LTS)
        - 我沒注意到我一開始選錯，但也可以跑，之後
- MRTK
    - 2.8.3
- Visual Studio
    - 2022
- Mixed Reality OpenXR Plugin
    - 1.8.0

## 作業系統要求

- 必須是 Windows 專業版以上，因為要用 Hyper-V
    1. 先去 BIOS 開 Virtualization Technology
    2. 開啟 Hyper-V

## 前置步驟

1. 安裝 windows SDK
    - 聽說裝完最新的後，建議再多裝幾個版本
        - 我個人只有裝最新的

2. 安裝 visual studio
    - 好像會根據 MRTK 的版本有對應的版本要求，不能無腦裝最新
    - 據說要選 「C++ 開發」和「通用 Windows 平台開發」
        - 右邊好像還要選
            - USB 設備連接
            - C++ 通用 Windows 平台工具

3. 安裝 Hololens 2 模擬器
    - 這是給 build 好的程式用的，不是在說 Unity Editor 裡面的手

4. 安裝 Unity
    - 建議透過 Unity Hub 管理 Unity 版本
    - 據說裝的 Unity 要裝以下兩個 module
        - Universal Windows Platform Build Support
        - Windows Build Support (IL2CPP)

5. Windows 和 Hololens 都要開啟「開發者模式」

6. 下載 Mixed Reality Feature Tool
    - 注意看這不是 MRTK
    - 這可以往 Unity 專案導入 MRTK
    - 可以導入 MRTK 2.6 以後的工具包

## 創建專案

1. Unity 開個 3D 專案
    - File -> Build Settings
    - 選擇 Universal Windows Platform
    - 點選 Switch Platform

2. 開啟 Mixed Reality Feature Tool
    - 針對專案安裝 MRTK
        - 必裝 
            - MRTK Foundation
            - Mixed Reality OpenXR Plugin

        - 可選
            - MRTK
                - Examples
                - Extensions
                - Tools
                - TestUtilities

## 在模擬器上執行

這坑真的有夠多，我結合上 stack overflow 的解法，所用的步驟:

1. 要用管理員模式開 Visual Studio，不然有可能遇到權限問題

2. Visual studio 要部屬程式的時候，會自己開一個 Hololens 2 Simulator，但他會開超久，然後造成 Timeout，無法部屬，部屬失敗後不要選繼續，也不要關掉模擬器

3. 這時候再看情況按 實心 / 空心綠色三角形 (without debugging)

4. 有可能可以 deploy，但運行時有問題，此時按紅色方塊終止，繼續綠色三角形，不要關掉模擬器