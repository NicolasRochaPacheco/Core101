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

  // Instruction memory interface
  output [31:0] ins_mem_addr_out,
  input [31:0] ins_mem_data_in,

  // Data memory interface
  output [31:0] data_mem_addr_out,
  inout [31:0] data_mem_data_inout

);

//-----------------------------------------------
// MAIN UNITS
//-----------------------------------------------
IFU ifu0 (

  // Clock and reset input
  .ifu_clock_in(clock_in),
  .ifu_reset_in(reset_in),

  // Data inputs
  .pc_upd_addr_in(),
  .pc_offset_in(),

  // Control inputs
  .pc_set_ctrl_in(),
  .pc_src_mux_ctrl_in(),
  .ins_mem_valid_ctrl_in(),
  .ir_set_ctrl_in(),

  // Data outputs
  .pc_stored_val_out(),
  .ir_stored_val_out(),

  // Control outputs
  .ins_mem_ready_out(),
  .ins_mem_hit_out()

);



endmodule
