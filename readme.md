All instructions use immediate value only if rs=r0 (r0 is hardwired to all zeros)

| Instruction | Opcode | Description |
|---|---|---|
|| Control ||
| nop | 'b0000 | No operation |
| call rs, rd, imm | 'b0001 | Call subroutine rs (imm), writing pc to rd |
| jmp rs, imm | 'b0010 | Jump to instruction rs (imm) |
| jmpz rs, imm | 'b0011 | Jump if zero to instruction rs (imm) |
| lw rs, rd, imm | 'b0100 | Load word at memory address rs (imm) to rd |
| sw rs, rd, imm | 'b0101 | Store word in rd to memory address rs (imm) |
| jmpnz rs, rd, imm | 'b0110 | Jump if not zero to instruction rs (imm) |
| move rs, rd, imm | 'b0111 | Move rs (imm) to rd |
|| Arithmetic ||
| add rs, rd, imm | 'b1000 | Add rs (imm) to rd and store result in rd |
| sub rs, rd, imm | 'b1001 | Subtract rs (imm) from rd and store result in rd |
| rr rs, rd, imm | 'b1010 | Rotate right rd by rs (imm) bits and store result in rd |
| rl rs, rd, imm | 'b1011 | Rotate left rd by rs (imm) bits and store result in rd |
| mul rs, rd, imm | 'b1100 | Mul rd by rs (imm) and store result in rd |
| div rs, rd, imm | 'b1101 | Divide rd by rs (imm) and store result in rd |
| rem rs, rd, imm | 'b1110 | Modulo rd by rs (imm) and store result in rd |


|imm[15:8]|rd[7:6]|rs[5:4]|opcode[3:0]|
|---|---|---|---|