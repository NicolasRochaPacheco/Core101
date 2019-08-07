// ALU module for 101core
// Copyright (C) 2019 <name of author>
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

module ALU(

  // INPUT
  input [31:0]  alu_input_a, // ALU_A
  input [31:0]  alu_input_b, // ALU_B
  input [31:0]  alu_opcode,

  // OUTPUT
  output [31:0] alu_output,
  output        alu_neg,
  output        alu_zero
);

// REG DEFINITION
reg [31:0] alu_result_reg;

always@(*)
  begin
    case(alu_opcode)
      4'b0000: // ALU OP: ALU_A + ALU_B
        alu_result_reg = alu_input_a + alu_input_b;
      4'b0001: // ALU OP: ALU_A - ALU_B
        alu_result_reg = alu_input_a - alu_input_b;
      4'b0010: // ALU OP:
        alu_result_reg =
      4'b0011: // ALU OP:
        alu_result_reg =
      4'b0100: // ALU OP:
        alu_result_reg =
      4'b0101: // ALU OP:
        alu_result_reg =
      4'b0110: // ALU OP:
        alu_result_reg =
      4'b0111: // ALU OP:
        alu_result_reg =
      4'b1000: // ALU OP:
        alu_result_reg =
      4'b1001: // ALU OP:
        alu_result_reg =
      4'b1010: // ALU OP:
        alu_result_reg =
      4'b1011: // ALU OP:
        alu_result_reg =
      4'b1100: // ALU OP:
        alu_result_reg =
      4'b1101: // ALU OP:
        alu_result_reg =
      4'b1110: // ALU OP:
        alu_result_reg =
      4'b1111: // ALU OP:
        alu_result_reg =
    endcase
  end

  assign alu_output = alu_result_reg;
  assign alu_neg = alu_result_reg[31];
  assign alu_zero = (alu_result_reg == 32'h00000000) ? 1'b1: 1'b0;

endmodule
