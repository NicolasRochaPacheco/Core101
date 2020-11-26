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
  input pc_calc_offset_en_in,
  input pc_calc_target_en_in,
  input pc_calc_prediction_en_in,
  input [XLEN-1:0] pc_calc_current_in,
  input [XLEN-1:0] pc_calc_offset_in,
  input [XLEN-1:0] pc_calc_target_in,
  input [XLEN-1:0] pc_calc_prediction_in,
  output pc_calc_pred_out,
  output [XLEN-1:0] pc_calc_addr_out
);

// Procedural block for PC address calculation
always @ ( * ) begin
  case ({pc_calc_offset_en_in, pc_calc_target_en_in, pc_calc_prediction_en_in})
    3'b000: pc_calc_addr_out = pc_calc_current_in + 4;
    3'b001: pc_calc_addr_out = pc_calc_prediction_in;
    3'b010: pc_calc_addr_out = pc_calc_target_in;
    3'b011: pc_calc_addr_out = pc_calc_target_in;
    3'b100: pc_calc_addr_out = pc_calc_current_in + pc_calc_offset_in;
    3'b101: pc_calc_addr_out = pc_calc_current_in + pc_calc_offset_in;
    3'b110: pc_calc_addr_out = pc_calc_target_in;
    3'b111: pc_calc_addr_out = pc_calc_target_in;
  endcase
end

endmodule
