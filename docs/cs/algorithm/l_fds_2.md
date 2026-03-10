# FDS Collection II

## Chapter 4 Graph

### 4.1 基本概念

- 有限可空的边集 $E$ 和有限非空的点集 $V$ 组成图 $G=\{V, E\}$；
- **无向图/Undirected Graph**：边没有方向，也就是 $(u, v) = (v, u)$；
- **有向图/Directed Graph**：边有方向，也就是 $(u, v) \neq (v, u)$；
    - Tip：数据结构基础中不考虑自环/Self Loop和多重边/Multigraph；
- **完全图/Complete Graph**：任意两个点之间都有边；
- 无向图中 $v_i$ 和 $v_j$ 被称为**连通**的，当且仅当 $G$ 中存在一条从 $v_i$ 到 $v_j$ 的路径；
- 无向图 $G$ 被称为**连通图**，当且仅当 $G$ 中任意两个节点都是连通的；
- 无向图的**联通成分**是指无向图的极大连通子图；
- 有向图中 $v_i$ 和 $v_j$ 被称为**强连通**的，当且仅当 $G$ 中存在一条从 $v_i$ 到 $v_j$ 的路径和一条从 $v_j$ 到 $v_i$ 的路径；
- 有向图 $G$ 被称为**强连通图**，当且仅当 $G$ 中任意两个节点都是强连通的。有向图的**强连通成分**是指有向图的极大强连通子图；
- 有向图 $G$ 被称为**弱连通图**，当且仅当 $G$ 的基础图（去掉所有边的方向）是连通图；


### 4.2 图的表示

- 邻接矩阵/Adjacency Matrix
    ```C
    #define MaxVertexNum 100
    int G[MaxVertexNum][MaxVertexNum];
    // 1 for connected, 0 for unconnected
    ```

- 邻接表/Adjacency List
    ```C
    typedef struct ArcNode {
        int adjvex;           // 顶点下标
        int weight;
        struct ArcNode *next;
    } ArcNode;                // 边表结点 
  
    typedef struct VNode {    // 顶点表结点
        VertexData data;
        ArcNode *first;       // 指向第一个邻接点
    } VNode, AdjList[MaxVertexNum];
  
    typedef struct {
        AdjList vertices;     // 邻接表，存储图中所有顶点
        int vexnum, arcnum;
    } ALGraph;
    ```

### 4.3 图的建立

- 邻接矩阵
    ```C
    void BuildGraph(ALGraph *G) {
        int ne, nv;
        scanf("%d %d", &nv, &ne);
        int u, v, w;
        for(int i = 0; i < ne; i++) {
            scanf("%d %d %d", &u, &v, &w);
            G->G[V][W] = G->G[W][V] = w;
        }
    }
    ```
- 邻接表
    ```C
    void BuildGraph(ALGraph *G)
    ```

### 4.4 拓扑排序

- **AOV网/Activity On Vertex Network**；有向图，其顶点代表活动，边代表活动之间的先后顺序关系；
- 如果存在一条从 $v_i$ 到 $v_j$ 的路径，则 $v_i$ 称为 $v_j$ 的前驱/predecessor，$v_j$ 称为 $v_i$ 的后继/successor；
- 如果存在一条边 $(v_i, v_j)$，则 $v_i$ 是 $v_j$ 的直接/Immediate 前驱，$v_j$ 是 $v_i$ 的直接后继；
- 拓扑排序/Topological Order 是一个图的点集的线性序列，满足：
    - 对于任意的点 $v_i$，$v_j$，如果 $v_i$ 是 $v_j$的前驱，在序列中 $v_i$ 出现在 $v_j$ 之前；
    - Tip：拓扑排序不唯一；

```C
void TopologicalSort(ALGraph G) {
    Queue Q = CreateQueue(NumVertex(G));
    int cnt;
    Vertex V, W;
    for(int i = 0; i < NumVertex(G); i++)
        if(Indegree[i] == 0) Enqueue(i, Q);
    while(!IsEmpty(Q)) {
        V = Dequeue(Q);
        TopNum[V] = ++cnt;
        for(each W adjacent to V)
            if(--Indegree[W] == 0) Enqueue(W, Q);
    }
    if(cnt != NumVertex(G)) Error("Graph has a cycle");
    free(Q);
}
```

### 4.5 BFS 和 DFS

**广度优先搜索/Breadth First Search**：从一个点出发，依次访问其邻接点，再访问邻接点的邻接点，以此类推，直到所有点都被访问过；

=== "邻接矩阵"

    ```C
    #define MaxN 100
    int G[MaxN][MaxN];
    int pre[MaxN];
    int visited[MaxN];

    void BFS(int src, int dst) {
        int queue[MaxN] = {0};
        int front = 0, rear = 0;
        queue[rear++] = src;
        visited[src] = 1;
        while (front < rear) {
            int v = queue[front++];
            for (int w = 0; w < MaxN; w++) {
                if (G[v][w] && !visited[w]) {
                    queue[rear++] = w;
                    visited[w] = 1;
                    pre[w] = v;
                    if (w == dst) {
                        return;
                    }
                }
            }
        }
    }
    ```

=== "邻接表"

    时间复杂度：$O(V+E)$（若不使用队列硬遍历则$T=O(V^2)$）

    ```C
    define MAXN 100
    int visited[MAXN];
    int prev[MAXN];
  
    void BFS(ALGraph G, int src, int dst) {
        int queue[MAXN] = {0};
        int front = 0, rear = 0;
        queue[rear++] = src;
        visited[src] = 1;
        while(front < rear) {
            int v = queue[front++];
            for(ArcNode *arc = G->vertices[v].first; arc != NULL; arc = arc->next) {
                int w = arc->adjvex;
                if(!visited[w]) {
                    prev[w] = v;
                    iqueue[rear++] = w;
                    visited[w] = 1;
                    if(w == dst) return;
                }
            }
        }
    }
    ```

**深度优先搜索/Depth First Search**：从一个点出发，访问其邻接点，再访问邻接点的邻接点，以此类推，直到所有点都被访问过，再回溯到上一个点，继续访问其他邻接点；

=== "邻接矩阵"

    ```C
    #define MaxN 100
    int G[MaxN][MaxN];
    int pre[MaxN];
    int visited[MaxN];

    void DFS(int v, int dst) {
        visited[v] = 1;
        for (int w = 0; w < MaxN; w++) {
            if (G[v][w] && !visited[w]) {
                pre[w] = v;
                DFS(w, dst);
                if (w == dst) {
                    return;
                }
            }
        }
    }
    ``` 

=== "邻接表"

    ```C
    #define MaxN 100
    int visited[MaxN];
    int pre[MaxN];

    void DFS(ALGraph *G, int v, int dst) {
        visited[v] = 1;
        for (ArcNode *arc = G->vertices[v].firstarc; arc; arc = arc->nextarc) {
            int w = arc->adjvex;
            if (!visited[w]) {
                pre[w] = v;
                DFS(G, w, dst);
                if (w == dst) {
                    return;
                }
            }
        }
    }
    ```



### 4.6 最短路径

**单源最短路径/Single Source Shortest Path**：从一个点到其他所有点的最短路径

- 无向无权图：广度优先搜索/BFS
- 无向/有向正权图：Dijkstra 算法
    ```C
    #define INFINITY INT_MAX
    void Dijkstra(ALGraph G, ins src){          // 确定源点 src 到其他所有点的最短路径长度
        int dist[MaxN] = {0};
        int visited[MaxN] = {0};                // 记录是否已经访问
        for (int i = 0; i < G->vexnum; i++)
            dist[i] = INFINITY;                 // 初始化
        dist[src] = 0;
        visited[src] = 1;
        for (ArcNode *arc = G->vertices[src].first; arc != NULL; arc = arc->next)
            dist[arc->adjvex] = arc->weight;    // 更新原点的邻接点距离
        for (int i = 0; i < G->vexnum; i++) {   // 重复 n-1 次
            int min = INFINITY, v = -1;
            for (int j = 0; j < G->vexnum; j++) {
                if (!visited[j] && dist[j] < min) {
                    min = dist[j];
                    v = j;                      // 找到未访问的最小距离点
                }
            }
            if (v == -1) break;                 // 未找到则剩下所有节点都不可达
            visited[v] = 1;
            for (ArcNode *arc = G->vertices[v].first; arc != NULL; arc = arc->next) {
                if (!visited[arc->adjvex] && dist[v] + arc->weight < dist[arc->adjvex])
                    dist[arc->adjvex] = dist[v] + arc->weight;
            }                                   // 更新其他点的距离
        }
    }
    ```
    这种实现的时间复杂度为 $O(V^2+E)$ 原因之一是内部寻找未访问的最小距离点的步骤是纯粹的线性搜索。

**坑**：If the length of each edge in an undirected graph $G(V, E)$ is increased by 1, the shortest path between any pair of nodes $v_i$ and $v_j$ will keep unchanged.

> 错！之需要考虑两条权重分别为 2->2->2 与 7 的路径，会发现原来的最短路径不再是最短路径。

### 4.7 网络流

**最大流**：给定一个正权有向图$G$，每个边上都有一个流量 $c$，从源点 $s$ 到汇点 $t$ 的最大流量。

求解方法：建立残差图，残差网络的边权如下，每在残差网络中寻找到一条增广路径，就更新一下残差图，知道找不到增广路径为止。

\[
    c_f(u, v) = \begin{cases} c(u, v) - f(u, v) & \text{if } (u, v) \in E \\
     f(v, u) & \text{if } (v, u) \in E \\
      0 & \text{otherwise } \end{cases}
\]

增广路径：从源点到汇点的一条简单路径路径，流量是路径上的最短路径。

```C
int maxFlow(int src, int dst) {
    int maxflow = 0;
    return maxflow;
}
```

### 4.8 最小生成树

**最小生成树/Minimum Spanning Tree**：给定一个无向连通图$G$，每个边上都有一个权重 $w$，找到一个树，包含这个图的所有节点并且使得所有边的权重之和最小。可以使用贪心算法！

Prim 算法：从一个节点开始，每次选择一个与当前生成树距离最小并且不会产生环的节点加入生成树，很适合稠密图。

Kruskal 算法：从所有边中选择权重最小的边，如果这条边不会产生环就加入生成树，跟适合稀疏图。

=== "Prim"

    和 Dijkstra 算法很像。

    ```C
    void Prim(ALGraph G, int src){
        int dist[MaxN] = {0};
        int visited[MaxN] = {0};                // 记录是否已经访问
        for (int i = 0; i < G->vexnum; i++)
            dist[i] = INFINITY;                 // 初始化
        dist[src] = 0;
        visited[src] = 1;
        for (ArcNode *arc = G->vertices[src].first; arc != NULL; arc = arc->next)
            dist[arc->adjvex] = arc->weight;    // 更新原点的邻接点距离
        for (int i = 0; i < G->vexnum; i++) {
            int min = INFINITY, v = -1;
            for (int j = 0; j < G->vexnum; j++) {
                if (!visited[j] && dist[j] < min) {
                    min = dist[j];
                    v = j;                      // 找到未访问的最小距离点
                }
            }
            if (v == -1) break;                 // 未找到则剩下所有节点都不可达
            visited[v] = 1;
            for (ArcNode *arc = G->vertices[v].first; arc != NULL; arc = arc->next) {
                if (!visited[arc->adjvex] && arc->weight < dist[arc->adjvex])
                    dist[arc->adjvex] = arc->weight;
            }                                   // 更新其他点的距离
        }
    }
    ```

=== "Kruskal"


## Chapter 5 Sorting

### 5.1 Insertion Sort

```C title="Insertion Sort"
void insertSort (int arr[], int len) {
    int i, j, tmp;
    for (i = 1; i < len; i++) {
        tmp = arr[i];
        for (j = i; j > 0 && arr[j - 1] > tmp; j--)
            arr[j] = arr[j - 1];
        arr[j] = tmp;
    }
}
```

进行 $n-1$ 趟排序，每一趟排序（第 $P$ 趟）都可以保证从 $0$ 到 $P-1$ 的元素是有序的，然后再插入第 $P$ 个元素。

- 最好情况的时间复杂度是 $O(N)$，这时整个数列是顺序的，开场就已经排好了；
- 最坏情况的时间复杂度是 $O(N^2)$，这种情况下数列是逆序的。
- 完全不需要另外一个数组，只需要临时变量，空间复杂度是 $O(1)$。

### 5.2 Shell Sort

希尔排序是插入排序的一种改进，它的时间复杂度会随具体实现（也就是增量序列的选取）而变化。

```C title="Shell Sort"
void shellSort(int arr[], int n) {
    int i, j, tmp;
    for (int inc = N / 2; inc > 0; inc /= 2) {  // Increment Sequence
        for (i = inc; i < N; ++i) {             // Insertion Sort
            tmp = arr[i];
            for (j = i; j >= inc; j -= inc) {
                if (tmp < arr[j - inc])
                    arr[j] = arr[j - inc];
                else
                    break;
            }
            a[j] = tmp;
        }
    }
}
```

- 希尔增量序列：如上面实现，$h_t=\lfloor N/2\rfloor, h_k = \lfloor h_{k+1}/2\rfloor$
    - 最坏复杂度 $O(N^2)$（即只在 1-sort 时进行了排序）。
- Hibbard 增量序列：$h_k = 2^k-1$
    - 最坏复杂度 $O(N^{3/2})$；
    - 平均复杂度 $O(N^{5/4})$。

### 5.3 Heap Sort

堆排序使用堆结构来进行排序：

- 算法一：将数组中的元素依次插入到堆中（可以是 $O(N)$ 线性建堆），然后依次从堆中取出最小元素
    - 时间复杂度 $O(N\log N)$；
    - 但是空间消耗翻倍了；
    ```C
    void heapSort(int arr[], int n) {
        BuildHeap(arr, n);                  // 最小堆, O(N)
        int tmp = malloc(sizeof(int) * n);
        for (int i = 0; i < n; ++i) 
            tmp[i] = DeleteMin(arr);       // O(logN)
        for (int i = 0; i < n; ++i) 
            arr[i] = tmp[i];
    }
- 算法二：
    - 以线性时间建最大堆（PercolateDown）；
    - 将堆顶元素与最后一个元素交换（相当于删除最大元素），然后进行 PercolateDown；
    - 依此循环，N-1 次删除后得到一个从小到大的序列。
    ```C
    void heapSort(int arr[], int n) {
        for (int i = n / 2; i >= 0; --i)    // Build Max Heap
            percolateDown(arr, i, n);
        for (int i = n - 1; i > 0; --i) {   // Delete Max
            swap(&arr[0], &arr[i]);
            percolateDown(arr, 0, i);
        }
    }
    ```
    - 平均比较次数为 $2N\log N - O(N\log\log N)$

### 5.4 Merge Sort

归并排序的时间复杂度在任何情况下都是 $O(N\log N)$，空间复杂度为 $O(N)$。

关键的操作是合并两个有序列表变成一个有序列表，归并操作则可以递归进行，分而治之，依次合并。

```C title="Merge Sort"
void mergeSort(int arr[], int n) {
    int *tmp = malloc(sizeof(int) * n);
    if (tmp != NULL) {
        mergeSortHelper(arr, tmp, 0, n - 1);
        free(tmp);
    } else {
        printf("No space for tmp array!\n");
    }
}

void mergeSortHelper(int arr[], int tmp[], int left, int right) {
    if (left < right) {
        int center = (left + right) / 2;
        mergeSortHelper(arr, tmp, left, center);
        mergeSortHelper(arr, tmp, center + 1, right);
        merge(arr, tmp, left, center + 1, right);
    }
}

void merge(int arr[], int tmp[], int leftPos, int rightPos, int rightEnd) {
    int leftEnd = rightPos - 1;
    int tmpPos = leftPos
    int numElements = rightEnd - leftPos + 1;
    while (leftPos <= leftEnd && rightPos <= rightEnd)
        if (arr[leftPos] <= arr[rightPos])
            tmp[tmpPos++] = arr[leftPos++];
        else
            tmp[tmpPos++] = arr[rightPos++];
    while (leftPos <= leftEnd)
        tmp[tmpPos++] = arr[leftPos++];
    while (rightPos <= rightEnd)
        tmp[tmpPos++] = arr[rightPos++];
    for (int i = 0; i < numElements; ++i, rightEnd--)
        arr[rightEnd] = tmp[rightEnd];
}
```

### 5.5 Quick Sort

已知的实际运行最快的排序算法：

- 最坏复杂度 $O(N^2)$；
- 最优复杂度 $O(N\log N)$；
- 平均复杂度 $O(N\log N)$。

选择一个基准元素（枢轴 pivot），将数组分成两个子数组，左边的元素都小于等于基准元素，右边的元素都大于等于基准元素，然后对两个子数组进行快排、合并。

- 选取 pivot：
    - 错误方法：pivot = arr[0]（对于排好序的数组仍会消耗 $O(N^2)$ 的时间）；
    - 安全方法：pivot = random element in arr；
        - 但随机数生成也有开销。
    - 三数中值分割法：pivot = (left + center + right) / 3。
- 小数组：
    - 对于小的 $N$（$N\leq 20$），快速排序慢于插入排序。
    - 可以在递归到 $N$ 较小的情况下改为插入排序。

```C title="Quick Sort"
void quickSort(int *arr, int len) {
    quickSortHelper(arr, 0, len - 1);
}

void quickSortHelper(int *arr, int left, int right) {
    if (left + cutoff < right) {                 // Cutoff for small arrays
        int pivot = median3(arr, left, right);
        int i = left, j = right - 1;
        while (1) {
            while (arr[++i] < pivot) ;
            while (arr[--j] > pivot) ;
            if (i < j) 
                swap(&arr[i], &arr[j]);
            else
                break;
        }
        swap(&arr[i], &arr[right - 1]);
        quickSortHelper(arr, left, i - 1);
        quickSortHelper(arr, i + 1, right);
    } else 
        insertSort(arr + left, right - left + 1);
}

int median3(int *arr, int left, int right) {
    int center = (left + right) / 2;
    if (arr[left] > arr[center]) 
        swap(&arr[left], &arr[center]);
    if (arr[left] > arr[right])
        swap(&arr[left], &arr[right]);
    if (arr[center] > arr[right])
        swap(&arr[center], &arr[right]);
    swap(&arr[center], &arr[right - 1]);
    return arr[right - 1];
}

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
```

### 5.6 Bucket Sort

如果输入数据都小于 $M$，则可以用一个大小为 $M$ 的数组来记录某个值出现了多少次，这个数组称为桶（bucket）：

- 桶初始化为 0，遍历输入数据，将每个数据对应的桶加 1
- 最后遍历桶中的所有元素，对于 bucket[x] = y，将 x 输出 y 次

时间复杂度 $O(N+M)$。

```C title="Bucket Sort"
void bucketSort(int *arr, int len) {
    int *bucket = malloc(sizeof(int) * len);
    if (bucket != NULL) {
        for (int i = 0; i < len; i++)   // Initialize Bucket
            bucket[i] = 0;
        for (int i = 0; i < len; i++)   // Counting
            bucket[arr[i]]++;
        for (int i = 0, j = 0; i < len; i++) {
            while (bucket[i] > 0) {
                arr[j++] = i;
                bucket[i]--;
            }
        }
        free(bucket);
    } else {
        printf("No space for bucket!\n");
    }
}
```

### 5.7 Radix Sort

从低位（LSD，Least Significant Digit）到高位（MSB），对每一位进行进行排序：时间复杂度为 $O(P(N+B))$，其中 $P$ 为轮数，$N$ 为元素个数，$B$ 为桶个数。

### 5.8 Stability

- 对于一个序列，如果存在两个相等的元素：
    - 排序后它们的相对位置不变，则称这个排序算法是稳定的；
    - 排序后它们的相对位置发生了变化，则称这个排序算法是不稳定的。
- 稳定排序：冒泡、归并、插入、基数；
- 不稳定排序：快排、希尔、堆排、选择。

## Chapter 6 Hashing

### 6.1 Hash Table

**哈希表/Hash Table** 也被称为散列表，将关键字值映射到表中的一个位置来访问记录，以加快查找的速度，哈希表需要支持查找关键词是否在表中，查询关键词，插入关键词，删除关键词等操作。

哈希表通常使用一个数组来实现，哈希表的每个位置都叫做一个**桶/Bucket**，一个桶可以有多个**槽/Slot**，当多个关键字对应一个位置的时候，将不同的关键词存放在同一个位置的不同槽中。

哈希表的核心是**哈希函数/Hash Function**，我们通过哈希函数将**关键字/标识符/Identifier** 映射到哈希表中的一个位置/索引。

对于大小为 `b`，最多有 `s` 个槽的哈希表，定义 $T$ 为哈希表关键字可能的所有不同值的个数，$n$ 为哈希表中所有不同关键字的个数，关键字密度定义为 $n / T$， 装载密度定义为 $\lambda = n / (sb)$。

当存在 $i_1 \neq i_2$ 但是 $\mathrm{hash}(k_1) = \mathrm{hash}(k_2)$ 的时候，我们称发生了**碰撞/Collision**，当把一个新的标识符映射到一个已经满了的桶的时候，我们称发生了**溢出/Overflow**。

在没有溢出的情况下，哈希表的**查找**时间、**插入**时间、**删除**时间都是 $O(1)$，但是在发生溢出的情况下，哈希表的性能会下降。

哈希函数应该满足以下条件：

- 尽可能易于计算，并且减少碰撞的可能性；
- 应该均匀分布/unbiased，即 $P(\mathrm{hash}(k) = i) = 1 / b$，这样的哈希函数称之为**均匀哈希函数/Uniform Hash Fuction**；
- 对于整数的哈希，比如 $f(x) = x\ \mathrm{ mod }\ \text{Tablesize}$，其中模应该最好选择为素数，因为这样对于随机输入，关键字的分布就会变得更加均匀。

### 6.2 Solving Collisions

- **分离链接/Sepatate Chaining**：把有限大小的槽换成一个链表，将哈希映射到同一个值的所有元素都保存在这个链表之中。
    ```C
    #define ElementType int
    typedef struct ListNode *Position;
    typedef struct HashTable *HashTable;
    typedef Position List;
    struct ListNode{
        ElementType val;     // Key Stored
        Position Next;       // Next Node in List 
    };
    struct HashTable{
        int TableSize;       // Size of Hash Table
        List *TheLists;      // Array of Buckets
    };
    ```
- **开放寻址/Open Addressing**：使用多个哈希函数 $\mathrm{hash}_1(x)$, $\mathrm{hash}_2(x)$, $\cdots$, $\mathrm{hash}_n(x)$，与增量函数 $f_i(x)$，其中每个哈希函数 $\mathrm{hash}_i(x)$ 都通过主哈希函数与增量函数来计算，亦即具有 $\mathrm{hash}_i(x) = \mathrm{hash}(x) + f_i(x)\ \mathrm{mod}\ \text{TableSize}$ 的形式，增量函数有很多种选择，因此衍生出不同的寻址方法，常见的有**线性探测/Linear Probing**，**二次探测/Quadratic Probing**，**双重哈希/Double Hashing** 等。使用开放寻址的哈希表的装载密度 $\lambda$ 不能超过 $0.5$，否则会导致性能下降。
- **线性探测/Linear Probing**：
- **二次探测/Quadratic Probing**：亦即增量函数 $f_i(x) = i ^ 2$，**如果使用二次探测，且表的大小为指数时，那么当表至少有一半是空的时，总能插入一个新的元素**。
    - 查找：$f(i) = f(i-1) + i^2 - (i-1)^2 = f(i-1) + 2i - 1$；
        ```C
        Position find(ElementType key, HashTable H) {
            Position currentPos = hash(key, H->TableSize);
            int collisionNum = 0;
            while (H->TheCells[currentPos].Info    != Empty && 
                   H->TheCells[currentPos].Element != key) {
                currentPos += 2 * ++collisionNum - 1;
                if (currentPos >= H->TableSize) currentPos -= H->TableSize;
            }
            return currentPos;
        }
        ```
    - 插入：
        ```C
        void insert(ElementType key, HashTable H) {
            Position pos = find(key, H);
            if (H->TheCells[pos].Info != Legitimate) {
                H->TheCells[pos].Info = Legitimate;
                H->TheCells[pos].Element = key;
            }
        }
        ```
- **双重哈希/Double Hashing**：亦即增量函数 $f_i(x) = i \cdot \mathrm{hash}'(x)$，其中 $\mathrm{hash}'(x)$ 是另一个哈希函数。说白了就是从第一次哈希的位置开始以 $\mathrm{hash}'(x)$ 为步长进行探测。
- **再哈希/Rehashing**：当哈希表填满一半了，或插入失败以及哈希表达到了某一个特定的装载密度时，我们需要进行再哈希。
    - 建立一个两倍大的哈希表；
    - 扫描原始哈希表；
    - 利用新的哈希函数将元素映射到新的哈希值，并插入；
    - 如果有原来的哈希表有 $N$ 个元素，则再哈希的时间复杂度为 $O(N)$。

