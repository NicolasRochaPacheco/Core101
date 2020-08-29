# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

CUR_DIR = $(shell pwd)

# Verilog source files
VPATH = $(CUR_DIR)/rtl/Core101_top.v \
				$(CUR_DIR)/rtl/Core101.v \
				$(CUR_DIR)/rtl/IFU/IFU.v \
				$(CUR_DIR)/rtl/IFU/PREDICTOR.v \
				$(CUR_DIR)/rtl/GPR/GPR.v \
				$(CUR_DIR)/rtl/DEC/IMM_GEN.v \
				$(CUR_DIR)/rtl/DEC/DECODE_UNIT.v \
				$(CUR_DIR)/rtl/DEC/FORWARDING_UNIT.v \
				$(CUR_DIR)/rtl/MEM/MAIN_MEMORY.v \
				$(CUR_DIR)/rtl/ISSUE/BRU.v \
				$(CUR_DIR)/rtl/ISSUE/ISSUE_UNIT.v \
				$(CUR_DIR)/rtl/EX/INT_EXEC.v \
				$(CUR_DIR)/rtl/EX/ALU.v \
				$(CUR_DIR)/rtl/EX/LSU_EXEC.v \
				$(CUR_DIR)/rtl/MISC/ADDER.v \
				$(CUR_DIR)/rtl/MISC/MUX_A.v \
				$(CUR_DIR)/rtl/MISC/MUX_B.v \
				$(CUR_DIR)/rtl/MISC/MUX_F.v \
				$(CUR_DIR)/rtl/MISC/ENCODE_B.v \
				$(CUR_DIR)/rtl/MISC/DECODE_F.v \
				$(CUR_DIR)/rtl/MISC/REG.v \
				$(CUR_DIR)/rtl/MISC/REG_NEG.v \
				$(CUR_DIR)/rtl/CONTROL/CONTROL.v

CPATH = $(CUR_DIR)/src/core101_testbench.cpp

simulate:
	@echo "Simulating Core101"
	$(VERILATOR) --cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VCore101_top.mk

Core101:
	@echo 'Building Core101 and uploading it to FPGA'
	

clean:
	@if [ -d "obj_dir" ]; then rm -r obj_dir; else echo "Directory does not exists."; fi
	@if [ -d "out" ]; then rm -r out; else echo "Directory does not exists."; fi