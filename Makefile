# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

CUR_DIR = $(shell pwd)

# Verilog source files
VPATH = $(CUR_DIR)/rtl/Core101_top.v \
				$(CUR_DIR)/rtl/IFU/IFU.v \
				$(CUR_DIR)/rtl/IFU/IFU_CONTROL.v \
				$(CUR_DIR)/rtl/DEC/DECODE_UNIT.v \
				$(CUR_DIR)/rtl/MEM/MAIN_MEMORY.v \
				$(CUR_DIR)/rtl/ISSUE/ISSUE_UNIT.v \
				$(CUR_DIR)/rtl/misc/ADDER.v \
				$(CUR_DIR)/rtl/misc/MUX_B.v \
				$(CUR_DIR)/rtl/misc/REG.v \
				$(CUR_DIR)/rtl/misc/REG_NEG.v

CPATH = $(CUR_DIR)/src/core101_testbench.cpp


Core101:
	@echo 'Building Core101'
	$(VERILATOR) --cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VCore101_top.mk

# Verilator test with a single module with its testbench
adder:
	echo 'Building a single adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/adder_testbench.cpp -I$(I_DIR)
	make -j -C obj_dir -f VADDER.mk

# Verilator test with a composed moule with its testbench
cascade:
	echo 'Building a cascade adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/CASCADE.v $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/cascade_testbench.cpp
	make -j -C obj_dir -f VCASCADE.mk

clean:
	@rm -r obj_dir
