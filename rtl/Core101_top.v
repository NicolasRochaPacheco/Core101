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

  // ================================================================
  // Debug_signals. Will be deprecated as the core is finished
  // ================================================================
  input halt_in,
  output [2:0] exec_unit_sel_out,
  output [4:0] gpr_a_out,
  output [4:0] gpr_b_out,
  output [4:0] gpr_rd_out,
  output [3:0] int_uop_out,
  output [3:0] vec_uop_out,
  output [3:0] lsu_uop_out,
  // ================================================================

  // Ins. mem. interface
  output [31:0] ins_mem_addr_out,
  output [31:0] ins_data_out,

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
wire [31:0] ins_mem_data_wire;

wire [2:0] exec_unit_sel_wire;
wire [3:0] exec_unit_uop_wire;

wire pc_mux_sel_wire;
wire imm_mux_sel_wire;

wire [4:0] gpr_a_wire;
wire [4:0] gpr_b_wire;
wire [4:0] gpr_rd_wire;

wire [3:0] int_uop_wire;
wire [3:0] vec_uop_wire;
wire [3:0] lsu_uop_wire;

//==============================
// INSTANCE DEFINITION
//==============================

// Main memory definition
MAIN_MEMORY mem0(
  .main_mem_addr_in(pc_addr_wire),

  .main_mem_data_out(ins_mem_data_wire)
);

// Instruction fetch unit module
IFU ifu0(
 .ifu_clock_in(clock_in),
 .ifu_reset_in(reset_in),

 .pc_addr_in(32'h00000000),
 .pc_offset_in(32'h0000008),

 .ir_data_in(ins_mem_data_wire),
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
  .opcode_in(ir_data_wire[6:2]),
  .funct3_in(ir_data_wire[14:12]),
  .funct7_in(ir_data_wire[31:25]),

  // Execution unit selection
  .exec_unit_sel_out(exec_unit_sel_wire),
  .exec_unit_uop_out(exec_unit_uop_wire),

  // PC mux selection signal
  .pc_mux_sel_out(pc_mux_sel_wire),

  // Immediate value mux selection signal
  .imm_mux_sel_out(pc_mux_sel_wire),

  // General purpose registers output
  .rs1_in(ir_data_wire[19:15]),
  .rs2_in(ir_data_wire[24:20]),
  .rd_in(ir_data_wire[11:7]),
  .dec_gpr_src_a_out(gpr_a_wire),
  .dec_gpr_src_b_out(gpr_b_wire),
  .dec_gpr_des_out(gpr_rd_wire)
);

// Issue unit
ISSUE_UNIT issue0 (
  // Execution unit selection bus
  .exec_unit_sel_in(exec_unit_sel_wire),
  .exec_uop_in(exec_unit_uop_wire),

  // Execution unit opcodes
  .int_exec_uop_out(int_uop_wire),
  .vec_exec_uop_out(vec_uop_wire),
  .lsu_exec_uop_out(lsu_uop_wire)
);

// Execution units

// General purpose registers


// Main control unit
assign ins_mem_addr_out = pc_addr_wire;
assign gpr_a_out = gpr_a_wire;
assign gpr_b_out = gpr_b_wire;
assign gpr_rd_out = gpr_rd_wire;
assign ins_data_out = ir_data_wire;
assign exec_unit_sel_out = exec_unit_sel_wire;

// uOp codes output
assign int_uop_out = int_uop_wire;
assign vec_uop_out = vec_uop_wire;
assign lsu_uop_out = lsu_uop_wire;


endmodule
