# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator

CUR_DIR = $(shell pwd)

# Verilog source files
VPATH = $(CUR_DIR)/rtl/misc/CASCADE.v \
		$(CUR_DIR)/rtl/misc/ADDER.v
	    

# CPATH = $(CUR_DIR)/src/adder_testbench.cpp
CPATH = $(CUR_DIR)/src/cascade_testbench.cpp


Core101:
	echo 'Building Core101'
	$(VERILATOR) -Wall --cc $(VPATH) --exe $(CPATH)
	make -j -C obj_dir -f VCASCADE.mk

adder:
	echo 'Building a single adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/adder_testbench.cpp
	make -j -C obj_dir -f VADDER.mk

cascade:
	echo 'Building a cascade adder'
	$(VERILATOR) -Wall -cc $(CUR_DIR)/rtl/misc/CASCADE.v $(CUR_DIR)/rtl/misc/ADDER.v --exe $(CUR_DIR)/src/cascade_testbench.cpp
	make -j -C obj_dir -f VCASCADE.mk

clean:
	@rm -r obj_dir
