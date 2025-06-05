# Verilog

## Chapter 1 Basic Knowledge

### 1.1 FPGA

**FPGA/Field Programmable Gate Array/现场可编程门阵列**：FPGA器属于专用集成电路/ASIC的一种半定制电路，是可以编程的逻辑列阵，可以按照设计人员的需求配置指定的电路结构，让客户不必依赖于芯片制造商设计和制造的专用集成电路就可以实现所需要的功能，同时实现非常高效的逻辑运算。其基本结构包括可编程输入输出单元，可配置逻辑块，数字时钟管理模块，嵌入式块RAM，布线资源，内嵌专用硬核，底层内嵌功能单元。

### 1.2 Verilog

Verilog HDL是一种硬件描述语言，用于从算法级、门级到开关级的多种抽象设计层次的数字系统建模。Verilog HDL提供了编程语言接口，通过这个接口可以在模拟、验证期间从设计外部访问设计，包括模拟的具体控制和运行。


### 1.3 数字电路

根据逻辑电路的不同特点，数字电路可以分为**组合逻辑**和**时序逻辑**。其中：

- 组合逻辑的特点是在任意时刻，模块的**输出仅仅取决于此时刻的输入**，与电路原本的状态无关。电路逻辑中不牵涉边沿信号的处理，也没有记忆性。
- 时序逻辑的特点是在任意时刻，模块的输出不仅取决于此时刻的输入，而且**还和电路原来的状态有关**。电路里面有存储元件用于保存信息。**一般仅当时钟的边沿到达时**，电路内部存储的信息才有可能发生变化。

## Chapter 2 Basic Syntax

### 2.1 数值系统

Verilog 这种硬件描述语言都基于基本的硬件逻辑之上，因此 Verilog 具有一套独特的基于电平逻辑的数值系统，使用下面四种基本数值表示电平逻辑：

- 0：表示低电平或者 False；
- 1：表示高电平或者 True；
- X：表示电平未知，实际情况可能是高电平或者低电平，甚至都不是；
- Z：表示高阻态，这种情况就是来源于信号没有驱动。

我们还经常用到整数，可以**简单使用十进制表示**，也可以使用**立即数**表示，基于如下的基数规则表示:`<bits>'<radix><value>`，其中 `<bits>` 表示二进制位宽，空缺不填就会根据后边的数值自动分配；`<radix>` 表示进制， `<radix>` 可以是 `b/o/d/h`，分别是二进制，八进制，十进制以及十六进制；`<value>` 表示数值，插入下划线 `_` 可以有效提升可读性。

### 2.2 标识符与变量类型

`wire` 用于声明线网型数据。`wire` 本质上对应着一根没有任何其他逻辑的导线，仅仅将输入自身的信号原封不动地传递到输出端。该类型数据用来表示以 `assign` 语句内赋值的组合逻辑信号，其默认初始值是 Z（高阻态）。

`wire` 是 Verilog 的**默认数据类型**。也就是说，对于没有显式声明类型的信号，Verilog 一律将其默认为 `wire` 类型。

`wire` 的电器特性：

- wire必须被**有且仅有**一个`assign`输入；
- wire可以有0个或者多个`assign`输出。

**`reg`**用于声明在 `always` 语句内部进行赋值操作的信号。一般而言，`reg` 型变量对应着一种存储单元，可以在赋值之间存储数据，其默认初始值是 X（未知状态）。为了避免可能的错误，凡是在 `always` 语句内部被赋值的信号，都应该被定义成 `reg` 类型。

如果 `always` 描述的是组合逻辑，那么 `reg` 就会综合成一根线，如果 `always` 描述的是时序逻辑，那么 `reg` 才会综合成一个寄存器/触发器。

### 2.3 运算符

按位运算符：

- `&`：按位与；
- `|`：按位或；
- `^`：按位异或；
- `~`：按位取反；
- `~^` 或者 `^~`：按位同或；
- **Note**：如果运算符的两个操作数位宽不相等，则利用 0 向左扩展补充较短的操作数。

算数运算符：

### `localparam` 与 `parameter`

`localparam` 类似于 C 中的 `const` 变量，看似是定义了一个变量，其实在生成的时候，只会生成一个立即数代替 `localparam` 变量。`localparam` 只能被赋值一次，赋值表达式可以是任意的 `localparam`、`parameter` 与立即数的计算结果，但不能是电路输出，这就类似于 C++ 的常量表达式 `constexpr`。

### 2.4 模块：结构与例化

Verilog 的基本单元就是**模块**，模块是具有输入输出端口的逻辑块，可以代表一个物理器件，也可以代表一个复杂的逻辑系统，比如基础逻辑门器件或者通用的逻辑单元。一个数字电路系统一般由一个或者多个模块组成，模块化设计将总的逻辑功能分块实现，通过模块之间的互联关系实现所需要的整体系统需求。

#### 2.4.1 模块结构

所有模块以关键词 `module` 开始，以关键词 `endmodule` 结束，从 `module` 开始到第一个分号的部分是**模块声明**，类似于 C 中的函数声明，包括了模块名称、参数列表与输入输出口列表。模块内部可以包括内部变量声明、数据流赋值语句 `assign`、过程赋值语句 `always` 以及底层模块例化。

**端口**是模块与外界交互的接口，对于外部环境来说，模块内部的信号与逻辑都是不可见的，端口的存在允许我们将端口视为一个黑盒，只需要正确链接端口并且了解模块作用，而不需要关心模块内部实现细节。端口的类型有三种：输入端口 `input`，输出端口 `output`，和双向端口 `inout`。端口会被默认声明为 `wire` 类型，如果声明为 `reg` 类型就不能省略对应的 `reg` 声明。

模块名与模块输入输出列表之间可以加入形如 `#(parameter 参数=默认值)` 的**参数列表**，参数可以有多个，拿逗号隔开，可以提供默认值也可以不提供默认值。

下面举个小小的例子，模块内部的内容就省略了吧：

```verilog
module example #(
    parameter LENGTH = 32,
    parameter TIMES = 8
)(
    input [LENGTH-1:0] a,
    input reg rs1, rs2,
    output [LENGTH-1:0] s
);
```

### 2.5 Verilog 语句

#### 2.5.1 连续赋值 `assign`

#### 2.5.2 过程赋值 `always`/`initial`

除了直接使用信号作为敏感变量，Verilog 还支持通过使用 `posedge` 和 `negedge` 关键字将电平变化作为敏感变量。其中 `posedge` 对应上升沿，`negedge` 对应下降沿。我们将电平从低电平变成高电平的时刻称为**上升沿**，从高电平变为低电平的时刻称为**下降沿**.

```Verilog
always@(posedge clk) // 上升沿触发
always@(negedge clk) // 下降沿触发
always@(posedge clk or negedge rstn) // 上升沿触发和下降沿复位
always@(posedge clk or posedge rstn) // 上升沿触发和上升沿复位
```

实际上 `reg` 的触发边沿和复位电平是由寄存器本身的电气特性决定的，比如 FPGA 的触发器一般是上升沿触发和高电平复位。但是我们可以通过给 `clk` 和 `rstn` 经过非门在连接到 `reg` 的方式实现所谓的下降沿触发和低电平复位（将非门和 `reg` 看成一个整体的话）。

这个地方幺蛾子比较多，下边是几个常见的问题：

=== "多时钟触发"

    核心原因：触发器只有一个时钟输入端口，综合的时候实际上并不能做到多时钟触发。
    ```Verilog
    always@(posedge clk1 or posedge clk2) // 上升沿触发
    ```
    
    从语义上看这个 `always` 块既在 `clk1` 上升沿触发，又在 `clk2` 上升沿触发。当我们仿真的时候，可以实现这个逻辑功能，但是因为触发器只有一个时钟输入端口，所以综合的时候实际上并不能做到 `clk1`、`clk2` 同时作为时钟触发。

=== "多边沿触发"

    核心原因：不存在这样的触发器。
    ```Verilog
    always@(clock)          // 上升沿也触发、下降沿也触发，即时钟电平翻转就触发
    always@(a or b or c)    // a、b、c 电平反转就触发
    ```
    从语义上看只要 `clock`、`a`、`b`、`c` 数据变化就会引起 `always` 块触发。仿真可以接受这样的逻辑设计，但是因为不存在即上升沿触发又下降沿触发，所以实际上并不能综合得到这样的时序电路。
    
    ```Verilog
    reg d;
    always@(a or b or c)begin
        if(a) d <= c;
        else d <= b;
    end
    ```
    虽然不能得到时序电路，但是可以综合得到组合电路。`d` 的结果依赖于 `a`、`b`、`c`，一但 `a`、`b`、`c` 的输入发生了变化，则 `d` 随着变化，这是符合组合电路的逻辑语义的。最后会得到 `b`、`c` 作为数据，`a` 作为选择子的二选一多路选择器。既然所有的信号只依赖于 `a`、`b`、`c`，所以简化成只要有信号的改变就触发 `always` 块。这就是我们的组合电路。

    ```verilog
    reg d;
    always @(*) begin
        if(a) d <= c;
        else d <= b;
    end
    ```

=== "多 `always` 块触发"

    核心原因：一个触发器不能被两个时钟沿触发。
    ```Verilog
    always@(posedge clk)begin
        d <= a;
    end
    always@(negedge clk)begin
        d <= b;
    end
    ```
    上升沿的时候 `d` 载入 `a` 的值，下降沿的时候 `d` 载入 `b` 的值。仿真允许 `reg` 在不同的 `always` 块被不同的时钟沿触发，但是在综合的时候一个 `reg` 不能被两个时钟沿触发。
    
    ```Verilog
    always@(posedge clk)begin
        if(c) d <= a;
    end
    always@(posedge clk)begin
        if(~c) d <= b;
    end
    ```
    这个逻辑是连仿真也无法通过的，因为在同一时间 `d` 被两个过程同时仲裁，即使我们知道这两个过程并不冲突，但是也不可以被编译通过。类似于 `wire` 不能被两个输出同时输入，`reg` 也不能在两个 `always` 块内被赋值，这都会引起 multi-driven 错误。


=== "异步触发"

    核心问题：**数据竞争**，不同路径的电平传播速度有快慢，电平在传播期间电路本身就处在不稳定状态，很多中间态在逻辑粉丝上无法覆盖。
    
    ```Verilog
    reg [1:0] d;
    wire problem;
    reg cond1;
    reg cond2;
    assign problem = cond1 & cond2;
    
    always@(posedge problem)begin
        d <= d + 2'b1;
    end
    ```

    当 cond1 和 cond2 同时为 1，problem 变为 1 的时候触发 always 块。这在仿真的时候不容易发现问题，但是请考虑下面这个情形：
    
    ```Verilog
    initial begin
        cond1=1'b0;cond2=1'b1;
        #5;
        cond1=1'b1;cond2=1'b0;
    end
    ```
    在仿真的时候会看到 `problem` 永远等于 `0`，`always` 块不会触发。但是真实的电路综合之后会因为时延造成问题。当 `cond1` 从 `0` 变为 `1` 的时候高电平需要一段时间在可以到的 `problem = cond1 & cond2` 的与门；`cond2` 从 `1` 变为 `0`，低电平也需要一段时间到达与门。如果 `cond1` 的高电平在 `cond2` 的低电平之前先到达，则会短暂的出现与门的输入都是高电平，最后 `problem` 短暂出现高电平，进而 `always` 块被触发，寄存器被复制。

    解决方法也很简单，转换为同步电路就好了，即在 `always` 块中使用 `posedge clk` 作为触发边沿。剩下的使用 `if` 语句来判断是否触发。


#### 2.5.3 阻塞赋值与非阻塞赋值

- 阻塞赋值

  阻塞赋值是**顺序执行**的，即下一条语句执行前，当前语句一定会执行完毕。这与 C 语言的赋值思想是一致的。阻塞赋值语句使用等号 `=` 作为赋值符。

- 非阻塞赋值

  非阻塞赋值属于**并行执行**语句，即下一条语句的执行和当前语句的执行是同时进行的，它不会阻塞位于同一个语句块中后面语句的执行，并且相互之间没有依赖关系。非阻塞赋值语句使用小于等于号 `<=` 作为赋值符。

#### 2.5.4 `generate` 语句

为了提升代码变量的局部性（毕竟对于常用的迭代参数，最好是每一个 `generate` 块对应一个 `genvar` 变量），所以我们常用下面的语法：

```verilog
generate
    genvar i;
    for(i=0; i<iteration_times; i=i+1)begin
        // do something
    end
endgenerate
```

在使用 `generate` 语句之后，Verilog 会在对应的模块内生成一个专用的命名空间 `genblk`，参数式编程下，相同的模块会对应不同的名字，比如 `genblk[i]:module_name`，这就不需要担心命名冲突的问题。

### 2.6 元件的 Verilog 实现

#### 2.6.1 触发器

最简单的触发器塞了两个寄存器和一根输入的线，在时钟上升沿的时候，将输入的值非阻塞地赋给第一个寄存器，在时钟下降沿的时候，将第一个寄存器的值非阻塞地赋给第二个寄存器。

```verilog
wire data;
reg a, b;
always @(posedge clk) begin
    a <= data;
end

always @(negedge clk) begin
    b <= a;
end
```

#### 2.6.2 使能寄存器

某些寄存器会有一个额外的**使能引脚**EN，只有当 `EN=1` 的时候，寄存器才会载入输入信号，相应的 Verilog 语法如下：

```verilog
reg a;
always @(posedge clk) begin
    if(EN) begin
        a <= data;
    end
end
```

!!! info
    我们之前将 `always@(*)` 的时候，`if` 是需要搭配 `else` 使用的，不然会导致环路错误，但是这里不需要，因为 `always@(*)` 综合得到的电路是用 `wire` 搭建的，它只是借用了 `reg` 的 `always` 块语法而已。但是 `always@(posedge clk)` 得到的电路使用真实的寄存器搭建的，是不会形成环路问题的。

#### 2.6.3 寄存器的初始化

=== "异步初始化"

    ```verilog
    reg a;  //高电平异步复位寄存器
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            a <= INTIAL_VALUE;
        end else if(wen)begin
            a <= data;
        end
    end

    reg b; //低电平异步复位寄存器
    always@(posedge clk or negedge rstn)begin
        if(~rstn)begin
            b <= INTIAL_VALUE;
        end else if(wen)begin
            b <= data;
        end
    end
    ```

    这段代码对应的寄存器是异步复位寄存器，这类寄存器除了有时钟输入 `clk`、使能输入 `CE`、数据输入 `data` 之外，还会有一个额外的输入引脚 `rst/rstn`。这个引脚如果输入 `0` 则寄存器会被复位，则该寄存器是低电平异步复位，复位引脚标注为 `rstn`；这个引脚如果输入 `1` 则寄存器会被复位，则该寄存器是高电平异步复位，复位引脚标注为 `rst`。

    由于复位操作不需要等待时钟信号为上升沿，只要有复位信号就可以立即复位，所以复位操作是异步的。

=== "同步初始化"
    
    ```verilog
    reg a;//高电平同步复位寄存器
    always@(posedge clk)begin
        if(rst)begin
            a <= INTIAL_VALUE;
        end else if(wen)begin
            a <= data;
        end
    end

    reg a;//低电平同步复位寄存器
    always@(posedge clk)begin
        if(~rstn)begin
            a <= INTIAL_VALUE;
        end else if(wen)begin
            a <= data;
        end
    end
    ```

    这段对应的是同步复位寄存器，对于高电平同步复位寄存器来说，没有显式的异步复位引脚，只有时钟信号 `clk`，复位信号 `rst` 会在时钟上升沿的时候生效，所以复位操作是同步的。

    同步复位寄存器更像是一个带有多路选择器的使能寄存器，还是对于高电平同步复位寄存器来说，使能信号 `CE` 接的是 `rst | wen`，这样只有在复位信号 `rst` 为 `1` 或者写使能信号 `wen` 为 `1` 的时候，寄存器才会被写入。复位信号 `rst` 作为选择子对写入值进行选择，当 `rst` 为 `1` 的时候，选择初始值 `INTIAL_VALUE`，当 `rst` 为 `0` 的时候，选择输入数据 `data`。

=== "FPGA 初始化"

    FPGA 的复位信号 `rstn` 由 FPGA 芯片的 C12 引脚引入。当 vivado 将 bitstream 下载到 FPGA 板之后，`rstn` 信号会先保持一段时间的 `0`，使得所有的寄存器可以被充分初始化，然后 `rstn `信号变为 `1` 且一直保持不变，这样所有的寄存器就从初始化阶段进入工作阶段，开始载入数据。
    
    FPGA 进入工作阶段后，我们也可以按开发板的 reset 按钮，让 `rstn` 再次输入 `0`，重新复位所有寄存器的值。
    
    ```Verilog
    set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports rstn]
    ```
    
    因为 FPGA 板的 `rstn` 在初始化阶段是低电平，所以该信号只能直接用于复位低电平复位寄存器。对于高电平复位的寄存器可以将 `rstn` 取反，然后用 `rst` 作为复位信号。
    ```Verilog
    wire rst;
    assign rst = ~rstn;
    ```

### 2.6.4 移位寄存器

```verilog
wire in_data;
reg [3:0] left_shift_reg;
reg [3:0] right_shift_reg;
always@(posedge clk)begin
    if(en)begin
        left_shift_reg <= {left_shift_reg[2:0], in_data};
        right_shift_reg <= {in_data, right_shift_reg[3:1]};
    end
end
```

```Verilog
wire [3:0] in_data;
reg [3:0] left_shift_reg [3:0];
reg [3:0] right_shift_reg [3:0];

integer i;
always@(posedge clk)begin
    if(en)begin
        for(i=0;i<3;i=i+1)begin
            left_shift_reg[i+1] <= left_shift_reg[i];
        end
        left_shift_reg[0] <= in_data;
    end
end
always@(posedge clk)begin
    if(en)begin 
        for(i=0;i<3;i=i+1)begin
            right_shift_reg[i] <= right_shift_reg[i+1];
        end
        right_shift_reg[3] <= in_data;
    end
end
```

## Chapter 3 SystemVerilog 高级语法

### 3.1 `logic` 与 `bit`

除了熟悉的 0 与 1 之外，还拥有**未知值/Unknown** (x) 与**高阻态/High-impedance** (Z) 的值的类型叫做 **4 状态类型/4-state types**。注意到常用的 `reg` 只可以在像 `initial` 和 `always` 的过程赋值中被驱动，而 `wire` 只可以在连续赋值 `assign` 中被驱动，这就很不方便，所以 SystemVerilog 就引入了一种新的4状态类型 `logic`，它的默认值为 x，可以出现在过程赋值与连续赋值之中。

在一般的测试程序之中，我们并不需要未知值与高阻态值，所以衍生了只有 0 和 1 的 **2 状态类型**。使用 2 状态类型有很多好处，比如减少内存使用、提升模拟速度，因而在数字设计中很好用。当 4 状态类型转化为 2 状态类型的时候，未知值和高阻态都会被转换成 0。 SystemVerilog 引入的最重要的 2 状态类型就是 `bit`，表示单独 1 位的值（电平）。

### 3.2 `typedef` 语法

```SystemVerilog
parameter WIDTH = 64;

typedef logic [WIDTH-1:0] data_t;
typedef logic [WIDTH*2-1:0] sum_t;
```

### 3.3 `enum` 枚举

直接上代码。

```verilog
typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7} state_t;

state_t state;
always@(pposedge clk or negedge rstn)begin
    if(~rstn)begin
        state <= S0;
    end else begin
        case(state)
            S0:if(X) state<=S1; else state<=S0; 
            S1:if(X) state<=S2; else state<=S0;
            S2:if(X) state<=S3; else state<=S0;
            S3:if(X) state<=S3; else state<=S4;
            S4:if(X) state<=S1; else state<=S5;
            S5:if(X) state<=S6; else state<=S0;
            S6:if(X) state<=S2; else state<=S7;
            S7:if(X) state<=S1; else state<=S0;
        endcase
    end
end
```

需要逐句逐字分析的只有不几行：

- `enum` 定义了一个枚举类型，`logic [2:0]` 表示这个枚举类型是一个3位的逻辑类型，所有的枚举变量和长度都是3位数据。
- `{S0, S1, S2, S3, S4, S5, S6, S7}` 一次性定义了枚举常量，从左到右依次是 0-7 的逻辑常量，这就避免了显示提供立即数的麻烦。
- `typedef` 和 `state_t` 是类型定义，将这个枚举变量定义为 `state_t` 类型，使用 `state_t` 类型的变量 `state` 代替了原来的 `logic [2:0]` 类型，就不用费尽心思保持位宽相同了。
- 对于定义的枚举变量 `state`，其可以存储定义的枚举类型的任意一个值。

### 3.4 数组

### 3.5 `queue` 队列

??? info "ZJU System 1"
    `queue` 语法仅用于仿真，不要用它实现电路，但是作为基本数据结构辅助还是很好的，

### 3.6 `struct` 结构

```SystemVerilog
parameter LEN = 4;
typedef logic [LEN-1:0] data_t;
typedef struct{
    data_t data [LEN-1:0];
} data_vector;
```

对应的模块端口语法需要是 `#!SystemVerilog input/output data_vector data_instance;`

这样就将很多个数据打包成一个数据结构，输入与输出的结构端口可以直接用结构变量进行链接，结构变量之间可以直接赋值，方便传输与处理。

### 3.7 `package` 包

> 包是用来定义一堆杂七杂八的参数用的。

我们可以在包中定义各种需要的**参数/parameter**，**类型/typedef**，**结构/struct**，**函数/function**。

```SystemVerilog
package Conv;
    parameter WIDTH = 64;
    parameter LEN   = 4;
    
    typedef logic [WIDTH-1:0] data_t;
    typedef logic [WIDTH*2-1:0] sum_t;
    
    typedef struct{
        data_t data [LEN-1:0];
    } data_vector;
    
endpackage
```

使用类似于 C++ 中的命名空间的语法来使用包中的定义，比如 `#!SystemVerilog output Conv::data_vector result;`，如果要引入 `Conv` 内的所有定义，可以使用 `#!SystemVerilog import Conv::*;` 来实现。

将包的定义放在一个文件的开头就可以引用包定义的内容，我们一般使用 Verilog 头文件 `.vh` 与宏实现，比如 `#!SystemVerilog `include "Conv.vh"`。

### 3.8 `interface` 接口

`interface` 接口是用来简化交互信号处理的。

```verilog
interface Decoupled_ift #(
    parameter DATA_WIDTH = 64
);

    typedef logic [DATA_WIDTH-1:0] data_t;
    typedef logic ctrl_t;
    data_t data;
    ctrl_t valid, ready;
    
    modport Master(
        output data;
        output valid;
        input  ready;
    );
    
    modport Slave(
        input data;
        input valid;
        output ready;
    );
    
endinterface
```

`interface name ... endinterface` 定义一个 `interface` 块，并且可以进行参数配置。


### 3.9 `always_comb` 扩展

## Chapter 4 SystemVerilog 与 C 的接口




