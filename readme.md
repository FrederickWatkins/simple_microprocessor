## Project Idea
This repository is a personal educational project to improve at verilog by implementing a simple single cycle* processor. It uses 8 bit wide data and 16 bit wide instructions.

*(As it uses a synchronous read main memory for the sake of realism, it is single cycle other than the lw instruction, which stalls the processor one cycle)

<img width="800" alt="Screenshot From 2026-01-31 15-27-25" src="https://github.com/user-attachments/assets/4fa77fe5-a395-434e-98f7-605db36b5f8c" />
<img width="800" alt="Screenshot From 2026-01-31 15-25-49" src="https://github.com/user-attachments/assets/0a35d12c-c4a9-4171-85d7-252e9ea7da8c" />

## ISA
All instructions use immediate value only if rs=r0 (r0 is hardwired to all zeros)

| Instruction | Opcode | Description |
|---|---|---|
|| Control ||
| nop | 'b0000 | No operation |
| call rs(imm), rd | 'b0001 | Call subroutine rs (imm), writing pc to rd |
| jmp rs(imm) | 'b0010 | Jump to instruction rs (imm) |
| jmpz rs(imm) | 'b0011 | Jump if zero to instruction rs (imm) |
| lw rs(imm), rd | 'b0100 | Load word at memory address rs (imm) to rd |
| sw rs(imm), rd | 'b0101 | Store word in rd to memory address rs (imm) |
| jmpnz rs(imm), rd | 'b0110 | Jump if not zero to instruction rs (imm) |
| move rs(imm), rd | 'b0111 | Move rs (imm) to rd |
|| Arithmetic ||
| add rs(imm), rd | 'b1000 | Add rs (imm) to rd and store result in rd |
| sub rs(imm), rd | 'b1001 | Subtract rs (imm) from rd and store result in rd |
| rr rs(imm), rd | 'b1010 | Rotate right rd by rs (imm) bits and store result in rd |
| rl rs(imm), rd | 'b1011 | Rotate left rd by rs (imm) bits and store result in rd |
| mul rs(imm), rd | 'b1100 | Mul rd by rs (imm) and store result in rd |
| div rs(imm), rd | 'b1101 | Divide rd by rs (imm) and store result in rd |
| rem rs(imm), rd | 'b1110 | Modulo rd by rs (imm) and store result in rd |


|imm[15:8]|rd[7:6]|rs[5:4]|opcode[3:0]|
|---|---|---|---|

## Architecture
The register file is a dual port memory, where the second read address is also the address for the write port. Due to this, the destination register of a two operand instruction must be the second source register. There are 3 general purpose registers (r0 is hardwired to 0).

The cpu uses two main data buses, bus 0 is fed by rd and main memory, and bus 1 by rs (and imm). Bus 0 can output to either the main memory or register file, and bus 1 to either the main memory address port or program counter. This is the configuration that requires the fewest connections to the buses.

The ALU has no accumulator, instead feeding directly to the register file write port.

The memory model is a full harvard architecture, keeping instruction memory completely seperate to data. Reprogramming is done through an external interface, stalling the cpu and switching the bus connections to allow the programming interface to write directly into the memories.
