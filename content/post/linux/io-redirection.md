---
title: "IO Redirection"
date: 2023-01-21T02:20:43+08:00
draft: true

type: "post"
tags: ["linux"]
categories : ["linux"]
---

# PPFDT
- per process file descriptor table
- 每個 process 都有
- 存放 file descriptors
    - file descriptors 是一個唯一的整數，用來識別作業系統上的 open file
- 0, 1, 2 是 Standard input / ouput / error
- 大小受限於 OPEN_MAX，亦即能同時間能開的最多檔案數

# Redirection

## Input redirection
- $ wc < /etc/passwd
    - 把 wc 的 PPFDT 的 stdin 改成 /etc/passwd
    - 如果是 $ wc /etc/passwd，則是在 PPFDT 追加 /etc/passwd

## Ouput redirection
- $ wc > f1
    - 把 wc 的 PPFDT 的 stdout 改成 f1

## Input & output redirection

兩個可以同時用
- $ cat < f1 > f2
- \>\> 可以 append
- $ < f1 cat > f2
    - 可以亂換位置

## Error redirection
- $ find / -name f1 2> error 1> outputs
    - 這樣就會把那些 Permission denied 的給到 errors，成功的給到 outputs
- 2>/dev/null
    - /dev/null 會把丟進來的東西都丟棄

## Copy Descripter

- 這兩者等價
    - $ cat f1 1>op_err 2>op_err 
    - $ cat f1 1>op_err 2>&1
        - make 2 a copy of 1