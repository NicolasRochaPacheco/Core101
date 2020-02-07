// Core101 instruction fetch unit module definition
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
	
	// Clock and reset input
	input ifu_clock_in,
	input ifu_reset_in,

	// Data inputs
	input [31:0] pc_upd_addr_in,
	input [31:0] pc_offset_in,

	// Control inputs
	input pc_set_ctrl_in,
	input [1:0] pc_src_mux_ctrl_in,
	input ins_mem_valid_ctrl_in,
	input ir_set_ctrl_in,

	// Data outputs
	output [31:0] pc_stored_val_out,
	output [31:0] ir_stored_val_out,

	// Control outputs
	output ins_mem_ready_out,
	output ins_mem_hit_out

);

//-----------------------------------------------
//  WIRE DEFINITION
//-----------------------------------------------
wire [31:0] pc_offset_adder_wire;
wire [31:0] pc_inc_adder_wire;
wire [31:0] pc_src_mux_wire;
wire [31:0] pc_stored_val_wire;
wire [31:0] ins_mem_fetched_ins_wire;


//-----------------------------------------------
//  MODULES INSTANTIATION
//-----------------------------------------------
ADDER #(.DATA_WIDTH(32)) offset_adder (
	.a_operand_in(),
	.b_operand_in(),
	.add_result_out()
);

ADDER #(.DATA_WIDTH(32)) inc_adder (
	.a_operand_in(),
	.b_operand_in(),
	.add_result_out()
);

MUX_B #(.DATA_WIDTH(32)) pc_src_mux (
	.a_data_src_in(),
	.b_data_src_in(),
	.c_data_src_in(),
	.d_data_src_in(),
	.data_sel_in(),
	.data_out(),
);

REG #(.DATA_WIDTH(32)) pc (
	.clock_in(),
	.reset_in()
	.set_in(),
	.data_in(),
	.data_out()
);

REG #(.DATA_WIDTH(32)) ir (
	.clock_in(),
	.reset_in()
	.set_in(),
	.data_in(),
	.data_out()
);

CACHE #(.DATA_WIDTH(32)) ins_cache (
	.valid_in(),
	.addr_in(),
	.hit_out(),
	.ready_out(),
	.data_out()
);


//-----------------------------------------------
// OUTPUT LOGIC
//-----------------------------------------------

endmodule
