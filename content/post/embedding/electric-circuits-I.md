---
title: "電路學 - I"
date: 2023-04-09T00:00:54+08:00
draft: false
description: ""
type: "post"
tags: ["electric-circuits"]
categories : ["embedded-system"]
---

## 基本概念
### 常見名詞
- 電路 (electric circuit)
- 元件 (element)
    - 電路組成的部分

### 單位系統

- 國際單位制 (International System of Units ,SI)

### 電荷與電流

- 電荷 (electric charge)
    - 組成原子的基本物質
    - 庫倫 (C)
    - 電荷守恆定律 (law of conservation of charge)
        - 電荷不能被創造、破壞，只能轉移，系統中的電荷總數不變。

- 電流 (electric current)
    - 電荷的時間變化率
    - 電流是電荷的移動，而且有方向性 
    - 安培 (A)
    - 公式
        - $i \triangleq \frac{dq}{dt}$
        - $Q \triangleq \int_{t_0}^{t}i\text{ }dt$ 
    - 直流電 (direct current, dc)
        - 恆定常數的電流
    - 交流電 (alternating current, ac)
        - 隨著時間以正弦波變化的電流

### 電壓

- 電動勢 (electromotive force, emf)
    - 驅動導體內的電子往某方向移動
    - 電壓 (voltage)、電位差 (potential difference)
    - 伏特 (V)
    - $v_{ab}\triangleq\frac{dw}{dq}$
        - 單位電荷從 b 移動到 a 需要做的功
        - $w$ 是能量，單位是焦耳(J)
        - $q$ 是電荷，單位是庫倫(C)
    - 壓降 (voltage drop)、壓升 (voltage rise)
    - 直流電壓 (dc voltage)、交流電壓 (ac voltage)

### 功率與能量
- 消耗或吸收能量的時間變化率，單位是瓦特(walt, W)
- 公式
    - $p \triangleq\frac{dw}{dt}$
    - $p=iv$

- 被動符號規則 (passive sign convention)
    - 電流從電壓的正極流入元件 ($p=+vi$)，表示該元件吸收功率
    - 電流從電壓的正極流出元件 ($p=-vi$)，表示該元件供應功率
- 能量守恆定律 (law of conservation of energy)
    - 電路中任何時刻的功率總和為 0
    - $\sum p=0$

### 電路元件
- 被動元件 (passive element)
    - 不具備產生能量的能力
    - 電阻器 (resistor)、電容器 (capacitor)、電感器 (inductor)
- 主動元件 (active element)
    - 具備產生能量的能力
    - 發電機 (generator)、電池 (battery)、運算放大器 (operational amplifier)

#### 電源
- 電壓源、電流源
    - 提供穩定電壓產生電流、提供穩定電流產生電壓
- 獨立電源
    - 獨立電源提供指定電壓或電流的主動元件，與電路中其他元件無關。
    - 電池和發電機可被當作近似理想的電壓源
- 相依電源
    - 提供的電壓或電流受另一個電流或電壓控制的主動元件
    - 類型
        - 電壓控制電壓源 (voltage-controlled voltage source, VCVS)
        - 電流控制電壓源 (current-controlled voltage source, CCVS)
        - 電壓控制電流源 (voltage-controlled current source, VCCS)
        - 電流控制電流源 (current-controlled current source, CCCS)


## 基本定律

### 歐姆定律 (Ohm's Law)
- 一般材料具備阻止電荷流通的特性，稱為電阻 (resistance)
- 均勻截面積下，$R=\rho \frac{l}{A}$
    - $\rho$ 是材料的電阻率 (resistivity)
- 電路中抑制電流的材料稱為電阻器 (resistor)
- $v=iR$
- 短路 (short circuit)、開路 (open circuit)
    - 短路: 電壓是 0，電流可能是任意值，電阻值接近 0
    - 開路: 電壓可能是任意值，電流是 0，電阻值接近無限大
- 固定電阻、可變電阻
    - 阻值可調與否
    - 常用的可變電阻是電位器 (potentiometer)
- 不是所有電阻都遵守歐姆定律
    - 遵守歐姆定律的稱為線性電阻 (linear resistor)，反之則為非線性電阻 (nonlinear resistor)，阻值隨電流變化

- 電導 (conductance)
    - 電阻 R 的倒數
    - 元件導通電流的能力
    - $G=\frac{1}{R}=\frac{i}{v}$
    - 單位姆歐 (mho, $\mho$) 或西門子 (siemens, S)
    - $1 S = 1 \mho = 1 A/V$

### Node, Branches, and Loops
- 分枝 (Branch) 
    - 任意的兩端元件，比如電壓源、電阻

- 節點 (Node) 
    - 指連接二個或多個分支的接點

- 迴路 (Loop) 
    - 是電路中的任一封閉路徑
    - 從一個節點開始，經過一組節點，最後回到一開始的節點，途中每個節點只經過一次
- 串聯
    - 多個元件共享單一節點
- 並連
    - 多個元件連接到相同的兩個節點

- 獨立迴路 (independent loop)
    - 至少包含一個不屬於其他獨立迴路的 branch
    - $b=l+n-1$
        - b 是 branch，l 是獨立迴路，n 是 node

### 克希荷夫定律 (Kirchhoff's Laws)

- Kirchhoff's current law (KCL)
    - 流入任一 node 或封閉邊界的電流總和為 0
        - 或是說流入某一節點的電流和等於流出的電流和
    - $\sum_{n=1}^{N}i_n=0$
        - $N$ 是連到 node 的 branch 數

- Kirchhoff's voltage law (KVL)
    - 一條封閉路徑(或迴路)中的電壓總和為零
        - 或是說 voltage drop 的總和 = voltage rise 的總和
    - $\sum_{m=1}^{M}n_m=0$
        - $M$ 是迴路中的 branch 數

### 串並聯電阻

- 串聯
    - $R_{eq}=\sum_{n=1}^N R_n$
        - $R_{eq}$ 是等效電阻 (equivalent resistance)
    - 分壓定理 (principle of voltage division)
        - 電壓和各電阻的阻值成正比，阻值越大，壓降越大
    - 分壓器 (voltage divider)
    - $v_1=\frac{R_1}{R_1+R_2}v$

- 並聯
    - $\frac{1}{R_{eq}}=\frac{1}{R_1}+\frac{1}{R_2}+...+\frac{1}{R_N}$
        - $R_{eq}$ 永遠小於並聯電阻中最小的電阻值
        - $G_{eq} = G_{1}+G_2+...+G_N$
    - 分流定理 (principle of current division)
        - 各分支電流與電阻值成反比
    - 分流器 (current divider)
    - $i_1=\frac{R_2}{R_1+R_2}i$

### Y - $\Delta$ 轉換 (Wye-Delta Transformations)
- 遇到電阻不是串聯也不是並聯的情況，要如何轉換
- 有時候把 Y 型網路和 $\Delta$ 型網路相互轉換會比較好算
- Y 型網路 = T 型網路
- $\Delta$ 網路 = $\Pi$ 網路

#### $\Delta$ - Y 轉換 (Delta to Wye conversion)
- Y 網路的每個電阻是 $\Delta$ 中的兩個相鄰電阻的相乘除以 $\Delta$ 中的三個電阻總和

#### Y - $\Delta$ 轉換 (Wye to Delta conversion)
- $\Delta$ 網路的每個電阻是 Y 中的兩兩電阻的相乘總和除以 Y 中的對角電阻

- 平衡 
    - 條件
        - $R_1=R_2=R_3=R_Y$
        - $R_a=R_b=R_c=R_{\Delta}$
    - 結果
        - $R_Y=\frac{R_\Delta}{3}$