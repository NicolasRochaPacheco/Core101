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
	input ifu_clock_in, 				// Clock signal input
	input ifu_reset_in,					// Reset signal input
	input pc_set_in,						// PC set input
	input ir_set_in,						// IR set input
	input pc_mux_sel_in,				// PC mux selection signal input
	input pc_branch_sel_in,			// PC branch MUX selection signal
	input [31:0] pc_branch_in,	// PC branch input data
  input [31:0] pc_addr_in,		// PC data input for jumps
  input [31:0] ir_data_in,		// Instruction register data inputs
  output [31:0] pc_addr_out,	// Program counter data output
  output [31:0] ir_data_out 	// Instruction register data output
);

//-----------------------------------------------
//  WIRE DEFINITION
//-----------------------------------------------
wire [31:0] pc_inc_wire; //
wire [31:0] pc_branch_mux_wire;
wire [31:0] pc_src_wire; //
wire [31:0] pc_addr_wire; //
wire [31:0] ir_data_wire;

//-----------------------------------------------
//  MODULES INSTANTIATION
//-----------------------------------------------
ADDER #(.DATA_WIDTH(32)) inc_adder (
	// Data inputs
	.a_operand_in(32'h00000004),
	.b_operand_in(pc_addr_wire),

	// Data outputs
	.add_result_out(pc_inc_wire)
);

MUX_A #(.DATA_WIDTH(32)) pc_src_mux (
	// Data inputs
	.a_data_src_in(pc_inc_wire),
	.b_data_src_in(pc_addr_in),

	// Control inputs
	.data_sel_in(pc_mux_sel_in),

	// Data outputs
	.data_out(pc_branch_mux_wire)
);

MUX_A #(.DATA_WIDTH(32)) branch_sel_mux (
	.a_data_src_in(pc_branch_mux_wire),
	.b_data_src_in(pc_branch_in),
	.data_sel_in(pc_branch_sel_in),
	.data_out(pc_src_wire)
);

REG #(.DATA_WIDTH(32)) pc (
	// Clock and reset inputs
	.clock_in(ifu_clock_in),
	.reset_in(ifu_reset_in),

	// Data inputs
	.data_in(pc_src_wire),
	.set_in(pc_set_in),

	// Data outputs
	.data_out(pc_addr_wire)
);

REG_NEG #(.DATA_WIDTH(32)) ir (
	// Clock and reset inputs
	.clock_in(ifu_clock_in),
	.reset_in(ifu_reset_in),

	// Data inputs
	.data_in(ir_data_in),

	// Control inputs
	.set_in(ir_set_in),

	// Data outputs
	.data_out(ir_data_wire)
);


//-----------------------------------------------
// OUTPUT LOGIC
//-----------------------------------------------
assign pc_addr_out = pc_addr_wire;
assign ir_data_out = ir_data_wire;



endmodule // IFU
