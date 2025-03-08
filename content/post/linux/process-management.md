---
title: "Process Management"
date: 2023-01-21T00:08:25+08:00
draft: false
type: "post"
tags: ["linux", "C"]
categories : ["linux"]
---


# Compile C

## 4-steps

1. pre-processing
2. compilation
3. assembly
4. linking

## Types of Object Files
1. Executable object file
2. Relocatable object file
3. Shared object file
4. Core file


## Formats of Object Files
1. a.out
    - initial version of UNIX
2. COFF
    - SVR3 UNIX
3. PE
    - Win. NT
4. ELF
    - SVR4 Linux

## ELF format of a program

|ELF Header|
|:---:|
|Program Header Table|
|.text |
|.rodata |
| .data|
|.bss |
|.symtab |
|.rel.text |
|.rel.data |
|.debug |
|.line |
|.strtab |
|Section Header Table |

可參考: http://ccckmit.wikidot.com/lk:elf

# Process
Instance of a program running on a computer

## Process Control Block

task_struct

1. Process Identification
    - PID, PPID, SID, UID, EUID..
2. Process State Information
3. Process Control Information