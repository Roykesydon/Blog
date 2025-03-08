---
title: "圖論筆記"
date: 2023-08-27T00:08:46+08:00
draft: false
type: "post"
tags: ["algorithm"]
categories: ["Interview"]
---

## Floyd-Warshall

```cpp
for (int k = 0; k < nodeCount; k++)
    for (int i = 0; i < nodeCount; i++)
        for (int j = 0; j < nodeCount; j++)
            DP[i][j] = min(DP[i][j], DP[i][k]+ DP[k][j]);
```

## dijkstra

- 時間複雜度 $O((V+E)*log(E))$
    - 最差每條邊都要插入 heap
    - 要取出 V 個點


```cpp
class cmp {
    public:
        bool operator()(edge a,edge b)
        {
            if(a.weight<b.weight)
                return true;
            return false;
        }
};

dis[a] = 0;
priority_queue<edge, vector<edge>, cmp> pq;
pq.push({a, 0});
while (!pq.empty()) {
    edge u = pq.top();

    pq.pop();
    if (!vis[u.to_node]) {
        vis[u.to_node] = 1;
        for (auto i : mp[u.to_node]) {
            if (dis[i.to_node] > dis[u.to_node] + i.weight) {
                dis[i.to_node] = dis[u.to_node] + i.weight;
                pq.push({i.to_node, dis[i.to_node]});
            }
        }
    }
}
```

## Topological Sorting

- 記得確認是不是 Directed Acyclic Graph
- BFS 是沒有前繼節點優先，DFS 是沒有後繼節點優先
- 用 BFS 的話就是把入度為 0 的點加入 Queue，一直維護該 Queue

```cpp
void dfs(int u) {
    if (!vis[u]) {
        vis[u] = true;
        for (auto j : edge[u]) dfs(j);
        toposort.push_back(u);
    }
}

for (int i = 1; i <= n; i++) dfs(i);
reverse(toposort.begin(), toposort.end());
```

## 樹的直徑

兩次 DFS，第一次找到離任意點最遠的點，第二次從該點出發找到離他最遠的點，這兩個點之間的距離就是樹的直徑。

## Lowest Common Ancestor

- 待補

## Eulerian path 歐拉路徑
- 每條邊只能被訪問一次（一筆畫問題）
- 條件
    - 除了兩個點外，其他都得為入度==出度。另外兩個點，最多有一個出度要比入度大一，最多有一個入度要比出度大一。（只能有 0 或 2 個奇點）
    - 須為連通圖
        - 視作無向圖的時候是否可以連到每個點


## Matching

### Hungarian Algorithm

- 待補

### 最小點覆蓋等等

- 待補