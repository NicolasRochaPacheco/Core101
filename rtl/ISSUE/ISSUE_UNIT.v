// Core101 issue module definition
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

module ISSUE_UNIT (
  // Execution unit selection bus
  input [2:0] exec_unit_sel_in,
  input [3:0] exec_uop_in,

  // Execution units enable signals
  output int_enable_out,
  output vec_enable_out,
  output lsu_enable_out,

  // Execution units opcode
  output [3:0] int_exec_uop_out,
  output [3:0] vec_exec_uop_out,
  output [3:0] lsu_exec_uop_out
);


// Enable signals registers
reg int_enable_reg;
reg vec_enable_reg;
reg lsu_enable_reg;

// Registers to hold each micro operation
reg [3:0] int_uop;
reg [3:0] vec_uop;
reg [3:0] lsu_uop;


// Combinational logic
always@(*) begin
  case(exec_unit_sel_in)
    3'b001:   begin
                int_enable_reg = 1'b1;
                vec_enable_reg = 1'b0;
                lsu_enable_reg = 1'b0;

                int_uop = exec_uop_in;
                vec_uop = 4'b0000;
                lsu_uop = 4'b0000;
              end

    3'b010:   begin
                int_enable_reg = 1'b0;
                vec_enable_reg = 1'b1;
                lsu_enable_reg = 1'b0;

                int_uop = 4'b0000;
                vec_uop = exec_uop_in;
                lsu_uop = 4'b0000;
              end

    3'b100:   begin
                int_enable_reg = 1'b0;
                vec_enable_reg = 1'b0;
                lsu_enable_reg = 1'b1;

                int_uop = 4'b0000;
                vec_uop = 4'b0000;
                lsu_uop = exec_uop_in;
              end

    default:  begin
                int_enable_reg = 1'b0;
                vec_enable_reg = 1'b0;
                lsu_enable_reg = 1'b0;

                int_uop = 4'b0000;
                vec_uop = 4'b0000;
                lsu_uop = 4'b0000;
              end
  endcase
end

// Drives enable signals
assign int_enable_out = int_enable_reg;
assign vec_enable_out = vec_enable_reg;
assign lsu_enable_out = lsu_enable_reg;

// Drives each execution unit uOp bus
assign int_exec_uop_out = int_uop;
assign vec_exec_uop_out = vec_uop;
assign lsu_exec_uop_out = lsu_uop;

endmodule
