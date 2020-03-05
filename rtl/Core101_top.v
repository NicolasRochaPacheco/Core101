// Core101 top module definition
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

module Core101_top(

  // Clock and reset
  input clock_in,
  input reset_in,

  // Halt signal
  input halt_in, // Will be deprecated as the control unit is finished

  // GPR outputs
  output [4:0] gpr_a_out,
  output [4:0] gpr_b_out,

  // Ins. mem. interface
  output [31:0] ins_mem_addr_out,

  // Memory interfaces
  inout mem_addr_inout,
  inout mem_data_inout,
  output mem_read_out,
  input mem_valid_in
);

// WIRE DEFINITION
wire pc_set_wire;
wire ir_set_wire;

wire [31:0] pc_addr_wire;
wire [31:0] ir_data_wire;


wire [4:0] gpr_a_wire;
wire [4:0] gpr_b_wire;

//==============================
// INSTANCE DEFINITION
//==============================
// Instruction fetch unit module
IFU ifu0(
 .ifu_clock_in(clock_in),
 .ifu_reset_in(reset_in),

 .pc_addr_in(32'h00000000),
 .pc_offset_in(32'h0000008),

 .ir_data_in(32'h00410333),
 .pc_addr_out(pc_addr_wire),
 .ir_data_out(ir_data_wire),

 .pc_set_in(pc_set_wire),
 .pc_mux_sel_in(2'b10),
 .ir_set_in(1'b1)
);

// The IFU control unit. A state machine for enabling or halting the IFU
IFU_CONTROL ifu_ctrl0 (
  // Clock and reset signals
  .ifu_ctrl_clock_in(clock_in),
  .ifu_ctrl_reset_in(reset_in),

  // Halt signal in
  .halt_signal_in(halt_in),

  // Control signals output
  .ifu_ctrl_pc_set_out(pc_set_wire),
  .ifu_ctrl_ir_set_out(ir_set_wire)
);

// Main decode unit
DECODE_UNIT decode0 (
  .dec_ins_in(ir_data_wire),

  .dec_gpr_src_a_out(gpr_a_wire),
  .dec_gpr_src_b_out(gpr_b_wire)
);

// Main control unit

assign ins_mem_addr_out = pc_addr_wire;
assign gpr_a_out = gpr_a_wire;
assign gpr_b_out = gpr_b_wire;


endmodule
