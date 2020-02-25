# Core101
This repository is intended to host Core101 central processing unit (CPU). This CPU will be used in a System on a Chip (SoC101) that is going to be developed once the core is finished. This core will support a RV32IV* specification from RISC-V ISA. Further details on supported instructions are discused later in this file. This core is expected to be finished by May 2020.

## Microarchitecture
Core101 is an in-order RISC-V core, that features a five-stage pipeline that resembles the microarchitecture of an out-of-order processor. Core101 pipeline consists of a instruction fetch (IF) stage, a instruction decode (ID) stage, an issue stage (IS), an execution/memory access stage (EX/MEM) and a writeback stage (WB). It has three "execution units": an integer execution unit, a vector execution unit and a load/store unit.

![alt text](https://github.com/NicolasRochaPacheco/Core101/blob/master/doc/resources/uA.png "Core101 microarchitecture diagram")

## Docker
Core101 is intended to run within a Docker container, in order to keep all dependencies and prerrequisites in an isolated virtual environment. Nevertheless, if you have the requiered software installed on your machine there is no reason for Core101 coming up with errors, unless it is a matter of source code, in which case we apologize beforehand.

We strongly recommend you using Docker to synthetize and test our code. Please check the [Core101 Docker documentation](https://github.com/NicolasRochaPacheco/Core101/blob/master/docker/README.md) if you want to use our Dockerfile. All console commands from Core101 documentation are intended to be run on a Docker container unless otherwise stated.

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


