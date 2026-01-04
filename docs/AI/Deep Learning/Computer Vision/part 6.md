# Introduction to Computer Vision in ZJU

## Lec 1: Introduction & Linear Algebra Review

罗列一下需要知道的点：

- 向量：向量的范数、单位向量/归一化、向量的加减、点积
- 矩阵：加减（矩阵之间、矩阵和标量）、乘法（满足结合律和分配律，但是不满足交换律）、单位矩阵，矩阵的逆（可逆矩阵必须是方阵，必须满足行秩等于列秩等于矩阵的秩，换句话说必须满秩），矩阵代表一个线性变换

=== "Scale"

    <img class="center-picture" src="./assets_3/1.webp" alt="image formation" width="500" />

=== "Reflection"
 
    <img class="center-picture" src="./assets_3/2.webp" alt="image formation" width="500" />

=== "Shear"

    <img class="center-picture" src="./assets_3/3.webp" alt="image formation" width="500" />

=== "Rotation"

    <img class="center-picture" src="./assets_3/4.webp" alt="image formation" width="500" />

=== "Affine Transformation"

    <img class="center-picture" src="./assets_3/5.webp" alt="image formation" width="500" />

- 特征值与特征向量：$Ax = \lambda x$，这里的 $x$ 就是 $A$ 的特征向量，$\lambda$ 是对应的特征值。特征值分解：$A = V \Lambda V^{-1}$，其中 $V$ 是特征向量组成的矩阵，$\Lambda$ 是对角矩阵，对角线上是对应的特征值。
- 主成分分析/PCA：作为特征值和特征向量的应用，算法流程为计算去中心化后的数据矩阵 $A_\text{centered}$ 的协方差矩阵 $C = \frac{1}{n-1} A_\text{centered}^T A_\text{centered}$，然后对 $C$ 进行特征值分解，选择最大的 $k$ 个特征值对应的特征向量作为新的基底，将数据投影到这个新的基底上，从而实现降维。

## Lec 2: Image Formation

成像就是一个从三维空间到二维空间的投影过程，但是投影过程没那么简单。如果直接将胶片放在物体前面曝光，

## Lec 3: Image Processing

