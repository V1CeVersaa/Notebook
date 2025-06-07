# Advanced Heaps

简而言之，除了下面几个特例，所有堆操作的时间复杂度都是 $O(\log n)$ 的：

1. 普通的二叉堆的合并是 $O(n)$ 的；
2. 二项堆的插入是 $O(1)$ 的；
3. 斜堆不考虑单点删除 Delete 和 DecreaseKey 操作。

## Leftist Heaps

定义每个结点的**零路径长/Null Path Length/**$\operatorname*{NPL}$ 为该结点到没有**两个孩子的子结点**的长度，并且定义 $\operatorname*{NPL}(\mathrm{null}) = -1$，没有孩子或者只有一个孩子的节点的 $\operatorname*{PNL}$ 为 0。注意到有下面事情：

$$
\operatorname*{NPL}(p) = \min\left\{\operatorname*{NPL}(\text{left}(p)), \operatorname*{NPL}(\text{right}(p)\right\} + 1
$$

若一个堆满足**左倾堆性质**，那么对于任意结点 $p$，有其左孩子的 $\operatorname*{NPL}$ 不小于右孩子的 $\operatorname*{NPL}$。那么称这样的堆为一个左顷堆/Leftist Heap。

左顷堆有一个很浅显的性质：若一个左顷堆的**右路径**上有 $r$ 个结点，这里右路径指的是从根结点到最右下方的孩子的路径，那么这个堆至少会有 $2^r - 1$ 个结点。左倾堆右路径节点个数至多是 $\lfloor \log (n + 1) \rfloor$ 的

左顷堆的核心是合并操作，递归式是通过下面操作完成的：先比较当前两个待合并子树的根结点的键值，选择较小（较大）的那个作为根结点，其左子树依然为左子树，右子树更新为「右子树和另一个待合并子树的合并结果」。在递归地更新完后，需要不**断检查左子树和右子树是否满足** $\operatorname*{NPL}_{\text{left child}} \geq \operatorname*{NPL}_{\text{right child}}$​ 的性质，如果不满足，我们则需要交换左右子树来维持性质。

```c
LeftistHeap merge_recursive(LeftistHeap h1, LeftistHeap h2) {
    if (h1 == NULL) return h2;
    if (h2 == NULL) return h1;
    if (h1->key > h2->key) {
        // Choose the smaller one as the root
        LeftistHeap temp = h1;
        h1 = h2;
        h2 = temp;
    }
    h1->right = merge_recursive(h1->right, h2);
    // Swap left and right child if needed
    if (h1->left == NULL) {
        h1->left = h1->right;
        h1->right = NULL;
    } else {
        if (h1->left->npl < h1->right->npl) {
            // Swap if NPL(left) < NPL(right)
            LeftistHeap temp = h1->left;
            h1->left = h1->right;
            h1->right = temp;
        }
        // Update NPL
        h1->npl = h1->right->npl + 1;
    }
    return h1;
}
```

迭代方式更加简洁：

<img class="center-picture" src="./assets/Heap-2.png" alt="drawing" width="600" />


单点插入可以看作是将一个结点作为一个左顷堆，然后与原堆合并的过程。DeleteMin 则是将根结点删除后，将其左右子树合并的过程。没啥可说的。

在递归的过程中，我们发现递归的深度不会超过两个堆的右路径的长度之和，因为每次递归都会使得两个堆的其中一个向着右路径上下一个右孩子推进，并且直到其中一个推到了叶子结点就不再加深递归。此递归向下的过程是 $O(\log n)$ 的。同时每一层的操作也是常数的，因为只需要完成接上指针、判断根结点、交换子树与更新 $\operatorname*{NPL}$ 的操作，所以整体的复杂度是 $O(\log n)$ 的。

单点删除也很简单，只需要将那个结点进行删除，然后其左右子树合并为新的子树（这里记为 $H_{\text{sub}}$，然后将 $H_{\text{sub}}$ 与原堆合并，最后从底向上递归的维护 $\operatorname*{NPL}$ 即可。注意到如果某个堆结点的左右子树都是左顷堆，那么这个结点也是左顷堆，所以我们合并成的 $H_{\text{sub}}$ 既然一定是左顷堆，那么就可以保证整个堆的性质不会被破坏。

## Skew Heaps

### 1. 数据结构介绍

我们回忆 Splay 树和 AVL 树，它们都是通过旋转操作来维持平衡性质的，但是唯一区别就是 AVL 树需要自底向上维持平衡性质，但是 Splay 树就不需要，其无条件的旋转操作提醒我们，或许可以通过无条件地交换左右子树来完成合并操作。具体操作如下：

1. Base Case：若堆 $H$ 与空堆 `null` 连接的情况时，斜堆需要处理 $H$ 的右路径，我们要求 $H$ 右路径上除了最大结点之外都必须交换其左右孩子（但是最大结点显然是右路径的最底端，不可能同时有左右结点，所以其不需要交换，除此之外对右路径上的每个结点，都需要对其左右结点进行交换）。
2. 非 Base Case：若 $H_1$ 的根结点小于 $H_2$，选择好根结点之后，其左子树甩到右边，成为右子树，然后递归地合并右子树和剩下的堆到新的根结点的左子树上。

斜堆一般不考虑单点删除和 DecreaseKey 这两个操作。

<img class="center-picture" src="./assets/Heap-3.png" alt="drawing" width="600" />

!!! Note
    It is an open problem to determine **precisely** the **expected right path length** of both leftist and skew heaps.

### 2. 摊还分析

**Definition**：一个结点 $p$ 被称为**重的/Heavy**，如果果它的右子树结点个数至少是 $p$ 的所有后代的一半（后代包括该结点 $p$ 自身）。反之称为轻结点/Light。

**引理**：对于右路径上有 $l$ 个**轻**结点的斜堆，整个斜堆至少有 $2^l - 1$ 个结点，这意味着**一个** $n$ **个结点的斜堆右路径上的轻结点个数为** $O(\log n)$。

**定理** 若我们有两个斜堆 $H_1$ 和 $H_2$，它们分别有 $n_1$ 和 $n_2$ 个结点，则合并 $H_1$ 和 $H_2$ 的摊还时间复杂度为 $O(\log n)$，其中 $n = n_1 + n_2$。

!!! Note "证明"
    有两个非常重要的观察：

    - **只有在** $H_1$ 和 $H_2$ **右路径上的结点才可能改变轻重状态**，这是很显然的，因为其它结点合并前后子树是完全被复制的，所以不可能改变轻重状态；
    - $H_1$ 和 $H_2$ **右路径上的重结点在合并后一定会变成轻结点**，这是因为右路径上结点一定会交换左右子树，并且后续所有结点也都会继续插入在左子树上（这也表明轻结点不一定变为重结点）。


## Binomial Heaps

### 1. 数据结构介绍和时间复杂度分析

**二项树**通过递归定义：一个只有一个结点的树为一个二项树，记为 $B_0$，其高度为 $0$，阶数也为 $0$；而 $k$ 阶 $B_k$ 为由两个 $B_{k-1}$ 的树根连接而成的树，连接方式是将一个树的树根链接到另外一个树的树根上。二项树 $B_k$ 的根结点有一棵 $B_{k-1}$ 子树，并且根结点的度数为 $k$，高度为 $k$。

$k$ 阶二项树有着一些简单的性质：

- 二项树不是二叉树，是 $N$ 叉树，$N$ 恰好是二项树的阶数；
- $k$ 阶二项树都是同构的，其树根都有 $k$ 个孩子，$2^k$ 个后代结点；
- $k$ 阶二项树的树根的孩子恰好为 $B_0$、$B_1$、$\cdots$、$B_{k-1}$；
- $k$ 阶二项树的深度为 $l$ 的结点恰好有 $\binom{k}{l}$ 个（根结点深度为 $0$）。

**二项堆**是一堆二项树组成的森林，其中每一个二项树都满足堆性质，且每一个二项树都具有不同的高度。

最简单的操作是 FindMin（对应最小堆），只需要遍历二项堆的根结点就可以了，这时候时间复杂度为 $O(\log n)$，也可以通过维护一个指向最小结点的指针来实现 $O(1)$ 的时间复杂度。

其次就是合并 Merge：首先，每个二项堆都唯一对应着一个二进制数，两个二项堆之间的合并可以看作两个二进制数的相加。我们从最低位向最高位进行操作，如果某一位进行的操作相当于 `1 + 1`，那么就会产生进位，这时候我们就需要将进位传递到下一位，这就恰好是两个相同阶数的二项树合并成一个阶数加一的二项树的过程。从二进制加法的角度来看，合并操作的时间复杂度显然是 $O(\log n)$ 的。

插入是合并的特例，相当于将一个结点作为一个二项树，然后与原堆合并，最差情况是不断产生进位，时间复杂度也是 $O(\log n)$。如果一个二项堆中最小的不存在的二项树为 $B_k$，那么插入的时间为 $T_{p} = \mathit{Const}\cdot (k + 1)$。而向一个空的二项堆插入 $n$ 个结点的时间复杂度为 $O(n)$，均摊时间复杂度因此就是常数时间。利用聚合法分析如下：

!!! Note "聚合法均摊分析"

    由于插入的操作和二进制数加一有着完全的对应关系，由于 $n$ 有着 $\lfloor\log n\rfloor + 1$ 个二进制比特位，并且每次加一都会有反转比特，每次反转比特对应的堆操作和树操作都是常数时间的。而最低位每次加一都会反转比特，次低位每两次加一就会反转比特，之后同理，所以 $n$ 次操作的整体时间复杂度为 

    $$
    n + \frac{n}{2} + \frac{n}{4} + \cdots + \frac{n}{2^{\lfloor\log n\rfloor + 1}} \to 2n
    $$

    极限在 $n\to \infty$ 的时候取到，这样就可以获得单步操作的常数摊还时间。

DeleteMin 的时间复杂度也 $O(\log n)$，大概分四步，首先找到最小的根结点与对应的树 $B_k$，然后将 $B_k$ 从二项堆中删除，接着将 $B_k$ 的子树们和原来的二项堆合并。每一步都是 $O(\log n)$  或 $O(1)$ 的时间复杂度，所以整体的时间复杂度是 $O(\log n)$ 的。

### 2. 二项堆的代码实现

首先，因为每个结点的孩子数量可能不只有两个，因此我们使用 LeftChild 和 NextSibling 的组合实现。

```cpp
BinQueue Merge( BinQueue H1, BinQueue H2 ){
    BinTree T1, T2, Carry = NULL;   
    int i, j;
    if ( H1->CurrentSize + H2-> CurrentSize > Capacity )  ErrorMessage();
    H1->CurrentSize += H2-> CurrentSize;
    for ( i=0, j=1; j<= H1->CurrentSize; i++, j*=2 ) {
        T1 = H1->TheTrees[i]; T2 = H2->TheTrees[i]; /* Current Status */
        switch( 4*!!Carry + 2*!!T2 + !!T1 ) { 
        case 0: /* 000 */  break;
        case 1: /* 001 */  break;   
        case 2: /* 010 */  H1->TheTrees[i] = T2; H2->TheTrees[i] = NULL; break;
        case 4: /* 100 */  H1->TheTrees[i] = Carry; Carry = NULL; break;
        case 3: /* 011 */  Carry = CombineTrees( T1, T2 );
                        H1->TheTrees[i] = H2->TheTrees[i] = NULL; break;
        case 5: /* 101 */  Carry = CombineTrees( T1, Carry );
                        H1->TheTrees[i] = NULL; break;
        case 6: /* 110 */  Carry = CombineTrees( T2, Carry );
                        H2->TheTrees[i] = NULL; break;
        case 7: /* 111 */  H1->TheTrees[i] = Carry; 
                        Carry = CombineTrees( T1, T2 ); 
                        H2->TheTrees[i] = NULL; break;
        }
    }
    return H1;
}
```

简单解释如下：

1. `Case 000`：没有树合并，直接 `break`；
2. `Case 001`：只有 $H_1$ 有树，不用合并，直接 `break`；
3. `Case 010`：只有 $H_2$ 有树，将 $H_2$ 的树移动到 $H_1$ 上；
4. `Case 100`：有进位，将进位树移动到 $H_1$ 上，进位清空；
5. `Case 011`：产生进位，将 $H_1$ 和 $H_2$ 的树合并为 `Carry`，$H_1$ 和 $H_2$ 的树清空；
6. `Case 101`：有进位且产生进位，将 $H_1$ 和进位树合并为 `Carry`，$H_1$ 的树清空；
7. `Case 110`：有进位且产生进位，将 $H_2$ 和进位树合并为 `Carry`，$H_2$ 的树清空；
8. `Case 111`：有进位且产生进位，将进位树移动到 $H_1$ 上，$H_1$ 和 $H_2$ 的树合并为进位树。

删除操作看起来复杂得多：

<img class="center-picture" src="./assets/Heap-4.png" alt="drawing" width="600" />

## Fibonacci Heap


## Amortized Performance 

| Operation   | Binary Heap   | Leftist Heap  | Skew Heap     | Binomial Heap | Fibonacci Heap |
| ----------- | ------------- | ------------- | ------------- | ------------- | -------------- |
| Insert      | \(O(\log n)\) | \(O(\log n)\) | \(O(\log n)\) | \(O(1)\)      | \(O(1)\)       |
| Merge       | \(O(n)\)      | \(O(\log n)\) | \(O(\log n)\) | \(O(\log n)\) | \(O(1)\)       |
| DeleteMin   | \(O(\log n)\) | \(O(\log n)\) | \(O(\log n)\) | \(O(\log n)\) | \(O(\log n)\)  |
| Delete      | \(O(\log n)\) | \(O(\log n)\) |               | \(O(\log n)\) | \(O(\log n)\)  |
| DecreaseKey | \(O(\log n)\) | \(O(\log n)\) |               | \(O(\log n)\) | \(O(1)\)       |
