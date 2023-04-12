---
title: "電路學 - II"
date: 2023-04-10T00:00:54+08:00
draft: false
description: ""
type: "post"
tags: ["electric-circuits"]
categories : ["embedded-system"]
---

## 分析方法
### 節點分析 (Nodal Analysis)

- 解節點電壓
    1. 選取一個節點做為參考節點 (reference node) 或已知節點 (datum node)，其他節點的電壓相對於它
        - 假設它電位為 0，稱為 ground
    2. 把 KCL 用在剩下的 n-1 個參考節點 (假設電流方向，可以隨便假設，只要一致，不要兩端電流都流入同個電阻)
    3. 求解聯立方程式，得到各節點電壓

### 包含電壓源的節點分析 (Nodal Analysis with Voltage Sources)
- 如果電壓源連接於兩個非參考節點間，可以把電壓源和這兩個節點和與其並聯的元件看做一個超節點 (supernode) 或廣義節點 (generalized node)，解決無法知道流過電壓源的電流的問題
    - 超節點的屬性
        - 超節點內部的電壓源提供限制方程式
        - 超節點本身沒電壓
        - 超節點要同時用 KCL 和 KVL

### 網目分析 (Mesh Analysis)
- 只能適用平面電路 (planer circuit)，不能用在非平面電路 (nonplaner circuit)
    - 在一個平面上沒有交互連接的分支
- 網目 (Mesh)
    - 不包含子迴路的單一迴路
- 網目電流 (mesh current)
    - 流經網目的電流

- 決定網目電流步驟
    - 在 n 個網目中，指定 n 個網目電流
    - 對 n 個網目個別應用 KVL，把歐姆定律應用在網目電流上，以表示電壓
    - 求解 n 個聯立方程式，計算網目電流

### 包含電流源的網目分析 (Mesh Analysis with Current Sources)
- 如果有兩個 Mesh 共用同一個電流源，會形成超網目 (supermesh)，把公用的電流源還有串聯的元件給移除掉

### 視察法
- 待補

### 節點分析 vs 網目分析
- 節點比網目少選節點分析，反之也是
- 要求電壓節點，求電流網目
- 可以用一種驗證另一種的結果
- 有些特殊問題只能用其中一種方法

### 直流電晶體電路
- 電子產品中的基本元件有三端主動元件--電晶體 (transistor)
    - 種類
        - 雙極性接面電晶體 (biopolar junction transistor, BJT)
            - 本節只討論這種
        - 場效電晶體 (field-effect transistor, FET)

- BJT 類型
    - NPN
    - PNP
- Part
    - 射極 (emitter, E)
    - 基極 (base, B)
    - 集極 (collector, C)

- 工作模式
    - 作用
        - $I_C=\alpha I_E$
            - $\alpha$ 是共基極電流增益 (common-base current gain)，表示射極注入的電子被基極收集的比例
        - $I_C=\beta I_B$
            - $\beta$ 是共射極電流增益 (common-emitter current gain)
            - $I_E=(1+\beta) I_B$
            - $\beta=\frac{\alpha}{1-\alpha}$
            - 因為 $\beta$ 很大，一個小的基極電流可以控制大電流的輸出，因此，雙極性電晶體可以當作放大器
    - 截止
    - 飽和

## 電路理論

### 線性性質 (Linear Property)
- 線性
    - 齊次性
        - 輸入 ( 激發 excitation) 乘以一個常數，輸出 ( 響應 response) 也會乘以相同的常數
        - $kiR=kv$
    - 可加性
        - 輸入總和的 response 等於個別輸入的 response 的總和
        - $v=(i_1+i_2)R=i_1R+i_2R=v_1+v_2$

- 因此稱電阻是一個線性元件，因為電阻、電壓、電流的關係滿足齊次性和可加性
- 如果電路滿足可加性和齊次性，稱此電路為線性電路
    - 線性電路是輸出與輸入為線性關係的電路
    - 組成
        - 線性元件
        - 線性相依電源
        - 獨立電源

### 重疊 (Superposition)
- 有兩個或更多的獨立電源時，除了節點和網目分析，可以求各獨立源對變數的貢獻，最後相加起來，這就是重疊
- 重疊定理
    - 在一個線性電路中，跨接於元件上的電壓(流經元件的電流) = 每個獨立電源單獨作用於該元件二端的電壓(單獨流經該元件的電流)的代數和

    - 注意事項
        - 同一時間只考慮一個獨立電源，把其他的電壓源當作 0 V(短路)、電流源當作 0 A(開路)
        - 相依電源受電路變數控制，保持不變
    
    - 步驟
        1. 保留一個獨立電源，算它的輸出(電壓或電流)
        2. 對每個電源做步驟 1
        3. 把每個獨立電源的貢獻相加

### 電源變換 (Source Transformation)
- 把電阻並聯的電流源和電阻串聯的電壓源做轉換(或反過來)
    - 電源變換條件
        - $V_s=i_sR$
    - 也是用相依電源，但也要遵守條件

### 戴維寧定理 (Thevenin's Theorem)
- 常有一種情境，電路種有一個特殊的元件是可變的，又稱負載 (load)，比如插座可能連接不同家電所組成的負載，而每當 load 改變，就要重新分析電路。戴維寧定理可以把固定的部分換成一個等效電路
- 戴維寧定理
    - 線性二端電路可被由電壓源 $V_{Th}$ 和電阻 $R_{Th}$ 串聯所組成的戴維寧等效電路 (Thevenin equivalent circuit) 取代
        - $V_{Th}$ 是二端的開路電壓
        - $R_{Th}$ 是關閉獨立電源後，端點上的輸入或等效電阻
            - 關閉所有獨立電源(根據 電壓/電流 來 短路/開路)，但考慮相依電源
            - $R_{Th}$ 有可能求出負值，這代表該電路提供功率，裡面有相依電源，雖然不可能出現在被動元件上，但等效電路是主動元件
            - 假設外接一個電壓源，求外面的 v 和 i 即可算出 $R_{Th}$

### 諾頓定理 (Norton's Theorem)
- 和戴維寧定理很像，但是等效電路改成電流源和並聯的電阻，實際上，根據電源變換，可以知道諾頓定理和戴維寧定理的等效電阻相等
- $R_N=R_{Th}$
- $I_N=\frac{V_{Th}}{R_{Th}}$

- 計算戴維寧或諾頓等效電路，要先求 $v_{oc}$、$i_{sc}$、$R_{in}$
    - 求出兩個就可以算第三個
    - $V_{Th}=v_{oc}$
        - $v_{oc}$ 是 a 和 b 兩端的開路電壓
    - $I_N=i_{sc}$
        - $i_{sc}$ 是 a 和 b 兩端的短路電流
    - $R_{Th}=\frac{v_{oc}}{i_{sc}}=R_N$

### 最大功率轉移 (Maximum Power Transfer)
- 轉移到 load 的功率是
    - $p=i^2R_{L}=(\frac{V_{Th}}{R_{Th}+R_L})^2R_L$
    - 最大值出現在 $R_L=R_{Th}$
        - 最大功率定理 (maximum power theorem)
    - $p_{max}=\frac{V_{Th}^2}{4R_{Th}}$

### 電源建模 (Source Modeling)

- 實際的電源非理想電源
    - 電壓源有串聯的內部電阻 (internal resistance)
        - 下面稱為 $R_s$
        - 要理想要趨近於 0
        - 若不連接 load (開路)，$v_{oc}=v_s$
            - $v_s$ 可以看做無負載源電壓 (unloaded source voltage)，連接 load 會使端電壓下降，這就是負載效應 (loading effect)
            - $R_L$ 越大會越接近理想電壓
        - 量測 $v_s$ 和內部電阻
            - 量開路電壓
                - $v_s=v_{oc}$
            - load 端連接可變電阻，調到 $v_L=v_{oc}/2$
            - 此時 $R_L=R_{Th}=R_s$
    - 電流源有並聯的電源電阻 (source resistance)
        - 要理想要趨近於無窮大
        - $R_L$ 越小越接近理想電源

### 電阻量測 (Resistance Measurement)
- 惠斯登電橋 (Wheatstone bridge)
    - 平衡電橋 (balanced bridge)
    - 非平衡電橋 (unbalanced bridge)