// Forwarding unit module definition
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

module FORWARDING_UNIT(
  input [4:0] rs1_addr_in,  // RS1 on ID
  input [4:0] rs2_addr_in,  // RS2 on ID
  input [4:0] rd1_addr_in,  // RD on IS
  input [4:0] rd2_addr_in,  // RD on EX
  input [4:0] rd3_addr_in,  // RD on WB
  output [9:0] fwd_mux_sel_out
);

// ========================================================
//                      WIRE DEFINITION
// ========================================================
wire [9:0] fwd_mux_sel_wire;

// ========================================================
//                      COMBINATIONAL LOGIC
// ========================================================
always@(*) begin
  // Sets every signal on zero
  fwd_mux_sel_wire = 10'b00000000;

  // Logic for RS1
  if(rs1_addr_in == rd1_addr_in)  // Compares ID-IS
    fwd_mux_sel_wire[0] = 1'b1;   // Enables on EX
  if(rs1_addr_in == rd2_addr_in)  // Compares ID-EX
    fwd_mux_sel_wire[0] = 1'b1;   // Enables on IS
  if(rs1_addr_in == rd3_addr_in)  // Compares ID-WB
    fwd_mux_sel_wire[0] = 1'b1;   // Enables on ID
end

// ========================================================
//                      OUTPUT LOGIC
// ========================================================
assign fwd_mux_sel_out = fwd_mux_sel_wire;

endmodule // FORWARDING_UNIT
