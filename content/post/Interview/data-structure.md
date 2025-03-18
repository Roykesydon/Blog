---
title: "資料結構筆記"
date: 2023-08-29T00:08:46+08:00
draft: true
type: "post"
tags: ["algorithm", "data-structure"]
categories: ["Interview"]
---

## Union-Find (DSU)

- 不同條件下的時間複雜度
  - 待補

```cpp
int find(int x) {
    if (f[x] == x)
        return x;
    else
        return f[x] = find(f[x]);
}
int merge(int x, int y) { f[find(x)] = find(y); }

int main() {
    for (int i = 1; i <= n; i++) f[i] = i;
    x = find(x);
    y = find(y);
    if (x != y) {
        merge(x, y);
    }
}
```

## Trie

```cpp
class Node {
   public:
    int cnt;
    int id;

    Node* nxt[26];
    Node() {
        cnt = 0;
        for (int i = 0; i < 26; i++) nxt[i] = nullptr;
    }
};
```

## Segment Tree 單點修改線段樹

```cpp
#define pl(x) (x * 2 + 1)
#define pr(x) (x * 2 + 2)
void build(int index, int l, int r) {
    if (l == r) {
        tree[index] = arr[l];
        return;
    }
    int mid = (l + r) / 2;
    build(pl(index), l, mid);
    build(pr(index), mid + 1, r);
    tree[index] = tree[pl(index)] * tree[pr(index)];
}
void change(int index, int q, int l, int r, int &value) {
    if (l == r) {
        tree[index] = value;
        return;
    }
    int mid = (l + r) / 2;
    if (mid >= q)
        change(pl(index), q, l, mid, value);
    else
        change(pr(index), q, mid + 1, r, value);
    tree[index] = tree[pl(index)] * tree[pr(index)];
}
void query(int index, int ql, int qr, int l, int r, int &ans) {
    if (ql <= l && r <= qr) {
        ans *= tree[index];
        return;
    }
    int mid = (l + r) / 2;
    if (ql <= mid) query(pl(index), ql, qr, l, mid, ans);
    if (mid < qr) query(pr(index), ql, qr, mid + 1, r, ans);
}
```
