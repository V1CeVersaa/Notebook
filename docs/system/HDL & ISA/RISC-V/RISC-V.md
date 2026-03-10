# RISC-V

!!! info
    参考：

    - [xg 的 RISC-V 笔记](https://note.tonycrane.cc/cs/pl/riscv/)

## RISC-V Principles

- **Simplicity favors regularity.**
- **Smaller is faster.**
- **Separated into multiple specifications**
- **ISA support is given by RV + word-width + extensions**, such as RV32I means RISC-V with 32-bit word width and integer base instruction set.

## User-Level ISA

User-Level ISA defines the normal instructions needed for computation:

- A mandatory **base integer ISA** RV32I/RV32E/RV64I
    - **I** for basic Integer instructions, including ALU(only with addition and subtraction), Branches and Jumps, Loads and Stores.
- Standard Extensions:
    - **M** for Integer Multiplication and Division.
    - **A** for Atomic Instructions.
    - **F** for Single-Precision Floating-Point.
    - **D** for Double-Precision Floating-Point.
    - **C** for Compressed Instructions (16-bit).
    - **V** for Vector Operations.
    - **Q** for Quad-Precision Floating-Point.
    - **Zicsr** for Control and Status Registers.
    - **Zifencei** for FENCE.I Instruction.
    - **G/IMAFDZicsr_Zifencei** for General Purpose, i.e. integer base and four standard extensions.

## Components

Any assembly programs are encoded as plain text files and contain four main components:

- **Comments**
- **Labels**
- **Assembly Instructions**
- **Assembly Directives**

## Addressing Architecture

A **Load/Store Architecture** is an instruction set architecture that requires values to be loaded/stored explicitly from/to memory before operating on them. In other words, to read/write a value from/to memory, the software must execute a load/store instruction.

The RISC-V ISA is a **Load/Store Architecture**. Hence, to perform operations (e.g. arithmetic operations), on data stored on memory, it requires the data to be first retrieved from memory into a register by executing a load instruction. As an example, let us consider the following assembly code, which loads a value from memory, multiply it by two, and stores the result on memory.

```asm
lw  a5, 0(a0)     # load the value at address a0 into register a5
add a6, a5, a5    # multiply the value in a5 by 2 and store the result
sw  a6, 0(a1)     # store the value in a6 at address a1
```

## Toolchain

The following toolchain is included in the `binutils-riscv64-unknown-elf` package:

- `riscv64-unknown-elf-as`: a version of the **GNU Assembler** that generates code for RISC-V ISAs.
    - `-march=rv32i`: specify the target ISA as RV32I.
    - `-mabi=ilp32`: specify the target ABI as ILP32.
    - example: `riscv64-unknown-elf-as -march=RV32I -mabi=ilp32 hello.o -o hello.s`
- `riscv64-unknown-elf-ld`: a version of the **GNU linker** that links object files into an executable file.
    - `-m elf32lriscv`: specify the object file format as ELF32.
- `riscv64-unknown-elf-objdump`: a version of the **GNU objdump** that displays information about object files.
    - `-D` or `--disassemble-all`: disassemble the contents of a binary file.
    - example: `riscv64-unknown-elf-ld -m elf32lricsv trunk.o -o trunk.x && riscv64-unknown-elf-objdump -D trunk,x`
    - `-r` or `--reloc`: inspect the contents of the relocation table on the file.
- `riscv64-unknown-elf-nm`: a version of the **GNU nm** that inspects the symbol table of an object file.
    - example: `riscv64-unknown-elf-nm trunk.o`
- `riscv64-unknown-elf-readelf`: inspect the ELF header of an executable file.
    - `-h` or `--file-header`: display the ELF file header.

## Supplement

- File format to encode object files:
    - **ELF** (Executable and Linkable Format) is frequently used in Linux-based systems.
    - **PE** (Portable Executable) is used in Windows-based systems.
