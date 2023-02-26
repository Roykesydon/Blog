---
title: "Shell"
date: 2023-01-19T23:00:02+08:00
draft: false
description: "有關 Shell 的一些東西"
type: "post"
tags: ["linux", "shell"]
categories : ["linux"]
---

# Features
- Process control
- Variables
- Flow control
- Functions
- File & cmd name completions
- Cmd line editng
- Cmd history

# Command Mode
- Interactive
- Non- Interactive

# Command Type
- internal / Builtin command 
    - 指令的程式碼是 shell 的一部分
        - e.g., cd, exit
    - 不會產生 child process
    - 有些 internal command，比如 echo, pwd，會 internal 和 external 都有實作

- external command
    - 指令的程式碼在硬碟上的某個 binary file
        - e.g., clear, ls
    - 會產生 child process

# Common Commands

比較實用或常用的

- grep 

    找字詞

    grep <string/pattern> <file>

    - -i 大小寫不敏感
    - -v 不包含關鍵字的

- cut
    找 column
    - -f 找哪些 column
    - -d 分隔符是什麼

- 比較兩個檔案
    - comm

        顯示 file1 獨有的列、 file2 獨有的列、file1 和 file2 共有的列
    
    - cmp, diff

        回傳不一樣的列資訊

- unset

    把指定的變數移除掉

- tee

    吃 stdin 輸出到 stdout 和其他檔案

- less

    讀檔案用

# Expansions
1. White space
2. Control Operators
    - ;
        - 讓指令接著執行
    - &
        - 放在結尾，讓指令在背景執行
    - &&
        - logical AND
    - ||
        - logical OR

            前面失敗才會跑後面
    - \#
        - 註解用
    - \
        - escape special characters
        - 放結尾好換行繼續輸入
    - $?
        - 一個特別的變數，有上個指令的 exit code
3. Shell variables
    - User defined
    - Env var
4. Shell history
5. File Globing
    - *, ?, [], -, !