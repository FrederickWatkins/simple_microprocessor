.text
move 1, r2
START:
CHECK_FIZZ:
move r2, r3
rem 3, r3
jmpnz CHECK_BUZZ
call STORE_FIZZ, r1

CHECK_BUZZ:
move r2, r3
rem 5, r3
jmpnz INCREMENT
call STORE_BUZZ, r1

INCREMENT:
add 1, r2
jmp START

STORE_FIZZ: ; Store value in r2 as fizz and incr fizz
lw FIZZ_ADDR r3 ; Load current fizz address into r3
sw r3, r2
add 1, r3
sw FIZZ_ADDR, r3
jmp r1
STORE_BUZZ: ; Store value in r2 as buzz and incr buzz
lw BUZZ_ADDR r3 ; Load current fizz address into r3
sw r3, r2
add 1, r3
sw BUZZ_ADDR, r3
jmp r1
.data
FIZZ_ADDR: 0x02
BUZZ_ADDR: 0xA0