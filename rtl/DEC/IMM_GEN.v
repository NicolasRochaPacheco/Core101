// Immediate value generator module definition
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

module IMM_GEN (
  input [4:0] opcode_in,
  input [24:0] instruction_in,
  output [31:0] immediate_out
);

// PARAMETER DEFINITION
parameter LOAD = 5'b00000;
parameter OPIMM = 5'b00100;
parameter AUIPC = 5'b00101;
parameter STORE = 5'b01000;
parameter OP = 5'b01100;
parameter LUI = 5'b01101;
parameter BRANCH = 5'b11000;
parameter JALR = 5'b11001;
parameter JAL = 5'b11011;
parameter SYSTEM = 5'b11100;
parameter OPV = 5'b10101;

// ========================================================
// WIRE DEFINITION
// ========================================================
wire [31:0] imm_wire;

// ========================================================
// COMBINATIONAL LOGIC
// ========================================================
always @ (*) begin
  case(opcode_in)
    LOAD:   imm_wire = {{21{instruction_in[24]}}, instruction_in[23:13]};
    OPIMM:  imm_wire = {{21{instruction_in[24]}}, instruction_in[23:13]};
    AUIPC:  imm_wire = {instruction_in[24:5], {12{1'b0}}};
    BRANCH: imm_wire = {{20{instruction_in[24]}}, instruction_in[0], instruction_in[23:18], instruction_in[4:1], 1'b0};
    default: imm_wire = 32'h00000000;
  endcase
end

// ========================================================
// OUTPUT LOGIC
// ========================================================
assign immediate_out = imm_wire;

endmodule
