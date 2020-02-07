// Core101 datapath module definition
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

module DATAPATH(

  // Clock and reset
  input datapath_clock_in,
  input datapath_reset_in,

  // Instruction memory interface
  input [31:0] datapath_ins_mem_data_in,
  output [63:0] datapath_ins_mem_addr_out,

  // Data memory interface
  input  [63:0] datapath_data_mem_data_in,
  output [63:0] datapath_data_mem_data_out,
  output [63:0] datapath_data_mem_addr_out,

  // Instruction fetch control signals
  input datapath_pc_set_val_in,       // PC
  input datapath_ir_set_val_in,       // IR
  input [1:0] datapath_pc_mux_sel_in, // PC mux src sel
  output datapath_ins_type_out,       // INS opcode type

  // Instruction decode control signals
  input datapath_imm_mux_src_sel_in   // IMM mux src sel

  // Execute control signals

  // Memory access control signals

  // Register writeback control signals

);

// Instruction fetch wire definition
wire [63:0] pc_update_value_wire;       // PC REG
wire [63:0] pc_stored_value_wire;
wire [63:0] pc_increment_adder_wire;    // PC SRC MUX
wire [63:0] pc_offset_adder_wire;
wire [63:0] pc_new_value_wire;
wire [63:0] pc_output_wire;
wire [31:0] ir_stored_value_wire;       // IR REG

// Instruction decode wire definition
// Execute wire definition
// Memory access wire definition
// Register writeback wire definition


//=====================================
// Instruction fetch instances
//=====================================
// Instruction register (CHECKED)
GEN_REG #(.DATA_WIDTH(32)) ir0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(datapath_ins_mem_data_in),
    .general_register_set_in(datapath_ir_set_val_in),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(ir_stored_ins_wire)
  );

// Program counter (CHECKED)
GEN_REG #(.DATA_WIDTH(64)) pc0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(pc_update_value_wire),
    .general_register_set_in(datapath_pc_set_val_in),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(pc_stored_value_wire)
  );

// PC source multiplexer (CHECKED)
GEN_MUX_4 #(.DATA_WIDTH(64)) pc_mux0 (
    .mux_four_sel_in(pc_mux_sel_in),            // From Control Unit
    .mux_four_zero_in(pc_increment_adder_wire), // PC + 4
    .mux_four_one_in(pc_offset_adder_wire),     // PC + offset
    .mux_four_two_in(pc_new_value_wire),        // PC
    .mux_four_three_in(64'h0),                  // 0 as not implemented
    .mux_output_out(pc_update_value_wire)       // To PC register
  );

// Adder for program counter increment (CHECKED)
ADDER #(.DATA_WIDTH(64)) adder_0 (
    .adder_A_data_in(pc_stored_value_wire),
    .adder_B_data_in(64'h4),
    .adder_data_out(pc_increment_adder_wire)
  );

// Adder for program counter offset increment
ADDER #(.DATA_WIDTH(64)) adder_1 (
    .adder_A_data_in(pc_stored_value_wire),
    .adder_B_data_in(<from_sign-extension_unit_imm_out>),
    .adder_data_out(pc_offset_adder_wire)
  );

//=====================================
// Instruction decode instances
//=====================================
// General purpose registers (GPR)
GPR #(.DATA_WIDTH(32)) gpr0 (
    .gpr_sel_A_in(ir_stored_ins_wire[19:15]),
    .gpr_sel_B_in(ir_stored_ins_wire[24:20]),
    .gpr_A_data_out(<TODO>),
    .gpr_B_data_out(<TODO>),
    .gpr_sel_rd_in(ir_stored_ins_wire[11:7]),
    .gpr_set_rd_in(<TODO>)
  );

// Immediate value generator unit
IMM_GEN #(.DATA_WIDTH(32)) imm_gen0 (
    .imm_gen_unit_ins_in(ir_stored_ins_wire[31:7]),
    .imm_gen_unit_type_in(ir_stored_ins_wire[6:0]),
    .imm_gen_unit_imm_out(<TODO>)
  );

// Immediate source multiplexer
GEN_MUX_2 #(.DATA_WIDTH(32)) imm_mux0 (
    .mux_two_sel_in(), // TODO
    .mux_two_zero_in(), // TODO
    .mux_two_one_in(), // TODO
    .mux_four_out() // TODO
  );

//=====================================
// Execute instances
//=====================================

//=====================================
// Memory access instances
//=====================================

//=====================================
// Register writeback instances
//=====================================

assign datapath_ins_mem_addr_out = pc_stored_value_wire;

endmodule
