// Core101 module definition
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



module Core101 (
  // Clock and reset in
  input clock_in,
  input reset_in,

  // Instruction memory interface
  output ins_mem_valid_out,
  output [31:0] ins_mem_addr_out,
  input ins_mem_ready_in,
  input [31:0] ins_mem_data_in,

  // Data memory interface
  output data_mem_valid_out,
  output data_mem_write_out,
  output [31:0] data_mem_addr_out,
  output [31:0] data_mem_data_out,
  input data_mem_ready_in,
  input [31:0] data_mem_data_in
);

// ISA WIDTH PARAMETER DEFINITION
parameter XLEN = 32;

// PIPELINE REGISTERS WIDTH DEFINITION
parameter PC_IF_WIDTH = 33;
parameter IF_DEC_WIDTH = 65;

// PIPELINE CONTROL WIRE DEFINITION
wire pipeline_pc_if_clear_wire;
wire pipeline_pc_if_set_wire;

// Program counter calculation
wire [31:0] pc_calc_addr_wire;
wire pc_calc_pred_wire;

// PC/IF pipeline register
wire [PC_ID_WIDTH-1:0] pc_if_pipeline_data_wire;
// =======================================================================

// Program counter calculation
PC_CALC #(.XLEN(XLEN)) pc_calc (
  .pc_calc_current_in(pc_if_pipeline_data_wire[XLEN-1:0]),
  .pc_calc_offset_in(),
  .pc_calc_target_in(),
  .pc_calc_prediction_in(),
  .pc_calc_offset_en_in(),
  .pc_calc_target_en_in(),
  .pc_calc_prediction_en_in(),
  .pc_calc_addr_out(pc_calc_addr_wire),
  .pc_calc_pred_out(pc_calc_pred_wire)
);

// PC/IF pipeline register
REG #(.XLEN(PC_IF_WIDTH)) pc_if_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_pc_if_clear_wire),
  .reg_set_in(pipeline_pc_if_set_wire),
  .reg_data_in({
      pc_calc_pred_wire,
      pc_calc_addr_wire
    }),
  .reg_data_out(pc_if_pipeline_data_wire)
);

// Assigns instruction memory address output
assign ins_mem_addr_out = pc_if_pipeline_data_wire[XLEN-1:0];
assign ins_mem_valid_out = pipeline_ins_mem_valid_wire;

// IF/DEC pipeline register
REG #(.XLEN(IF_DEC_WIDTH)) if_dec_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_if_dec_clear_wire),
  .reg_set_in(pipeline_if_dec_set_wire),
  .reg_data_in({
      pc_if_pipeline_data_wire[XLEN],
      ins_mem_data_in,
      pc_if_pipeline_data_wire[XLEN-1:0]
    }),
  .reg_data_out(pc_if_dec_pipeline_data_wire)
);

// Branch predictor


// Forwarding unit


// Immediate generation


// Instruction decoding


// DEC/REG pipeline register


// General purpose registers


// Issue unit


// REG/EX pipeline register


// Branch Resolver


// ALU


// Load/Store Unit


// EX/WB pipeline register


// Pipeline control
PIPELINE_CONTROL pipeline_control (

  // Clock and reset inputs
  .pipeline_clock_in(clock_in),
  .pipeline_reset_in(reset_in),

  // Instruction memory interface control
  .pipeline_ins_mem_valid_out(pipeline_ins_mem_valid_wire),
  .pipeline_ins_mem_ready_in(ins_mem_ready_in)

  // Pipeline registers write enable
  .pipeline_pc_if_set_out(pipeline_pc_if_set_wire),
  .pipeline_if_dec_set_out(pipeline_if_dec_set_wire)
);



endmodule
