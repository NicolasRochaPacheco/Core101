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

  //=========================
  // WIRE DEFINITION
  //=========================
  // Instrucion fetch
  wire pc_set_val_wire;     // PC
  wire [1:0] pc_src_wire;   // PC
  wire ir_set_val_wire;     // IR


  DATAPATH datapath0(
      .datapath_clock_in(clock_in),
      .datapath_reset_in(reset_in),

      .datapath_ins_mem_data_in(),
      .datapath_ins_mem_addr_out(),

      .datapath_pc_set_val_in(pc_set_val_wire),
      .datapath_pc_src_in(pc_src_wire),
      .datapath_ir_set_val_in(ir_set_val_wire)
    );


  CONTROL control_unit0(
      .control_unit_clock_in(<clock>),
      .control_unit_reset_in(<reset>)
    );

endmodule
