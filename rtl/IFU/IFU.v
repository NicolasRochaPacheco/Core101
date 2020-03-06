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
	// Clock and reset signal inputs
	input ifu_clock_in,
	input ifu_reset_in,

	// Program counter data inputs
  input [31:0] pc_addr_in,
  input [31:0] pc_offset_in,

  // Instruction register data inputs
  input [31:0] ir_data_in,

  // Program counter data output
  output [31:0] pc_addr_out,

  // Instruction register data output
  output [31:0] ir_data_out,

  // Control signals
  input pc_set_in,
  input [1:0] pc_mux_sel_in,
  input ir_set_in
);


//-----------------------------------------------
//  WIRE DEFINITION
//-----------------------------------------------
wire [31:0] pc_offset_wire; //
wire [31:0] pc_inc_wire; //
wire [31:0] pc_src_wire; //
wire [31:0] pc_addr_wire; //


//-----------------------------------------------
//  MODULES INSTANTIATION
//-----------------------------------------------
ADDER #(.DATA_WIDTH(32)) offset_adder (
	// Data inputs
	.a_operand_in(pc_offset_in),
	.b_operand_in(pc_addr_wire),

	// Data outputs
	.add_result_out(pc_offset_wire)
);

ADDER #(.DATA_WIDTH(32)) inc_adder (
	// Data inputs
	.a_operand_in(32'h00000004),
	.b_operand_in(pc_addr_wire),

	// Data outputs
	.add_result_out(pc_inc_wire)
);

MUX_B #(.DATA_WIDTH(32)) pc_src_mux (
	// Data inputs
	.a_data_src_in(pc_addr_in),
	.b_data_src_in(pc_offset_wire),
	.c_data_src_in(pc_inc_wire),
	.d_data_src_in(32'h00000000),

	// Control inputs
	.data_sel_in(pc_mux_sel_in),

	// Data outputs
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
	.data_out(ir_data_out)
);

assign pc_addr_out = pc_addr_wire;

//-----------------------------------------------
// OUTPUT LOGIC
//-----------------------------------------------


endmodule // IFU
