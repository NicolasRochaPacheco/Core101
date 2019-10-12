# Makefile for Core101
include sources.list

# Required programs for synthesis and compilation
IVERILOG = iverilog

MAIN_PATH = $(HOME)/L0G1C101/Core101
RTL_PATH = $(MAIN_PATH)/rtl
SYNTH_OUT_PATH = $(MAIN_PATH)/synth_out


iverilog:
	mkdir -p $(SYNTH_OUT_PATH)
	$(IVERILOG) -o $(SYNTH_OUT_PATH)/core 
