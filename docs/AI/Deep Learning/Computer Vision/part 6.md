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

成像就是一个从三维空间到二维空间的投影过程，但是投影过程没那么简单。如果直接将胶片放在物体前面曝光，那么基本上不能得到一个清晰的图像，因为每一个胶片上的点都并不一一对应一个物体表面的点，太多的点的光线混合在一起了，这样的图片势必不能清晰。一个简单的想法是在胶片和物体之间放一个小孔，那么这就大幅过滤了进入胶片的光线数量，从而使得每一个胶片上的点更有可能对应物体表面的一个点—至少不会有太多点混合在一起。

<img class="center-picture" src="./assets_3/6.webp" alt="image formation" width="500" />

这个开的孔叫做**光圈/Aperture**，光圈越小，成像越清晰，但是透过光线的数量会更少，图像会更暗，如果变得实在太小也会发生**衍射/Diffraction**。

本质上，光圈的想法是过滤光线，使得一个点发出的光线只有可能出现在胶片上的一小部分，从而减少混合的可能性。**透镜/Lens/镜头** 的作用是类似的，它通过折射光线，使得一个点发出的光线更有可能聚集在胶片上的一个点上，不光减少了混合的可能性，还增加了透过光线的数量，从而使得图像更亮。

镜头是一个凸透镜，有汇聚光线的作用。镜头的重要参数是**焦距/Focal Length** $f$，高斯成像公式 $\frac{1}{f} = \frac{1}{d_o} + \frac{1}{d_i}$ 描述了物距 $d_o$，像距 $d_i$ 和焦距 $f$ 之间的关系。

**放大率/Magnification** $M$ 定义为 $M = \frac{h_i}{h_o} = \frac{d_i}{d_o}$，其中 $h_i$ 是像的高度，$h_o$ 是物体的高度。物体离得越远，放大率就越小，成像就越小，这就是近大远小。绝大多数时候，我们可以认为像距 $d_i$ 就是焦距 $f$，因为物体离得很远，$d_o \gg f$，这就是长焦镜头比短焦镜头成像更大的原因。 

**视野/Field of View/FOV** 定义为镜头能够看到的角度范围，视野越大，镜头能够看到的范围就越大。大致满足下面关系 $\tan(\mathit{FOV} / 2) = w/2f$，其中 $w$ 是传感器的宽度，$f$ 是焦距，也就是说，如果传感器越大、焦距越小，视野就越大。

<img class="center-picture" src="./assets_3/7.webp" alt="image formation" width="500" />

镜头也有光圈/Aperture，光圈大小直接由直径 $D$ 表示，但是更方便的是用**光圈数值/F-number** $N = f/D$ 来表示，F-number 越大，光圈直径越小，但是图像越暗。

**失焦/Defocus** 是由于物体不在焦平面上导致的模糊现象。对焦错误的物体在成像平面上形成一个模糊圆圈，如果对焦错误的物体物距为 $o'$，焦距为 $f$，像距为 $i'$，则模糊圆圈的直径 $b = D / i' \cdot \lvert i' - i \rvert$，这里面 $i$ 是正确对焦时的像距。

<img class="center-picture" src="./assets_3/8.webp" alt="image formation" width="500" />

**景深/Depth of Field/DOF** 是指在成像时，物体可以偏离焦平面多少距离而仍然保持清晰的范围，意思是说，即使物体出现一定的失焦，但是其模糊圆圈的直径仍然小于某个允许的最大值 $c$，这个值一般是像素点的大小或者人眼能够分辨的最小尺寸。计算公式比较复杂，但是一般来讲，**焦距越大，景深越小**，所以长焦镜头更容易拍出来背景虚化的照片；**物距越小，景深越小**，所以拍远处的物体更容易清晰，拍近处的物体更容易虚化；$N$ 越小，**光圈越大，景深越小**，越容易虚化。所以拍人像的时候一般使用大光圈、长焦距、近前景、远背景的组合。

<img class="center-picture" src="./assets_3/9.webp" alt="image formation" width="500" />

## Lec 3: Image Processing

