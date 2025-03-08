---
title: "磁碟管理"
date: 2024-04-24T00:00:43+08:00
draft: false

type: "post"
tags: ["linux"]
categories : ["linux"]
---

- 有關名詞
  - 扇區: 最小的儲存單位
  - block: 一次讀取的最小單位，是多個連續的扇區
  - inode
    - OS 用來記錄檔案的 metadata
    - 每個文件的 inode number 是唯一的
    - 可以用 `ls -li` 來看 inode number
      - inode data
        - 檔案的大小
        - 擁有者
        - 擁有者的 group
        - 權限
        - 修改時間
        - 文件的實體指針，指向 block

- 格式化分區
  - 主分區
  - 擴展分區
    - 邏輯分區
  - 默認分區 1~4 給主分區和擴展分區，邏輯分區從 5 開始
    - /dev/sda1、/dev/sda2 這種就是分區

- fdisk
    - 小於 2TB 的磁碟，可以用 fdisk，但是大於 2TB 的磁碟，要用 parted，且要用 GPT
    - `fdisk -l` 列出所有分區
    - `fdisk /dev/sda` 進入 fdisk
      - n 新增分區
        - 再設置 sector 的起始位置和結束位置
      - d 刪除分區
      - t 更改分區的 system id
      - w 寫入並且離開

- parted
    - `parted /dev/sda` 進入 parted
        - `mklabel gpt`
          - 可以把 disk 轉成 GPT
          - GPT 區分主分區和邏輯分區
        - `mkpart primary <start> <end>`
          - 創建一個 primary partition，從 start 到 end (MB)

- 軟硬連結
  - 軟連結
    - `ln -s <source> <destination>`
    - 如果刪除軟連結的檔案的話，不會影響原本的檔案
    - 源文件刪除後，軟連結失效
    - 支持資料夾
    - 支持跨文件系統
  - 硬連結
    - `ln <source> <destination>`
    - 一般情況，inode 和檔案名稱是一對一的關係
    - 軟連結 inode 號碼是不一樣的，代表是兩個個體，硬連結 inode 號碼是一樣的
    - 刪除硬連結對源文件沒有影響
    - 刪除源文件對硬連結沒有影響
      - 但是如果刪除所有硬連結，文件的連結數變成 0，則文件會被刪除
    - 不能對資料夾使用
    - 不能跨文件系統

- mkfs
  - 對分區進行格式化文件系統

- fsck
  - file system check
  - 檢查和修復文件系統

- lsblk
  - `lsblk -f` 列出所有分區的文件系統

- vfs
  - virtual file system
  - linux 可能有多種文件系統，在上面有一層 vfs，讓所有文件系統都可以通過一個統一的接口來訪問

- Mount
  - 設備要 mount 才可以使用，給設備提供一個出入口
  - `mount`
    - `-l` 列出所有已經 mount 的設備
    - `-t` 指定文件系統，不指定的話，會自動判斷
    - `-o` 一些有關於 mount 的參數
      - `async` 非同步讀寫，效率高，但是喪失安全性
      - `sync` 同步讀寫，效率低，但是讀寫安全
      - `atime/noatime` 是否要紀錄文件的訪問時間
    - `-r` read-only

- LVM
    - logical volume manager
    - 把一個或多個硬碟在邏輯上進行合併，可以動態調整大小
    - 硬盤的多個分區，由 LVM 統一管理為 volume group
    - 名詞
      - PP: physical partition
      - PV: physical volume
        - 通常一個 PV 對應一個 PP
        - PE: physical extends
          - PV 中可以分配的最小單位，同一個 VG 中，所有 PV 的 PE 大小都是一樣的
      - VG: volume group
        - 創建在 PV 上，可以劃分成多個 PV
      - LV: logical volume
        - 創建在 VG 上，可以動態擴容的分區
        - LE: logical extends
          - LV 中的基本單位，一個 LE 對應一個 PE
    - 創建
      - PP 階段
        - 用 fdisk 格式化，修改 system id 為 8e (預設是 83)
      - PV 階段
        - 用 pvcreate, pvdisplay 把 linux 分區轉成 PV
        - 指令
          - `pvcreate /dev/sda /dev/sdb`: 把 sda 和 sdb 轉成 PV
            - 適用硬碟和分區
          - `pvs`: 查看 PV
      - VG 階段
        - 用 vgcreate, vgdisplay 創建 VG
        - 指令
          - `vgcreate vg1 /dev/sda /dev/sdb`: 創建 VG vg1，用 sda 和 sdb
          - `vgs`: 查看 VG
          - `vgextend vg1 /dev/sdc`: 把 sdc 加入 vg1
          - `vgdisplay`: 查看 VG
      - LV 階段
        - 用 lvcreate, lvdisplay 創建 LV
        - 把 VG 分成多個 LV
        - 也要幫 LV 創建文件系統
        - 指令
          - `lvs`: 查看 LV
          - `lvextend -L +1000G /dev/vg1/lv1`: 把 lv1 增加 1000G
            - ex4 可以不用 umount
            - 還要 `resize2fs /dev/vg1/lv1` 來調整文件系統大小
              - 可以用 `df -h` 來檢查