# Core101
This repository is intended to host Core101 central processing unit (CPU). This CPU will be used on an embedded system (SoC101) that is going to be developed once the core is finished. This core will support the RV32IV* from RISC-V ISA. Further details on supported instructions are discused later in this file. This core is expected to be finished by May 2020.


## Microarchitecture
Core101 is an in-order RISC-V core, that features a five-stage pipeline that resembles an out-of-order processor microarchitecture. Core101 pipeline consists of an instruction fetch (IF) stage, an instruction decode (ID) stage, an issue stage (IS), an execution/memory access stage (EX/MEM) and a writeback stage (WB). It has three "execution units": an integer execution unit, a vector execution unit and a load/store unit. Core101 will fully support the integer base extension from RISC-V ISA (RV32I) and some instructions from vector extension, that we denoted RV32V* .

![Core101 microarchitecture should be shown here](https://github.com/NicolasRochaPacheco/Core101/blob/master/doc/resources/uA.png "Core101 microarchitecture diagram")


## Docker
Core101 is intended to be synthetized within a Docker container, in order to keep all dependencies and prerrequisites in an isolated virtual environment. Nevertheless, if you have the requiered software installed on your machine there is no reason for Core101 coming up with errors, unless it is a matter of source code, in which case we apologize beforehand.

We strongly recommend you using Docker, and the provided Docker image, to synthetize and test our code. Please check the [Core101 Docker documentation](https://github.com/NicolasRochaPacheco/Core101/blob/master/docker) if you want to use our Dockerfile. All console commands from Core101 documentation are intended to be run on a Docker container unless otherwise stated.


## Synthetization
Synthetization of Core101 is done with [Verilator](https://www.veripool.org/projects/verilator/wiki/Intro) and testbenches are written in C++. We are looking forward to test Core101 with RISC-V tests to ensure that ISA is supported properly.

We will provide two synthetization tests using Verilator, these tests are intended to check that modules can be synthetized. Of course, installation of prerrequisites should not be a problem since we provide a Docker image with all dependencies and requiered files.

To synthetize on the docker container, run the following console command:

    $ source l0g1c2docker.bash

This will run the testbenches on the docker container and output the result on the console. Just make sure that path to Core101 has a parent directory called L0G1C101.

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


