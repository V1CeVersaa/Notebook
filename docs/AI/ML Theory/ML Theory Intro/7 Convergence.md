# Chapter 7: 收敛率

!!! Info "几乎全是凸优化里边的知识，如果学过会很爽"

本章关注优化算法的收敛率/Convergence Rate，首先回顾一下优化问题的一般形式：

$$\min_{\boldsymbol{w}\in\mathcal{W}} f(\boldsymbol{w}),$$

其中 $f(\cdot)$ 是优化的目标函数，$\boldsymbol{w}$ 是优化变量，$\mathcal{W}$ 是优化变量的可行域。为了方便讨论，下面仅关注凸优化问题，即要求上述优化问题的目标函数 $f(\cdot)$ 是凸函数，优化变量 $\boldsymbol{w}$ 的可行域 $\mathcal{W}$ 是凸集合。注意到，第 1 章所提到的支持向量机的主问题和对偶问题均可以表示为上述形式。在评价不同的优化算法时，会有收敛条件和收敛率这两个角度来对优化进程进行评估和考量。

## 1. 基本概念

令上述优化问题的最优解为 $\boldsymbol{w}^* \in \arg\min_{\boldsymbol{w}\in\mathcal{W}} f(\boldsymbol{w})$，优化算法旨在高效地寻找优化问题的最优解 $\boldsymbol{w}^*$，或目标函数的最小值 $f(w^*)$。然而，精确求解优化问题一般而言是非常困难的。因此，优化算法通常设计为迭代算法，不断近似求解优化问题。记迭代优化算法为 $\mathcal{A}$，该算法生成一组序列 $\{\boldsymbol{w}_1, \boldsymbol{w}_2, \ldots, \boldsymbol{w}_t, \ldots\}$ 来不断逼近目标函数的最优解 $\boldsymbol{w}^*$。一般而言，迭代优化算法采用如下更新方法，

$$\boldsymbol{w}_{t+1} = \mathcal{M}(\boldsymbol{w}_t, \mathcal{O}(f, \boldsymbol{w}_t)),$$

其中 $\mathcal{M}$ 为优化算法的更新策略，$\mathcal{O}$ 为函数信息源。

根据所使用的函数信息源 $\mathcal{O}$ 的不同，常用优化算法可以分为零阶算法、一阶算法和二阶算法：

1. 零阶算法：仅利用函数值来优化的算法，典型的零阶优化算法有遗传算法、粒子群算法和模拟退火算法等。
2. 一阶算法：利用函数的梯度信息来优化的算法，典型的一阶优化算法有梯度下降/Gradient Descent/GD 算法和随机梯度下降/Stochastic Gradient Descent/SGD 算法等。
3. 二阶算法：利用函数的 Hessian 矩阵来优化的算法，典型的二阶优化算法有牛顿法。

刻画优化算法性能有两种等价的衡量准则：**收敛率**和**迭代复杂度**。假设算法迭代了 $T$ 轮，$\boldsymbol{w}_T$ 为最终输出。

- 收敛率旨在刻画优化误差 $f(\boldsymbol{w}_T) - f(\boldsymbol{w}^*)$ 与迭代轮数 $T$ 之间的关系，常见的收敛率有

    $$f(\boldsymbol{w}_T) - f(\boldsymbol{w}^*) = O\left(\frac{1}{\sqrt{T}}\right), O\left(\frac{1}{T}\right), O\left(\frac{1}{T^2}\right), O\left(\frac{1}{\beta^T}\right),$$

    其中 $\beta > 1$。上面列举的收敛率越来越快，最后一种收敛率 $O(1/\beta^T)$ 通常被称为线性收敛，因为误差位于误差和迭代次数的对数线性坐标图中的一根直线的下方。

- 迭代复杂度则是刻画为了达到 $\epsilon$-最优解，需要的迭代轮数。具体而言，迭代复杂度描述为了达到 $f(\boldsymbol{w}_T) - f(\boldsymbol{w}^*) \leq \epsilon$，迭代轮数 $T$ 和 $\epsilon$ 的关系。上述收敛率所对应的迭代复杂度分别为：

    $$T = \Omega\left(\frac{1}{\epsilon^2}\right), \Omega\left(\frac{1}{\epsilon}\right), \Omega\left(\frac{1}{\sqrt{\epsilon}}\right), \Omega\left(\log\frac{1}{\epsilon}\right).$$

收敛率和迭代复杂度反映了目标函数的最优性。当最优解唯一时，也可以采用当前解和最优解之间的距离 $d(\boldsymbol{w}_t, \boldsymbol{w}^*)$ 作为评估优化算法性能的指标，其中 $d(\cdot,\cdot)$ 是某距离度量函数，如欧氏距离 $d(\boldsymbol{w}_t, \boldsymbol{w}^*) = \|\boldsymbol{w}_t - \boldsymbol{w}^*\|$。

常见的优化算法可以分为确定优化/Deterministic Optimization 和随机优化/Stochastic Optimization 两类。确定优化利用函数的真实信息来进行迭代更新，而随机优化则会利用一些随机信息（如梯度的无偏估计）来进行迭代更新。下面将分别介绍确定优化方法和随机优化方法，并考虑凸函数和强凸函数两种情况。

## 2. 确定优化

### 2.1 凸函数

对于一般的凸优化问题，可以采用梯度下降达到 $O(1/\sqrt{T})$ 的收敛率，我们这里考虑的是梯度投影法，基本流程如下：

<img class="center-picture" src="./assets/7-1.webp" width="600" />

在第 $t$ 轮迭代中，首先计算函数 $f(\cdot)$ 在 $\boldsymbol{w}_t$ 上的梯度 $\nabla f(\boldsymbol{w}_t)$，然后依据梯度下降 $\boldsymbol{w}'_{t+1} = \boldsymbol{w}_t - \eta_t \nabla f(\boldsymbol{w}_t)$ 更新当前解，其中 $\eta_t > 0$ 为步长。这里需要注意的是，在原始问题中存在 $\boldsymbol{w} \in \mathcal{W}$ 的约束。但是通过梯度下降获得的中间解 $\boldsymbol{w}'_{t+1}$ 不必属于集合 $\mathcal{W}$。因此还需要通过投影操作 $\boldsymbol{w}_{t+1} = \Pi_\mathcal{W}(\boldsymbol{w}'_{t+1})$ 保证下一轮的解属于 $\mathcal{W}$。投影操作的定义为：

$$\Pi_\mathcal{W}(\boldsymbol{z}) = \underset{\boldsymbol{x}\in\mathcal{W}}{\arg\min} \|\boldsymbol{x}-\boldsymbol{z}\|,$$

其目的是在集合 $\mathcal{W}$ 中寻找距离输入最近的点。最后，将算法 $T$ 轮迭代的平均值作为输出。

下面给出采用固定步长梯度下降的收敛率。

**定理 7.1**（梯度下降收敛率）：假设目标函数 $f(\cdot)$ 是凸的 $l$-Lipschitz 连续函数，且可行域 $\mathcal{W}$ 有界，则采用固定步长梯度下降的收敛率为 $O\left(1/\sqrt{T}\right)$。

???- Info "证明"

    假设可行域 $\mathcal{W}$ 直径为 $\Gamma$，并且目标函数满足 $l$-Lipschitz 连续，即对于任意 $\boldsymbol{u}, \boldsymbol{v} \in \mathcal{W}$，

    $$\|\boldsymbol{u}-\boldsymbol{v}\| \leq \Gamma, \quad \|\nabla f(\boldsymbol{u})\| \leq l.$$

    为了简化分析，考虑固定的步长 $\eta_t = \eta$。

    对于任意的 $\boldsymbol{w} \in \mathcal{W}$，

    $$\begin{aligned}
        f(\boldsymbol{w}_t) - f(\boldsymbol{w}) &\leq \langle\nabla f(\boldsymbol{w}_t), \boldsymbol{w}_t - \boldsymbol{w}\rangle \\
        &= \frac{1}{\eta}\langle\boldsymbol{w}_t - \boldsymbol{w}'_{t+1}, \boldsymbol{w}_t - \boldsymbol{w}\rangle \\
        &= \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}'_{t+1} - \boldsymbol{w}\|^2 + \|\boldsymbol{w}_t - \boldsymbol{w}'_{t+1}\|^2) \\
        &= \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}'_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta}{2}\|\nabla f(\boldsymbol{w}_t)\|^2 \\
        &\leq \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta}{2}\|\nabla f(\boldsymbol{w}_t)\|^2,
    \end{aligned}$$

    最后一个不等号利用了凸集合投影操作的非扩展性质：

    $$\|\Pi_\mathcal{W}(\boldsymbol{x}) - \Pi_\mathcal{W}(\boldsymbol{z})\| \leq \|\boldsymbol{x}-\boldsymbol{z}\|, \forall \boldsymbol{x},\boldsymbol{z}.$$

    注意到目标函数满足 $l$-Lipschitz连续，所以我们可以得到：

    $$f(\boldsymbol{w}_t) - f(\boldsymbol{w}) \leq \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta}{2}l^2.$$

    对上式从 $t=1$ 到 $T$ 求和，有：

    $$\begin{aligned}
        \sum_{t=1}^T f(\boldsymbol{w}_t) - Tf(\boldsymbol{w}) &\leq \frac{1}{2\eta}(\|\boldsymbol{w}_1 - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{T+1} - \boldsymbol{w}\|^2) + \frac{\eta T}{2}l^2 \\
        &\leq \frac{1}{2\eta}\|\boldsymbol{w}_1 - \boldsymbol{w}\|^2 + \frac{\eta T}{2}l^2 \\
        &\leq \frac{1}{2\eta}\Gamma^2 + \frac{\eta T}{2}l^2.
    \end{aligned}$$

    根据 Jensen 不等式可以得到：

    $$\begin{aligned}
        f(\bar{\boldsymbol{w}}_T) - f(\boldsymbol{w}) &= f\left(\frac{1}{T}\sum_{t=1}^T \boldsymbol{w}_t\right) - f(\boldsymbol{w}) \\
        &\leq \frac{1}{T}\sum_{t=1}^T f(\boldsymbol{w}_t) - f(\boldsymbol{w}) \\
        &\leq \frac{\Gamma^2}{2\eta T} + \frac{\eta l^2}{2}.
    \end{aligned}$$

    因此，

    $$f(\bar{\boldsymbol{w}}_T) - \min_{\boldsymbol{w}\in\mathcal{W}} f(\boldsymbol{w}) \leq \frac{\Gamma^2}{2\eta T} + \frac{\eta l^2}{2} = \frac{l\Gamma}{\sqrt{T}} = O\left(\frac{1}{\sqrt{T}}\right).$$

    这使用了均值不等式的性质，其中步长设置为 $\eta = \Gamma/(l\sqrt{T})$。

    定理得证。

### 2.2 强凸函数

本节考虑目标函数 $f : \mathcal{W} \mapsto \mathbb{R}$ 是 $\lambda$-强凸函数，即其满足 $f(\boldsymbol{z}) \geq f(\boldsymbol{x}) + \nabla f(\boldsymbol{x})^{\mathrm{T}}(\boldsymbol{z} - \boldsymbol{x}) + \frac{\lambda}{2}\lVert \boldsymbol{z} - \boldsymbol{x} \rVert^2$。对于 $\lambda$-强凸函数，有以下定理：

**定理 7.2**（强凸函数性质）：假设 $f$ 为 $\lambda$-强凸函数，$\boldsymbol{w}^*$ 为其最优解，对于任意 $\boldsymbol{w} \in \mathcal{W}$ 有

$$f(\boldsymbol{w}) - f(\boldsymbol{w}^*) \geq \frac{\lambda}{2}\|\boldsymbol{w} - \boldsymbol{w}^*\|^2.$$

此外，若梯度有上界 $l$，则

$$\begin{aligned}
    \|\boldsymbol{w} - \boldsymbol{w}^*\| &\leq \frac{2l}{\lambda}, \\
    f(\boldsymbol{w}) - f(\boldsymbol{w}^*) &\leq \frac{2l^2}{\lambda}.
\end{aligned}$$

我们也要求其是一个 $\gamma$-Lipschitz 连续函数，即对于任意 $\boldsymbol{w}, \boldsymbol{v} \in \mathcal{W}$，有

$$|\nabla f(\boldsymbol{w}) - \nabla f(\boldsymbol{v})| \leq \gamma\|\boldsymbol{w} - \boldsymbol{v}\|.$$

根据我们在凸优化已经证明的内容，这等价于：

$$f(\boldsymbol{w}^{\prime}) \leq f(\boldsymbol{w}) + \langle\nabla f(\boldsymbol{w}), \boldsymbol{w}^{\prime} - \boldsymbol{w}\rangle + \frac{\gamma}{2}\|\boldsymbol{w}^{\prime} - \boldsymbol{w}\|^2, \forall \boldsymbol{w}, \boldsymbol{w}^{\prime} \in \mathcal{W}.$$

针对光滑且强凸函数的梯度下降算法的基本流程如下：

<img class="center-picture" src="./assets/7-2.webp" width="600" />

和一般的凸函数的梯度下降方法类似，每轮迭代的优化式子的闭式解为：

$$\boldsymbol{w}_{t+1} = \Pi_\mathcal{W}\left(\boldsymbol{w}_t - \frac{1}{\gamma}\nabla f(\boldsymbol{w}_t)\right).$$

因此，其本质仍然是梯度投影法。对于上述梯度下降算法，有如下定理：

**定理 7.3**（梯度下降收敛率）：若目标函数满足 $\lambda$-强凸且 $\gamma$-Lipschitz 连续，梯度下降取得了线性收敛率 $O\left(1/\beta^T\right)$，其中 $\beta > 1$。

???- Info "证明"

    根据目标函数的性质以及更新公式，

    $$\begin{aligned}
        f(\boldsymbol{w}_{t+1}) &\leq f(\boldsymbol{w}_t) + \langle\nabla f(\boldsymbol{w}_t), \boldsymbol{w}_{t+1} - \boldsymbol{w}_t\rangle + \frac{\gamma}{2}\|\boldsymbol{w}_{t+1} - \boldsymbol{w}_t\|^2 \\
        &= \min_{\boldsymbol{w}\in\mathcal{W}}\left(f(\boldsymbol{w}_t) + \langle\nabla f(\boldsymbol{w}_t), \boldsymbol{w} - \boldsymbol{w}_t\rangle + \frac{\gamma}{2}\|\boldsymbol{w} - \boldsymbol{w}_t\|^2\right) \\
        &\leq \min_{\boldsymbol{w}\in\mathcal{W}}\left(f(\boldsymbol{w}) - \frac{\lambda}{2}\|\boldsymbol{w} - \boldsymbol{w}_t\|^2 + \frac{\gamma}{2}\|\boldsymbol{w} - \boldsymbol{w}_t\|^2\right) \\
        &\leq \min_{\boldsymbol{w}=\alpha\boldsymbol{w}^*+(1-\alpha)\boldsymbol{w}_t,\alpha\in[0,1]}\left(f(\boldsymbol{w}) + \frac{\gamma-\lambda}{2}\|\boldsymbol{w} - \boldsymbol{w}_t\|^2\right) \\
        &= \min_{\alpha\in[0,1]}\left(f(\alpha\boldsymbol{w}^* + (1-\alpha)\boldsymbol{w}_t) + \frac{\gamma-\lambda}{2}\|\alpha\boldsymbol{w}^* + (1-\alpha)\boldsymbol{w}_t - \boldsymbol{w}_t\|^2\right) \\
        &\leq \min_{\alpha\in[0,1]}\left(\alpha f(\boldsymbol{w}^*) + (1-\alpha)f(\boldsymbol{w}_t) + \frac{\gamma-\lambda}{2}\alpha^2\|\boldsymbol{w}^* - \boldsymbol{w}_t\|^2\right) \\
        &= \min_{\alpha\in[0,1]}\left(f(\boldsymbol{w}_t) - \alpha(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)) + \frac{\gamma-\lambda}{2}\|\alpha\boldsymbol{w}^* + (1-\alpha)\boldsymbol{w}_t - \boldsymbol{w}_t\|^2\right) \\
        &\leq \min_{\alpha\in[0,1]}\left(f(\boldsymbol{w}_t) - \alpha(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)) + \frac{\gamma-\lambda}{2}\frac{2}{\lambda}\alpha^2(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*))\right) \\
        &= \min_{\alpha\in[0,1]}\left(f(\boldsymbol{w}_t) + \left(\frac{\gamma-\lambda}{\lambda}\alpha^2 - \alpha\right)(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*))\right).
    \end{aligned}$$

    这就到了对二次函数进行优化：

    - 如果 $\lambda/(2(\gamma-\lambda)) \geq 1$，令 $\alpha = 1$，则有

        $$f(\boldsymbol{w}_{t+1}) - f(\boldsymbol{w}^*) \leq \frac{\gamma-\lambda}{\lambda}(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)) \leq 1/2(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)).$$

    - 如果 $\lambda/(2(\gamma-\lambda)) < 1$，令 $\alpha = \lambda/(2(\gamma-\lambda))$，则有

        $$f(\boldsymbol{w}_{t+1}) - f(\boldsymbol{w}^*) \leq (1 - \frac{\lambda}{4(\gamma - \lambda)})(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)) = \frac{4\gamma-5\lambda}{4(\gamma-\lambda)}(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)).$$

    因此，令

    $$\beta = \begin{cases}
        \frac{\lambda}{\gamma - \lambda}, & \frac{\lambda}{2(\gamma-\lambda)} \geq 1; \\
        \frac{4(\gamma-\lambda)}{4\gamma-5\lambda}, & \frac{\lambda}{2(\gamma-\lambda)} < 1;
    \end{cases}$$

    那么下式总是成立

    $$f(\boldsymbol{w}_{t+1}) - f(\boldsymbol{w}^*) \leq \frac{1}{\beta}(f(\boldsymbol{w}_t) - f(\boldsymbol{w}^*)).$$

    将上式扩展可得

    $$f(\boldsymbol{w}_T) - f(\boldsymbol{w}^*) \leq \frac{1}{\beta^{T-1}}(f(\boldsymbol{w}_1) - f(\boldsymbol{w}^*)) = O\left(\frac{1}{\beta^T}\right).$$  

    定理得证。

如果目标函数只满足强凸性质，就可以采用后面针对强凸函数的随机优化算法，仅需要将随机梯度改为真实梯度。

## 3. 随机优化

### 3.1 凸函数

<!-- ## 3. 随机优化

### 3.1 凸函数

为优化凸函数，将采用随机优化的代表性算法——随机梯度下降。随机梯度下降和梯度下降非常类似，唯一的区别在于使用随机梯度代替真实梯度。与真实梯度相比，随机梯度的计算通常更加简单，因此每轮迭代的计算代价低。

随机梯度下降算法的一般流程如下：

1: 任意初始化 $\boldsymbol{w}_1 \in \mathcal{W}$;  
2: for $t = 1,\ldots,T$ do  
3:    梯度下降: $\boldsymbol{w}'_{t+1} = \boldsymbol{w}_t - \eta_t\boldsymbol{g}_t$;  
4:    投影: $\boldsymbol{w}_{t+1} = \Pi_\mathcal{W}(\boldsymbol{w}'_{t+1})$;  
5: end for  
6: 返回 $\bar{\boldsymbol{w}}_T = \frac{1}{T}\sum_{t=1}^T \boldsymbol{w}_t$。

其中要求 $\boldsymbol{w}_t$ 的随机梯度 $\boldsymbol{g}_t$ 是真实梯度 $\nabla f(\boldsymbol{w}_t)$ 的无偏估计，即

$$\mathbb{E}[\boldsymbol{g}_t] = \nabla f(\boldsymbol{w}_t).$$

上述方法非常适用于机器学习问题，尤其是在处理大数据时。下面以监督学习为例介绍随机梯度下降的应用。监督学习的最终目的是最小化泛化风险。令数据分布为 $\mathcal{D}$，可以用风险最小化来描述监督学习的目标

$$\min_{\boldsymbol{w}\in\mathcal{W}} f(\boldsymbol{w}) = \mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\boldsymbol{w},\boldsymbol{z})],$$

其中 $\boldsymbol{z} \sim \mathcal{D}$ 表示 $\boldsymbol{z}$ 是从数据分布 $\mathcal{D}$ 中采样获得，$\ell(\cdot,\cdot)$ 为损失函数。但是在现实场景中很难直接获得真实的数据分布 $\mathcal{D}$，因此通常采用经验风险最小化来近似求解上述问题。从数据分布 $\mathcal{D}$ 独立同分布采样得到 $m$ 个样本 $\boldsymbol{z}_1,\ldots,\boldsymbol{z}_m$，其中 $\boldsymbol{z}_i = (\boldsymbol{x}_i,y_i)$，$\boldsymbol{x}_i$ 为样本特征，$y_i$ 为样本标记。经验风险最小化旨在优化训练数据上的平均损失，即求解下面的优化问题：

$$\min_{\boldsymbol{w}\in\mathcal{W}} f(\boldsymbol{w}) = \frac{1}{m}\sum_{i=1}^m \ell(\boldsymbol{w},\boldsymbol{z}_i).$$

对于上述问题的求解，如果采用确定优化，在每轮迭代中都需要计算 $f(\boldsymbol{w})$ 的梯度。当数据量 $m$ 很大时，其计算代价非常高。因而，在大数据优化任务中，可以采用随机优化技术，利用随机梯度来代替真实梯度实现梯度下降算法。具体而言，只需要将上述算法中第 3 步改为下式：

$$\boldsymbol{w}'_{t+1} = \boldsymbol{w}_t - \eta_t\nabla\ell(\boldsymbol{w}_t,\boldsymbol{z}_t),$$

其中 $\boldsymbol{z}_t$ 是从 $m$ 个样本中随机采样得到。从上面的描述可以看出，随机梯度下降的每轮迭代只需要利用 1 个样本，因此随机梯度下降每轮迭代的计算复杂度非常低，特别适用于大规模机器学习。

对于一般的 Lipschitz 连续凸函数，随机梯度下降可以达到 $O(1/\sqrt{T})$ 的收敛率。该收敛率从期望意义上成立，并且也以大概率成立。具体有如下定理：

**定理 7.4** (随机梯度下降收敛率) 假设目标函数的随机梯度有上界，且可行域有界，则随机梯度下降的收敛率是 $O\left(\frac{1}{\sqrt{T}}\right)$。

**证明** 假设随机梯度上界为 $l$，可行域 $\mathcal{W}$ 直径为 $\Gamma$，即对于任意 $t \in [T]$，$\boldsymbol{u},\boldsymbol{v} \in \mathcal{W}$，

$$\|\boldsymbol{g}_t\| \leq l,$$

$$\|\boldsymbol{u}-\boldsymbol{v}\| \leq \Gamma.$$

同样为了简化分析，考虑固定的步长 $\eta_t = \eta$。

对于任意的 $\boldsymbol{w} \in \mathcal{W}$，

$$f(\boldsymbol{w}_t) - f(\boldsymbol{w})$$

$$\leq \langle\nabla f(\boldsymbol{w}_t), \boldsymbol{w}_t - \boldsymbol{w}\rangle = \langle\boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$= \frac{1}{\eta}\langle\boldsymbol{w}_t - \boldsymbol{w}'_{t+1}, \boldsymbol{w}_t - \boldsymbol{w}\rangle + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$= \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}'_{t+1} - \boldsymbol{w}\|^2 + \|\boldsymbol{w}_t - \boldsymbol{w}'_{t+1}\|^2) + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$= \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}'_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta}{2}\|\boldsymbol{g}_t\|^2 + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$\leq \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta}{2}\|\boldsymbol{g}_t\|^2 + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$\leq \frac{1}{2\eta}(\|\boldsymbol{w}_t - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{t+1} - \boldsymbol{w}\|^2) + \frac{\eta l^2}{2} + \langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle.$$

对上面的不等式从 $t=1$ 到 $T$ 求和，得到

$$\sum_{t=1}^T f(\boldsymbol{w}_t) - Tf(\boldsymbol{w})$$

$$\leq \frac{1}{2\eta}(\|\boldsymbol{w}_1 - \boldsymbol{w}\|^2 - \|\boldsymbol{w}_{T+1} - \boldsymbol{w}\|^2) + \frac{\eta T}{2}l^2 + \sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$\leq \frac{1}{2\eta}\|\boldsymbol{w}_1 - \boldsymbol{w}\|^2 + \frac{\eta T}{2}l^2 + \sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$$

$$\leq \frac{1}{2\eta}\Gamma^2 + \frac{\eta T}{2}l^2 + \sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle.$$

最后，依据 Jensen 不等式 (1.11)，可得

$$f(\bar{\boldsymbol{w}}_T) - f(\boldsymbol{w}) = f\left(\frac{1}{T}\sum_{t=1}^T \boldsymbol{w}_t\right) - f(\boldsymbol{w})$$

$$\leq \frac{1}{T}\sum_{t=1}^T f(\boldsymbol{w}_t) - f(\boldsymbol{w})$$

$$\leq \frac{\Gamma^2}{2\eta T} + \frac{\eta l^2}{2} + \frac{1}{T}\sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle.$$

可以看出，(7.33) 与 7.2.1 节梯度下降分析的结果 (7.11) 的唯一区别在于多了一项 $\frac{1}{T}\sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle$。

下面先证明随机梯度下降算法期望意义上的收敛率。注意到 (7.25) 成立，因此

$$\mathbb{E}\left[\sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle\right] = 0.$$

对公式 (7.33) 求期望可得

$$\mathbb{E}[f(\bar{\boldsymbol{w}}_T)] - f(\boldsymbol{w}) \leq \frac{\Gamma^2}{2\eta T} + \frac{\eta l^2}{2} = \frac{l\Gamma}{\sqrt{T}},$$

其中令 $\eta = \Gamma/(l\sqrt{T})$。

前面的分析证明了从期望意义上，$\boldsymbol{w}_T$ 的收敛率在 $O(1/\sqrt{T})$ 量级。由于在实际应用中，一般只能运行随机梯度下降算法 1 次，因此需要刻画单次运行随机梯度下降算法所能达到的效果，即提供大概率的理论保障。

为了分析随机梯度下降算法的理论保障，将利用针对鞅差序列的 Azuma 不等式 (1.40)。根据 (7.25) 可知，$\langle\nabla f(\boldsymbol{w}_1) - \boldsymbol{g}_1, \boldsymbol{w}_1 - \boldsymbol{w}\rangle,\ldots$ 组成一个鞅差序列，从而可以利用 (1.40) 求鞅差之和的上界。根据假设 (7.29)，可得

$$|\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle| \leq \|\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t\|\|\boldsymbol{w}_t - \boldsymbol{w}\|$$

$$\leq \Gamma(\|\nabla f(\boldsymbol{w}_t)\| + \|\boldsymbol{g}_t\|) \leq 2l\Gamma.$$

上式的推导过程中利用了 Jensen 不等式 (1.11) 获得 $\|\nabla f(\boldsymbol{w}_t)\|$ 的上界

$$\|\nabla f(\boldsymbol{w}_t)\| = \|\mathbb{E}[\boldsymbol{g}_t]\| \leq \mathbb{E}[\|\boldsymbol{g}_t\|] \leq l.$$

根据 (1.40) 可知，以至少 $1-\delta$ 的概率有

$$\sum_{t=1}^T\langle\nabla f(\boldsymbol{w}_t) - \boldsymbol{g}_t, \boldsymbol{w}_t - \boldsymbol{w}\rangle \leq 2l\Gamma\sqrt{2T\log\frac{1}{\delta}}.$$

将上式代入 (7.33) 可得，以至少 $1-\delta$ 的概率

$$f(\bar{\boldsymbol{w}}_T) - f(\boldsymbol{w}) \leq \frac{\Gamma^2}{2\eta T} + \frac{\eta l^2}{2} + 2l\Gamma\sqrt{\frac{2}{T}\log\frac{1}{\delta}} = \frac{l\Gamma}{\sqrt{T}}\left(1 + 2\sqrt{2\log\frac{1}{\delta}}\right)$$

$$= O\left(\frac{1}{\sqrt{T}}\right).$$

定理得证。

-->

### 3.2 强凸函数

<!--  -->

### 3.3 Epoch-GD 的大概率结论

注意到，Epoch-GD 同样可以用于确定优化场景，此时，将随机梯度替换成真实梯度，收敛率保持不变。因此，对于目标函数是强凸的确定优化，可以直接应用 Epoch-GD 算法得到 $O(1/[\lambda T])$ 的收敛率。此外，还可以证明随机情况下 Epoch-GD 以大概率取得 $O(\log\log T / [\lambda T])$ 的收敛率。但是这部分证明过于复杂，下面只列举结论，有时间再补充证明。

???- Info "证明"
???- Info "证明"
???- Info "证明"



## 4. 分析实例

### 4.1 支持向量机

我们分析如何使用确定优化方法求解支持向量机，唯一区别就是我们使用的是次梯度，而不是一般意义的梯度。

<img class="center-picture" src="./assets/7-5.webp" width="600" />

算法的第五行出现了错误，应该是 $\boldsymbol{w}_{t+1}^{\prime} = \dfrac{\Lambda}{\max(\lVert \boldsymbol{w}_{t+1}^{\prime}\rVert, \Lambda)} \boldsymbol{w}_{t+1}^{\prime}$。

### 4.2 对率回归


<img class="center-picture" src="./assets/7-6.webp" width="600" />
