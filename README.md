# Core101
This repository is intended to host Core101 central processing unit (CPU) development. This CPU will be used in a System on a Chip (SoC101) that is going to be developed along with the core.

## Specifications

  |Specification | Value |
  |---|---|
  |ISA|RISC-V|
  |Architecture|Modified Harvard|
  |Data width|32 bits|
  |ISA Extensions|Integer (RV32I), Vector (RV32V)|
  |Pipeline stages|1 (From version 0.1), 5 (From version 1.0)|
  |Technology|FPGA, VLSI|

## Releases
Core101 will be developed and released according to the following specification:

### Version 0.1
Defined on September 23rd, 2019, Core101 version 0.1 will support the following subset of RISC-V I-Spec:

* LW
* SW
* SLL
* SRL
* ADD
* SUB
* OR
* AND
* SLT
* BEQ

It was also defined that Core101 will have the following hardware specifications:

* Single stage datapath, at most, per supported instruction.
* 32 general purpose registers as defined on RISC-V I-Spec.
* PC register, incremented by either normal PC increment or branch target address.
* IR with no instruction cache provided.
* Partial immediate handling support. Loads and stores cannot have an offset. Branches are allowed to have an offset.
* Four operations ALU.
* Shift unit.
* Memory access units.
* No memory cache supported.
* No exceptions and traps are supported.
* No CSR supported.


### Version 0.2


### Version 0.3
