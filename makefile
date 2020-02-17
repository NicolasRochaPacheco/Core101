# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

# Verilog source files
RTL_FILES = rtl/misc/ADDER.v

Core101:
	@$(VERILATOR) -Wall --cc $(RTL_FILES)

clean:
	@rm -r obj_dir