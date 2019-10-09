// General register module definition
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
  output [31:0] datapath_ins_mem_addr_out

  //=========================
  // CONTROL SIGNALS
  //=========================

  // Program counter
  input datapath_pc_set_val_in;
  input [1:0] datapath_pc_src_in;



);

//=====================================
// Instruction fetch instances
//=====================================
// Instruction register
GEN_REG #(.DATA_WIDTH(32)) ir0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(datapath_ins_mem_data_in),
    .general_register_set_in(<from_control_unit>),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(<to_instruction_decode>)
  );

// Program counter
GEN_REG #(.DATA_WIDTH(32)) pc0 (
    .general_register_clock_in(datapath_clock_in),
    .general_register_data_in(<from_ins_mem_interface>),
    .general_register_set_in(<from_control_unit>),
    .general_register_reset_in(datapath_reset_in),
    .general_register_data_out(datapath_ins_mem_addr_out)
  );





endmodule
