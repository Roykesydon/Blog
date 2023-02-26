---
title: "Process Scheduling"
date: 2023-02-20T21:12:52+08:00
draft: false
description: ""
type: "post"
tags: ["linux"]
categories : ["linux"]
---

# Process Scheduling
- 可能時機
    1. running -> waiting
    2. running -> ready
    3. waiting -> ready
    4. running -> terminate

- Process Scheduler
    - Preemptive scheduler (Time slice)
        - 可以被搶占
    - Non-Preemptive scheduler
        - 又稱 cooperative scheduling
        - 只可能出現在時機 1 或 4

- Classification fo Processes(related to scheduling)
    1. Interactive Processes (50 - 150 ms)
    2. Batch Processes
    3. Real time Processes
        - Hard
        - Soft

- Classification of Processes(related to CPU usage)
    1. CPU Bound
    2. I/O Bound

# Standard Scheduling Algorithm

1. FCFS
2. SJF
3. SRTF
4. Priority Based
5. Highest Response Ratio Next
6. Round Robin
7. Virtual RR
8. Multi-Level Queue Scheduler
9. Multi-Level Feed Back Queue Scheduler
10. Rotating Staircase Deadline Scheduler

# UNIX SVR3 Scheduler
有 32 個 runqueue，每個 runqueue 負責 4 個 priority values

- 128 Priority values
    - 0-49: Kernel
    - 50-127: User

- $Priority_j=Base_j+CPU_j(i)+nice_j$
    - Base: 0-127
    - $CPU_j(i) = DR * CPU_j(i-1)$
        - DR = $\frac{1}{2}$
    - nice: -20 ~ +19
        - 可以用 nice 和 renice 改 process nice value

# Schedtool

- Query & set per process scheduling parameters
    1. Scheduling Policy
        - Real time
            1. SCHED_RR
            2. SCHED_FIFO
        - Conventional
            1. SCHED_NORMAL (default)
            2. SCHED_BATCH (CPU intensive)
            3. SCHED_ISO (unused)
            4. SCHED_IDLEPRIO (low pri jobs)
    2. Nice Value (-20 to +19)
    3. Static Priority (1-99)
    4. CPU affinity
        - process 想運行在某個指定的 CPU 上，不被轉移到其他 CPU，才不會降低指定 CPU 的 cache 命中率
            - soft CPU affinity
            - hard CPU affinity
        - cpus_allowed
            - 一個用來指定 CPU 的 mask
        
- ```
    schedtool <PID>
    ```