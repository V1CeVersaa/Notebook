# Instructions: Language of the Computer

!!! Info

    RISC-V 系统学习一遍就足够了，再多看多少本书都没啥意思了，而 COAD 和 CS61B 都属于没啥意思的这种，详细的可以指路：

    - [我写的一点点整理](../HDL%20&%20ISA/RISC-V/RISC-V.md)
    - [DDCA 里边有关 RISC-V 的一些内容](../DDCA/Chapter6.md)
    - [xg 的整理](https://note.tonycrane.cc/cs/pl/riscv/)

    下面当初学的时候随便记了点东西，没啥用虽然。

## Temporary Variables

在 RV32I 之中只有寄存器 `x5` `x6` `x7` 是临时寄存器,被命名为 `t0` `t1` `t2`，这些寄存器可以用于存储临时变量或者任意修改，同时可以将临时变量存储在栈之中，这就需要调整栈指针 `x2` 也就是 `sp` 的值。下面是几个例子：

```C 
int a = 5;
char b[] = "string";
int c[10];
uint8_t d = b[3];
c[4] = a + d;
c[a] = 20;
```

```asm
# a in 0(sp), b in 4(sp), c in 12(sp), d in 52(sp)
addi    sp, sp, -56
li      t0, 5
sw      t0. 0(sp)       # a = 5
li      t0, 0x69727473
sw      t0, 4(sp)
li      t0, 0x0000676E
sw      t0, 8(sp)       # b = "string"
lb      t0, 7(sp)
sb      t0, 52(sp)      # d = b[3]
lw      t0, 0(sp)
lbu     t1, 52(sp)
add     t2, t0, t1
sw      t2, 28(sp)      # c[4] = a + d
li      t0, 20
lw      t1, 0(sp)
slli    t1, t1, 2       # a * 4
addi    t1, t1, 12
add     t1, t1, sp
sw      t0, 0(t1)       # c[a] = 20     
```

## Control Flow

### `if-then` statements

<div class="grid" markdown>

```C title="if-then in C"
if (x >= 10)
    y = x;
// reduce with goto
if (x < 10) goto skip;
    y = x;
skip: ...
```

```asm title="if-then in RISC-V"
# assume x in a3, y in a4
    li  t0, 10
    blt a3, t0, skip 
    add a4, a3, zero
skip: ...
```

</div>

### `while` loop

### `do-while` loop

### `for` loop

使用移位指令与 `lw` 实现 `lbu` 指令。

```asm
# lbu using lw: lbu s1, 1(s0)
lw      s1, 0(s0)       # load word
li      t0, 0x0000FF00  # load bitmask
and     s1, s1, t0      # get target byte
srli    s1, s1, 8       # shift right
```

使用移位指令与 `sw` 实现 `sb` 指令。

```asm
# sb using sw: sb s1, 3(s0)
lw      t0, 0(s0)       # load current word
li      t1, 0x00FFFFFF  # load bitmask
and     t0, t0, t1      # zero top byte
slli    t1, s1, 24      # little-endian & shift left
or      t0, t0, t1      # combine
sw      s1, 0(s0)       # store
```

```C
while ((*q++ = *p++) != '\0') ;
```

```asm
# copy String p to q
# p -> s0, q -> s1
loop:
    lb      t0, 0(s0)       # load byte
    sb      t0, 0(s1)       # store byte
    addi    s0, s0, 1       # increment p
    addi    s1, s1, 1       # increment q
    bne     t0, x0, loop    # loop if not null
    j       exit            # exit if null
```

## Function Calls

Six steps of calling a function:

- Put arguments in a place where the function can access them.
- Transfer control to the function.
- The function will acquire any (local) storage it needs.
- The function performs its task.
- The function puts the return value in an accessible place and cleans up.
- Transfer back the control to the caller.

Arguments registers:

- `a0` to `a7` for arguments.
- `a0` and `a1` for return values.
- `sp` for the stack pointer, holding the current memory address of the bottom of the stack.
- Order of arguments matters.
- If need extra arguments, use the stack.

Example:

```C
void main(void) {
    int a = 3;
    int b = a + 1;
    a = add(a, b);
}

int add(int x, int y) {
    return x + y;
}
```

```asm
main:
    addi a0, x0, 3
    addi a1, a0, 1
    jal  ra, add
add:
    add  a0, a0, a1
    jr   ra
```

Basic structure of a function:

```asm
Prologue
    func_label:
    addi sp, sp, -framesize
    sw   ra, (framesize-4)(sp)
    # store other callee-saved registers
    # save other regs if needed
Body
    # function body
Epilogue
    # restore other regs if needed
    # restore callee-saved registers
    lw ra, (framesize-4)(sp)
    addi sp, sp, framesize
    jr ra   # or ret
```

## Recursion in RISC-V

```C title="Factorial in C"
int factorial(int n) {
    if (n == 0) return 1;
    return n * factorial(n-1);
}
```

```asm title="Factorial in RISC-V"
factorial:
    addi sp, sp, -16
    sw   ra, 12(sp)
    li   t0, 1
    blt  a0, t0, else
    sw   a0, 8(sp)
    addo a0, a0, -1
    jal  ra, factorial
    lw   t0, 8(sp)
    mul  a0, t0, a0
    j    fact_end
else:
    li   a0, 1
fact_end:
    lw   ra, 12(sp)
    addi sp, sp, 16
    ret
```

```C title="Fibonacci in C"
int fibonacci(int n) {
    if (n < 2) return 1;
    return fibonacci(n-1) + fibonacci(n-2);
}
```

```asm title="Fibonacci in RISC-V"
fibonacci:
    li t0, 2                # test if n < 2    
    blt a0, t0, fib_base    # if n < 2, return 1

    addi sp, sp, -8         # allocate stack space
    sw   ra, 4(sp)          # store return address
    sw   a0, 0(sp)          # store original n

    addi a0, a0, -1         # n-1 in a0
    jal  x1, fibonacci      # calculate fib(n-1)

    lw   t0, 0(sp)          # load original n to t0
    sw   a0, 0(sp)          # store fib(n-1) to stack
    addi a0, t0, -2         # now n-2 in a0
    jal  x1, fibonacci      # calculate fib(n-2)

    lw   t0, 0(sp)          # load fib(n-1) to t0
    add  a0, a0, t0         # calculate fib(n) = fib(n-1) + fib(n-2)
    lw   ra, 4(sp)          # load return address
    addi sp, sp, 8          # clean up stack
    ret

fib_base:                   # base case, return 1
    li a0, 1
    ret
```

## local Storage for variables

Stack Pointer `sp` holds the address of the bottom of the stack.

- Decrement it (stack grows downwards), and use `sw` to write to a variable.
- To clean up, just increment the stack pointer.

```asm
# store t0 to the stack
addi sp, sp, -4  # allocate space
sw   t0, sp      # store t0
addi sp, sp, 4   # clean up
```









