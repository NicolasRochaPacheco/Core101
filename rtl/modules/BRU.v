// Branch resolver unit module definition
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

module BRU #(
  parameter DATA_WIDTH = 32
)(
  input bru_prediction_in,            // Prediction input
  input [3:0] bru_uop_in,             // uOP input
  input [DATA_WIDTH-1:0] bru_pc_in,   // Program counter address
  input [DATA_WIDTH-1:0] bru_rs1_in,  // R[rs1] data input
  input [DATA_WIDTH-1:0] bru_rs2_in,   // R[rs2] data input
  input [DATA_WIDTH-1:0] bru_imm_in,  // Immediate value.

  output reg bru_correction_out,
  output reg [DATA_WIDTH-1:0] bru_target_out  // PC new address output
);


reg _result_flag;


// COMBINATIONAL LOGIC
always @ (*) begin

    case(bru_uop_in)  // Resolves the branch
      4'b0000: _result_flag = (bru_rs1_in == bru_rs2_in) ? 1'b1:1'b0; // BEQ
      4'b0001: _result_flag = (bru_rs1_in != bru_rs2_in) ? 1'b1:1'b0; // BNE
      4'b0010: _result_flag = (bru_rs1_in <  bru_rs2_in) ? 1'b1:1'b0; // BLT
      4'b0011: _result_flag = (bru_rs1_in >= bru_rs2_in) ? 1'b1:1'b0; // BGE
      4'b0110: _result_flag = 1'b0; //(rs1_data_in<rs2_data_in) ? 1'b1:1'b0;  // BLTU
      4'b0111: _result_flag = (bru_rs1_in >  bru_rs2_in) ? 1'b1:1'b0;
      default: _result_flag = 1'b0;
    endcase

    // Checks the prediction and branch result
    bru_correction_out = (bru_prediction_in == _result_flag) ? 1'b0:1'b1;

    // Calculates target address
    bru_target_out = bru_pc_in + bru_imm_in;

end

endmodule
