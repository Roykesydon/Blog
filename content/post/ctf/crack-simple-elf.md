---
title: "跳過密碼字串比對"
date: 2023-03-07T14:26:17+08:00
draft: true
description: ""
type: "post"
tags: ["ctf","binary-exploitation"]
categories : ["ctf"]
---

# Assembly language
- Control flow
    - jumps, branches, calls
        - jmp, jne, je, bne, be, call
        - branch 就是根據 status flag 而 jump
            - je 0x33 代表「如果 zero flag 是 1 就跳到 0x33」
        - call 是 unconditional GOTO，但會把下一個 address 放到 stack
            - 那 RET instruction 可以晚點把它取出，並回到那邊

- status flag
    - 在 register 上的多數 operation，比如加減法，會對 status flags 產生影響
    - 只有很少的 status flags，而且他們通常存在在一個 special register 上
    - 範例
        - zero flag
            - 上個運算的結果是不是 0，在一些條件判斷很常用該 flag

## Register
- 從組合語言的角度來看，是一些有固定 size 的全域變數
- special register
    - Program Counter
        - 記錄下個要執行的 instruction
        - 別名
            - PC
            - Intel x86 叫 Instruction Pointer
                - 根據 16/32/64 bits，稱為 IP/EIP/RIP 
    - Stack pointer
        - SP, ESP, RSP
    - Base Pointer
        - BP, EBP, RBP




# 繞過字串比對

該程式吃一個參數，比對是不是密碼

我們要透過 gdb 從執行檔觸發 printf("Access Granted!\n");

- 程式碼:
    ```c
    #include <string.h>
    #include <stdio.h>

    int main(int argc, char *argv[]) {
        if(argc==2) {
            printf("Checking License: %s\n", argv[1]);
            if(strcmp(argv[1], "AAAA-Z10N-42-OK")==0) {
                printf("Access Granted!\n");
            } else {
                printf("WRONG!\n");
            }
        } else {
            printf("Usage: <key>\n");
        }
        return 0;
    }
    ```
    - 來源: https://github.com/LiveOverflow/liveoverflow_youtube/blob/master/0x05_simple_crackme_intro_assembler/license_1.c
    -   ```gcc ./test.c -o ./test -Wall```
        - -Wall 可以顯示所有警告
    
輸入 ```gdb ./test``` 

可以透過 ```disassemble main``` 來顯示 main function 的 assembler instruction

可以用 ```set disassembly-flavor intel``` 來換個風格

```
Dump of assembler code for function main:
   0x0000000000001189 <+0>:     endbr64
   0x000000000000118d <+4>:     push   rbp
   0x000000000000118e <+5>:     mov    rbp,rsp
   0x0000000000001191 <+8>:     sub    rsp,0x10
   0x0000000000001195 <+12>:    mov    DWORD PTR [rbp-0x4],edi
   0x0000000000001198 <+15>:    mov    QWORD PTR [rbp-0x10],rsi
   0x000000000000119c <+19>:    cmp    DWORD PTR [rbp-0x4],0x2
   0x00000000000011a0 <+23>:    jne    0x11fb <main+114>
   0x00000000000011a2 <+25>:    mov    rax,QWORD PTR [rbp-0x10]
   0x00000000000011a6 <+29>:    add    rax,0x8
   0x00000000000011aa <+33>:    mov    rax,QWORD PTR [rax]
   0x00000000000011ad <+36>:    mov    rsi,rax
   0x00000000000011b0 <+39>:    lea    rdi,[rip+0xe4d]        # 0x2004
   0x00000000000011b7 <+46>:    mov    eax,0x0
   0x00000000000011bc <+51>:    call   0x1080 <printf@plt>
   0x00000000000011c1 <+56>:    mov    rax,QWORD PTR [rbp-0x10]
   0x00000000000011c5 <+60>:    add    rax,0x8
   0x00000000000011c9 <+64>:    mov    rax,QWORD PTR [rax]
   0x00000000000011cc <+67>:    lea    rsi,[rip+0xe47]        # 0x201a
   0x00000000000011d3 <+74>:    mov    rdi,rax
   0x00000000000011d6 <+77>:    call   0x1090 <strcmp@plt>
   0x00000000000011db <+82>:    test   eax,eax
   0x00000000000011dd <+84>:    jne    0x11ed <main+100>
   0x00000000000011df <+86>:    lea    rdi,[rip+0xe44]        # 0x202a
   0x00000000000011e6 <+93>:    call   0x1070 <puts@plt>
   0x00000000000011eb <+98>:    jmp    0x1207 <main+126>
   0x00000000000011ed <+100>:   lea    rdi,[rip+0xe46]        # 0x203a
   0x00000000000011f4 <+107>:   call   0x1070 <puts@plt>
   0x00000000000011f9 <+112>:   jmp    0x1207 <main+126>
   0x00000000000011fb <+114>:   lea    rdi,[rip+0xe3f]        # 0x2041
   0x0000000000001202 <+121>:   call   0x1070 <puts@plt>
   0x0000000000001207 <+126>:   mov    eax,0x0
   0x000000000000120c <+131>:   leave
   0x000000000000120d <+132>:   ret
End of assembler dump.
```

可以先畫 control flow graph，分析每塊的運作情形，或找軟體生，比如在 MacOS 可以用 Hopper

- 指令
    - ```break *main``` 
        - 在 main 的第一行設置 breakpoint
        - 也可以直接把 main 換成某個 address，比如```break *0x00000000000011fb```

    - ```run  <參數，比如這邊就是 key>```
        - 跑程式
    
    - ```info registers```
        - 執行的過程中，可以隨時查看 register 情形，
        - e registers are the low 32 bits of the r registers

    - 程式執行到下一步
        - 可用 ```si```、```ni```、```continue```
            - si 和 ni 會跑到下一行程式，差別是 si 會進去 function calls
                - 接著可以一直按 enter，不用一直重打

    - ```x/s <address>```
        - 印出 ASCII 字串，可以用在 .rodata section

最後會發現關鍵在 
```
   0x00000000000011d6 <+77>:    call   0x1090 <strcmp@plt>
   0x00000000000011db <+82>:    test   eax,eax
   0x00000000000011dd <+84>:    jne    0x11ed <main+100>
```
我們執行 <+82> 前，把 eax 改為 0 即可，test 用來確認一個值是否為 0，目的是為了後面的 jne，我們的目標是讓 zero flag 設成 1，而 eax 是 rax 的 first 32 bits。

本來是 ```rax 0x23 35```，下完```set $eax=0```，變成```rax 0x0 0```

此時我們接著 ```ni``` 下去，得到 "Access Granted!"

# Tools
- hexdump
    - 可以把二進制文件印出來
        - -C 可以額外顯示 ASCII

- strings
    - 把高於某種長度的 printable character sequence 印出來

- objdump
    - -d 可以用來 disassemble
    - -x 可以查看 header
        - section
            - .text
                - 存放程式碼的地方
                - ```15 .text 000001e5 00000000000010a0 00000000000010a0 000010a0 2**4```
                    - 長度 0x1e5 bytes
                    - address 在 0x10a0
            - .rodata
                - read only data

- strace
    - trace system calls and signal

- radare2
    - UNIX-like reverse engineering framework and command-line toolset
    - ```r2 ./test```
    - ```aaa```
        - 深度分析
    - ```afl```
        - 列出所有 function
    - ```?```
        - --help
        - a?
            - a 的詳細說明
    - ```s main```
        - seek address
    - ```pdf```
        - 印出當前函式的 disassembly 
    - ```VV```
        - Visual mode(graph)
        - ```p```
            - 切換顯示方法(包含顯示 address)
        - ```?```
            - --help

    - ```V!```
        - 可以看到大量資訊的方法

    - ```r2 -d ./test```
        - 像 gdb 一樣 debug
        - ```db <address>```
            - 設置 breakpoint
        - ```:dc```
            - 按 ":" 跑 command mode，這樣就可以在 VV 看
            - dc 會 run 程式碼
        - ```s```
            - 和 si 一樣，可以用 ```S```，那就是 ni
        - ```dr```
            - register info
            - ```dr rip=0x00123123123```
                - 可以這樣設置位址
    
    - ```ood [args]```
        - reopen in debug mode (with args)
        
    - ```afvn <var1> <var2>```
        - rename variable

# Uncrackable?
密碼直接放在 binary，連 vim 都可以輕鬆看到，接下來會挑戰更難一點的情形，先從不把 key 放在裡面開始，雖然上次直接改 register 的做法根本不用管 key 是什麼

1. 不顯示 string 密碼
    - 這次的做法改成，不再是 check string 一不一樣，而是先算 license key 的所有 char 轉成 int 後的總合，並且刪除掉 license key，之後對輸入的密碼算總和看一不一樣
    -   ```
        0x00001212      72c2           jb 0x11d6
        0x00001214      817de8940300.  cmp dword [var_18h], 0x394
        0x0000121b      750e           jne 0x122b
        ```
    - 程式碼的這塊是看總合的，這時我們在 jne 設 breakpoint 後，可以直接把 rip 改到改成下一行的 address，直接繞過
        - 關鍵在於只要可以找到是哪一行 cmp，就可以繞過它

2. parser differential
    - 讓 linux 可執行，但讓 debugger 不能跑
    - 每個 Parser 的演算法略有不同
    - fuzzing
        - 隨機改一個 bytes，有可能執行結果和原本一樣，但是 parser 有問題