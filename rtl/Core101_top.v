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
  output [31:0] imm_value_out,
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

// Control signals wires
wire pc_set_wire;  // PC set signal
wire ir_set_wire;  // IR set signal
wire [31:0] pc_addr_wire;  // PC new addr bus
wire [31:0] ir_data_wire;  // IR-driven data bus
wire [31:0] ins_mem_data_wire;  // $I driven data bus
wire [2:0] exec_unit_sel_wire;
wire [3:0] exec_unit_uop_wire;
wire pc_mux_sel_wire;
wire imm_mux_sel_wire;

// GPR data wires
wire [31:0] rs1_data_wire;
wire [31:0] rs2_data_wire;
wire [31:0] rd_data_wire;
wire [31:0] imm_value_wire;

// Execution unit enable wires
wire int_enable_wire;
wire vec_enable_wire;
wire lsu_enable_wire;

// uOP data wires
wire [3:0] int_uop_wire;
wire [3:0] vec_uop_wire;
wire [3:0] lsu_uop_wire;

//==============================
// INSTANCE DEFINITION
//==============================
// Main memory definition. Temporal module. Acts as the main memory
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
  // Opcodes inputs
  .opcode_in(ir_data_wire[6:2]),
  .funct3_in(ir_data_wire[14:12]),
  .funct7_in(ir_data_wire[31:25]),

  // Execution unit selection outputs
  .exec_unit_sel_out(exec_unit_sel_wire),
  .exec_unit_uop_out(exec_unit_uop_wire),

  // PC mux selection signal outputs
  .pc_mux_sel_out(pc_mux_sel_wire),

  // Immediate value mux selection signal outputs
  .imm_mux_sel_out(imm_mux_sel_wire),

  // Invalid isntruction exception signal output
  .invalid_ins_exception()
);

// Immediate value generator unit
IMM_GEN imm_gen0 (
  // OP to select the appropiate format
  .opcode_in(ir_data_wire[6:2]),

  // Instruction source values
  .instruction_in(ir_data_wire[31:7]),

  // Immediate value output
  .immediate_out(imm_value_wire)
);

// IMM VALUE MUX should be here


// PC MUX should be here

// Issue unit
ISSUE_UNIT issue0 (
  // Execution unit selection bus
  .exec_unit_sel_in(exec_unit_sel_wire),
  .exec_uop_in(exec_unit_uop_wire),

  // Current uOP requiered registers data
  //.rsa_data_in(),
  //.rsb_data_in(),
  //.rd_addr_in(),

  // Execution unit enable signals
  .int_enable_out(int_enable_wire),
  .vec_enable_out(vec_enable_wire),
  .lsu_enable_out(lsu_enable_wire),

  // Execution unit opcodes
  .int_exec_uop_out(int_uop_wire),
  .vec_exec_uop_out(vec_uop_wire),
  .lsu_exec_uop_out(lsu_uop_wire)
);


// Execution units
INT_EXEC int0 (
  .a_data_in(rs1_data_wire),
  .b_data_in(rs1_data_wire),

  .enable_in(int_enable_wire),
  .uop_in(int_uop_wire),

  .res_data_out(rd_data_wire) // Must go to a output MUX
);


// General purpose registers
GPR gpr0 (

  // Clock and reset inputs
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Registers addresses input signals
  .rs1_addr_in(ir_data_wire[19:15]),
  .rs2_addr_in(ir_data_wire[24:20]),
  .rd_addr_in(ir_data_wire[11:7]), // Directly from IR! Must be pipelined

  // Read data outputs
  .rs1_data_out(rs1_data_wire),
  .rs2_data_out(rs2_data_wire),

  // Write data output
  .rd_data_in(rd_data_wire)

);


// Output assignment
assign ins_mem_addr_out = pc_addr_wire;
assign gpr_a_out = ir_data_wire[19:15];
assign gpr_b_out = ir_data_wire[24:20];
assign gpr_rd_out = ir_data_wire[11:7];
assign ins_data_out = ir_data_wire;
assign exec_unit_sel_out = exec_unit_sel_wire;
assign imm_value_out = imm_value_wire;

// uOp codes output
assign int_uop_out = int_uop_wire;
assign vec_uop_out = vec_uop_wire;
assign lsu_uop_out = lsu_uop_wire;


endmodule
