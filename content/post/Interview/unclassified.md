---
title: "未分類演算法 & 資料結構筆記"
date: 2023-08-27T00:09:46+08:00
draft: false
type: "post"
tags: ["algorithm", "data-structure"]
categories: ["Interview"]
---

## Sorting

### Merge Sort

- 一直拆分兩邊最後再輪流 merge 起來，merge 時看兩邊開頭誰最小，依序放
- 都是 $O(nlogn)$
- stable
- not in-place

### Quick sort

- 選定一個 pivot，用兩個指針從兩邊開始往中間找。當左指針找到比 pivot 大的數值，右指針找到比 pivot 小的數值後交換。直到兩個指針相遇，再把 pivot 換到中間，繼續兩邊處理
- 最差會到 $O(n^2)$，平均 $O(nlogn)$

- 選 pivot
  - 隨機選
  - Median of Three
    - 選開頭、中間和結尾的中位數

## Other

### Binary Exponentiation 快速冪

```cpp
int qpow(int x, int m) {
    int ans = 1;
    while (m) {
        if (m & 1) ans *= x;
        x *= x;
        m >>= 1;
    }
    return ans;
}
```

### Discretization 離散化

```cpp
sort(vec.begin(), vec.end());
vec.resize(unique(vec.begin(), vec.end()) - vec.begin());
for (int i = 0; i < vec.size(); i++) {
    val[i] = lower_bound(vec.begin(), vec.end(), val[i]) - vec.begin();
}
```

### Ternary Search 三分搜

```cpp
l = -10000.0;
r = 10000.0;
while (r - l > eps) {
    ml = (r - l) / 3.0 + l;
    mr = (r - l) * 2.0 / 3.0 + l;
    if (f(ml) > f(mr)) {
        l = ml;
    } else {
        r = mr;
    }
}
```