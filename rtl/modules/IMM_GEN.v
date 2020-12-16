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
  input [6:0] imm_gen_opcode_in,
  input [24:0] imm_gen_ins_in,
  output reg [31:0] imm_gen_data_out
);

// PARAMETER DEFINITION
parameter LOAD = 7'b0000011;
parameter OPIMM = 7'b0010011;
parameter AUIPC = 7'b0010111;
parameter STORE = 7'b0100011;
parameter OP = 7'b0110011;
parameter LUI = 7'b0110111;
parameter BRANCH = 7'b1100011;
parameter JALR = 7'b1100111;
parameter JAL = 7'b1101111;
parameter SYSTEM = 7'b1110011;
parameter OPV = 7'b1010111;

// ========================================================
// COMBINATIONAL LOGIC
// ========================================================
always @ (*) begin
  case(imm_gen_opcode_in)
    LOAD:   imm_gen_data_out = {{21{imm_gen_ins_in[24]}},
                        imm_gen_ins_in[23:13]};
    OPIMM:  imm_gen_data_out = {{21{imm_gen_ins_in[24]}},
                        imm_gen_ins_in[23:13]};
    AUIPC:  imm_gen_data_out = {imm_gen_ins_in[24:5],
                        {12{1'b0}}};
    STORE:  imm_gen_data_out = {{21{imm_gen_ins_in[24]}}, // 21
                        imm_gen_ins_in[23:18],            // 6
                        imm_gen_ins_in[4:0]};             // 5
    OP:     imm_gen_data_out = 32'h00000000;
    LUI:    imm_gen_data_out = {imm_gen_ins_in[24:5],
                        {12{1'b0}}};
    BRANCH: imm_gen_data_out = {{20{imm_gen_ins_in[24]}}, // 20
                        imm_gen_ins_in[0],      // 1
                        imm_gen_ins_in[23:18],  // 6
                        imm_gen_ins_in[4:1],    // 4
                        1'b0};
    JALR:   imm_gen_data_out = {{21{imm_gen_ins_in[24]}},
                        imm_gen_ins_in[23:13]};
    JAL:    imm_gen_data_out = {{12{imm_gen_ins_in[24]}},
                        imm_gen_ins_in[12:5],
                        imm_gen_ins_in[13],
                        imm_gen_ins_in[23:14],
                        1'b0};
    default: imm_gen_data_out = 32'h00000000;
  endcase
end

endmodule
