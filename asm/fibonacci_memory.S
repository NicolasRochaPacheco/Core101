
.text

  .global _start

# Loads parameters for fibonacci routine
_start:
  li x10, 0x1000
  li x11, 10
  j _fibonacci

# Calculates the numbers of the fibonacci sequence
# and then stores the values in memory. It receives
# the following parameters:
#  x10 -> base address for storing the numbers
#  x11 -> how many numbers will be calculated
_fibonacci:
  li x5, 0
  li x31, 1
  sw x5, 0(x10)
  addi x11, x11, -1
  li x6, 1
  addi x10, x10, 4
  sw x6, 0(x10)
  addi x11, x11, -1

_calc:
  add x7, x5, x6
  add x5, x0, x6
  add x6, x0, x7

_store:
  addi x10, x10, 4
  sw x6, 0(x10)
  addi x11, x11, -1
  bne x0, x11, _calc

_exit:
  li x1, 0
  li x2, 0
  li x3, 0
  li x4, 0
  li x5, 0
  li x6, 0
  li x7, 0
  li x8, 0
  li x9, 0
  li x10, 0
  li x11, 0
  li x12, 0
  li x13, 0
  li x14, 0
  li x15, 0
  li x16, 0
  li x18, 0
  li x19, 0
  li x20, 0
  li x21, 0
  li x22, 0
  li x23, 0
  li x24, 0
  li x25, 0
  li x26, 0
  li x27, 0
  li x28, 0
  li x29, 0
  li x30, 0
  li x31, 0
  addi x17, x17, 1
  j _start
