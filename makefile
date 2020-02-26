# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

CUR_DIR = $(shell pwd)

# Verilog source files
VPATH = $(CUR_DIR)/rtl/IFU.v \
		$(CUR_DIR)/rtl/misc/ADDER.v \
		$(CUR_DIR)/rtl/misc/MUX_B.v \
		$(CUR_DIR)/rtl/misc/REG.v \

CPATH = $(CUR_DIR)/src/ifu_testbench.cpp


Core101:
	echo 'Building Core101'
	#$(VERILATOR) -Wall --cc $(VPATH) --exe $(CPATH)
	$(VERILATOR) --cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VCore101_top.mk

# Verilator tests with simple modules
adder:
	echo 'Building a single adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/adder_testbench.cpp -I$(I_DIR)
	make -j -C obj_dir -f VADDER.mk

cascade:
	echo 'Building a cascade adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/CASCADE.v $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/cascade_testbench.cpp
	make -j -C obj_dir -f VCASCADE.mk

ifu:
	echo 'Building IFU'
	$(VERILATOR) -Wall -cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VIFU.mk

clean:
	@rm -r obj_dir
