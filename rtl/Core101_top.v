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

module Core101_top (
  input clock_in,
  input reset_in,

  // IF/ID debug signals
  output if_id_prediction_out,
  output [31:0] ir_data_if_id_out,
  output [31:0] pc_data_if_id_out,

  // ID/IS debug signals
  output [1:0] id_is_fwd_out,
  output [31:0] imm_id_is_data_out,
  output [31:0] pc_id_is_data_out,

  // IS/EX debug signals
  output bru_enable_out,
  output branch_taken_out,
  output rd_write_enable_out,
  output [3:0] int_uop_out,
  output [3:0] lsu_uop_out,
  output [3:0] vec_uop_out,
  output [3:0] bru_uop_out,
  output [4:0] rd_addr_ex_wb_out,

  output [31:0] wb_data_out,
  output [31:0] ex_a_data_out,
  output [31:0] ex_b_data_out
);

// Dummy memory definition
wire [31:0] ins_mem_addr_wire;
wire [31:0] ins_mem_data_wire;

// Debug wire from IF/ID
wire if_id_prediction_wire;
wire [31:0] pc_data_if_id_wire;
wire [31:0] ir_data_if_id_wire;

// Debug wire from ID/IS
wire [1:0] id_is_fwd_wire;
wire [31:0] imm_data_wire;
wire [31:0] pc_id_is_data_wire;

wire write_enable_wire;
wire [3:0] int_uop_wire;
wire [4:0] rd_addr_ex_wb_wire;

wire [31:0] wb_data_wire;

wire [31:0] ex_a_data_wire;
wire [31:0] ex_b_data_wire;

//
Core101 core101 (
  .clock_in(clock_in),
  .reset_in(reset_in),
  .ins_mem_data_in(ins_mem_data_wire),
  .ins_mem_addr_out(ins_mem_addr_wire),

  // IF debug signals
  .if_id_prediction_out(if_id_prediction_wire),
  .ir_data_if_id_out(ir_data_if_id_wire),
  .pc_data_if_id_out(pc_data_if_id_wire),

  // ID/IS
  .id_is_fwd_out(id_is_fwd_wire),
  .imm_id_is_data_out(imm_data_wire),
  .pc_id_is_data_out(pc_id_is_data_wire),

  .rd_addr_ex_wb_out(rd_addr_ex_wb_wire),
  .wb_data_out(wb_data_wire),
  .rd_write_enable_out(write_enable_wire),
  .int_uop_out(int_uop_wire),
  .lsu_uop_out(),
  .vec_uop_out(),
  .bru_uop_out(),
  .bru_enable_out(),
  .branch_taken_out(),
  .ex_a_data_out(ex_a_data_wire),
  .ex_b_data_out(ex_b_data_wire)
);

//
MAIN_MEMORY mem (
  .main_mem_addr_in(ins_mem_addr_wire),
  .main_mem_data_out(ins_mem_data_wire)
);


// IF/ID
assign if_id_prediction_out = if_id_prediction_wire;
assign pc_data_if_id_out = pc_data_if_id_wire;
assign ir_data_if_id_out = ir_data_if_id_wire;

// ID/IS
assign id_is_fwd_out = id_is_fwd_wire;
assign imm_id_is_data_out = imm_data_wire;
assign pc_id_is_data_out = pc_id_is_data_wire;

// IS/EX
assign int_uop_out = int_uop_wire;
assign ex_a_data_out = ex_a_data_wire;
assign ex_b_data_out = ex_b_data_wire;

// EX/WB
assign rd_addr_ex_wb_out = rd_addr_ex_wb_wire;
assign wb_data_out = wb_data_wire;
assign rd_write_enable_out = write_enable_wire;


endmodule // Core101_top
