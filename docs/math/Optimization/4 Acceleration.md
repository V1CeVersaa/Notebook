# 加速方法

## 凸函数类复杂度下界分析

## 强凸函数复杂度下界分析

## 动量方法

## Nesterov 加速梯度下降

### 估计序列

Nesterov 加速方法基于其提出的**估计序列/Estimate Sequences** 的概念。

**定义**：

<!-- 估计序列的定义：有一对序列 \{\phi_k(\bm x)\}_{k=0}^\infty ， \{\lambda_k\}_{k=0}^\infty ，
\lambda_k \ge 0 ，其被称作 f(\bm x) 的估计序列，如果 \lambda_k\to 0 ，且对 \forall \bm
x\in\mathbb{R}^n ， \forall k\ge 0 ，我们有
\begin{align} \phi_k(\bm x)\le (1-\lambda_k)f(\bm x)+\lambda_k\phi_0(\bm x)
\end{align}\qquad\cdots\cdots(1)
估计序列有什么用呢？我们有如下引理：
引理 1：如果对某点列 \{\bm x_k\} 有
\begin{align} f(\bm x_k)\le \phi_k^*\equiv \min_{\bm x\in\mathbb{R}^n}\phi_k(\bm x)
\end{align}\qquad\cdots\cdots(2)
则有 \begin{align} f(\bm x_k)-f^*\le \lambda_k\left(\phi_0(\bm x)-f^*\right)\to 0 \end{align} 。
证明很简单，事实上
\begin{align} f(\bm x_k)&\le \phi_k^*=\min_{\bm x\in\mathbb{R}^n}\phi_k(\bm x)\\
&\le\min_{\bm x\in\mathbb{R}^n}\big((1-\lambda_k)f(\bm x)+\lambda_k\phi_0(\bm x)\big)\\ &\le
(1-\lambda_k)f(\bm x^*)+\lambda_k\phi_0(\bm x^*) \end{align}
可以看到，这里 \lambda_k 就揭示了函数 f 的收敛率。任意满足 (2) 的序列 \{\bm x_k\} ，我们都
可以从 \{\lambda_k\} 的收敛速率直接推出 \{\bm x_k\} 的收敛速度。不过有两个问题亟待解决：
• 我们还不知道怎么构造估计序列；
• 我们不知道怎么满足式 (2) 的条件。
第一个问题 相对比较简单，构造的方法如下
引理 2：假设
\left\{ \begin{align} &1.\; f\in\mathcal{S}_{\mu,L}^{1,1}(\mathbb{R}^n)\\ &2.\; \phi_0\;\text{是
}\mathbb{R}^n\text{ 上任意函数}\\ &3.\; \{\bm y_k\}_{k=0}^\infty\text{ 是 }\mathbb{R}^n\text{ 上
任意序列}\\ &4.\; \text{系数 }\{\alpha_k\}_{k=0}^\infty\text{ 满足条件 }\alpha_k\in(0,1)\text{ 且
}\sum_{k=1}^\infty\alpha_k=\infty\text{ (即发散)}\\ &5.\; \text{选择 }\lambda_0 =1 \end{align}
\right.
那么有如下定义的一对序列\{\phi_k(\bm x)\}_{k=0}^\infty ， \{\lambda_k\}_{k=0}^\infty是 f(\bm
x) 的估计序列：
\begin{align} \lambda_{k+1}&= (1-\alpha_k)\lambda_k\\ \phi_{k+1}(\bm x)&= (1-
\alpha_k)\phi_k(\bm x)+\alpha_k\left(f(\bm y_k)+\langle\nabla f(\bm y_k),\bm x-\bm y_k\rangle
+\frac{\mu}{2}\lVert\bm x-\bm y_k\rVert^2\right) \end{align}\qquad\dots\dots(3)
可以看到 \phi_{k+1}(\bm x) 的第二项是 f 的线性逼近 ，从而 \phi_k 是 \phi_0 和一系列下界的平
均。用归纳法证明，由于 \begin{align} \phi_0(\bm x)\le (1-\lambda_0)f(\bm x)+\lambda_0
\phi_0(\bm x)=\phi_0(\bm x) \end{align} ，因此式 (1) 对 k=0 成立；假设式 (1) 对某 k\ge 0 成立，
那么
\begin{align} \phi_{k+1}(\bm x)&\le (1-\alpha_k)\phi_k(\bm x)+\alpha_kf(\bm x)\\ &= \big(1-(1-
\alpha_k)\lambda_k\big)f(\bm x)+(1-\alpha_k)\big(\underbrace{\phi_k(\bm x)-(1-
\lambda_k)f(\bm x)}_{\le \lambda_k\phi_0(\bm x)}\big)\\ &\le \big(1-(1-
\alpha_k)\lambda_k\big)f(\bm x)+(1-\alpha_k)\lambda_k\phi_0(\bm x)\\ &= (1-
\lambda_{k+1})f(\bm x)+\lambda_{k+1}\phi_0(\bm x) \end{align}
即式 (1) 对 k+1 也成立，从而该构造满足式 (1) 。
不过不要忘了估计序列要求满足 \lambda_k\to 0 ；由于 \lambda_k>0 对 k=0,1,\dots 成立，有
\begin{align} &\ln \lambda_{k+1}=\ln\left((1-\alpha_k)\lambda_k\right)\\
\Rightarrow\;&\ln\lambda_{k+1}-\ln \lambda_k=\ln(1-\alpha_k)\le -\alpha_k\\ \overset{累加}
{\Rightarrow}\;&\ln\lambda_{k+1} = \ln\lambda_{k+1}-\ln\lambda_0 \le -\sum_{i=0}^{k}\alpha_k
\end{align}
根据第 4 个条件， \{\alpha_k\} 是发散的，因此 k\to\infty 时 \ln\lambda_{k+1}\to -\infty ，即
\lambda_k\to 0 。 引理 2 得证。
现在我们有了构造，可以任意选择 \phi_0(\bm x) ，为了接下来容易处理，我们选择一个简单的二
次函数，这样可以有很好的性质；有如下引理：
引理 3： \begin{align}\phi_0(\bm x)=\phi_0^*+\frac{\gamma_0}{2}\lVert\bm x_0-\bm
v_0\rVert^2\end{align} ，则引理 2 定义的递推关系 (3) 会使得 \{\phi_k(\bm x)\} 保持规范形式
（canonical form） ：
\begin{align}\phi_k(\bm x)=\phi_k^*+\frac{\gamma_k}{2}\lVert\bm x_0-\bm
v_k\rVert^2\end{align}
其中：
\begin{align} \gamma_{k+1}&=(1-\alpha_k)\gamma_k+\alpha_k\mu\\ \bm v_{k+1}&= \frac{1}
{\gamma_{k+1}}\big((1-\alpha_k)\gamma_k\bm v_k+\alpha_k\mu\bm y_k-\alpha_k\nabla f(\bm
y_k)\big)\\ \phi^*_{k+1}&= (1-\alpha_k)\phi_k^*+\alpha_kf(\bm y_k)-\frac{\alpha_k^2}
{2\gamma_{k+1}}\lVert\nabla f(\bm y_k)\rVert^2+\frac{\alpha_k(1-\alpha_k)\gamma_k}
{\gamma_{k+1}}\left(\frac{\mu}{2}\lVert\bm y_k-\bm v_k\rVert^2+\langle\nabla f(\bm y_k),\bm
v_k-\bm y_k\rangle\right) \end{align}
其中 \mu 是 f 的强凸系数。
这个引理看起来十分之麻烦，我们梳理一下证明的思路：
1. 首先得确定这个“规范形式”能不能保留：如果能证明 \phi_k(\bm x) 是二次函数，那么它就能写
成规范形式；
2. 接下来要检查 \{\gamma_k\} 、 \{\bm v_k\} 和 \{\phi_k^*\} 的迭代关系是否正确；
3. 可以先根据递推得出 \gamma_k ，然后直接推断其余的项。如果推导的结果符合引理中的定
义，则该引理得证。
证明：首先使用归纳法证明 \phi_k(\bm x) 是二次函数；注意到 \nabla^2 \phi_0(\bm
x)=\gamma_0\bm I_n ，设对于某 k\ge 0 满足 \nabla^2\phi_k(\bm x)=\gamma_k\bm I_n ，那么
根据 (3) ，
\begin{align} \underbrace{\nabla^2\phi_{k+1}(\bm x)=(1-\alpha_k)\nabla^2\phi_k(\bm
x)+\alpha_k\mu\bm I_n}_{\text{by }(3)}=\big((1-\alpha_k)\gamma_k+\alpha_k\mu\big)\bm
I_n\equiv\gamma_{k+1}\bm I_n \end{align}
这证明了 \phi_k(\bm x) 仍然满足标准形式。
下面检查 \bm v_{k+1} ，其是 \phi_k 的极小值点；我们观察 (3) 中的 \phi_{k+1}(\bm x) 递推式，
由于方程 \nabla \phi_{k+1}(\bm x)=\bm 0 的解就是 \bm v_{k+1} ，最终可以整理如下
\begin{align} (1-\alpha_k)\gamma_k(\bm v_{k+1}-\bm v_k)+\alpha_k\nabla f(\bm
y_k)+\alpha_k\mu(\bm v_{k+1}-\bm y_k)=0 \end{align}
从这个方程中可以直接得到 \bm v_{k+1} 的闭式解。
最后检查 \phi_k^* ，我们继续根据 (3) 中的递推式，有
\begin{align} \phi_{k+1}^*+\frac{\gamma_{k+1}}{2}\lVert\bm y_{k+1}-\bm v_{k+1}\rVert^2&=
\phi_{k+1}(\bm y_{k})\\ &=(1-\alpha_k)\underbrace{\left(\phi_k^*+\frac{\gamma_k}{2}\lVert\bm
y_k-\bm v_k\rVert^2\right)}_{\phi_k(\bm y_k)}+\alpha_kf(\bm y_k)\\ &= (1-
\alpha_k)\frac{\gamma_k}{2}\lVert\bm y_k-\bm v_k\rVert^2+(1-
\alpha_k)\phi_k^*+\alpha_kf(\bm y_k) \end{align}
将上式左侧的 \bm v_{k+1} 通过迭代式替换掉，就得到了 \phi_{k+1}^* 的表达式；这里的公式整理
有些麻烦，故从略。
回忆一下，之前我们有两个问题，第一个问题（如何构造估计序列）已经解决了；第二个问题是如
何才能满足式 (2) 的条件。这就需要我们确定辅助序列 \{\bm y_k\} 和 \{\alpha_k\} 。设对于某 k\ge
0 满足式 (2) ，即 f(\bm x_k)\le\phi_k^* ，那么有
\begin{align} \phi_k^*\ge f(\bm x_k)\ge f(\bm y_k)+\langle\nabla f(\bm y_k),\bm x_k -\bm
y_k\rangle\end{align}
将引理 3 中 \phi_{k+1}^* 的递推式代入这个不等式，可以得到这样的式子：
\begin{align} \phi_{k+1}^*\ge\underbrace{\boxed{ f(\bm y_k)-\frac{\alpha_k^2}
{2\gamma_{k+1}}\lVert\nabla f(\bm y_k)\rVert^2}}_{\text{利用 } \alpha_k\text{ 的自由度，令其
}\ge f(\bm x_{k+1})}+\underbrace{(1-\alpha_k)\left\langle\nabla f(\bm
y_k),\frac{\alpha_k\gamma_k}{\gamma_{k+1}}(\bm v_k-\bm y_k)+\bm x_k-\bm
y_k\right\rangle}_{\text{利用 }\bm y_k\text{ 的自由度，令其为 }0} \end{align}
回忆一下我们想得到的最终结果是 \phi_{k+1}^*\ge f(\bm x_{k+1}) ，考察上式方框里的内容，假
设在 \bm y_k 处以 \begin{align}h_k=\frac{1}{L}\end{align} 梯度下降一步，将得到的结果定为 \bm
x_{k+1} ，那么我们可以得到\begin{align} &\bm x_{k+1}=\bm y_k-h_k\nabla f(\bm y_k)=\bm y_k-\frac{1}{L}\nabla f(\bm y_k)\\
\overset{\text{凸性}}{\Rightarrow}\;& f(\bm y_k)-\frac{1}{2L}\lVert\nabla f(\bm y_k)\rVert^2\ge
f(\bm x_{k+1}) \end{align}
也就是说，我们能让方框里的式子 \ge f(\bm x_{k+1}) ；因为 \alpha_k 是随意取的，只要让
\alpha_k 取二次方程 \begin{align} L\alpha_k^2=(1-
\alpha_k)\gamma_k+\alpha_k\mu\quad(=\gamma_{k+1}) \end{align} 的正根，就可以得到
\begin{align} \frac{\alpha_k^2}{2\gamma_{k+1}}=\frac{1}{2L} \end{align} ；于是有
\begin{align} \phi_{k+1}^*\ge f(\bm x_k)+(1-\alpha_k)\left\langle\nabla f(\bm
y_k),\frac{\alpha_k\gamma_k}{\gamma_{k+1}}(\bm v_k-\bm y_k)+\bm x_k-\bm y_k\right\rangle
\end{align}
最后，还有 \bm y_k 是随意选择的，我们利用这个自由度，让后面这一大坨式子直接为零：
\begin{align} &\frac{\alpha_k\gamma_k}{\gamma_{k+1}}(\bm v_k-\bm y_k)+\bm x_k-\bm
y_k=0\\ \Rightarrow\;& \bm y_k=\frac{\alpha_k\gamma_k\bm v_k+\gamma_{k+1}\bm x_k}
{\gamma_k+\alpha_k\mu} \end{align}
这样就得到了我们想要的结果。
关于估计序列（estimation）方法，读者也可以参考：Michel Baes. (2009). Estimate sequence
methods: extensions and approximations. optimization-online.org...。 -->
