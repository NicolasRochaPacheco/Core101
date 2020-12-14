# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

# Path to verilog files
VPATH := $(shell find rtl -name '*.v')

# Path to C++ testbench
CPATH = ./testbench/core101_testbench.cpp

# Simulates core
simulate: rtl/memory/ins_mem.hex rtl/memory/data_mem.hex
	@echo "Simulating Core101"
	@$(VERILATOR) --trace --cc $(VPATH) --exe $(CPATH)
	@make -j -C obj_dir -f VCore101_top.mk
	./obj_dir/VCore101_top
	@echo "Simlation ended"

fpga:
	@echo 'Building Core101 and uploading it to FPGA'

clean:
	@if [ -d "obj_dir" ]; then rm -r obj_dir; fi
	@if [ -d "out" ]; then rm -r out; fi
