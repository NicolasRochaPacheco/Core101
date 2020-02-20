# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

# Verilog source files
VPATH = /rtl/misc/ADDER.v

CPATH = /src/adder_testbench.cpp


Core101:
	echo 'Building Core101'
	@$(VERILATOR) -Wall --cc $(VPATH) --exe $(CPATH)
	@make -j -C obj_dir -f VADDER.mk VADDER

clean:
	@rm -r obj_dir