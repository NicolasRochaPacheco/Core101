// Program counter calculation module definition
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


module PC_CALC #(
  parameter XLEN = 32
)(
  // Falgs for non-INC PC calculation
  input pc_calc_correction_en_in,
  input pc_calc_prediction_en_in,

  // Input for current PC value
  input [XLEN-1:0] pc_calc_current_in,

  // Data input for non-INC PC calculation
  input [XLEN-1:0] pc_calc_correction_in,
  input [XLEN-1:0] pc_calc_prediction_in,

  // Output of PRED flag and calculated PC value
  output reg pc_calc_pred_out,
  output reg [XLEN-1:0] pc_calc_addr_out
);

// Procedural block for PC address calculation
always @ ( * ) begin
  case ({pc_calc_correction_en_in, pc_calc_prediction_en_in})
    2'b00: pc_calc_addr_out = pc_calc_current_in + 4; // INC
    2'b01: pc_calc_addr_out = pc_calc_prediction_in;  // PRED + J
    2'b10: pc_calc_addr_out = pc_calc_correction_in;  // CORRECTION
    2'b11: pc_calc_addr_out = pc_calc_correction_in;  // CORRECTION
  endcase

  pc_calc_pred_out = pc_calc_prediction_en_in & !pc_calc_correction_en_in;

end

endmodule
