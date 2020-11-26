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

module Core101_top #(
  parameter XLEN = 32
) (
  input clock_in,
  input reset_in
);

// =======================================================================
// Instruction memory wire definition
wire ins_mem_valid_wire;
wire ins_mem_ready_wire;
wire [31:0] ins_mem_addr_wire;
wire [31:0] ins_mem_data_wire;

// Data memory wire definition
wire data_mem_valid_wire;
wire data_mem_ready_wire;
wire data_mem_write_wire;
wire [31:0] data_mem_addr_wire;
wire [31:0] data_mem_data_inbound_wire;
wire [31:0] data_mem_data_outbound_wire;
// =======================================================================


// Core101 instantiation
Core101 core101 (
  // Clock and reset in
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Instruction memory interface
  .ins_mem_valid_out(ins_mem_valid_wire),
  .ins_mem_addr_out(ins_mem_addr_wire),
  .ins_mem_ready_in(ins_mem_ready_wire),
  .ins_mem_data_in(ins_mem_data_wire),

  // Data memory interface
  .data_mem_valid_out(data_mem_valid_wire),
  .data_mem_write_out(data_mem_write_wire),
  .data_mem_addr_out(data_mem_addr_wire),
  .data_mem_data_out(data_mem_data_outbound_wire),
  .data_mem_ready_in(data_mem_ready_wire),
  .data_mem_data_in(data_mem_data_inbound_wire)
);

// Instruction memory instantiation
INS_MEM #(.XLEN(32)) ins_memory (
  .ins_mem_valid_in(ins_mem_valid_wire),
  .ins_mem_addr_in(ins_mem_addr_wire),
  .ins_mem_ready_out(ins_mem_ready_wire),
  .ins_mem_data_out(ins_mem_data_wire)
);

// Data memory instantiation
DATA_MEM #(.XLEN(32)) data_memory (
  .data_mem_valid_in(data_mem_valid_wire),
  .data_mem_write_in(data_mem_write_wire),
  .data_mem_addr_in(data_mem_addr_wire),
  .data_mem_data_in(data_mem_data_inbound_wire),
  .data_mem_data_out(data_mem_data_outbound_wire),
  .data_mem_ready_out(data_mem_ready_wire)
);

endmodule
