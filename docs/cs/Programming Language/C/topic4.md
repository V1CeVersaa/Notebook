# Standard Library

## `assert` 库

## `stdio` 库

- `int sprintf(char *buffer, const char *format,...)`函数

    向字符串`buffer`里写入，相当于多了一个转换格式/读写的工具函数。

- `int fprintf(FILE *stream, const char *format,...)`函数

- `sscanf()`函数

- `fscanf()`函数

    向输出流`stream`中写入。

## `stdlib`库

### 1. 随机数

- `void srand(unsigned int seed)`

    `srand()`函数为伪随机数生成器`rand()`播种，正常的用法是：`srand((unsigned int) time(NULL))`

    这段代码利用当前时间为伪随机数生成器`rand(0)`提供种子，这样子就可以得到了近似于真随机的随机数。

- `int rand(void)`

    伪随机数生成器`rand()`生成一个介于`0`到`RAND_MAX`的随机数。如果没有`srand()`的播种，`rand()`函数就会默认生成种子为1的随机数。每次调用`rand()`函数，我们得到的都是上次生成的随机数的下一个数

    值得注意的是，在调用函数`rand()`之前的时候，伪随机数生成器只应该被播种一次。
    
    > Generally speaking, the pseudo-random number generator should only be seeded once, before any calls to `rand()`, and the start of the program. It should not be repeatedly seeded, or reseeded every time you wish to generate a new batch of pseudo-random numbers.
    
    更重要的是，当`rand()`接受相同的种子的时候，他会生成相同的随机数数列。

## `time`库

### 变量类型

- `time_t` 这是一个适合储存日历时间的**长整型`(long int)`**变量，表示着从**POSIX time** （1970年1月1日00：00）开始的总秒数。

### 函数

- `time_t time(time_t *seconds)`

    `time()`函数将当前日历时间作为一个`time_t`类型的变量返回，并且将这个变量存储在输入的指针`seconds`中（前提是这个指针不为空指针）。

    由于`time_t`类型其实是一个`long int`转换成`int`(或者`unsigned int`)的时候还是需要强制转换说明的2
  
  
