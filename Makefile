# Makefile for Core101

# Required programs for synthesis and compilation
VERILATOR = verilator
YOSYS = yosys
RISC_V_PREFIX = riscv32-unknown-elf


# Path to verilog files
VPATH := $(shell find rtl -name '*.v')

# Path to C++ testbench
CPATH = ./testbench/core101_testbench.cpp

# Path to pin definition
PIN_DEF = tinyFPGA_pins.pcf

# Path to core BLIF file
BLIF_OUT = ./out/synth/core.blif

# Directories
SYNTH_OUT = ./out/synth


# =============================================================================
# MAIN TARGETS
# =============================================================================
simulate: rtl/memory/ins_mem.hex
	@echo "Simulating Core101"
	@$(VERILATOR) --trace --cc $(VPATH) --exe $(CPATH)
	@make -j -C obj_dir -f VCore101_top.mk
	./obj_dir/VCore101_top
	@echo "Simlation ended"

fpga: $(SYNTH_OUT)/core.bin
	@echo 'Building Core101 and uploading it to FPGA'
	@sudo python -m tinyprog -p $<

# Validates every module
IMM_GEN PC_CALC FWD PREDICTOR: out
	@echo "Validating $@ module w/ a thousand tests"
	@python3 ./golden/modules_testbench.py -m $@ -n 1000
	@vsim -c -do ./testbench/modules/$@/$@.do
	@python3 ./golden/modules_analyzer.py -r ./out/$@_results.txt


# =============================================================================
# FPGA TARGETS
# =============================================================================

out/synth/modules/%.blif: rtl/modules/%.v
	$(YOSYS) -ql out/synth.log -p 'synth_ice40 -blif $@' $<


$(SYNTH_OUT)/core.bin: $(SYNTH_OUT)/core.asc
	icepack $< $@

$(SYNTH_OUT)/core.asc: $(PIN_DEF) $(BLIF_OUT)
	arachne-pnr -d 8k -P cm81 -o $@ -p $^

$(BLIF_OUT): $(SYNTH_OUT) $(VPATH)
	$(YOSYS) -ql out/synth.log -p 'synth_ice40 -top Core101 -blif $@' $(VPATH)

# =============================================================================
# HEX TARGETS
# =============================================================================

rtl/memory/ins_mem.hex: asm/fibonacci_memory.S out/code
	$(RISC_V_PREFIX)-as -o out/code/fibonacci $<
	$(RISC_V_PREFIX)-objcopy -O verilog out/code/fibonacci $@

# =============================================================================
# DIRECTORY TARGETS
# =============================================================================

# Main output directory
out:
	if [ ! -d "out" ]; then mkdir out/; fi

# Synthetization output directory
out/synth:
	if [ ! -d "out/" ]; then mkdir -p $(SYNTH_OUT); fi

out/code:
	mkdir -p out/code


clean:
	if [ -d "obj_dir" ]; then rm -r obj_dir/; fi
	if [ -d "out" ]; then rm -r out/; fi
	if [ -d "work" ]; then rm -r work/; fi
	if [ -f "transcript"]; then rm transcript; fi
