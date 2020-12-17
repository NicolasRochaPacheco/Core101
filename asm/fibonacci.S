.globl _main

.text

_main:
	addi x1, x0, 3
	addi x2, x0, 7
	addi x3, x0, 1

_decide:
	bne x1, x2, _loop
	sub x2, x2, x1
	addi x2, x2, 4
	beq x0, x0, _exit

_loop:
	sub x2, x2, x3
	addi x4, x4, 1
	bne x1, x2, _loop
	beq x0, x0, _decide

_exit:
	add x0, x0, x0
