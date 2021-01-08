
from numpy.random import choice
from random import randint
from ctypes import c_int32

class Module(object):

	def __init__(self, name):

		self.name = name
		self.inputs = []
		self.outputs = []
		self.memories = []

	def exectute(self, inputs):
		raise NotImplementedError


	def add_input(self, name, width, restricted=None):

		self.inputs.append(self.__define_port(name, width, restricted))



	def add_output(self, name, width, restricted=None):

		self.outputs.append(self.__define_port(name, width))


	def __define_port(self, name, width, restricted=None):

		# Defines port directory
		port_dict = {
			"name":name,
			"min_value": 0,
			"max_value": 2 ** int(width) - 1,
			"restricted":restricted
		}

		return port_dict

	def add_memory(self, name, width, depth):

		data = []

		for i in range(depth):
			
			position = {
				'value':0,
				'min_value':0,
				'max_value': 2 ** int(width) -1,
			}

			data.append(position)

		memory = {
			'name': name,
			"data": data
		}

		self.memories.append(memory)


	def generate_random_inputs(self):

		opcodes = [3, 15, 19, 23, 35, 51, 55, 99, 103, 111, 115]
		funct3 = [i for i in range(8)]
		funct7 = [0, 32]
		reset, p_reset = [0, 1], [0.99, 0.01]

		random_inputs = {}

		for port in self.inputs:

			name = port["name"]
			
			if port["restricted"] == None:
				value = randint(port["min_value"], port["max_value"])

			elif port["restricted"] == "OPCODE":
				value = choice(opcodes)

			elif port["restricted"] == "FUNCT3":
				value = choice(funct3)

			elif port["restricted"] == "FUNCT7":
				value = choice(funct7)

			elif port["restricted"] == "RESET":
				value = choice(reset, p=p_reset)

			# Appends value to file
			random_inputs[name] = value

		return random_inputs


	def __str__(self):
		return self.name


	def __repr__(self):
		return self.name


class PC_CALC(Module):
	""" Class that represents the PC_CALC module from Core101. """
	
	def __init__(self):

		# Initializes parent class
		Module.__init__(self, "PC_CALC")

		# Adds inputs to module
		self.add_input("correction_en", 1)
		self.add_input("prediction_en", 1)
		self.add_input("current_addr", 32)
		self.add_input("correction_addr", 32)
		self.add_input("prediction_addr", 32)

		# Adds outputs to module
		self.add_output("prediction_flag", 1)
		self.add_output("pc_addr", 32)

	
	def execute(self, inputs):
		""" Defines the behaviour of PC_CALC modules.
		
		Args:
			inputs (dict): dictionary with values for inputs.
			
		Returns:
			dict: dictionary with values for outputs
		
		"""
		
		# Gets enable signals from list
		pred_en, corr_en = inputs["prediction_en"], inputs["correction_en"]
		
		# Defines address output and flag calculation
		if (pred_en and corr_en):
			pc_address = inputs["correction_addr"]
			is_prediction = 0
			
		elif (pred_en and not corr_en):
			pc_address = inputs["prediction_addr"]
			is_prediction = 1
		
		elif (not pred_en and corr_en):
			pc_address = inputs["correction_addr"]
			is_prediction = 0
			
		else:
			pc_address = inputs["current_addr"] + 4
			is_prediction = 0
		
		# Adds outputs to dictionary
		outputs = {
			"prediction_flag":is_prediction,
			"pc_addr":pc_address
		}

		# Returns outputs
		return outputs


class PREDICTOR(Module):

	def __init__(self):

		# Initalizes parent class
		Module.__init__(self, "PREDICTOR")

		self.add_input("predictor_reset_in", 1, "RESET")

		self.add_input("predictor_pred_addr_in", 32)
		self.add_output("predictor_pred_enable_out", 1)
		self.add_output("predictor_pred_addr_out", 32)

		self.add_input("predictor_feedback_result_in", 1)
		self.add_input("predictor_feedback_write_enable_in", 1)
		self.add_input("predictor_feedback_addr_in", 32)
		self.add_input("predictor_feedback_return_in", 32)

		self.add_memory("return_stack", 34, 16)


	def execute(self, inputs):

		# Prediction inference
		indx = int(bin(inputs["predictor_pred_addr_in"])[2:][-10:], 2)

		# Retrieves data from memory
		value = bin(self.memories[0]["data"][indx]['value'])[2:].zfill(34)

		# Gets prediction bits and return address
		pred_bit = int(value[0], 2)
		pred_addr = int(value[-32:], 2)

		if bool(inputs["predictor_reset_in"]):
			for i in range(16):
				self.memories[0]["data"][i]["value"] = 0

		# Feedback interface
		if bool(inputs["predictor_feedback_write_enable_in"]):

			# Gets index value
			indx = int(bin(inputs["predictor_feedback_addr_in"])[2:][-4:], 2)

			# Retrieves mem status bits
			value = bin(self.memories[0]["data"][indx]['value'])[2:].zfill(34)

			# Gets prediction bits from memory
			pred_bits = int(value[:2], 2)

			# Updates prediction bits
			if pred_bits == 0:
				if bool(inputs["predictor_feedback_result_in"]):
					new_val = 1
				else:
					new_val = 0

			if pred_bits == 1:
				if bool(inputs["predictor_feedback_result_in"]):
					new_val = 3
				else:
					new_val = 0

			if pred_bits == 2:
				if bool(inputs["predictor_feedback_result_in"]):
					new_val = 3
				else:
					new_val = 0

			if pred_bits == 3:
				if bool(inputs["predictor_feedback_result_in"]):
					new_val = 3
				else:
					new_val = 2

			# converts new val to bin
			new_val = bin(new_val)[2:].zfill(2)

			# Updates return address
			new_addr = bin(inputs["predictor_feedback_return_in"])[2:].zfill(32)

			# Creates new value 
			upd = int(new_val + new_addr, 2)

			# Stores on memory
			self.memories[0]["data"][indx]['value'] = upd
			
		outputs = {
			"predictor_pred_enable_out":pred_bit,
			'predictor_pred_addr_out':pred_addr
		}

		return outputs


class PREDICTOR_CHECK(Module):

	def __init__(self):

		Module.__init__(self, "PREDICTOR_CHECK")

		self.add_input("pred_in", 1)
		self.add_input("self_pred_in", 1)
		self.add_input("opcode_in", 7, "OPCODE")
		self.add_input("pc_in", 32)

		self.add_output("correction_out", 1)
		self.add_output("target_out", 32)


	def execute(self, inputs):

		pred = bool(inputs["pred_in"])
		self_pred = bool(inputs["self_pred_in"])
		opcode_in = int(inputs["opcode_in"])

		pc_in = inputs["pc_in"]

		if pred and self_pred:

			if opcode_in in [99, 103, 111]:
				correction_out = 0
			
			else:
				correction_out = 1

		else:
			correction_out = 0

		# Always assigns output as PC INC
		target_out = pc_in + 4

		outputs = {
			"correction_out":correction_out,
			"target_out":target_out
		}

		return outputs


class IMM_GEN(Module):

	def __init__(self):

		# Initalizes parent class
		Module.__init__(self, "IMM_GEN")

		# Adds inputs to module
		self.add_input("opcode_in", 7, "OPCODE")
		self.add_input("instruction_in", 25)

		# Adds output to module
		self.add_output("immediate_out", 32)


	def execute(self, inputs):
		""" Defines the behaviour of IMM_GEN modules.
		
		Args:
			inputs (dict): dictionary with values for inputs.
			
		Returns:
			dict: dictionary with values for outputs
		
		"""

		# Retrieves opcode from inputs
		opcode = inputs["opcode_in"]

		# Converts instruction (w/o opcode) to binary for bit manipulation
		bin_ins = bin(int(inputs["instruction_in"]))[2:].zfill(25)

		# Depending on opcode, the IMM_VALUE is generated.
		if opcode in [3, 19, 103]:

			# Creates sign extension for I instruction format
			sign_extension = ""

			# Generates bits for sign extension length
			for i in range(21):
			 	sign_extension += bin_ins[0]

			# Retrieves value from binary instruction
			value = bin_ins[25-24:25-13]

			# Generates immediate 
			imm_str = sign_extension + value

		elif opcode in [35]:

			# Creates sign extension for S instruction format
			sign_extension = ""

			for i in range(21):
				sign_extension += bin_ins[0]

			# Retrieves value from binary instruction
			value0 = bin_ins[1:7]
			value1 = bin_ins[20:]

			# Generates immediate 
			imm_str = sign_extension + value0 + value1

		elif opcode in [99]:

			# Creates sign extension for B instruction format
			sign_extension = ""

			for i in range(20):
				sign_extension += bin_ins[0]

			# Retrieves value from binary instruction
			value0 = bin_ins[24]
			value1 = bin_ins[1:7]
			value2 = bin_ins[20:24]

			# Generates immediate 
			imm_str = sign_extension + value0 + value1 + value2 + '0'


		elif opcode in [23, 55]:

			# Creates sign extension for U instruction format
			value = bin_ins[0:25-5]

			z_fill = ""

			for i in range(12):
				z_fill += '0'

			# 
			imm_str = value + z_fill

		elif opcode in [111]:

			# Creates sign extension for J instruction format
			sign_extension = ""

			for i in range(12):
				sign_extension += bin_ins[0]

			# Retrieves value from binary instruction
			value0 = bin_ins[12:20] # 8
			value1 = bin_ins[11]	# 1
			value2 = bin_ins[1:11]  # 10

			# Generates immediate 
			imm_str = sign_extension + value0 + value1 + value2 + '0'

		else:

			# Default immediate is zero
			imm_str = ""

			# R instruction format
			for i in range(32):

				imm_str += '0'

		imm_value = int(imm_str, 2)

		# Adds output to dictionary
		outputs = {
			"immediate_out": imm_value
		}

		# Returns outputs
		return outputs


class FORWARDING_UNIT(Module):
	
	def __init__(self):

		Module.__init__(self, "FORWARDING_UNIT")

		self.add_input("fwd_if_ra_addr_in", 5)
		self.add_input("fwd_if_rb_addr_in", 5)
		self.add_input("fwd_id_rd_addr_in", 5)

		self.add_output("fwd_mux_sel_out", 2)


	def execute(self, inputs):

		ra = inputs["fwd_if_ra_addr_in"] 
		rb = inputs["fwd_if_rb_addr_in"]
		rd = inputs["fwd_id_rd_addr_in"]
		
		sel = ""

		if rb != 0:
			sel += str(int(rb == rd))
		
		if ra != 0:
			sel += str(int(ra == rd))

		outputs = {
			"fwd_mux_sel_out":sel
		}

		return outputs


class DECODER(Module):

	def __init__(self):

		Module.__init__(self, "DECODER")

		self.add_input("dec_opcode_in", 7, "OPCODE")
		self.add_input("dec_funct3_in", 3, "FUNCT3")
		self.add_input("dec_funct7_in", 7, "FUNCT7")

		self.add_output("dec_imm_mux_sel_out", 1)
		self.add_output("dec_pc_mux_sel_out", 1)
		self.add_output("dec_rd_write_enable_out", 1)
		self.add_output("dec_rd_data_sel_out", 1)
		self.add_output("dec_jump_sel_out", 1)
		self.add_output("dec_invalid_ins_exception", 1)
		self.add_output("dec_exec_unit_sel_out", 4)
		self.add_output("dec_exec_unit_uop_out", 4)

	def execute(self, inputs):
		
		opcode = inputs["dec_opcode_in"]
		funct3 = inputs["dec_funct3_in"]
		funct7 = inputs["dec_funct7_in"]

		# Defines invalid instruction flag
		invalid_ins = 0

		# Execution unit selection. INT unit = 1
		if opcode in [15, 19, 23, 51, 55, 115]:
			exec_unit = 1
		# BRU = 2
		elif opcode in [99, 103, 111]:
			exec_unit = 2
		# LSU = 4
		elif opcode in [3, 35]:
			exec_unit = 4
		else:
			exec_unit = 0
			invalid_ins = 1

		# UOP Generation
		if opcode == 3: # LOAD
			if funct3 == 0:
				exec_uop = 0
			elif funct3 == 1:
				exec_uop = 1
			elif funct3 == 2:
				exec_uop = 2
			elif funct3 == 4:
				exec_uop = 4
			elif funct3 == 5:
				exec_uop = 5
			else:
				exec_uop = 15

		elif opcode == 15:	# MISC-MEM (FENCE as NOP)
			exec_uop = 8

		elif opcode == 19:	# OP-IMM
			if funct3 == 0:
				exec_uop = 0
			elif funct3 == 1:
				exec_uop = 15
			elif funct3 == 2:
				exec_uop = 10
			elif funct3 == 3:
				exec_uop = 11
			elif funct3 == 4:
				exec_uop = 4
			elif funct3 == 5:
				if funct7 == 0:
					exec_uop = 14
				else:
					exec_uop = 13
			elif funct3 == 6:
				exec_uop = 2
			elif funct3 == 7:
				exec_uop = 3

		elif opcode == 23:	# AUIPC
			exec_uop = 0

		elif opcode == 35: # STORE
			if funct3 == 0:
				exec_uop = 8

			elif funct3 == 1:
				exec_uop = 9

			elif funct3 == 2:
				exec_uop = 10

			else:
				exec_uop = 15

		elif opcode == 51:	# OP
			if funct3 == 0:
				if funct7 == 0:
					exec_uop = 0
				else:
					exec_uop = 1
			elif funct3 == 1:
				exec_uop = 15
			elif funct3 == 2:
				exec_uop = 10
			elif funct3 == 3:
				exec_uop = 11
			elif funct3 == 4:
				exec_uop = 4
			elif funct3 == 5:
				if funct7 == 0:
					exec_uop = 14
				else:
					exec_uop = 13
			elif funct3 == 6:
				exec_uop = 2
			elif funct3 == 7:
				exec_uop = 3

		elif opcode == 55:	# LUI
			exec_uop = 9

		elif opcode == 99:	# BRANCH
			if funct3 == 0:
				exec_uop = 0
			elif funct3 == 1:
				exec_uop = 1
			elif funct3 == 4:
				exec_uop = 2
			elif funct3 == 5:
				exec_uop = 3
			elif funct3 == 6:
				exec_uop = 6
			elif funct3 == 7:
				exec_uop = 7
			else:
				exec_uop = 15

		elif opcode == 103:	# JALR
			exec_uop = 9

		elif opcode == 111:	# JAL
			exec_uop = 8

		elif opcode == 115:
			exec_uop = 8

		# Will use PC value?
		if opcode in [23, 111]:
			pc_enable = 1
		else:
			pc_enable = 0

		# Will use IMM value?
		if opcode in [3, 19, 23, 35, 55, 103, 111]:
			imm_enable = 1
		else:
			imm_enable = 0

		# Will write on register?
		if opcode in [3, 19, 23, 51, 55, 103, 111]:
			reg_enable = 1
		else:
			reg_enable = 0

		# Will write PC+4 on register or data?
		if opcode in [103, 111]:
			rd_sel = 1
		else:
			rd_sel = 0

		# Is it a jump?
		if opcode in [103, 111]:
			jump_sel = 1
		else:
			jump_sel = 0

		# Defines outputs dictionary
		outputs = {
			"dec_imm_mux_sel_out":imm_enable,
			"dec_pc_mux_sel_out":pc_enable,
			"dec_rd_write_enable_out":reg_enable,
			"dec_rd_data_sel_out":rd_sel,
			"dec_jump_sel_out":jump_sel,
			"dec_invalid_ins_exception":invalid_ins,
			"dec_exec_unit_sel_out": exec_unit,
			"dec_exec_unit_uop_out":exec_uop
		}

		# Returns outputs
		return outputs


class REGISTERS(Module):

	def __init__(self):

		Module.__init__(self, "REGISTERS")

		self.add_input("gpr_reset_in", 1)
		
		self.add_input("gpr_write_enable_in", 1)
		self.add_input("gpr_rd_data_in", 32)
		self.add_input("gpr_rd_addr_in", 5)

		self.add_input("gpr_rs1_addr_in", 5)
		self.add_input("gpr_rs2_addr_in", 5)

		self.add_output("gpr_rs1_data_out", 32)
		self.add_output("gpr_rs2_data_out", 32)

		self.add_memory("gpr", 32, 32)


	def execute(self, inputs):

		# Retrieves addresses from inputs
		rs1_addr, rs2_addr = inputs["gpr_rs1_addr_in"], inputs["gpr_rs2_addr_in"]

		# Reads data from memory
		rs1_data = self.memories[0]['data'][rs1_addr]
		rs2_data = self.memories[0]['data'][rs2_addr]

		# Writes data on registers if necessary
		if bool(inputs["gpr_write_enable_in"]) and inputs["gpr_rd_addr_in"] != 0:

			self.memories[0]["data"][inputs["gpr_rd_addr_in"]] = inputs["gpr_rd_data_in"]

		# Assigns outputs
		outputs = {
			"gpr_rs1_data_out":rs1_data,
			"gpr_rs2_data_out":rs2_data
		}

		return outputs



class ISSUE(Module):


	def __init__(self):

		Module.__init__(self, "ISSUE")

		self.add_input("exec_unit_sel_in", 4)
		self.add_input("exec_unit_uop_in", 4)

		self.add_output("int_enable_out", 1)
		self.add_output("vec_enable_out", 1)
		self.add_output("bru_enable_out", 1)
		self.add_output("lsu_enable_out", 1)

		self.add_output("int_uop_out", 4)
		self.add_output("vec_uop_out", 4)
		self.add_output("bru_uop_out", 4)
		self.add_output("lsu_uop_out", 4)


	def execute(self, inputs):

		exec_unit_sel = inputs["exec_unit_sel_in"]
		exec_unit_uop = inputs["exec_unit_uop_in"]

		# INT
		if exec_unit_sel == 1:
			int_enable_out = 1
			vec_enable_out = 0
			bru_enable_out = 0
			lsu_enable_out = 0

			int_uop_out = exec_unit_uop
			vec_uop_out = 0
			bru_uop_out = 0
			lsu_uop_out = 0

		# BRU
		elif exec_unit_sel == 2:
			int_enable_out = 0
			vec_enable_out = 0
			bru_enable_out = 1
			lsu_enable_out = 0

			int_uop_out = 0
			vec_uop_out = 0
			bru_uop_out = exec_unit_uop
			lsu_uop_out = 0

		# LSU
		elif exec_unit_sel == 4:
			int_enable_out = 0
			vec_enable_out = 0
			bru_enable_out = 0
			lsu_enable_out = 1

			int_uop_out = 0
			vec_uop_out = 0
			bru_uop_out = 0
			lsu_uop_out = exec_unit_uop

		# VEC
		elif exec_unit_sel == 8:
			int_enable_out = 0
			vec_enable_out = 1
			bru_enable_out = 0
			lsu_enable_out = 0

			int_uop_out = 0
			vec_uop_out = exec_unit_uop
			bru_uop_out = 0
			lsu_uop_out = 0

		# Assigns outputs
		outputs = {
			"int_enable_out":int_enable_out,
			"vec_enable_out":vec_enable_out,
			"bru_enable_out":bru_enable_out,
			"lsu_enable_out":lsu_enable_out,
			"int_uop_out":int_uop_out,
			"vec_uop_out":vec_uop_out,
			"bru_uop_out":bru_uop_out,
			"lsu_uop_out":lsu_uop_out
		}

		return outputs


class BRU(Module):

	def __init__(self):

		Module.__init__(self, "BRU")

		self.add_input("bru_enable_in", 1)
		self.add_input("bru_prediction_in", 1)
		self.add_input("bru_uop_in", 4)
		self.add_input("bru_pc_in", 32)
		self.add_input("bru_rs1_in", 32)
		self.add_input("bru_rs2_in", 32)
		self.add_input("bru_imm_in", 32)

		self.add_output("bru_correction_out", 1)
		self.add_output("bru_target_out", 1)

		self.add_output("bru_fb_result_out", 1)
		self.add_output("bru_fb_write_en_out", 1)


	def execute(self, inputs):

		uop = inputs["bru_uop_in"]
		pred = inputs["bru_prediction_in"]
		enable = bool(inputs["bru_enable_in"])
		immediate, pc = inputs["bru_imm_in"], inputs["bru_pc_in"]
		rs1, rs2 = inputs["bru_rs1_in"], inputs["bru_rs2_in"]
		rs1_s, rs2_s = c_int32(rs1).value, c_int32(rs2).value

		if enable:
			
			# BEQ
			if uop == 0:
				result = (rs1 == rs2)

			# BNE
			elif uop == 1:
				result = (rs1 != rs2)

			# BLT
			elif uop == 2:
				result = (rs1_s < rs2_s)

			# BGE
			elif uop == 3:
				result = (rs1_s >= rs2_s)

			# BLTU
			elif uop == 6:
				result = (rs1 < rs2)

			# BGEU
			elif uop == 7:
				result = (rs1 >= rs2)

			# JAL or JALR
			elif uop in [8, 9]:
				result = True

			else:
				result = False

			# Effective address calculation
			if result:
				if uop == 9:
					address = rs1 + immediate
				else:
					address = pc + immediate

			else:
				address = pc + 4

			# Correction signal
			correction = not(pred and result)

			# Feedback write enable
			write_en = 1


		# If module is not enabled, signals are not driven
		else:
			correction = 0
			address = 0
			result = 0
			write_en = 0

		# Assigns outputs
		outputs = {
			"bru_correction_out": int(correction),
			"bru_target_out": int(address),
			"bru_fb_result_out": int(result),
			"bru_fb_write_en_out": int(write_en)
		}

		# Returns outputs
		return outputs


class ALU(Module):

	def __init__(self):

		Module.__init__(self, "ALU")

		self.add_input("a_input_in", 32)
		self.add_input("b_input_in", 32)
		self.add_input("uop_in", 4)

		self.add_output("result_out", 32)

		
	def execute(self, inputs):

		uop = inputs["uop_in"]
		op_a, op_b = inputs["a_input_in"], inputs["b_input_in"]


		# ADD
		if uop == 0:
			result = op_a + op_b

		# SUB
		elif uop == 1:
			result = op_a - op_b

		# OR
		elif uop == 2:
			result = op_a | op_b

		# AND
		elif uop == 3:
			result = op_a & op_b

		# XOR
		elif uop == 4:
			result = op_a ^ op_b

		# BUFFER RS1
		elif uop == 8:
			result = op_a

		# BUFFER RS2
		elif uop == 9:
			result = op_b

		# SLT
		elif uop == 10:

			op_a = c_int32(op_a).value
			op_b = c_int32(op_b).value

			if(op_a < op_b):
				result = 1
			else:
				result = 0 

		# SLTU 
		elif uop == 11:

			if(op_a < op_b):
				result = 1
			else:
				result = 0 

		# SRA
		elif uop == 13:
			result = op_a >> (op_b & 31)

		# SRL
		elif uop == 14:
			result = op_a >> (op_b & 31)

		# SLL
		elif uop == 15:
			result = op_a << (op_b & 31)

		# Default logic is buffer A input
		else:
			result = op_a

		# Assigns outputs
		outputs = {
			"result_out":result
		}

		return outputs


class LSU(Module):

	def __init__(self):

		Module.__init__(self, "LSU")

		self.add_input("lsu_enable_in", 1)
		self.add_input("lsu_uop_in", 4)
		self.add_input("lsu_a_data_in", 32)
		self.add_input("lsu_b_data_in", 32)
		self.add_input("lsu_c_data_in", 32)
		self.add_input("lsu_mem_data_in", 32)

		self.add_output("lsu_mem_valid_out", 1)
		self.add_output("lsu_mem_opcode_out", 3)
		self.add_output("lsu_mem_addr_out", 32)
		self.add_output("lsu_mem_data_out", 32)
		self.add_output("lsu_result_out", 32)


	def execute(self, inputs):

		enable = bool(inputs["lsu_enable_in"])
		data_in = inputs["lsu_a_data_in"]
		base, imm = inputs["lsu_b_data_in"], inputs["lsu_c_data_in"]
		opcode_in = bin(inputs["lsu_uop_in"])[2:].zfill(4)

		# Effective address calculation
		addr_out = base + imm

		# Data output bus
		data_out = data_in

		# If module is enabled 
		if enable:

			# Enables valid signal
			valid_out = 1

			# Selects opcode based on module opcode
			if opcode_in[0] == '0': # LOAD

				# Checks if unsigend
				if opcode_in[1] == '1':

					if int(opcode_in[2:]) == 0: # Byte
						result_out = int(bin(data_in)[-8:].zfill(32), 2)

					else: # Halfword
						result_out = int(bin(data_in)[-16:].zfill(32), 2)

				else:

					# Checks data length
					if int(opcode_in[2:]) == 0: # Byte
						# Checks sign
						if bin(data_in)[-8] == '1':
							fill = 0xFFFFFF00
						else:
							fill = 0

						result_out = int(bin(data_in)[-8:]) + fill


					elif int(opcode_in[2:]) == 1: # Halfword
						# Checks sign
						if bin(data_in)[-8] == '1':
							fill = 0xFFFF0000
						else:
							fill = 0

						result_out = int(bin(data_in)[-16:]) + fill

					else:
						result_out = data_in


			else:	# STORE
				opcode_out = int(opcode_in[2:]) + 4

		# If module is not enabled
		else:
			valid_out = 0
			opcode_out = 0
			result_out = 0

		# Assigns outputs
		outputs = {
			"lsu_mem_valid_out":int(valid_out),
			"lsu_mem_opcode_out":int(opcode_out),
			"lsu_mem_addr_out":int(opcode_out),
			"lsu_mem_data_out":int(data_out),
			"lsu_result_out":int(result_out)
		}

		return outputs


class PIPELINE_CONTROL(Module):

	def __init__(self):

		Module.__init__(self, "PIPELINE_CONTROL")

		# Reset input
		self.add_input("reset_in", 1, "RESET")

		# Correction flags
		self.add_input("bru_correction_flag", 1)
		self.add_input("check_correction_flag", 1)

		# Instruction memory interface
		self.add_output("ins_mem_valid_out", 1)
		self.add_input("ins_mem_ready_in", 1)

		# Data memory interface
		self.add_input("data_mem_valid_in", 1)
		self.add_input("data_mem_ready_in", 1)

		# Exceptions
		self.add_input("invalid_ins_exception_in", 1)

		# Pipeline registers set
		self.add_output("pc_if_set_out", 1)
		self.add_output("if_dec_set_out", 1)
		self.add_output("dec_reg_set_out", 1)
		self.add_output("reg_ex_set_out", 1)
		self.add_output("ex_wb_set_out", 1)

		# Pipeline registers clear
		self.add_output("pc_if_clear_out", 1)
		self.add_output("if_dec_clear_out", 1)
		self.add_output("dec_reg_clear_out", 1)
		self.add_output("reg_ex_clear_out", 1)
		self.add_output("ex_wb_clear_out", 1)

		# State variable for ins memory status
		self.ins_mem = 0


	def execute(self, inputs):

		reset_in = inputs["reset_in"]

		bru_flag = inputs["bru_correction_flag"]
		check_flag = inputs["check_correction_flag"]

		ins_mem_ready_in = inputs["ins_mem_ready_in"]

		data_mem_ready_in = inputs["data_mem_ready_in"]
		data_mem_valid_in = inputs["data_mem_valid_in"]

		invalid_ins = inputs["invalid_ins_exception_in"]

		if self.ins_mem == 2:
			ins_mem_valid = 0
		else:
			ins_mem_valid = 1

		# Creates a correction status value
		correction_status = bru_flag * 2 + check_flag

		# Clears pipeline according to correction status
		if correction_status == 0:
			pc_if_clear = 0
			if_dec_clear = 0
			dec_reg_clear = 0
			reg_ex_clear = 0
			ex_wb_clear = 0

		elif correction_status == 1:
			pc_if_clear = 0
			if_dec_clear = 1
			dec_reg_clear = 0
			reg_ex_clear = 0
			ex_wb_clear = 0

		elif correction_status == 2:
			pc_if_clear = 0
			if_dec_clear = 1
			dec_reg_clear = 1
			reg_ex_clear = 1
			ex_wb_clear = 0

		else:
			pc_if_clear = 0
			if_dec_clear = 1
			dec_reg_clear = 1
			reg_ex_clear = 1
			ex_wb_clear = 0

		# Stalls pipeline if data memory has a problem
		data_mem_status = data_mem_ready_in * 2 + data_mem_valid_in

		if data_mem_valid_in == 1 and data_mem_ready_in == 0:
			pc_if_set = 0
			if_dec_set = 0
			dec_reg_set = 0
			reg_ex_set = 0
			ex_wb_set = 0

		else:
			pc_if_set = 1
			if_dec_set = 1
			dec_reg_set = 1
			reg_ex_set = 1
			ex_wb_set = 1



		if reset_in == 1:
			self.ins_mem = 0
		
		else:

			# Updates ins mem status
			if self.ins_mem == 0:
				if ins_mem_ready_in == 1:
					self.ins_mem = 0
				else:
					self.ins_mem = 1

			elif self.ins_mem == 1:
				if ins_mem_ready_in == 1:
					self.ins_mem = 0
				elif correction_status != 0:
					self.ins_mem = 2
				else:
					self.ins_mem = 1

			elif self.ins_mem == 2:
				self.ins_mem = 0

			else:
				self.ins_mem = 1

		outputs = {
			"ins_mem_valid_out":ins_mem_valid,
			"pc_if_set_out":pc_if_set,
			"if_dec_set_out":if_dec_set,
			"dec_reg_set_out":dec_reg_set,
			"reg_ex_set_out":reg_ex_set,
			"ex_wb_set_out":ex_wb_set,
			"pc_if_clear_out":pc_if_clear,
			"if_dec_clear_out":if_dec_clear,
			"dec_reg_clear_out":dec_reg_clear,
			"reg_ex_clear_out":reg_ex_clear,
			"ex_wb_clear_out":ex_wb_clear
		}

		return outputs

