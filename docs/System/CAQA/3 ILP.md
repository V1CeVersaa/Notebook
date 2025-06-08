# Instruction-Level Parallelism

!!! Abstract "Outline"

??? Info "高僧预测"

    <img class="center-picture" src="assets/3 ILP/review-1.png" alt="drawing" width="550" />

    <img class="center-picture" src="assets/3 ILP/review-2.png" alt="drawing" width="550" />

    <img class="center-picture" src="assets/3 ILP/review-3.png" alt="drawing" width="550" />

    <img class="center-picture" src="assets/3 ILP/review-4.png" alt="drawing" width="550" />

    <img class="center-picture" src="assets/3 ILP/review-5.png" alt="drawing" width="550" />

    <img class="center-picture" src="assets/3 ILP/review-6.png" alt="drawing" width="550" />


## 1. 指令级并行：概念与挑战

对于确定一个程序中的并行度以及如何利用并行，判断**指令之间的依赖关系**至关重要。如果两条指令是**并行**的，那么只要流水线有足够的资源，就可以在一个任意深度的流水线之中同时执行他们，并且不会导致任何停顿；如果两条指令是相互依赖的，那么其必须按照顺序执行。

值得注意的是，依赖是程序的一种属性。某种给定依赖是否会导致检测到实际冒险，冒险又是否会导致停顿，这都取决于流水线结构的性质。下面假设指令 i 位于指令 j 之前，一般存在下面三种依赖：

- **数据依赖/真数据依赖/Data Dependence**：指令 i 生成的结果可能会被指令 j 用到；或者指令 j 数据依赖于指令 k，指令 k 又数据依赖于指令 i。
- **名称依赖/Name Dependence**：两条指令使用相同的寄存器或者存储地址（称为**名称**），但与该名称相关的指令之间并没有数据流动的时候，就会发生名称依赖。
- **控制依赖/Control Dependence**：控制依赖决定了指令 i 相对于分支指令的顺序，使指令 i 按照争取的指令顺序执行，并且只在应当执行的时候执行。除了程序中第一个基本块中的指令以外，其他所有指令都和某组分支存在控制依赖，为了保持程序顺序，必须保持这些控制依赖。

名称依赖之下又可以分为反依赖/Antidependence 和输出依赖/Output Dependence：

- 当指令 j 对指令 i 读取的寄存器或者存储地址执行写操作的时候，就会在指令 i 和指令 j 之间产生**反依赖**，为了能保证指令 i 可以读到正确的值，必须保持指令之间的顺序。
- 当指令 i 和指令 j 都写入相同的寄存器或者存储地址的时候，就会在指令 i 和指令 j 之间产生**输出依赖**，为了保证最后写入的值和指令 j 相对应，必须保持指令之间的顺序。

由于没有在指令之间传递值，如果改变这些指令之中使用的名称，使这些指令不再冲突，名称依赖中涉及的指令就可以重新排序或者同时执行。这种操作称为寄存器重命名/Register Renaming。

根据指令中读访问和写访问的顺序，可以将数据冒险分为 3 类：

- **RAW/Read After Write/写后读**：j 试图在 i 写入一个源位置之前读取该源位置，所以 j 会错误地获得旧值，这与真数据依赖相对应。为了确保 j 会收到来自 i 的值，必须保持程序顺序。
- **WAW/Write After Write/写后写**：j 试图在 i 写一个操作数之前写该操作数。这些写操作将以错误的顺序执行，最后写入目标位置的是由 j 写入的值，而不是由 i 写入的值。这种冒险与输出依赖相对应。只有在允许多个流水级进行写操作的流水线中，或者在前一指令停顿时允许后-指令继续执行的流水线中，才会发生 WAW 冒险。
- **WAR/Write After Read/读后写**：j 尝试在 i 读取一个目标位置之前写入该位置，所以i会错误地获取新值。这一冒险源于反依赖。对于大多数静态安排流水线（即使是较深的流水线或者浮点流水线），由于所有读操作都比所有写操作要早一些，所以不会发生 WAR。

## 2. 使用动态调度克服数据冒险

我们之前的流水线使用静态调度/Static Scheduling，也就是在获取指令后会发射该指令，除非发现该指令存在数据依赖且无法通过前递/Forwarding 来隐藏该数据依赖，此时冒险检测硬件会从使用该寄过的指令开始，使流水线出于停顿状态，直到依赖清除后再获取新的指令。简而言之，使用静态调度的流水线的关键特征和限制是：使用顺序指令发射和执行，且存在暂停/Stall。

在动态调度/Dynamic Scheduling 中，硬件会重新安排指令的执行顺序以减少停顿，同时保持数据流和异常行为不变（在不改变数据流的同时尽可能避免停顿）。它的优点有：

- 允许针对一种流水线结构编译的代码在不同的流水线上高效执行；
- 可以应对编译的时候依赖关系未知的情况；
- 允许处理器容忍一些意料之外的延时，比如缓存缺失，可以在解决缓存缺失的时候执行其他代码。

在经典的五级流水线之中，可以在指令译码/ID 期间检查结构冒险和数据冒险，当**可以无冒险执行**的时候，就可以从 ID 发射出去，并且确认所有数据冒险都已经解决。为了可以实现动态调度，我们将发射过程分为两部分：检查所有结构冒险和等待数据冒险的消失，我们仍然使用顺序指令发射，但是我们希望一条指令可以在其数据操作数可用的时候立刻开始执行，因此这样的流水线实际上是乱序执行的/Out-of-Order Execution，这也意味着乱序完成/Out-of-Order Completion。但是这样的性质会让事情变得复杂起来：

- 乱序执行可能导致 WAR 和 WAW 冒险，后面会使用寄存器重命名来解决。
- 乱序完成会使异常处理变得复杂，采用连续完成的动态调度必须保留异常行为，既要使严格按照程序顺序执行时发生的异常仍然实际发生，又要保持不会发生其他异常；并且动态调度的处理器可能造成**非精确异常**，意味着在发生异常的时候，**处理器状态**和严格按照程序顺序执行指令时的状态不完全一致，这又有两个子原因：
    - 流水线在执行导致异常的指令时，可能**已经完成**了按照程序顺序排在这一条指令**之后**的指令；
    - 流水线在执行导致异常的指令时，可能**还没有完成**按照程序顺序排在这一条指令**之前**的指令。

非精确异常增大了在异常之后重新开始执行的难度，后面我们会讨论这些问题。

我们将五级简单流水线的 ID 流水级分为下面两个阶段：

- 发射/Issue/IS：指令译码，检查结构冒险（顺序发射）；
- 读取操作数/Read Operands/RO：一直等到没有数据冒险之后，读取操作数。

<img class="center-picture" src="assets/3 ILP/3-1.png" alt="dynamic scheduling" width="550" />

我们区分一个指令**开始执行**和**完成执行**的时刻：在这两个时刻之间，指令处于执行过程之中。我们的流水线允许同时执行多条指令，这是利用动态调度优势的前提。但是同时执行多条指令也意味着我们需要**有多个功能单元**或者流水化功能单元，两者兼有也可以，但是我们一般假设具有多个功能单元。

### 2.1 Scoreboard 算法

我们考虑下面的 RISC-V 代码：

```asm
FLD    F6, 34(R2)
FLD    F2, 45(R3)
FMUL.D F0, F2, F4
FSUB.D F8, F2, F6
FDIV.D F10, F0, F6
FADD.D F6, F8, F2 
```

简单来讲，Scoreboard 算法维护三个表，分别记录**指令及指令状态**，**功能单元状态**和**寄存器状态**，当只有第一个 Load 指令结束之后，这三个表应该如下所示：

=== "指令状态表"

    我们认为第二个 Load 指令只完成了执行，并未完成写回操作，由于 Add 部件只有一个，因此最后一条 Add 指令不能被发射。因为第一条 Mul 指令需要使用 F2 寄存器，而 F2 寄存器被第二个 Load 指令占用，因此第一条 Mul 指令需要等待，无法读取操作数，后面的指令也同理。

    <img class="center-picture" src="assets/3 ILP/3-2.png" alt="instruction table" width="550" />

=== "功能单元状态表 & 寄存器状态表"

    这里解释一下功能单元状态表的每一个字段的意思：

    - `Busy`：功能单元是否被占用；`Op`：功能单元正在执行的操作；
    - `Fi`、`Fj`、`Fk`：分别代表目的操作数和两个/一个源操作数；
    - `Qj`、`Qk`：表明两个源操作数来自哪个部件，比如第二行的 `Qj` 为 Integer 部件，表明 F2 寄存器来自 Integer 部件；
    - `Rj`、`Rk`：表明两个源操作数是否已经准备好，这分为三种情况：
        - `yes`：表明操作数准备好了，但是还没有读；
        - `no` 且 `Qj` 为空，表明操作数已经读取好；
        - `no` 且 `Qj` 不为空，表明操作数还没有准备好，别的指令有可能修改这个操作数，就更别说读了。

    下面的寄存器状态表记录了**每一个寄存器将会被哪一个部件修改**。

    <img class="center-picture" src="assets/3 ILP/3-3.png" alt="functional unit table" width="550" />

=== "处理器结构"

    注意这张图右侧的四个阶段实际上并不是在描述流水线，而是指明了指令的执行阶段。

    <img class="center-picture" src="assets/3 ILP/3-4.png" alt="processor structure" width="550" />

当 `FMUL.D` 指令准备好写回结果的时候，三个表长这样：

=== "指令状态表"

    <img class="center-picture" src="assets/3 ILP/3-5.png" alt="instruction table" width="550" />

=== "功能单元状态表 & 寄存器状态表"

    <img class="center-picture" src="assets/3 ILP/3-6.png" alt="functional unit table" width="550" />

当 `FDIV.D` 指令准备好写回结果的时候，三个表长这样：

=== "指令状态表"

    <img class="center-picture" src="assets/3 ILP/3-7.png" alt="instruction table" width="550" />

=== "功能单元状态表 & 寄存器状态表"

    <img class="center-picture" src="assets/3 ILP/3-8.png" alt="functional unit table" width="550" />

???- "例题"

    === "题目"

        <img class="center-picture" src="assets/3 ILP/3-9.png" alt="example" width="550" />

    === "答案"

        <img class="center-picture" src="assets/3 ILP/3-10.png" alt="example" width="550" />

Scoreboard 算法的问题之一在于没有积极的处理反依赖和输出依赖，只是使用停顿来解决这两种依赖，而 Tomasulo 算法会积极使用寄存器重命名进一步处理依赖。

### 2.2 Tomasulo 算法





