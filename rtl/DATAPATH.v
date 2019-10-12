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
  output [31:0] datapath_ins_mem_addr_out,

  // CONTROL SIGNALS
  // Instruction fetch
  input datapath_pc_set_val_in,       // PC
  input datapath_ir_set_val_in,       // IR
  input [1:0] datapath_pc_mux_sel_in, // PC mux src sel
  // Instruction decode
  input datapath_imm_gen_type_in,     // IMM type
  input datapath_imm_mux_src_sel_in   // IMM mux src sel

);

// WIRE DEFINITION
// Instruction fetch
wire [31:0] pc_data_src_wire;
wire [31:0] pc_stored_val_wire;
wire [31:0] pc_incremented_wire;

//=====================================
// Instruction fetch instances
//=====================================
// Instruction register
GEN_REG #(.DATA_WIDTH(32)) ir0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(datapath_ins_mem_data_in),
    .general_register_set_in(datapath_ir_set_val_in),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(<to_instruction_decode_unit>)
  );

// Program counter
GEN_REG #(.DATA_WIDTH(32)) pc0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(pc_data_src_wire),
    .general_register_set_in(datapath_pc_set_val_in),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(pc_stored_val_wire)
  );

// PC source multiplexer
GEN_MUX_4 #(.DATA_WIDTH(32)) pc_mux0 (
    .mux_four_sel_in(pc_mux_sel_in),
    .mux_four_zero_in(pc_incremented_wire),   // PC + 4
    .mux_four_one_in(<from_pc_offset_unit>),  // PC + offset
    .mux_four_two_in(<new_pc_addr>),          // new PC
    .mux_four_three_in(),                     // Not implemented
    .mux_output_out(pc_data_src_wire)
  );

// PC incrementer
PC_INC #(.DATA_WIDTH(32)) pc_inc0 (
    .pc_inc_value_in(pc_stored_val_wire),
    .pc_inc_incremented_val_out(pc_incremented_wire)
  );

//=====================================
// Instruction decode instances
//=====================================

GPR #(.DATA_WIDTH(32)) gpr0 (

  );

IMM_GEN #(.DATA_WIDTH(32)) imm_gen0 (

  );

GEN_MUX_2 #(.DATA_WIDTH(32)) imm_mux0 (

  );

assign datapath_ins_mem_addr_out = pc_stored_val_wire;

endmodule
