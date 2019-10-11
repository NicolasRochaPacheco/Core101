# Makefile for Core101


MAIN_PATH = $(HOME)/L0G1C101/Core101
RTL_PATH = $(MAIN_PATH)/rtl


VERILOG_FILES = $(RTL_PATH)/CPU.v 						\
								$(RTL_PATH)/CONTROL.v					\
								$(RTL_PATH)/DATAPATH.v				\
								$(RTL_PATH)/if/PC_INC.v				\		# Instruction fetch modules
								$(RTL_PATH)/misc/GEN_REG.v 		\   # Miscelaneous modules
								$(RTL_PATH)/misc/GEN_MUX_4.v			#
