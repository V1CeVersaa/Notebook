# Chapter 2: Machine Learning and Deep Learning

## 1. Supervised Learning and the Concepts of Bias and Overfitting

简单来讲，监督学习就是寻找一个函数 $f: \mathcal{X} \to \mathcal{Y}$，接受一个输入 $x \in \mathcal{X}$，输出一个预测 $y \in \mathcal{Y}$，

<!-- 好的，我们来详细地推导一下图片中给出的偏差-方差分解（Bias-Variance Decomposition）公式。

这个推导的目标是证明模型的**期望均方误差（Expected Mean Squared Error）** 可以被分解为偏差的平方、参数方差和内部方差的和。

为方便起见，我们先统一一下符号：
* $Y$：数据的真实标签。
* $f(x | D_{LS})$：在特定训练集 $D_{LS}$ 上训练得到的模型，我们简记为 $\hat{f}(x)$。
* $E_{Y|x}[Y]$：给定数据点 $x$ 时，真实标签 $Y$ 的期望值。这代表了数据背后真实的、无噪声的规律，我们记为 $f_{true}(x)$。
* $E_{D_{LS}}[\hat{f}(x)]$：模型对数据点 $x$ 的预测值的期望。这个期望是在所有可能的训练集 $D_{LS}$ 上计算的，代表了模型的“平均”预测。我们简记为 $\bar{f}(x)$。

我们要推导的左边部分是期望预测误差：
$$\text{Error}(x) = E_{D_{LS}} E_{Y|x} [ (Y - \hat{f}(x))^2 ]$$

---

### 推导步骤

**第一步：分解为噪声项和模型误差项**

我们可以在括号内同时加上和减去 $f_{true}(x)$（即 $E_{Y|x}[Y]$），这不会改变表达式的值。

$$\text{Error}(x) = E_{D_{LS}, Y|x} [ (Y - f_{true}(x) + f_{true}(x) - \hat{f}(x))^2 ]$$

然后，我们将 $(Y - f_{true}(x))$ 视为一项 $A$，将 $(f_{true}(x) - \hat{f}(x))$ 视为另一项 $B$，利用 $(A+B)^2 = A^2 + 2AB + B^2$ 展开：

$$\text{Error}(x) = E_{D_{LS}, Y|x} [ (Y - f_{true}(x))^2 + (f_{true}(x) - \hat{f}(x))^2 + 2(Y - f_{true}(x))(f_{true}(x) - \hat{f}(x)) ]$$

接下来，我们将期望算子 $E_{D_{LS}, Y|x}$ 分配到每一项上：

$$\text{Error}(x) = E_{D_{LS}, Y|x} [(Y - f_{true}(x))^2] + E_{D_{LS}, Y|x} [(f_{true}(x) - \hat{f}(x))^2] + E_{D_{LS}, Y|x} [2(Y - f_{true}(x))(f_{true}(x) - \hat{f}(x))]$$

现在我们来处理交叉项（第三项）。由于 $f_{true}(x)$ 和 $\hat{f}(x)$ 在给定的 $D_{LS}$ 下对于 $Y|x$ 的期望是常数，我们可以把它们提到 $E_{Y|x}$ 的外面：

$$E_{D_{LS}} [ 2(f_{true}(x) - \hat{f}(x)) \cdot E_{Y|x}[Y - f_{true}(x)] ]$$

根据定义，$f_{true}(x) = E_{Y|x}[Y]$，所以 $E_{Y|x}[Y - f_{true}(x)] = E_{Y|x}[Y] - f_{true}(x) = 0$。因此，整个交叉项为零。

这样，我们的误差公式就简化为：

$$\text{Error}(x) = E_{Y|x} [(Y - f_{true}(x))^2] + E_{D_{LS}} [(f_{true}(x) - \hat{f}(x))^2]$$

* **第一项 $E_{Y|x} [(Y - f_{true}(x))^2]$**：这是数据本身固有的噪声，即 $Y$ 在其均值 $f_{true}(x)$ 周围的方差。它不依赖于训练集 $D_{LS}$ 或我们的模型 $\hat{f}(x)$。在图片的公式 (2.4) 中，这被称为**内部方差（Internal variance）**。

**第二步：进一步分解模型误差项**

现在我们来处理第二项 $E_{D_{LS}} [(f_{true}(x) - \hat{f}(x))^2]$。我们用类似的方法，在括号内同时加上和减去 $\bar{f}(x)$（即 $E_{D_{LS}}[\hat{f}(x)]$）：

$$E_{D_{LS}} [(f_{true}(x) - \bar{f}(x) + \bar{f}(x) - \hat{f}(x))^2]$$

同样，我们将 $(f_{true}(x) - \bar{f}(x))$ 视为一项 $A$，将 $(\bar{f}(x) - \hat{f}(x))$ 视为另一项 $B$，并展开：

$$E_{D_{LS}} [ (f_{true}(x) - \bar{f}(x))^2 + (\bar{f}(x) - \hat{f}(x))^2 + 2(f_{true}(x) - \bar{f}(x))(\bar{f}(x) - \hat{f}(x)) ]$$

将期望算子 $E_{D_{LS}}$ 分配到每一项：

$$E_{D_{LS}}[(f_{true}(x) - \bar{f}(x))^2] + E_{D_{LS}}[(\bar{f}(x) - \hat{f}(x))^2] + E_{D_{LS}}[2(f_{true}(x) - \bar{f}(x))(\bar{f}(x) - \hat{f}(x))]$$

我们再次处理交叉项（第三项）。由于 $f_{true}(x)$ 和 $\bar{f}(x)$ 都是关于 $D_{LS}$ 的常数（它们不随特定训练集的变化而变化），我们可以把它们提到 $E_{D_{LS}}$ 的外面：

$$2(f_{true}(x) - \bar{f}(x)) \cdot E_{D_{LS}}[\bar{f}(x) - \hat{f}(x)]$$

根据定义，$\bar{f}(x) = E_{D_{LS}}[\hat{f}(x)]$，所以 $E_{D_{LS}}[\bar{f}(x) - \hat{f}(x)] = \bar{f}(x) - E_{D_{LS}}[\hat{f}(x)] = 0$。因此，这个交叉项也为零。

这样，模型误差项就分解为：

$$(f_{true}(x) - \bar{f}(x))^2 + E_{D_{LS}}[(\hat{f}(x) - \bar{f}(x))^2]$$

* **第一项 $(f_{true}(x) - \bar{f}(x))^2$**：这是**偏差（Bias）的平方**。它衡量了模型的“平均”预测值 $\bar{f}(x)$ 与真实规律 $f_{true}(x)$ 之间的差距。
* **第二项 $E_{D_{LS}}[(\hat{f}(x) - \bar{f}(x))^2]$**：这是**方差（Variance）**。它衡量了模型在不同训练集上的预测结果的变化程度或不稳定性。在图片的公式 (2.4) 中，这被称为**参数方差（Parametric variance）**。

---

### 最终结果

将第一步和第二步的结果合并，我们就得到了完整的偏差-方差分解：

$$\text{Error}(x) = \underbrace{ (f_{true}(x) - \bar{f}(x))^2 }_{\text{Bias}^2} + \underbrace{ E_{D_{LS}}[(\hat{f}(x) - \bar{f}(x))^2] }_{\text{Parametric Variance}} + \underbrace{ E_{Y|x} [(Y - f_{true}(x))^2] }_{\text{Internal Variance}}$$

将我们的符号替换回图片中的符号：

* $f_{true}(x)$ 替换为 $E_{Y|x}(Y)$
* $\hat{f}(x)$ 替换为 $f(x | D_{LS})$
* $\bar{f}(x)$ 替换为 $E_{D_{LS}}f(x | D_{LS})$

我们就得到了图片中的公式：

1.  **bias²(x)** 正是 $(E_{Y|x}(Y) - E_{D_{LS}}f(x|D_{LS}))^2$。
2.  **σ²(x)** 是**内部方差**和**参数方差**的和：
    $$\sigma^2(x) = \underbrace{E_{Y|x}(Y - E_{Y|x}(Y))^2}_{\text{Internal variance}} + \underbrace{E_{D_{LS}}(f(x|D_{LS}) - E_{D_{LS}}f(x|D_{LS}))^2}_{\text{Parametric variance}}$$
3.  将这两部分加起来，就得到了公式 (2.3):
    $$E_{D_{LS}} E_{Y|X} (Y - f(X | D_{LS}))^2 = \sigma^2(x) + \text{bias}^2(x)$$

推导完成。 -->

