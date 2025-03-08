---
title: "Linux 瑣事"
date: 2023-01-19T01:50:07+08:00
draft: false
description: "一些不想單獨分一篇又有關 Linux 的東西放這"
type: "post"
tags: ["linux"]
categories : ["linux"]
---

# VM

A software implementation of a machine

1. System VM
    - 提供可以執行 GuestOS 的 complete system platform
2. Process VM
    - 像一個一般的 app 一樣在 hostOS 跑，支援單一個 process

## Hypervisor

又稱虛擬機器監視器（英語：virtual machine monitor，縮寫為VMM）
用來管理 VM

允許多個 GuestOS 跑在 host computer

- Type-1

    - bare-metal hypervisors
    - 直接在硬體上執行
- Type-2

    - hosted hypervisors
    - 在 hostOS 上執行


# directories

1. Binary
    - e.g., bin, sbin, lib, opt
        - bin: 有關 user 的指令
        - sbin: 管理員會用的指令
        - opt: optional software，多數機器中這是空的

2. Configuration
    - e.g., boot, etc, 
3. Data
    - e.g., home, root, srv, media, mnt, temp
4. In memory
    字面上的意思，不在 hard disk，在 memory
    - e.g., dev, proc, sys
5. System Resources
    - e.g., usr
6. Variable Data
    - e.g., var

