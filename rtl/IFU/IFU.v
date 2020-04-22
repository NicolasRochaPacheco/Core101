// Core101 instruction fetch unit (IFU) module definition
// Copyright (C) 2019 Nicolas Rocha Pacheco
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


//-----------------------------------------------
//  MODULE DEFINITION
//-----------------------------------------------
module IFU (
	input ifu_clock_in, 						// Clock signal input
	input ifu_reset_in,							// Reset signal input
	input ifu_pc_set_in,						// PC set input
	input ifu_ir_set_in,						// IR set input
	input ifu_jump_sel_in,					// PC branch MUX selection signal
	input ifu_branch_sel_in,				// PC mux selection signal input
	input [31:0] ifu_jump_in,				// PC data input for jumps
	input [31:0] ifu_branch_in,			// PC branch input data
  input [31:0] ifu_ir_data_in,		// Instruction register data inputs
  output [31:0] ifu_pc_addr_out,	// Program counter data output
  output [31:0] ifu_ir_data_out 	// Instruction register data output
);

//-----------------------------------------------
//  WIRE DEFINITION
//-----------------------------------------------
wire [31:0] pc_inc_wire; 				//
wire [31:0] pc_jump_addr_wire;	//
wire [31:0] pc_src_wire; 				//
wire [31:0] pc_addr_wire; 			// Stored PC value
wire [31:0] ir_data_wire;

//-----------------------------------------------
//  MODULES INSTANTIATION
//-----------------------------------------------
// Adder increment for PC
ADDER #(.DATA_WIDTH(32)) inc_adder (
	.a_operand_in(32'h00000004),				// +4
	.b_operand_in(pc_addr_wire),				// Current PC value
	.add_result_out(pc_inc_wire)				// Data outputs
);

// 2-to-1 multiplexer
MUX_A #(.DATA_WIDTH(32)) jump_mux (
	.a_data_src_in(pc_inc_wire),				// PC inc data
	.b_data_src_in(ifu_jump_in),		// Jump address input
	.data_sel_in(ifu_jump_sel_in),	// Jump signal SEL
	.data_out(pc_jump_addr_wire)				// Selection between jump and inc
);

// 2-to-1 multiplexer
MUX_A #(.DATA_WIDTH(32)) branch_sel_mux (
	.a_data_src_in(pc_jump_addr_wire),	// Selection between jump and INC
	.b_data_src_in(ifu_branch_in),			// Branch address input
	.data_sel_in(ifu_branch_sel_in),		// Branch sel signal
	.data_out(pc_src_wire)							// Selection between jump, inc and branch
);

// PC register
REG #(.DATA_WIDTH(32)) pc (
	.clock_in(ifu_clock_in),						// Clock input for PC register
	.reset_in(ifu_reset_in),						// Reset input for PC register
	.data_in(pc_src_wire),							// Data input for PC register
	.set_in(ifu_pc_set_in),							// Set signal for PC register
	.data_out(pc_addr_wire)							// Data output for PC register
);

// IR register
REG_NEG #(.DATA_WIDTH(32)) ir (
	.clock_in(ifu_clock_in),
	.reset_in(ifu_reset_in),
	.data_in(ifu_ir_data_in),
	.set_in(ifu_ir_set_in),
	.data_out(ir_data_wire)
);

//-----------------------------------------------
// OUTPUT LOGIC
//-----------------------------------------------
assign ifu_pc_addr_out = pc_addr_wire;
assign ifu_ir_data_out = ir_data_wire;

endmodule // IFU
