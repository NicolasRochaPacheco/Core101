// Core101 decode module definition
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


module INT_EXEC (

  // A and B data bus input
  input [31:0] a_data_in,
  input [31:0] b_data_in,

  // Enabel signal input
  input enable_in,

  // uOP bus input
  input [3:0] uop_in,

  // RES data output
  output [31:0] res_data_out
);


// ==============================================
// MICRO-OPCODES DEFINITION
// ==============================================
// 4'b0000: ADD
// 4'b0001: SUB
// 4'b0010: OR
// 4'b0011: AND
// 4'b0100: XOR
// 4'b0101:
// 4'b0110:
// 4'b0111:
// 4'b1000: BUFFER RS1
// 4'b1001: BUFFER RS2
// 4'b1010: SLT (Set lower Than)
// 4'b1011: SLTU (Set Lower Than Unsigned)
// 4'b1100:
// 4'b1101: SRA (Shift Right Arithmetic)
// 4'b1110: SRL (Shift Right Logic)
// 4'b1111: SLL (Shift left logic)
// ==============================================


// ==============================================
// INSTANCE DEFINITION
// ==============================================
ALU #(.DATA_WIDTH(32)) alu0 (
  .a_data_in(a_data_in),
  .b_data_in(b_data_in),
  .uop_in(uop_in),
  .result_out(res_data_out)
);


endmodule
