
import csv
import sys
import numpy as np
from argparse import ArgumentParser 

from modules import *


def dump_to_file(name, array, is_csv_file=True):

	prefix = "./out/"

	if is_csv_file:
		_file_name = prefix + name + ".csv"
		_sep = ','
	else:
		_file_name = prefix + name + ".txt"
		_sep = ' '

	_writer = csv.writer(open(_file_name, 'w'), delimiter=_sep)

	if is_csv_file:
		_writer.writerow(list(array[0].keys()))

	for array_dict in array:

		_writer.writerow(list(array_dict.values()))


def run_testbench(module_name, number):

	# Defines module dictionary
	modules_dict = {
		"PC_CALC": PC_CALC(),
		"PRED": PREDICTOR(),
		"IMM_GEN": IMM_GEN(),
		"DEC": DECODER(),
		"FWD": FORWARDING_UNIT(),
		"REG": REGISTERS(),
		"IS": ISSUE(),
		"BRU": BRANCH_RESOLVER(),
		"ALU": ALU(),
		"LSU": LSU()
	}

	# Tries to get module from dictionary
	try:
		module = modules_dict[module_name]

	# If module with given name is not found, then a message is shown and program exits
	except KeyError as e:
		print("There is no module with name: {}. Valid module names are: {}".format(module, list(modules_dict.keys())))
		sys.exit()

	# Creates lists to store inputs and outputs
	inputs, outputs = [], []

	# Iterates over number of tests
	for n in range(number):
		
		# Generates random inputs
		_in = module.generate_random_inputs()
		
		# Calculates outputs based on random inputs
		_out = module.execute(_in)

		# Stores inputs and outputs
		inputs.append(_in)
		outputs.append(_out)

	# Dumps values to file
	dump_to_file(module_name + "_inputs", inputs, False)
	dump_to_file(module_name + "_outputs", outputs, False)


if __name__ == "__main__":

	# Defines argument parser
	_parser = ArgumentParser(description="A program to generate Core101 modules golden files.")

	# Adds required aruments group
	_required = _parser.add_argument_group("Required arguments")

	_required.add_argument(
		"-m",
		"--module", 
		help="Name of the module that will be tested",
		type=str,
		required=True
	)

	_required.add_argument(
		"-n",
		"--number", 
		help="Number of random test executed on module",
		type=int,
		required=True
	)

	args = _parser.parse_args()

	run_testbench(args.module, args.number)