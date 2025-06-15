# Thread Level Parallelism

!!! Abstract "Outline"

    - [x] [1. 多处理器体系结构](#1)
    - [x] [2. 缓存一致性协议](#2)
    - [ ] [3. 存储器一致性模型](#3)

??? Info "高僧预测"

    重点在缓存一致性，细节来讲在监听协议和 MSI 协议。存储器一致性不重要。

    === "MIMD, UMA and NUMA"

        <img class="center-picture" src="assets/5 TLP/review-1.webp" alt="drawing" width="550" />

        <img class="center-picture" src="assets/5 TLP/review-2.webp" alt="drawing" width="550" />

        <img class="center-picture" src="assets/5 TLP/review-3.webp" alt="drawing" width="550" />

    === "Cache Coherence"

        <img class="center-picture" src="assets/5 TLP/review-4.webp" alt="drawing" width="550" />

        <img class="center-picture" src="assets/5 TLP/review-5.webp" alt="drawing" width="550" />

    === "Snooping and MSI"

        <img class="center-picture" src="assets/5 TLP/review-6.webp" alt="drawing" width="550" />

        <img class="center-picture" src="assets/5 TLP/review-7.webp" alt="drawing" width="550" />

        <img class="center-picture" src="assets/5 TLP/review-8.webp" alt="drawing" width="550" />


!!! Info "Flynn 分类法"

    <img class="center-picture" src="assets/5 TLP/5-1.webp" alt="Flynn" width="550" />

## 1. 多处理器体系结构

由于利用指令级并行的收益越来越少，单处理器的性能增长逐渐放缓，在新的时代背景下，多处理器在从低端到高端的各个领域都扮演了重要的角色。本章主要研究线程级并行的利用。

线程级并行和指令集并行的重要区别是：线程级并行由软件系统或者程序员在较高层级上确认，并行执行的是包含大量指令的线程。TLP 意味着需要同时执行多个独立的线程，每一个线程都具有自己的程序计数器追踪执行位置，主要通过 MIMD 利用。

MIMD 架构主要分为两大类：

- Multiprocessor System/多处理器系统，其基于**共享地址空间**：
    - 整个系统只存在一个地址空间，所有的处理器都共享这个地址空间；
    - 但是只有一个地址空间并不意味着只有一个物理内存，实际上可以通过一块物理共享的内存实现，也可以通过分布式的内存实现。
- Multicomputer System/多计算机系统，其基于消息传递/Message Passing：
    - 每一个处理器都有自己的局部内存/Local Memory 或者叫私有内存/Private Memory，其只可以被这个处理器访问，不能被别的处理器**直接**访问；
    - 因此，处理器之间的通信必须通过显式地发送和接收消息来完成。

### 1.1 MIMD 多处理器架构

<img class="center-picture" src="assets/5 TLP/5-2.webp" alt="Shared Memory System" width="550" />

根据所包含的处理器数量，可以将现有共享存储器的多处理器分为两类，而处理器的数量又决定了存储器的组织方式和互联策略，因此我们按照存储器的组织方式来称呼多处理器：

- 对称多处理器/Symmetric Multiprocessor/SMP：也称为集中式共享存储器多处理器/Centralized Shared-Memory Multiprocessor
    - 核心数量较少，一般不超过 32 个，因此处理器可以共享一个集中式存储并且平等访问之，这就是对称一词的来源；
    - SMP 体系结构有时也称为**一致存储器访问/Uniform Memory Access/UMA** 多处理器，这是因为所有处理器访问存储器的延迟都是一致的，**即使存储器被分为多个组的时候也是如此**；
    - 某些多核处理器对最外层高速缓存的访问是非均匀的，这种结构被称为非均匀高速缓存访问/Nonuniform Cache Access/NUCA，因此即便它们拥有单一主内存，也并非真正的 SMP；
- 分布式共享存储器/Distributed Shared Memory/DSM 多处理器：也称为**非一致存储器访问/Non-Uniform Memory Access/NUMA** 多处理器
    - 多处理器采用物理分布式存储器，这是为了支持更多的处理器，存储器必须分布在处理器之间，否则存储器系统就无法在不答复延长访问延迟的情况下为大量处理器提供高带宽支持；
    - 之所以 DSM 多处理器也被称为 NUMA 多处理器，这是因为数据的访问时间取决于数据在存储器中的位置，显然，访问本地内存比访问远程内存要快；
    - 缺点是 DSM 让在处理之间传输数据的过程变得更加复杂了，需要软件开发人员编写额外的代码来处理数据传输。

<img class="center-picture" src="assets/5 TLP/5-8.webp" alt="Multicomputer System" width="550" />

在 NUMA 多处理器之上，还有一种更特殊的结构叫做 COMA，即全缓存内存访问/Cache Only Memory Access/COMA 多处理器，每个处理器节点中没有固定的存储层次结构，所有缓存构成一个统一的地址空间。

=== "SMP/UMA"

    特征：物理内存被所有处理器统一共享，所有处理器访问任何内存字的时间相同，**每个处理器可以配备私有缓存或私有内存**。

    因为 UMA 有 Shared Cache，其 Cache 一致性是有保证的。

    <img class="center-picture" src="assets/5 TLP/5-4.webp" alt="SMP/UMA" width="550" />

    <img class="center-picture" src="assets/5 TLP/5-5.webp" alt="SMP/UMA" width="550" />

=== "DSM/NUMA"

    特征：所有的 CPU 共享一个一致的地址空间，使用 LOAD 和 STORE 指令访问远程内存，访问远程内存比访问本地内存慢，处理器可以使用缓存。
    
    我们也区分 NC-NUMA/Non-Cache Non-Uniform Memory Access 和 CC-NUMA/Cache Coherent NUMA，前者不使用 Cache，后者有 Cache。使用 Cache 就必须要保证 Cache 一致性，后面会讲。

    <img class="center-picture" src="assets/5 TLP/5-6.webp" alt="DSM/NUMA" width="550" />

    <img class="center-picture" src="assets/5 TLP/5-7.webp" alt="DSM/NUMA" width="550" />

=== "COMA"

    特征：所有 Cache 形成一个统一的地址空间，存在数据迁移，使用分布式的缓存目录进行远端 Cache 的访问。数据在最开始时可以被分配在任意 Cache 中，但程序开始执行后这些数据会被移动到需要使用的地方去。

    <img class="center-picture" src="assets/5 TLP/5-9.webp" alt="COMA" width="550" />

    <img class="center-picture" src="assets/5 TLP/5-10.webp" alt="COMA" width="550" />


### 1.2 MIMD 多计算机架构

<img class="center-picture" src="assets/5 TLP/5-3.webp" alt="Multicomputer System" width="550" />

每一个线程/处理器都有自己的私有内存，他们通过 ICN/Interconnection Network 进行通信，模型被概括为 NORMA/No-Remote Memory Access。

每一个节点由一个或者多个 CPU、RAM、硬盘和 I/O 设备组成，这些节点通过 ICN 连接，利用一系列拓扑机构、开关策略和路径寻找算法来实现通信。

<img class="center-picture" src="assets/5 TLP/5-11.webp" alt="Multicomputer System" width="550" />

=== "MPP/Massively Parallel Processors"

    MPP 是由数百个处理器构成的，大规模并行计算系统，现在也广泛用于商业和网络应用，开发难度大，价格高，市场有限。

    特征：一般使用标准的商用 CPU 作为处理器，使用高性能的私有互连网络，能以低延迟和高带宽传递消息，具备强大的输入/输出能力，具备特殊的容错处理能力。

    <img class="center-picture" src="assets/5 TLP/5-12.webp" alt="MPP" width="550" />


=== "COW/Cluster of Workstations"

    COW 是由大量通过商用网络连接在一起的 PC 或工作站组成的系统，可以完全使用打屁模生产的商用组件组装，性价比很高。也分为集中式和非集中式两种类型。

    <img class="center-picture" src="assets/5 TLP/5-13.webp" alt="COW" width="550" />

    <img class="center-picture" src="assets/5 TLP/5-14.webp" alt="COW" width="550" />

### 1.3 并行计算的挑战

没啥可说的，学会使用 Amdahl 定律就行：

=== "Example 1"

    <img class="center-picture" src="assets/5 TLP/5-15.webp" alt="Example 1" width="550" />

=== "Example 2"

    <img class="center-picture" src="assets/5 TLP/5-16.webp" alt="Example 2" width="550" />

=== "Example 3"

    <img class="center-picture" src="assets/5 TLP/5-17.webp" alt="Example 3" width="550" />

## 2. 缓存一致性协议

!!! Info "卧槽内容太多了，我觉得我意会了"






<!-- 好的，我会按照顺序逐一解释您提供的四张图片中的每一页 PPT。

---

### **图片 1/4 (image_d3e1ba.jpg)**

这张图片包含了四页 PPT，主要介绍了多处理器系统面临的挑战、内存一致性与缓存一致性的区别，以及实现缓存一致性的两种基本机制。

---

#### **幻灯片 1：Challenges of Multi-process system based on Shared Memory (基于共享内存的多处理器系统的挑战)**

* **简要总结:** 这页 PPT 展示了基于共享内存的多处理器系统的基本架构，并引出了由此产生的核心挑战。

* **内容翻译与解释:**
    * **标题:** 基于共享内存的多处理器系统的挑战
    * **图示:** 图中展示了多个处理器核心（core），每个核心都通过共享总线（Shared Bus）连接到一块共享内存（Shared Memory）。每个核心通常还拥有自己的缓存（Cache）。
    * **核心问题:** 这种架构的优势是所有处理器可以方便地共享数据。但问题也随之而来：当多个处理器都缓存了同一份内存数据的副本时，如果其中一个处理器修改了自己缓存中的数据，其他处理器的缓存副本就会变成“过时”或“无效”的数据。如何确保所有处理器在任何时候读取数据时都能获得最新的值，这就是缓存一致性（Cache Coherence）问题。

---

#### **幻灯片 2：Challenges of Multi-process system based on Shared Memory (基于共享内存的多处理器系统的挑战)**

* **简要总结:** 这页 PPT 通过一个具体的例子，直观地展示了没有缓存一致性机制时，数据不一致问题是如何发生的。

* **内容翻译与解释:**
    * **标题:** 基于共享内存的多处理器系统的挑战
    * **图示:** 上方的图展示了两种多处理器架构。左边是多核（Core）共享缓存，右边是多 CPU 各自有独立缓存。下方的表格模拟了一个操作序列。
    * **表格解释:**
        * `Time step` (时间步): 表示操作发生的顺序。
        * `Event` (事件): 描述了哪个 CPU 进行了什么操作。
        * `Cache contents for CPU A` (CPU A 的缓存内容)。
        * `Cache contents for CPU B` (CPU B 的缓存内容)。
        * `Memory contents for location X` (内存地址 X 的内容)。
    * **序列分析:**
        1.  **时间 0:** 系统初始状态，内存地址 `X` 的值为 `1`。
        2.  **时间 1:** `CPU A reads X` (CPU A 读取 X)。它从内存中读取值 `1` 并存入自己的缓存。
        3.  **时间 2:** `CPU B reads X` (CPU B 读取 X)。它也从内存中读取值 `1` 并存入自己的缓存。
        4.  **时间 3:** `CPU A stores 0 into X` (CPU A 将 0 存入 X)。CPU A 更新了自己缓存中 X 的值为 `0`。 **问题出现了**：此时，CPU A 的缓存是 `0`，CPU B 的缓存是 `1`，而内存中的值可能还是 `1`（取决于写策略）。数据的多个副本出现了不一致。

---

#### **幻灯片 3：Memory Consistency and Cache Coherence (内存一致性与缓存一致性)**

* **简要总结:** 这页 PPT 明确区分了两个相关但不同的概念：内存一致性（Memory Consistency）和缓存一致性（Cache Coherence），并强调后者是前者的基础。

* **内容翻译与解释:**
    * **标题:** 内存一致性与缓存一致性
    * **Memory Consistency (内存一致性):** 需要内存一致性模型 (Need Memory Consistency Model)
        * “当一个值被写入后，何时能被读取到。” (When a written value will be returned by a read)
        * “如果一个处理器向地址 A 写入，随后另一个处理器向地址 B 写入，那么任何处理器看到 B 的新值时，也必须能看到 A 的新值。” (If a processor writes location A followed by location B, any processor that sees the new value of B must also see the new value of A)
        * **解释:** 内存一致性定义了多个处理器对内存进行读写操作的顺序规则。它关心的是“不同内存地址”上的操作在所有处理器看来其发生的顺序是否一致。
    * **Cache Coherence (缓存一致性):** 需要缓存一致性协议 (Need Cache Coherence Protocol)
        * “任何处理器对任意内存地址的读取，都必须返回最近写入的值。” (All reads by any processor must return the most recently written value)
        * “任意两个处理器对同一地址的写操作，在所有处理器看来其发生的顺序是一致的。” (Writes to the same location by any two processors are seen in the same order by all processors)
        * **解释:** 缓存一致性更关注“同一内存地址”的多个副本（在不同缓存和主存中）的一致性。它确保了对单个数据块的读写是正确的。
    * **关系:** 正确的缓存一致性是实现内存一致性的前提。它确保了对单个地址的分析是可靠的，从而让更高层级的内存一致性模型得以建立。

---

#### **幻灯片 4：Cache Coherence (缓存一致性)**

* **简要总结:** 这页 PPT 介绍了实现缓存一致性的两种核心机制：迁移（Migration）和复制（Replication）。

* **内容翻译与解释:**
    * **标题:** 缓存一致性
    * **Migration (迁移):**
        * “一个数据项可以被移动到一个本地缓存并在那里使用。” (A data item can be moved to a local cache and used there in a transparent fashion.)
        * **解释:** 迁移是指将数据从主内存或另一个处理器的缓存中“移动”到当前需要它的处理器的本地缓存中。这个过程对程序员是透明的。
        * **优点:** “迁移降低了访问共享数据项的延迟和对共享内存的带宽需求。” (Migration reduces both the latency to access a shared data item and the bandwidth demand on the shared memory.)
    * **Replication (复制):**
        * “当一个共享数据被同时读取时，缓存在本地缓存中为该数据项创建一个副本。” (When shared data are being simultaneously read, the caches make a copy of the data item in the local cache.)
        * **解释:** 复制允许同一数据块的多个副本存在于不同的本地缓存中，这对于多个处理器同时读取同一数据非常高效。
        * **优点:** “复制降低了访问共享数据项的延迟和竞争。” (Replication reduces both latency of access and contention for a read shared data item.)
    * **总结:** 迁移和复制是缓存系统提高性能的关键，但复制也正是导致数据不一致问题的根源，因此需要缓存一致性协议来管理这些副本。

---
---

### **图片 2/4 (image_d3e19d.jpg)**

这张图片包含了四页 PPT，深入探讨了缓存一致性问题的原因、协议分类，并具体介绍了两种主流的协议：监听协议和目录协议。

---

#### **幻灯片 1：Cache Coherence (缓存一致性)**

* **简要总结:** 这页 PPT 总结了缓存一致性问题产生的原因，并引出了解决该问题的两大类协议。

* **内容翻译与解释:**
    * **标题:** 缓存一致性
    * **Causes of cache coherence problems (缓存一致性问题的原因):**
        * “在现代并行计算机中，处理器通常拥有缓存。内存数据可能在整个系统中拥有多个副本。这导致了缓存一致性问题。” (In modern parallel computers, processors often have Cache. Memory data may have multiple copies in the entire system. This leads to the cache coherence problem.)
        * **解释:** 这句话再次强调了问题的根源：为了性能，数据被复制到多个缓存中，而这些副本之间可能产生不一致。
    * **Cache coherence protocol (缓存一致性协议):**
        * “由缓存、CPU和内存共同遵守的一套规则，用以防止同一数据的不同版本出现在多个缓存中，这就是缓存一致性协议。” (A set of rules implemented by Cache, CPU, and memory to prevent different versions of the same data from appearing in multiple Caches forms a cache coherence protocol.)
        * **协议分类:**
            * **Bus snooping protocol (总线监听协议)**
            * **Directory based protocol (基于目录的协议)**
        * **解释:** 为了解决数据不一致问题，硬件层面需要实现一套协议来管理数据副本。目前主流的协议分为两大类：监听协议和目录协议，它们适用于不同的系统架构。

---

#### **幻灯片 2：Cache Coherence (缓存一致性)**

* **简要总结:** 这页 PPT 详细介绍了总线监听协议的工作原理，并说明了它主要适用于 UMA（统一内存访问）架构。

* **内容翻译与解释:**
    * **标题:** 缓存一致性
    * **For UMA: snoopy coherence protocols (适用于 UMA 架构：监听一致性协议):**
        * “在监听一致性协议中，所有处理器都监听（snoop）总线。当一个处理器修改其私有缓存中的数据时，它会向总线上广播无效化信息或更新后的数据，以通知其他缓存进行更新。” (In the snoopy coherence protocols, all processors snoop the bus. When a processor modifies the data in the private cache, it broadcasts invalid information or updated data on the bus to invalidate or update other copies.)
    * **图示:**
        * 图中展示了一个基于总线的系统，多个 CPU 和内存（M）都连接到同一条总线（BUS）上。每个 CPU 都有自己的私有缓存（Private Memory/Cache）。
        * **工作流程:** 当一个 CPU（例如最左边的 CPU）想要写入数据时，它会通过总线发送一个消息。其他所有 CPU 的缓存控制器都会“监听”到这个消息，并根据协议规则决定是使自己的缓存副本无效（Invalidate）还是用新数据更新（Update）。
    * **适用性:** 这种方法简单有效，但因为所有通信都依赖于共享总线，总线会成为系统扩展的瓶颈。因此，它主要用于拥有少量处理器（通常几十个以内）的 UMA 系统。

---

#### **幻灯片 3：Cache Coherence (缓存一致性)**

* **简要总结:** 这页 PPT 介绍了另一种主流协议——目录协议，并解释了其工作原理及适用场景（NUMA 架构）。

* **内容翻译与解释:**
    * **标题:** 缓存一致性
    * **For NUMA: Directory protocol (适用于 NUMA 架构：目录协议):**
        * “目录协议使用一个目录（directory）来记录系统中哪些处理器在其缓存中拥有特定存储块的副本。当一个处理器想要写入一个共享块时，它通过目录向拥有该块副本的处理器发送一个点对点的无效信号，从而使所有其他副本失效。” (The directory protocol uses a directory to record which processors in the system have copies of certain storage blocks in the cache. When a processor wants to write a shared block, it sends an invalid signal to those processors that have copies of the block through the directory in a "point-to-point" way, so that all other copies are invalidated.)
    * **图示:**
        * 图中展示了一个基于目录的系统，它通过互连网络（Interconnection Network）连接。每个节点包含 CPU、内存（Memory）和本地总线（Local Bus）。关键在于，系统中有一个集中的或分布式的目录（Directory）。
        * **工作流程:** 当一个 CPU 要写数据时，它不再向所有人广播，而是先查询目录。目录会告诉它哪些其他的 CPU 拥有这份数据的副本。然后，它只向这些特定的 CPU 发送无效化消息。
    * **适用性:** 这种点对点通信避免了广播带来的总线瓶颈，因此具有更好的扩展性，非常适合拥有大量处理器的大规模 NUMA（非统一内存访问）系统。

---

#### **幻灯片 4：Cache Coherence (缓存一致性)**

* **简要总结:** 这页 PPT 展示了两种具体的缓存一致性协议的状态转换流程图。

* **内容翻译与解释:**
    * **标题:** 缓存一致性
    * **图示:** 这两个流程图非常复杂，详细描述了在不同事件（如本地读/写命中/缺失，总线读/写请求等）发生时，缓存块（cache block）的状态如何迁移。
    * **左图: A Write-through cache with No-Write-Allocate (采用写穿透和不按写分配策略的缓存)**
        * **写穿透 (Write-through):** 每次写操作既更新缓存，也同时更新主内存。
        * **不按写分配 (No-Write-Allocate):** 当发生写缺失（Write Miss）时，数据只写入主内存，而不会被加载到缓存中。
        * **状态:** 主要有两个状态：有效（Valid）和无效（Invalid）。流程图展示了处理器请求（如 PrRd, PrWr）和总线请求（BusRd, BusWr）如何导致状态在这两者之间转换。
    * **右图: A Write-back cache with Write-Allocate (采用写回和按写分配策略的缓存)**
        * **写回 (Write-back):** 写操作只更新缓存，并设置一个“脏位”（dirty bit）。数据只在缓存块被替换出去时才写回主内存。
        * **按写分配 (Write-Allocate):** 当发生写缺失时，会先将数据块从内存加载到缓存中，然后再进行写操作。
        * **状态:** 这种协议更复杂，通常包含多个状态，如“修改”（Modified）、“独占”（Exclusive）、“共享”（Shared）和“无效”（Invalid）（即 MESI 协议的基础）。流程图显示了在各种本地和总线事件下，这些状态之间如何相互转换。

---
---

### **图片 3/4 (image_d3e15d.jpg)**

这张图片包含了四页 PPT，继续深入探讨监听协议，具体区分了写穿透和写回两种策略，并介绍了两种主要的监听协议类型：写无效和写更新。

---

#### **幻灯片 1：Snoopy Coherence Protocols (监听一致性协议)**

* **简要总结:** 这页 PPT 介绍了在监听协议中两种不同的处理写操作的内存更新策略：写穿透（Write-through）和写回（Write-back）。

* **内容翻译与解释:**
    * **标题:** 监听一致性协议
    * **Write-through (写穿透):**
        * “当向缓存行写入数据时，相应的主内存内容也会被修改，内存中的数据在任何时候都保持最新状态。” (While writing the data in the cache line, the content in the corresponding memory is also modified, and the data in the memory is kept up to date at any time.)
        * **解释:** 这是一种简单直接的策略。优点是实现简单，且主存数据始终是有效的。缺点是每次写操作都需要访问主存，会产生较大的总线流量和延迟。
    * **Write-back (写回):**
        * “写操作不直接写入内存。当缓存行被修改时，会设置一个特定的位（脏位），以表明缓存中的数据已经过期（与主存不一致）。最终，数据会在某个时刻（通常是该缓存行被替换时）被写回内存，但这可能是在多次写操作之后。” (The write operation does not directly write to the memory. On the contrary, when the cache line is modified, a certain bit in the cache is set to indicate that the data in the cache line is correct but the data in the memory is out of date. Of course, the line will eventually be written back to memory, but it may be after multiple write operations.)
        * **解释:** 这种策略性能更高，因为连续的多次写操作只在缓存中进行，减少了对主存的访问。缺点是实现更复杂，并且在数据被写回之前，主存中的数据是过时的。

---

#### **幻灯片 2：Write-through Cache Coherency Protocol (写穿透缓存一致性协议)**

* **简要总结:** 这页 PPT 总结了写穿透协议下，缓存控制器响应本地请求和远程请求时的四种基本情况，并指出了实现时需要做的决策。

* **内容翻译与解释:**
    * **标题:** 写穿透缓存一致性协议
    * **表格:** “根据此协议，监控缓存执行读写操作时有四种情况。” (Four situations when the monitoring cache performs read and write operations according to this protocol)
        * **Read Miss (读缺失):**
            * **Local Request (本地请求):** 从内存访问数据 (Access data from memory)。
            * **Remote Request (远程请求):** - (无操作)。
        * **Read Hit (读命中):**
            * **Local Request:** 使用本地缓存数据 (Use local cache data)。
            * **Remote Request:** - (无操作)。
        * **Write Miss (写缺失):**
            * **Local Request:** 修改内存中的数据 (Modify data in memory)。
            * **Remote Request:** - (无操作)。
        * **Write Hit (写命中):**
            * **Local Request:** 修改缓存和内存 (Modify cache and memory)。
            * **Remote Request:** 使缓存项无效 (Invalidate the cache item)。
    * **要点:**
        * “直接写缓存一致性的基本协议有很多变种。” (There are many changes in the basic protocol of write direct Cache consistency)
        * **关键决策点:**
            * 对于远程写操作，是使用**更新策略 (Update Strategy)** 还是**无效策略 (Invalidate Strategy)**。
            * 当缓存写缺失时，是否将对应的字传输到缓存中，即是否使用**按写分配策略 (Write-allocate Policy)**。
        * **解释:** 这个表格和要点说明了，即使是相对简单的写穿透协议，在具体实现时也有不同的设计选择，这些选择会影响协议的性能和复杂性。

---

#### **幻灯片 3：Snoopy Coherence Protocols (监听一致性协议)**

* **简要总结:** 这页 PPT 通过一个具体的例子，展示了写无效协议（Write Invalidate Protocol）在写回（Write-back）缓存下的工作流程。

* **内容翻译与解释:**
    * **标题:** 监听一致性协议
    * **核心协议:** 写无效协议 (Write invalidate protocol) - “它在一次写操作时使其他副本无效。” (It invalidates other copies on a write.)
    * **表格:** “一个在单总线上的写无效协议示例，针对单个缓存块 (X) 和写回缓存。” (An invalidation protocol works on a snooping bus for a single cache block (X) with write-back caches.)
        * `Processor activity` (处理器活动)
        * `Bus activity` (总线活动)
        * `Contents of processor A's cache` (处理器 A 缓存内容)
        * `Contents of processor B's cache` (处理器 B 缓存内容)
        * `Contents of memory location X` (内存地址 X 内容)
    * **序列分析:**
        1.  初始状态，内存 X 值为 `0`。
        2.  **处理器 A 读 X:** 发生“缓存缺失 (Cache miss for X)”。A 通过总线读取，将 `0` 载入缓存。
        3.  **处理器 B 读 X:** 发生“缓存缺失 (Cache miss for X)”。B 通过总线读取，将 `0` 载入缓存。此时 A 和 B 都有副本。
        4.  **处理器 A 写 1 到 X:** A 在本地写入。同时，它在总线上发出“写无效 (Invalidation for X)”信号。
        5.  **处理器 B 收到无效信号:** B 将其缓存中 X 的副本置为无效。此时只有 A 拥有有效副本（值为 `1`），但内存中的值仍为 `0`（因为是写回策略）。
        6.  **处理器 B 读 X:** 发生“缓存缺失 (Cache miss for X)”。此时 A 的缓存控制器会监听到 B 的读请求，发现自己有“脏”数据，于是它会响应这个请求，将数据 `1` 提供给 B，并同时将数据写回内存。

---

#### **幻灯片 4：Snoopy Coherence Protocols (监听一致性协议)**

* **简要总结:** 这页 PPT 正式提出了监听协议的两种主要类型：写无效协议和写更新/广播协议。

* **内容翻译与解释:**
    * **标题:** 监听一致性协议
    * **Write invalidate protocol (写无效协议):**
        * “它在一次写操作时使其他副本无效。” (It invalidates other copies on a write.)
        * **解释:** 这是最常见的监听协议类型。当一个处理器写入数据时，它会广播一个无效化消息，其他所有持有该数据副本的缓存都会将自己的副本标记为无效。后续如果需要读取，必须重新从内存或持有最新副本的缓存中获取。
    * **Write update / write broadcast protocol (写更新/写广播协议):**
        * “当一个数据项被写入时，更新所有已缓存的该数据项的副本。” (Update all the cached copies of a data item when that item is written.)
        * **解释:** 在这种协议中，当一个处理器写入数据时，它会把新的数据值广播出去。其他所有持有该数据副本的缓存都会用这个新值来更新自己的副本。
    * **比较:** 写无效协议通常开销更小，因为它只需要传递一个简短的无效信号，而不是整个数据块。写更新协议在某些特定场景下（如一个生产者，多个消费者频繁读取）可能性能更好，但会产生更大的总线流量。

---
---

### **图片 4/4 (image_d3e141.jpg)**

这张图片包含了四页 PPT，聚焦于一种具体的写无效协议——MSI 协议，并用详细的表格和状态转换图来解释其工作机制。

---

#### **幻灯片 1：Snoopy Coherence Protocols (监听一致性协议)**

* **简要总结:** 这页 PPT 介绍了写无效协议的一种具体实现方式——MSI 协议，它为每个缓存块定义了三种状态。

* **内容翻译与解释:**
    * **标题:** 监听一致性协议
    * **Write invalidate protocol (写无效协议):**
    * **Implementation (实现):**
        * **three block states (MSI protocol) (三种块状态 (MSI 协议)):**
            * **Invalid (无效):** 缓存块中的数据是无效的。
            * **Shared (共享):** 缓存块中的数据是有效的，与主存一致，并且在其他处理器的缓存中可能存在副本。这个状态下，数据是只读的。
            * **Modified (修改/脏):** 缓存块中的数据是有效的，已经被本地处理器修改过，与主存不一致。这是系统中该数据块的唯一有效副本，因此这个状态也暗示了“独占” (Exclusive) 的所有权。
    * **对状态的详细解释:**
        * **Shared:** “表示该块在私有缓存中可能是共享的。” (indicates that the block in the private cache is potentially shared)
        * **Modified:** “表示该块已在私有缓存中被更新过；暗示该块是独占的。” (indicates that the block has been updated in the private cache; implies that the block is exclusive)
    * **解释:** MSI 是最基础的缓存一致性协议之一。通过为每个缓存块维护这三种状态，系统可以跟踪数据的有效性、是否被修改以及是否被共享，从而正确地处理读写请求和维护数据一致性。

---

#### **幻灯片 2 & 3：Write Invalidation Protocol (write back) (写无效协议 (写回))**

* **简要总结:** 这两页 PPT 本质上是同一份详细的表格，描述了在采用写回策略的 MSI 协议中，缓存控制器如何响应来自处理器（本地）和总线（远程）的各种请求，以及相应的状态转换和操作。

* **内容翻译与解释 (以第二页幻灯片为例):**
    * **标题:** 写无效协议 (写回)
    * **表格列名:**
        * `Request` (请求来源): Processor (处理器) 或 Bus (总线)。
        * `Source of address` (地址来源): 描述请求的类型，如读命中、写缺失等。
        * `Type of cached block` (缓存块类型/当前状态): Invalid, Shared, or Modified.
        * `Cache state transition` (缓存状态转换): 描述操作后缓存块的新状态。
        * `Function and explanation` (功能与解释): 描述缓存控制器执行的具体操作。
    * **关键操作示例分析 (编号对应图中数字):**
        * **1. Processor Read Miss (处理器读缺失), 状态: Invalid:**
            * **操作:** 在总线上发起读请求 (BusRd)。
            * **结果:** 获得数据后，状态变为 **Shared**。
        * **2. Processor Write Miss (处理器写缺失), 状态: Invalid:**
            * **操作:** 在总线上发起“为写而读”或“无效化读”请求 (BusRdX)。
            * **结果:** 获得数据并写入后，状态变为 **Modified**。
        * **3. Processor Write Hit (处理器写命中), 状态: Shared:**
            * **操作:** 在总线上发起无效化广播 (BusUpgr/BusInvalidate)。
            * **结果:** 状态变为 **Modified**。这表示从共享只读变为独占可写。
        * **4. Bus Read (总线读请求), 状态: Modified:**
            * **操作:** 监听到其他处理器要读这个数据。因为自己的数据是脏的（最新的），所以必须由自己来提供数据。它会将数据写回内存（或直接发给请求者），然后将自己的状态降级为 **Shared**。
        * **5. Bus Read for Write (BusRdX), 状态: Shared:**
            * **操作:** 监听到其他处理器要写入这个数据。
            * **结果:** 将自己的副本置为 **Invalid**。
    * **解释:** 这个表格是 MSI 协议的“真值表”，完整定义了协议的行为逻辑。通过这个表格，可以精确地追踪任何操作序列下，每个缓存中数据块的状态变化。

---

#### **幻灯片 4：Write Invalidation Protocol (write back) (写无效协议 (写回))**

* **简要总结:** 这页 PPT 以状态机图的形式，可视化地展示了 MSI 协议的状态转换过程，使其更直观易懂。

* **内容翻译与解释:**
    * **标题:** 写无效协议 (写回)
    * **图示:** 这是一个状态转换图，包含三个状态节点：`Invalid` (无效), `Shared` (共享), 和 `Modified` (修改/脏)。箭头表示状态之间的转换，箭头上的文字描述了触发该转换的事件。
    * **图示分析 (解读部分关键路径):**
        * **从 Invalid 到 Shared:** 由 `CPU read` (CPU 读) 触发。此时发生读缺失 (read miss)，需要通过总线 `Place read miss on bus` (在总线上放置读缺失请求) 来获取数据。
        * **从 Invalid 到 Modified:** 由 `CPU write` (CPU 写) 触发。此时发生写缺失 (write miss)，需要通过总线 `Place write miss on bus (BusRdX)` 来获取数据并声明独占权。
        * **从 Shared 到 Modified:** 由 `CPU write` (CPU 写) 触发。此时是写命中，但因为当前是共享状态，不能直接写。需要通过总线发送无效化信号 `Place invalidate on bus`，然后进入 `Modified` 状态。
        * **从 Modified 到 Shared:** 由 `Bus read` (总线读) 触发。表示有其他处理器要读这个数据。当前缓存必须响应请求 `Write-back cache block` (写回缓存块)，然后将自己的状态降级为 `Shared`。
        * **从 Shared/Modified 到 Invalid:** 由 `Bus read for write (BusRdX)` 或 `Bus invalidate` 触发。表示有其他处理器要写入该数据块，当前缓存必须放弃自己的副本。
    * **解释:** 这个状态图与前两页的表格内容是完全对应的，但形式上更加简洁和形象化，是理解和实现缓存一致性协议的标准工具。

希望这些详尽的解释能帮助您完全理解这些 PPT 的内容！ -->

## 3. 存储器一致性模型

