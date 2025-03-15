---
title: "IPC -- Inter-Process Communication"
date: 2023-01-28T15:31:50+08:00
draft: true
description: "Inter-Process Communication"
type: "post"
tags: ["linux"]
categories : ["linux"]
---

# Share information between processes
1. 透過硬碟上的文件溝通
    - 超慢
2. 透過 kernel buffer
    - 滿快的，但這樣要一直在 user mode 和 kernel mode 來回切換，因為kernel buffer 在 kernel space
3. 透過 shared memory region
    - shared memory region 在 user space

# Mechanisms
1. Signals

2. Communication
    1. Data transfer
        - Byte Stream
            - Pipes
            - FIFOs(Named Pipes)
            - stream sockets
        - Message Passing
            - SystemV MsgQ
            - POSIX MsgQ
            - datagram sockets
    2. Shared Memory
        - SystemV S.M
        - POSIX S.M
        - Memory Mapping
            - anonymous memory mapping
            - memory mapped file
3. Synchronization

#  Pipes
- Related processes
    - parent-child
    - sibling
- Executing on same machine
- 用法
    - cmd1 | cmd2
        - cmd1 不是輸出到 stdout，而是由 kernel 維護的 buffer，也就是 pipe
        - cmd 不是從 stdin 獲取輸入，而是從 pipe 獲取
    - cmd1 | cmd2 | ... | cmdn


# Named Pipes / FIFOs
- Related / Unrelated processes
- Executing on same machine

- creat a FIFO
    - commands
        - mkfifo
        - mknod

嘗試寫入或讀取 FIFO 時，會被 redirect 到 pipe

# Signal Handling

## Signal
- Used by OS to notify running process some event has occured without the process needing to pull for that event
- process 收到 signal 後會先停止執行並執行 signal handler

1. A process did something
    - SIGSEGV(11), SIGFPE(8), SIGILL(4), SIGPIPE(13)...
2. A process wants to tell another process something
    - SIGCHILD(17)
        - child process terminated
3. User sends sig to foreground processes
    - Ctrl + C SIGINT(2)
    - Ctrl + \ SIGQUIT(3)
    - Ctrl + Z SIGTSTP(20)

### disposition
決定 process 遇到 signal 時該怎麼處理

- Term
    - teminate process
- Ign
    - ignore
- Core
    - terminate the process and dump core
- Stop
    - stop the process
- Cont
    - continue the process if it is stopped

### Signal can't not be caught
- SIGKILL(9)
- SIGSTOP(19)

### Commands
- trap

    可以 handle signal


## kill
kill - L 可以看到 standard signal 和 real-time signal

standard signal 開頭是 SIG，realt-time signal 是 SIGRT