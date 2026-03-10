# FDS Collection I

## Chapter 1 Algorithm Analysis

## Chapter 2 Linear List

### 2.3 其他操作

=== "反转链表"

    ```C
    ListNode *reverse(ListNode *head) {
        ListNode *newHead = NULL;
        ListNode *tmp, *cur = head;
        while (head != NULL) {
            tmp = head->next;
            head->next = newHead;
            newHead = head;
            head = tmp;
        }
        return newHead;
    }
    ```

## Chapter 3 Trees

### 3.1 Concepts and Terminology

**Degree of a node**: the number of subtrees of the node.

**Degree of a tree**: the maximum degree of all nodes.

**Parent**: a node that has subtrees.

**Children**: the roots of the subtrees of a parent.

**Silblings**: the children of the same parent.

**Leaf/terminal node**: a node that has no children.

**Path from node A to node B**: a (unique) sequence of nodes starting from A and ending at B, such that each node is a child of the previous one.

**Length of path**: the number of edges on the path.

**Depth of a node**: the length of the unique path from the root to the node.

**Height of a node**: the length of the **longest** path from the node to a leaf.

**Height of a tree**: the height of the root.

**Ancestors of a node**: all nodes on the path from the node up to the root.

**Descendants of a node**: all nodes in its subtrees.

Every tree can be transformed into a binary tree with **FirstChild-NextSibling** representation.

### 3.2 Binary Trees

A **binary tree** is a tree in which no node can have more than two children.

可以使用 **First-Child-Next-Sibling** 表示法来将任意树转换为二叉树，将 FirstChild 作为左子节点，NextSibling 作为右子节点。

**Expression Trees**: 每个节点都是一个操作符，叶子节点是操作数，可以表示算数表达式。

#### 3.2.1 节点实现

```C
typedef struct TreeNode {
    int val;
    int height;     // Not necessary
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;
```

#### 3.2.2 基本操作

!!! info
    这种版本的节点的定义包括了节点的高度，但是在一般的树中，这是没有必要的，只是在AVL树中，节点高度才尤其重要.在下面的操作中就干脆省略了.

=== "Constructor"
    ```C
    TreeNode *newTreeNode(int val) {
        TreeNode *node;
        node = malloc(sizeof(TreeNode));
        node->val = val;
        node->left = NULL;
        node->right = NULL;
        return node;
    }
    ```

=== "Insertion and Deletion"
    这是在`n1->n2`中插入新节点`p`或者删除这个节点的操作.

    ```C
    TreeNode *p = newTreeNode(1);
    p->left = n2;
    n1->left = n1;

    TreeNode *del = p;
    n1->left = n2;
    free(del);
    ```

#### 3.2.3 遍历

遍历时间复杂度都是$O(n)$，迭代的空间复杂度是$O(n)$.

=== "Levelorder"

    层序遍历从顶部到底**逐层**遍历二叉树，并且按照从左到右的顺序遍历每一层的节点，从本质上来讲，层序遍历其实属于**广度优先遍历/Breadth-first Traversal**.我们一般借助**队列**来实现层序遍历.

    ```C
    int *levelOrder (TreeNode *root, int *size) {
        int front, rear;
        int index, *arr;
        TreeNode *node;
        TreeNode **queue = malloc(sizeof(TreeNode *) * MAX_SIZE);
        front = rear = 0;

        queue[rear++] = root;
        int *arr = malloc(sizeof(int) * MAX_SIZE);
        while (front < rear) {
            node = queue[front++];
            arr[index++] = node->val;
            if (node->left != NULL){
                queue[rear++] = node->left;
            }
            if (node->right != NULL){
                queue[rear++] = node-right;
            }
        }
        *size = index;
        arr - realloc(arr, sizeof(int) * index);
        free(queue);
        return arr;
    }

    ```

=== "Preorder"

    先访问根节点，再访问子树，左子树优先于右子树.

    ```C
    int *arr = malloc(sizeof(int) * MAX_SIZE);
    void preOrder(TreeNode *root, int *size, int *arr) {
        if (root == NULL)
            return;
        arr[(*size)++] = root->val;
        preOrder(root->left, size, arr);
        preOrder(root->right, size, arr);
    }
    arr = realloc(arr, sizeof(int) *(*size));
    ```

=== "Postorder"

    先访问子树，左子树先于右子树，再访问根节点.

    ```C
    void postOrder(TreeNode *root, int *size) {
        if (root == NULL)
            return;
        postOrder(root->left, size);
        postOrder(root->right, size);
        arr[(*size)++] = root->val;
    }
    ```

=== "Inorder & Recursive"

    先访问左子树，再访问根，最后访问右子树.

    ```C
    void inOrder(TreeNode *root, int *size) {
        if (root == NULL)
            return;
        inOrder(root->left, size);
        arr[(*size)++] = root->val;
        inOrder(root->right, size);
    }
    ```

=== "Inorder & Iterative"

    什么？你还想折磨自己？

    你需要在循环里边手动建一个堆栈来模仿系统堆栈的行为，想想都觉得受不了，消停写你的迭代版得了。

### 3.3 Binary Search Trees

二叉搜索树满足以下性质：

- 所有的节点都有一个以整数表示的键值，且互不相同；
- 所有节点的左节点的值都小于这个节点的值；
- 所有节点的右节点的值都大于这个节点的值；
- 所有节点的左右子树都是二叉搜索树；
- 二叉搜索树的中序遍历是一个递增的序列。

=== "Find"

    ```C
    TreeNode *rec_find(TreeNode *root, int val) {
        if (root == NULL)
            return NULL;
        if (root->val < val)
            return find(root->right, val);
        else if (root->val > val)
            return find(root->left, val);
        else
            return root;
    }
    ```

    ```C
    TreeNode *ite_find(TreeNode *root, int val) {
        while (root != NULL) {
            if (root->val < val)
                root = root->right;
            else if (root->val > val)
                root = root->left;
            else
                return root;
        }
        return NULL;
    }
    ```

=== "Find Min"

    ```C
    TreeNode *ite_findMin(TreeNode *root) {
        if (root == NULL)
            return NULL;
        while (root->left != NULL)
            root = root->left;
        return root;
    }
    ```

    ```C
    TreeNode *rec_findMin(TreeNode *root) {
        if (root == NULL)
            return NULL;
        if (root->left == NULL)
            return root;
        return findMin(root->left);
    }
    ```

=== "Find Max"

    ```C
    TreeNode *findMax(TreeNode *root) {
        if (root == NULL)
            return NULL;
        while (root->right != NULL)
            root = root->right;
        return root;
    }
    ```

    ```C
    TreeNode *rec_findMax(TreeNode *root) {
        if (root == NULL)
            return NULL;
        if (root->right == NULL)
            return root;
        return findMax(root->right);
    }
    ```

=== "Insert"

    ```C
    TreeNode *insert(TreeNode *root, int val) {
        if (root == NULL) {
            root = newTreeNode(val);
        } else if (root->val < val) {
            root->right = insert(root->right, val);
        } else if (root->val > val) {
            root->left = insert(root->left, val);
        }
    }
    ```

=== "Delete"

    删除分为三种情况：

    - 删除叶节点：直接删除即可；
    - 删除只有一个儿子的节点：直接删除，然后把儿子接上；
    - 删除有两个儿子的节点：
        - 将该节点替换为左子树的最大值，或右子树的最小值；
        - 递归删除左子树的最大值，或右子树的最小值。

### 3.4 Threaded Binary Trees

- 如果一个节点的左子节点为空的，那么将左指针指向中序遍历的前驱节点；
- 如果一个节点的右子节点为空的，那么将右指针指向中序遍历的后继节点。
- 一定有一个 Head Node，其左子节点是根，右子节点是自身；被中序遍历的第一个节点的左指针和最后一个节点的右指针共同指向。

### 3.5 Heap/Priority Queue

#### 3.5.1 二叉堆

二叉堆首先是一个满足**堆性质**的完全二叉树，对于最大堆为例，所谓堆性质是：某个树的所有子树的根节点值都大于等于子节点值。同理，我们可以定义最小堆。

#### 3.5.2 堆的实现

堆其实是一个完全二叉树，完全二叉树又很容易表示成数组，所以堆基于数组来实现，但是存储数组的时候很有讲究：数组的元素代表二叉树的节点值，索引代表层序遍历中节点在二叉树中的位置，所有的索引将由 `1` 开始，这样就可以很方便的通过索引来找到节点的父节点和子节点。数据结构如下：

```C
typedef struct HeapStruct{
    int *elements;
    int size;
    int capacity;
} HeapStruct;

typedef HeapStruct *Heap;
```

下面是获取父节点、左子节点、右子节点的函数：

=== "getParent"

    ```c
    int getParent(int i) {
        return i / 2;
    }
    ```

=== "getLeft"

    ```c
    int getLeft(int i) {
        return 2 * i;
    }
    ```

=== "getRight"

    ```c
    int getRight(int i) {
        return 2 * i + 1;
    }
    ```

#### 3.5.3 基本操作

**典中典**：线性建堆算法，时间复杂度为 $O(n)$。

```C
void BuildHeap(Heap H) {
    for (int i = H->size/2; i > 0; i--) {
        PercolateDown(i, H);
    }
}
```

=== "Percolate"

    上滤和下滤，逻辑是先把要移动的元素存起来，然后慢慢腾位置，最后把原来的值放到合适的位置。这里的代码是最小堆的代码。

    ```C
    void PercolateUp(int i, Heap H) {
        int temp = H->data[i];
        int index;
        for (index = i; H->data[index/2] > temp && index > 1; index /= 2)
            H->data[index] = H->data[index/2];      // 找父节点，然后往下移动
        H->data[index] = temp;                      // 把原来的值放到合适的位置
    }

    void PercolateDown(int i, Heap H) {
        int temp = H->data[i];
        int parent, child = 0;
        for (parent = i; parent * 2 <= H->size; parent = child) {
            child = parent * 2;
            if (child != H->size && H->data[child + 1] < H->data[child])
                child++;                            // 找到左右子节点中较小的那个
            if (temp > H->data[child])
                H->data[parent] = H->data[child];
            else break;
        }
        H->data[parent] = temp;
    }
    ```

=== "Insert"

    ```C
    void Insert(int x, Heap H) {
        int i;
        if (H->size == H->capacity) {
            printf("Heap is full.\n");
            return;
        }
        for (i = ++H->size; H->data[i/2] > x; i /= 2)
            H->data[i] = H->data[i/2];
        H->data[i] = x;
    }
    ```

=== "Delete"

    只需要删除堆顶的元素，把最后的元素放到堆顶，然后下滤即可。

    ```C
    int DeleteMin(Heap H) {
        if (H->size == 0) {
            printf("Heap is empty.\n");
            return -1;
        }
        int min = H->data[1];
        H->data[1] = H->data[H->size--];
        PercolateDown(1, H);
        return min;
    }
    ```

### 3.6 Disjoint Set

并查集支持两种操作：

- **Union**：合并两个集合，或者说将一棵树的根节点作为另一棵树的根节点的子节点。
- **Find**：查找某个元素所在的集合，或者查询两个元素是否属于同一个集合，这要求我们找到这个节点的根节点。

使用数组来表示并查集，`S[i]` 的值表示节点 `i` 的父节点，一般会将父节点作为负数，其绝对值表示父节点代表的集合的大小。

#### 3.6.1 路径压缩

在查找的过程中将路径上的所有节点都指向根节点，这样可以减少查找的时间复杂度与树的高度。

```C
int Find(int x) {
    if (S[x] < 0)
        return x;
    return S[x] = Find(S[x]);
}
```

或者一种更简单的方法：

```C
int Find(int x) {
    return S[x] < 0 ? x : S[x] = Find(S[x]);
}
```

以循环实现：

```C
int Find(int x) {
    int root;
    for (root = x; S[root] >= 0; root = S[root]) ;       // Find the root
    for (int trail = x; trail != root; trail = S[trail]) // Path Compression
        S[trail] = root;
    return root;
}
```

#### 3.6.2 按大小合并

将节点数较小的树合并到节点数较大的树上。

```C
void Union(int x, int y) {
    int root_x = Find(x);
    int root_y = Find(y);
    if (root_x == root_y)
        return;
    else if (root_x < root_y) {
        S[root_x] += S[root_y];
        S[root_y] = root_x;
    } else {
        S[root_y] += S[root_x];
        S[root_x] = root_y;
    }
}
```

按大小压缩形成的拥有 $N$ 个节点的树的高度不会超过 $\log_{2}N+1$，因此进行 $N$ 次 Union 操作和 $M$ 次 Find 操作的时间复杂度为 $O(N + M\log_{2}N)$。

#### 3.6.3 按高度合并

按高度合并需要记录树的高度，将高度较小的树合并到高度较大的树上。

按高度合并不能和压缩路径一起使用。

```C
void Init (int n) {
    for (int i = 0; i < n; i++) {
        parent[i] = i;
        rank[i] = 0;
    }
}

void Union(int x, int y) {
    int root1 = Find(x);
    int root2 = Find(y);
    if (root1 == root2) {
        return;
    }
    if (rank[root1] < rank[root2]) {
        parent[root1] = root2;
    } else {
        parent[root2] = root1;
        if (rank[root1] == rank[root2]) {
            rank[root1]++;
        }
    }
}
```
