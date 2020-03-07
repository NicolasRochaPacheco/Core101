# Core101
This repository is intended to host Core101 central processing unit (CPU). This CPU will be used on an embedded system (SoC101) that is going to be developed once the core is finished. This core will support and RV32IV* from RISC-V ISA. Further details on supported instructions are discused later in this file. This core is expected to be finished by May 2020.

---

## Microarchitecture
Core101 is an in-order RISC-V core, that features a five-stage pipeline that resembles an out-of-order processor microarchitecture. Core101 pipeline consists of an instruction fetch (IF) stage, an instruction decode (ID) stage, an issue stage (IS), an execution/memory access stage (EX/MEM) and a writeback stage (WB). It has three "execution units": an integer execution unit, a vector execution unit and a load/store unit. Core101 will fully support the integer base extension from RISC-V ISA (RV32I) and some instructions from vector extension, that we boldly denoted RV32V*.

![Core101 microarchitecture should be shown here](https://github.com/NicolasRochaPacheco/Core101/blob/master/doc/resources/uA.png "Core101 microarchitecture diagram")

### ISA Support
As stated before, Core101 will support a 32-bits RISC-V ISA, consisting of the base integer extension (RV32I), and some of the Vector extension instructions. Since this core will be used on an embedded system, we will choose the supported Vector instructions thinking about an embedded system profile. As far as the Vector extension v0.8, a profile for embedded system is proposed, and the Vector instruction subset for this core is intended to use that proposal to include vector operations.

---

## Using Core101
This part describes how to use Core101. We provide instructions to allow virtually every user to use this Core. In the following subsections you will find a guide on how to clone the repository, how to setup the Docker container and understand why we use it, and how to run tests.

### Docker
Core101 is intended to be synthetized within a Docker container, in order to keep all dependencies and prerrequisites in an isolated virtual environment. Nevertheless, if you have the requiered software installed on your machine there is no reason for Core101 coming up with errors, unless it is a matter of source code, in which case we apologize beforehand.

We strongly recommend you using Docker, and the provided Docker image, to synthetize and test our code. Please check the [Core101 Docker documentation](https://github.com/NicolasRochaPacheco/Core101/blob/master/docker) if you want to use our Dockerfile. All console commands from Core101 documentation are intended to be run on a Docker container unless otherwise stated.


### Synthetization
Synthetization of Core101 is done with [Verilator](https://www.veripool.org/projects/verilator/wiki/Intro) and testbenches are written in C++. We are looking forward to test Core101 with RISC-V tests to ensure that ISA is supported properly. Once you have the docker container working on your computer, to synthetize run the following console command:

    $ source l0g1c2docker.bash

This bash script will copy the 

### Tests
We will provide two synthetization tests using Verilator, these tests are intended to check that modules can be synthetized. Of course, installation of prerrequisites should not be a problem since we provide a Docker image with all dependencies and requiered files.



This will run the testbenches on the docker container and output the result on the console. Just make sure that path to Core101 has a parent directory called L0G1C101.

#### Adder test
To test a single adder, synthetized by Verilator with a testbench consisting of three additions do:

    $ make adder
    $./obj_dir/VADDER

The tests should output:

    15
    -5
    -15

#### Cascade adder test
To test a cascade adder, with three inputs, and two adders, do:

    $ make cascade
    $./obj_dir/VCASCADE

Tests should output:

    $ 30
    $ -13
    $ 0


