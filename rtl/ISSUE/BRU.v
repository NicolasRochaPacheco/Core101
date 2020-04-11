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
  DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] rs1_data_in,   // R[rs1] data input
  input [DATA_WIDTH-1:0] rs2_data_in,   // R[rs2] data input
  input [2:0] sel_in,                   // SEL in
  input [3:0] uop_in,         // uOP input
  output [1:0] pc_mux_sel_out // PC mux selection output
);

// WIRE DEFINITION
wire [1:0] pc_mux_sel_wire;

// COMBINATIONAL LOGIC
always @ (*) begin
  if (sel_in==3'b011)
    case(uop_in)
      4'b0000: pc_mux_sel_wire = (rs1_data_in==rs2_data_in) ? 2'b01 : 2'b10;
      4'b0001: pc_mux_sel_wire = (rs1_data_in!=rs2_data_in) ? 2'b01 : 2'b10;
      default: pc_mux_sel_wire = 2'b10;
    endcase
  else
    pc_mux_sel_wire = 2'b10;
end

// OUTPUT ASSIGNMENT
assign pc_mux_sel_out = pc_mux_sel_wire;

endmodule
