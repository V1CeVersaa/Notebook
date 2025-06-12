# Data-Level Parallelism in Vector, SIMD, and GPU Architectures

!!! Abstract "Outline"

    - [ ] [1. SIMD：向量处理器](#1-simd)
    - [ ] [2. SIMD：阵列机](#2-simdarray-processor)
    - [ ] [3. GPU 上的 DLP](#3-gpu-dlp)
    - [ ] [4. 检测与增强 LLP](#4-llp)

!!! Info "Flynn 分类法"

    <img class="center-picture" src="assets/4 DLP/4-1.webp" alt="Flynn" width="550" />

## 1. SIMD：向量处理器

### 1.1 Vector Processor & Scalar Processor 

三种处理数据的方式：

=== "Horizontal Processing Method"

    <img class="center-picture" src="assets/4 DLP/4-2.webp" alt="Horizontal Processing Method" width="550" />

=== "Vertical Processing Method"

    <img class="center-picture" src="assets/4 DLP/4-3.webp" alt="Vertical Processing Method" width="550" />

=== "Grouping (Vertical and Horizontal)"

    <img class="center-picture" src="assets/4 DLP/4-4.webp" alt="Grouping (Vertical and Horizontal)" width="550" />


### 1.2 Cray-1 Vector Processor

<img class="center-picture" src="assets/4 DLP/4-5.webp" alt="Cray-1 Vector Processor" width="550" />

<img class="center-picture" src="assets/4 DLP/4-6.webp" alt="Cray-1 Vector Processor" width="550" />

- 每一个向量寄存器都有一条**独立总线**连接到 6 个向量功能单元；
- 每一个向量功能单元都有一条总线，返回操作结果到向量寄存器总线；
- 只要没有**寄存器冲突/Vi 冲突**和**功能冲突**，每一个向量寄存器和向量功能单元可以并行执行。
    - 向量寄存器冲突/Vi 冲突：并行执行的指令访问相同的向量寄存器，就发生冲突/The source vector or result vector of each vector instruction working in parallel uses the same Vi.
        - 读写数据相关：

            \begin{aligned}
                V_0 &\leftarrow V_1 + V_2 \\
                V_3 &\leftarrow V_0 \times V_4
            \end{aligned}

        - 读数据相关：

            \begin{aligned}
                V_0 &\leftarrow V_1 + V_2 \\
                V_3 &\leftarrow V_1 \times V_4
            \end{aligned}

    - 功能冲突：并行执行的每一个向量指令必须不使用相同的向量功能单元/Each vector instruction working in parallel must use the same functional unit.

        \begin{aligned}
            V_3 &\leftarrow V_1 \times V_2 \\
            V_5 &\leftarrow V_4 \times V_6
        \end{aligned}

        只有当第一条向量指令完全执行完毕，这时候浮点乘法单元被释放，第二条向量指令才开始执行。


<img class="center-picture" src="assets/4 DLP/4-7.webp" alt="Cray-1 Vector Processor" width="550" />

### 1.3 提升向量处理器的性能

**假设**：将向量数据元素送到功能部件、将结果存在向量寄存器以及将数据从内存送到 fetch function unit （可以看作是向量寄存器）都需要一拍

=== "练习"

    <img class="center-picture" src="assets/4 DLP/4-8.webp" alt="Exercise" width="550" />

=== "完全串行"

    <img class="center-picture" src="assets/4 DLP/4-9.webp" alt="Fully Serial" width="550" />

=== "并行前两条"

    <img class="center-picture" src="assets/4 DLP/4-10.webp" alt="Parallel First Two" width="550" />

=== "使用 Vector Chaining"

    <img class="center-picture" src="assets/4 DLP/4-11.webp" alt="Vector Chaining" width="550" />



<!-- 以下内容针对“Improve the Performance of Vector Processor”这一小节的所有PPT页，先给出本小节的总体简要总结，然后分四大点（也是PPT列出的四种方法）逐一详尽、啰嗦地展开解释。

---

## 小节总体简要总结

本小节围绕“如何进一步提升向量处理器（vector processor）性能”提出了四种主要技术手段：

1. 配置多组功能单元并实现并行；
2. 引入向量链（vector chaining）技术；
3. 采用**回收（recycling）挖掘**技术以加速数据重用／回收处理；
4. 构建多处理器系统，将多个向量处理器协同工作。

下面针对每一项，结合PPT给出的示例机型、运行模型、性能分析等，详尽展开。

---

### 一、配置多组功能单元并行工作

**简要总结**：通过在硬件层面配备多组独立的、各司其职的单功能流水线，使它们可以同时展开不同的向量操作，从而形成多条并行操作流水线。

**详尽解释**：

1. **为什么要配置多组功能单元？**

   * 向量处理本质上是对大量同类型数据做同样的运算。若只有一条流水线，吞吐率受限；多条流水线并行可显著提升每拍（beat）完成的元素数量。
   * 不同运算（加法、乘法、逻辑、移位、地址计算等）可交由不同功能单元负责，减少单元之间的切换开销。

2. **PPT中CRAY-1示例**：

   * CRAY-1 向量处理器一共有 **4 组 × 12 条** 单功能流水线组件（共 48 条，但以 4 组形式排列）：

     1. **向量组件**：向量加法（vector add）、向量移位（shift）、向量逻辑操作…
     2. **浮点组件**：浮点加法（f‐add）、浮点乘法（f‐mult）、倒数计算（reciprocal）…
     3. **标量组件**：标量加法、移位、逻辑操作，以及计数器“1”/地址“count”更新等；
     4. **地址计算组件**：整数加法和乘法，用于生成下一个元素的内存地址。
   * 每组组件内部采用**流水线方式**工作：一拍接着一拍地处理向量元素，各组之间又可以同时处理不同指令或不同向量。

3. **并行流水线的组织**：

   * 处理器调度逻辑将一条向量指令分解为若干功能阶段（fetch→decode→read regs→compute E1→…→write‐back），并映射到对应的功能单元组。
   * 当多条向量指令同时发出时，只要它们互不冲突（无寄存器冲突、无功能冲突），就能在各自的功能组件组中并行推进。
   * 整体效果：吞吐率 ≈ 组数 × 每组每拍能处理的元素数。

---

### 二、使用向量链（Vector Chaining）技术

**简要总结**：向量链技术允许在不需要完全完成一次指令写回的情况下，直接将上一个指令正在产生的部分结果“链入”下一个指令，从而减少等待时间、加速指令串的执行。

**详尽解释**：

1. **链式执行的动机**

   * 对于多条依赖关系紧密的向量指令，传统执行必须等前一条指令将所有结果写回向量寄存器、再由后一指令读取，导致大量空拍（bubble）。
   * 链式（chaining）则在**每个元素**完成运算后立即“输送”给后续指令对应的功能单元，而不必等整个向量全部处理完毕写回。

2. **PPT 中的描述**：

   * “It has two related instructions that are written first and then read.”
   * 若无功能冲突、无源向量冲突，功能组件可以串联成“元素级”流水线 —— 真正实现“pipeline orientation”到向量执行流程中。

3. **CRAY-1 上的向量链示例**

   * 操作 D = A × (B+C) 被拆为三条向量指令：

     1. `V3 ← Memory`         // 载入向量 A
     2. `V2 ← V0 + V1`        // B+C 浮点加法
     3. `V4 ← V2 × V3`        // 乘法
   * **非链式执行**：

     * 必须等 `V2` 完全写回后，才能启动乘法指令对 `V2` 做读 → `V4` 运算，元素间有整向量级的串行延迟。
   * **链式执行**：

     * 当 `V2[i] = V0[i]+V1[i]` 在加法组件完成写回的那个元素 `i`，马上“链接”到乘法组件，进行 `V3[i]*V2[i]` 运算。
     * 这样，每个元素只产生一次最小延迟，而不是整个向量完成后才开始下一条指令。

4. **性能对比**（假设向量长度 N≤64，每beat能传送／存储一个元素）

   * **串行执行**（①→②→③ 完全串行）：耗时 ≈ 3N + 22 beats
   * **并行前两条**（①并② 并行，再③ 串行）：≈ 2N + 15 beats
   * **全链式**（元素级链式并行 ①②③）：≈ N + 16 beats
   * **结论**：链式技术对于长向量（N大）提升更明显——从3N到N级别的量级加速。

---

### 三、采用“回收挖掘”（Recycling Mining）技术

> **注**：PPT 原文提到 “recycling mining technology”，学界一般将其理解为“结果复用”或“缓冲寄存器回收”技术，用于在寄存器/缓冲区层面挖掘数据重用，减少对主存的访问并加速管线回收。

**简要总结**：通过在寄存器文件或缓冲寄存器中为中间数据保留缓存，并智能重复利用这些已加载或已计算的结果，进一步降低访存和切换开销，提高管线填充率和资源利用率。

**详尽解释**：

1. **回收挖掘的核心思想**

   * 向量运算常有数据重用：例如某个中间向量既是后续多条指令的输入，也可能被多次使用。
   * 若每次都回写主存再重读，不仅耗带宽，还会插入空拍。
   * **回收挖掘**即：将中间向量暂存在“缓冲寄存器”（buffer registers）或专门的“小型缓存”中，当下一条指令需要时直接取用，省掉多余写回/加载周期。

2. **硬件支持**

   * CRAY-1 中的 4 组 **Buffer Register**（64×64 位）即承担了类似作用：数据在向量寄存器与主存之间往返时，先在缓冲寄存器驻留，以便指令流水线上更快访问。
   * 现代向量／SIMD 处理器中也常见“寄存器前推（register forwarding）”、“结果队列”或“小型一级缓存”来实现同样目标。

3. **对性能的影响**

   * **减少访存延迟**：当下一条指令能从缓冲区直接取数，避免跨主存的长延迟。
   * **缩短功能单元空拍**：减少因等待数据而停滞的拍数，使得链式和并行更流畅。
   * **提高资源复用率**：同样的向量数据不必多次搬运，带宽和带宽占用峰值降低。

---

### 四、构建多处理器系统

**简要总结**：将多颗（向量）处理器集群化，并行工作，用数量换速度，使系统整体浮点运算峰值达到更高级别。

**详尽解释**：

1. **多处理器并行的思路**

   * 单颗向量处理器吞吐有限，当应用无法完全矢量化或存在控制流分支时，扩展更多处理器可进一步提升整体吞吐。
   * 系统层面将多颗向量CPU通过高速互连（crossbar、NUMA、共享缓存等）连接，每颗单独运行自己的向量指令流。

2. **PPT示例机型**：

   * **CRAY-2**

     * 内置 **4** 个向量处理器，峰值浮点性能可达 **1800 MFLOPS**。
     * 早期通过液氦冷却，时钟频率突破 CRAY-1 多倍。
   * **CRAY Y-MP / C90**

     * 扩展至 **最多 16** 个向量处理器并行工作，成批调度向量任务。
     * 在大型科学计算、气象模拟等领域带来数十 GFLOPS 级别性能。

3. **多处理器系统的挑战**

   * **负载均衡**：如何将向量任务在处理器间高效分配，避免某颗过载、某颗空闲。
   * **内存一致性**：多颗 CPU 共享大容量主存，需设计缓存一致性协议或划分 NUMA 域。
   * **互连带宽**：节点间通信延迟与带宽必须足够高，以支撑向量数据分发和结果收集。

---

以上即对“Improve the Performance of Vector Processor”这一小节中所有PPT页的逐项、分点、详尽（稍微啰嗦）的解析，并在每段开头给出简要总结。如需对某个技术细节（如回收挖掘的不同硬件实现，或者多处理器下的向量任务调度策略）进一步深究，请随时指出！
 -->

### 1.4 RV64 Vector Extension

大致基于 Cray-1 架构，但是有改进和不同。

## 2. SIMD：Array Processor/阵列机

<!-- 下面针对您提供的“§5.2 SIMD: array processor”部分的所有PPT页，先做分组简要总结，再按组别进行详尽、啰嗦的解释。

---

## 1．Array Processor 的定义与特征

**简要总结**
Array Processor（阵列式处理器）是一种 SIMD 机器，它由 N 个处理元素（PE₀…PEₙ₋₁）构成阵列，由一个单一的控制单元（Control Unit）广播指令，各 PE 在相同指令下并行处理各自所分配的数据。

**详尽解释**

* **处理元素（PE）**

  * 每个 PE 是一个独立的运算单元，通常包含自己的算术逻辑单元（ALU）、寄存器、甚至本地存储。
  * 其功能与标量 CPU 相似，但规模小、专用性强，只执行单个数据元素的操作。
* **阵列互连**

  * 各 PE 通过某种互连网络（Interconnection Network，ICN）按照矩阵或其它拓扑方式互连，既可进行数据交换，也可从主控单元接收指令／广播。
* **单一控制**

  * 一个全局 Control Unit 向所有 PE 同步广播指令，保证“同指令”下各 PE 并行执行各自数据。
  * 这种“指令广播、数据并行”的模式，与 Vector Processor（向量处理器）中“向量指令处理一条向量”异曲同工，只是硬件划分更为细粒度。
* **别名**

  * Array Processor 有时也称为 Parallel Processor（平行处理器）或 Massively Parallel Processor（大规模并行处理器），突出其“海量处理单元并行工作”的特点。

---

## 2．ILLIAC IV 示例

**简要总结**
ILLIAC IV 是早期经典的阵列式处理器原型机，由 8×8 = 64 个 PE 和对应本地存储组成矩阵阵列，指令通过广播方式发送。

**详尽解释**

* **体系结构**

  * 顶端一个全局 Control Unit，负责取指并通过广播（Broadcast Instruction）将当前指令一瞬间下发到 8×8 矩阵中所有 PE。
  * **每个格子**：左上半为 PE（Processing Element，包含 ALU、寄存器），右下半为 PE 自带的本地寄存器/小容量内存（Regfile/Mem），实现数据本地化存取。
* **规模与性能**

  * 64 个 PE 并行向量运算；当时用于气象模拟、图像处理等大批量数据并行场景。
* **限制**

  * 每个 PE 本地存储有限，程序需精心布局以避免大规模互 PE 通信瓶颈。
  * 广播总线带宽和同步开销也对性能有较大影响。

---

## 3．阵列处理器的基本结构：分布式内存 vs 集中式共享内存

**简要总结**
根据各 PE 与内存的组织方式，可将阵列式处理器分为“分布式内存（Distributed Memory）”和“集中式共享内存（Centralized Shared Memory）”两类基本结构。

### 3.1 分布式内存

**简要总结**
每个 PE 都有自己专属的小型本地存储 PEMᵢ（Processing Element Memory），所有 PEM 通过互连网络（ICN）互通，并由后端控制器统一协调数据流。

**详尽解释**

* **结构示意**

  * N 个 PE₀…PEₙ₋₁；
  * 每个 PE 旁边紧连一个本地存储 PEM₀…PEₙ₋₁（这里称为 Register File 或小缓存）；
  * 它们都挂在一条或多条互连网络 ICN 上，ICN 同时连向后端中央控制/协调单元（如 CUM、SC）。
* **数据访问**

  * 当需要跨 PE 数据交换或访问全局数据时，ICN 承担路由与传输；
  * 本地 PEM 可先缓存常用向量分片，减少对后端主存（或 I/O）访问。
* **优缺点**

  * **优点**：每个 PE 本地化存储，避免集中带宽瓶颈；易于扩展到上百、上千个 PE；
  * **缺点**：程序需要显式地管理数据分块、在 PE 之间移动；互连网络负载高时延迟大。
* **主流地位**

  * 多数早期及现代大规模 SIMD/Array Processor 采用分布式内存结构，因为可扩展性强。

### 3.2 集中式共享内存

**简要总结**
所有 PE 通过互连网络 ICN 与若干全局主存 MM₀…MMₖ₋₁ 互联，形成多个处理器共享一组内存的架构。

**详尽解释**

* **结构示意**

  * N 个 PE 连接至 ICN；
  * ICN 进一步连接到 K 个共享内存模块 MM₀…MMₖ₋₁；
  * 再通过 I/O 通道（I/O-CH）接入外部存储、交互设备。
  * 一个中央 Control Unit（CU）和系统控制器（SC）分别通过控制总线广播指令、收集状态。
* **主要差异**

  1. **内存分布**：分布式是每 PE 独占；集中式是多 PE 共享多个内存模块。
  2. **互连角色**：分布式 ICN 主要用于 PE–PE 通信；集中式 ICN 既服务 PE–内存，也可做 PE–PE 间接通信。
* **优缺点**

  * **优点**：编程模型更接近传统共享存储，多处理器协作时易于共享数据；
  * **缺点**：共享内存瓶颈明显，需精心设计缓存一致性或访问调度；扩展性相对弱于分布式。

---

## 4．互连网络设计挑战

**简要总结**
想要在 N 个 PE 之间做全直连，需要 C(n,2)=n(n–1)/2 条链路；但随着 N 增大直连难以实现，必须依赖间接互连网络（交换机、路由器、总线、交叉开关等）来降低硬件成本并提供足够带宽与灵活性。

**详尽解释**

1. **直连对数公式**

   * 需要的连接对数 P = Cₙ² = n(n–1)/2。
   * N=64 时 P=2016 条点对点链路，硬件代价、布线复杂度、功耗都急剧飙升。
2. **间接互连（Indirect Path）**

   * 通过共享总线、交叉开关、分层交换网络等，减少物理链路数；
   * 利用**交换机（Switch Node）**、**链路（Link）**、\*\*接口（Interface／Network Interface Card）\*\*等模块分段转发数据。
3. **并行计算机系统设计**

   * **通信架构（Communication Architecture）**：并行机的核心，包括底层互连网络和上层软件／编译器／运行时支持；
   * 设计议题：互连拓扑、网络性能瓶颈、并行任务调度、软件通信接口等。

---

## 5．互连网络的组成与分类

**简要总结**
互连网络可分为五大基本要素：CPU (PE)、Memory (MM/PEM)、Interface、Link、Switch Node；同时按照**拓扑**、**时序**、**交换方式**、**控制策略**等维度分类。

### 5.1 五大组成

* **CPU (Processing Element)**：运算节点，产生／消费数据。
* **Memory**：存储节点，可在集中式或分布式架构中扮演不同角色。
* **Interface**：网卡或专用网络接口，负责打包／解包消息并驱动链路。
* **Link**：物理传输通道（电缆、光纤、并行线、串行线），定义带宽、延迟、全/半双工。
* **Switch Node**：多端口交换设备，执行存储交换和路径选择，决定路由性能与网络吞吐。

### 5.2 互连网络的关键设计点

* **拓扑（Topology）**：

  * **静态拓扑**：固定连接（如环形、网格、超立方体），程序执行时不变；
  * **动态拓扑**：通过可重构交换机动态建立／拆除连接（如总线、交叉开关、多级网络）。
* **时序模式**：

  * **同步系统**：采用全局统一时钟（如经典 SIMD 阵列），消息按拍传输；
  * **异步系统**：各 PE 独立时钟，消息无全局同步，常见于 MIMD 或 loosely synchronized 系统。
* **交换方式**：

  * **电路交换**：建立端到端固定通路后传输数据，适合大块连续传输；
  * **分组／报文交换**：将消息分为分组，网络按跳转方式转发，适合不规则通信。
* **控制策略**：

  * **集中式控制**：由一个全局控制单元统一调度／路由，易管理但可成瓶颈；
  * **分布式控制**：每个交换节点自治决策，扩展性好但路由复杂。

### 5.3 互连网络分类示例

* **静态网络**：连接路径在程序执行期间固定，如二维网格、环形、树状等。
* **动态网络**：依赖可编程交换机构建任意拓扑，如交叉开关矩阵（crossbar）、多级交换网络（Omega、Butterfly）、可重构光互连等。

---

以上即对 §5.2 “array processor” 全部 PPT 页面的分组式、详尽讲解，并在每个部分开头给予简要总结。如需进一步深入某个互连拓扑具体实现、性能模型（带宽/延迟分析），或阵列处理器编程模型（如掩码处理、指令队列化），请继续指正！
 -->

=== "Cube 0"

    <img class="center-picture" src="assets/4 DLP/4-15.webp" alt="Cube 0" width="550" />

=== "Cube 1"

    <img class="center-picture" src="assets/4 DLP/4-16.webp" alt="Cube 1" width="550" />

=== "Cube 2"

    <img class="center-picture" src="assets/4 DLP/4-17.webp" alt="Cube 2" width="550" />

=== "Overall Cube"

    <img class="center-picture" src="assets/4 DLP/4-18.webp" alt="Overall Cube" width="550" />


<img class="center-picture" src="assets/4 DLP/4-19.webp" alt="PM2I" width="550" />

奇形怪状的网络：

=== "Linear"

    <img class="center-picture" src="assets/4 DLP/4-22.webp" alt="Linear" width="550" />

=== "Circular"

    环形网络以及带有弦的环形网络：

    <img class="center-picture" src="assets/4 DLP/4-23.webp" alt="Circular" width="550" />

    <img class="center-picture" src="assets/4 DLP/4-24.webp" alt="Circular with Chord" width="550" />

=== "Tree"

    树形网络以及带有循环的树形网络、Binary Fat Tree：

    <img class="center-picture" src="assets/4 DLP/4-25.webp" alt="Tree" width="550" />

    <img class="center-picture" src="assets/4 DLP/4-26.webp" alt="Tree with Loop" width="550" />

=== "Star"

    <img class="center-picture" src="assets/4 DLP/4-27.webp" alt="Star" width="550" />

=== "Grid (Favorite)"

    <img class="center-picture" src="assets/4 DLP/4-28.webp" alt="Grid" width="550" />

=== "2D Torus"

    <img class="center-picture" src="assets/4 DLP/4-29.webp" alt="2D Torus" width="550" />

=== "Hypercube"

    <img class="center-picture" src="assets/4 DLP/4-30.webp" alt="Hypercube" width="550" />

=== "Cube with Loop"

    <img class="center-picture" src="assets/4 DLP/4-31.webp" alt="Cube with Loop" width="550" />

<img class="center-picture" src="assets/4 DLP/4-32.webp" alt="Summary" width="550" />



## 3. GPU 上的 DLP

## 4. 检测与增强 LLP

