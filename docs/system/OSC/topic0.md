# Introduction: OS Structure

## What is an OS?

操作系统是应用程序和硬件之间的软件层，提供了资源的抽象和分配/**Resource Abstractor and Resource Allocator**。操作系统定义了一系列逻辑资源，并将其与硬件资源对应起来，比如我们常见的硬件资源有 CPU、硬盘和 RAM，常见的逻辑资源有进程、文件和数组等。

至于如何启动操作系统，计算机需要先运行一个引导程序/Bootsrap Program，引导程序一般存在 ROM 中，在启动的时候初始化寄存器内容、硬件控件内容等等，然后将 OS 内核载入内存的正确位置，启动第一个进程，然后等待事件发生。

多道程序设计/Multi-Programming

时分共享/Time-Sharing 亦即有快速上下文切换的多道程序，每一个任务不能运行太久，这就允许了非常短的响应时间，每一个任务都有着只有自己在运行的错觉，这就允许了交互式用户体验，

指令的
