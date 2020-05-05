# Core101
<p align="justify">This repository is intended to host Core101 central processing unit (CPU). This CPU will be used on an embedded system (SoC101) that is going to be developed once the core is finished. This core supports Integer (RV32I) and some Vector (RV32V) instructions from RISC-V ISA. Details on supported instructions are introduced later in this README. Core101 will be mainly used on Soc101, but anyone who finds this core useful is free to use it. The main goal behind developing Core101 is introducing vector operations in an embedded system using RISC-V, but other goals were set for its development. We wanted Core101 to be as well documented as possible regarding its usage and working principles. On the other hand, to make Core101 usage as easy as possible by a third-party user, we introduced Docker for running simulations.</p>

---

## Using Core101
<p align="justify">This part describes how to use Core101. You will find a guide in how to clone the repository, how to setup the docker container, and how to run programs. For testing purposes we use a program that outputs the numbers from the Fibonacci sequence.</p>

### Cloning Core101
<p align="justify">To clone Core101 in your computer run the following commands in the console:</p>

	$ git clone https://github.com/NicolasRochaPacheco/Core101.git

<p align="justify">We encourage you to clone Core101 in a folder named L0G1C101 on your home directory. We are working to override this restriction but in the mean time there is no alternative.</p>

### Docker
Core101 is intended to be synthetized within a Docker container, in order to keep all dependencies and prerrequisites in an isolated virtual environment. Nevertheless, if you have the requiered software installed on your machine there is no reason for Core101 coming up with errors, unless it is a matter of source code, in which case we apologize beforehand.

We strongly recommend you using Docker, and the provided Docker image, to synthetize and test our code. Please check the [Core101 Docker documentation](https://github.com/NicolasRochaPacheco/Core101/blob/master/docker) if you want to use our Dockerfile.


### Synthetization
Synthetization of Core101 is done with [Verilator](https://www.veripool.org/projects/verilator/wiki/Intro) and testbenches are written in C++. We are looking forward to test Core101 with RISC-V tests to ensure that ISA is supported properly. Once you have the docker container working on your computer, to synthetize run the following console command:

    $ source l0g1c2docker.bash

This bash script will copy this repository inside the Docker container, then it will synthetize the core, and run some tests. We are currently thinking of how to allow an user to run his/her own tests within the Docker container.

### Tests
This section is intended to show how tests can be executed on Core101. Tests' source code comes from [Software101](www.github.com/NicolasRochaPacheco/Software101) repository and are compiled using the RV32I toolchain. There are three test programs intended to validate the execution of arithmetic and logical instructions, conditional jumps, and a mix of them. By April 20th, Core101 is able to execute arithmetic, logic and conditional jumps.

---

## Microarchitecture
<p align="justify">Core101 is an in-order RISC-V core, that features a five-stage pipeline that resembles an out-of-order processor microarchitecture. Core101 pipeline consists of an instruction fetch (IF) stage, an instruction decode (ID) stage, an issue stage (IS), an execution/memory access stage (EX/MEM) and a writeback stage (WB). It has three "execution units": an integer execution unit, a vector execution unit and a load/store unit. Core101 will fully support the integer base extension from RISC-V ISA (RV32I) and some instructions from vector extension, that we boldly denoted RV32V*.</p>

<p align="center">
	<img width="500px" src="https://github.com/NicolasRochaPacheco/Core101/blob/master/doc/resources/files/uA_general.png">
</p>

### ISA Support
As stated before, Core101 will support a 32-bits RISC-V ISA, consisting of the base integer extension (RV32I), and some of the Vector extension instructions. Since this core will be used on an embedded system, we will choose the supported Vector instructions thinking about an embedded system profile. As far as the Vector extension v0.8, a profile for embedded system is proposed, and the Vector instruction subset for this core is intended to use that proposal to include vector operations.

#### Supported Instructions as of May 5th

| LUI   |                    | BNE  | :heavy_check_mark: |
| AUIPC | :heavy_check_mark: | BLT  | :heavy_check_mark: |
| JAL   | :heavy_check_mark: | BGE  | :heavy_check_mark: |
| JALR  | :heavy_check_mark: | BLTU | :heavy_check_mark: |
| BEQ   | :heavy_check_mark: | BGEU | :heavy_check_mark: |


