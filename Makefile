# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

CUR_DIR = $(shell pwd)

# Verilog source files
VPATH = $(CUR_DIR)/rtl/Core101_top.v \
				$(CUR_DIR)/rtl/IFU/IFU.v \
				$(CUR_DIR)/rtl/GPR/GPR.v \
				$(CUR_DIR)/rtl/IFU/IFU_CONTROL.v \
				$(CUR_DIR)/rtl/DEC/IMM_GEN.v \
				$(CUR_DIR)/rtl/DEC/DECODE_UNIT.v \
				$(CUR_DIR)/rtl/MEM/MAIN_MEMORY.v \
				$(CUR_DIR)/rtl/ISSUE/ISSUE_UNIT.v \
				$(CUR_DIR)/rtl/EX/INT_EXEC.v \
				$(CUR_DIR)/rtl/EX/ALU.v \
				$(CUR_DIR)/rtl/MISC/ADDER.v \
				$(CUR_DIR)/rtl/MISC/MUX_A.v \
				$(CUR_DIR)/rtl/MISC/MUX_B.v \
				$(CUR_DIR)/rtl/MISC/MUX_F.v \
				$(CUR_DIR)/rtl/MISC/DECODE_F.v \
				$(CUR_DIR)/rtl/MISC/REG.v \
				$(CUR_DIR)/rtl/MISC/REG_NEG.v

CPATH = $(CUR_DIR)/src/core101_testbench.cpp


Core101:
	@echo 'Building Core101'
	$(VERILATOR) --cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VCore101_top.mk

# Verilator test with a single module with its testbench
adder:
	echo 'Building a single adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/MISC/ADDER.v --exe $(CUR_DIR)/src/adder_testbench.cpp -I$(I_DIR)
	make -j -C obj_dir -f VADDER.mk

# Verilator test with a composed moule with its testbench
cascade:
	echo 'Building a cascade adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/MISC/CASCADE.v $(CUR_DIR)/rtl/MISC/ADDER.v --exe $(CUR_DIR)/src/cascade_testbench.cpp
	make -j -C obj_dir -f VCASCADE.mk

clean:
	@rm -r obj_dir
