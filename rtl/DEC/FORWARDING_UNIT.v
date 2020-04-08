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

  if(rd1_addr_in != 5'b00000) begin
    if(rs1_addr_in == rd1_addr_in)    // Compares ID-IS
      fwd_mux_sel_wire[5:3] = 3'b111; // Enables on EX0,
    if(rs2_addr_in == rd1_addr_in)    // Compares ID-IS
      fwd_mux_sel_wire[2:0] = 3'b111; // Enables on EX_
  end

  if(rd2_addr_in != 5'b00000) begin
    if(rs1_addr_in == rd2_addr_in)  // Compares IS-EX
      fwd_mux_sel_wire[7] = 1'b1;   // Enables on IS0
    if(rs2_addr_in == rd2_addr_in)  // Compares IS-EX
      fwd_mux_sel_wire[6] = 1'b1;   // Enables on IS1
  end

  if(rd3_addr_in != 5'b00000) begin
    if(rs1_addr_in == rd3_addr_in)  // Compares EX-WB
      fwd_mux_sel_wire[9] = 1'b1;   // Enables on ID0
    if(rs2_addr_in == rd3_addr_in)  // Compares EX-WB
      fwd_mux_sel_wire[8] = 1'b1;   // Enables on ID1
  end
end

// ========================================================
//                      OUTPUT LOGIC
// ========================================================
assign fwd_mux_sel_out = fwd_mux_sel_wire;

endmodule // FORWARDING_UNIT
