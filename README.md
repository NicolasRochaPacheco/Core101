# Core101
This repository is intended to host Core101 central processing unit (CPU). This CPU will be used in a System on a Chip (SoC101) that is going to be developed once the core is fully developed. This core will support a RV32IV* specification from RISC-V ISA. Further details on supported instructions will be discused later. This core is expected to be finished by May 2020.

## Synthetization
Synthetization of Core101 is done with [Verilator](https://www.veripool.org/projects/verilator/wiki/Intro) and testbenches are written in C++. We are looking forward to test Core101 with RISC-V tests to ensure that ISA is supported properly.

We will provide two synthetization tests using Verilator, these tests are intended to check that modules can be synthetized. Of course, installation of prerrequisites should not be a problem since we provide a Docker image with all dependencies and requiered files.

### Adder test
To test a single adder, synthetized by Verilator with a testbench consisting of three additions do:

    $ make adder
    $./obj_dir/VADDER

The tests should output:

    15
    -5
    -15

### Cascade adder test
To test a cascade adder, with three inputs, and two adders, do:

    $ make cascade
    $./obj_dir/VCASCADE

Tests should output:

    $ 30
    $ -13
    $ 0

## Microarchitecture
This core will have the following microarchitecture:

![alt text](https://github.com/NicolasRochaPacheco/Core101/blob/master/doc/resources/uA.png "Core101 microarchitecture diagram")
