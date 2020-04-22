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
  input [4:0] fwd_if_rb_addr_in,  // RS1 on ID
  input [4:0] fwd_if_ra_addr_in,  // RS2 on ID
  input [4:0] fwd_id_rd_addr_in,  // RD on IS
  output [1:0] fwd_mux_sel_out   // FWD MUX values
);

// ========================================================
//                      WIRE DEFINITION
// ========================================================
wire [1:0] fwd_mux_sel_wire;

// ========================================================
//                      COMBINATIONAL LOGIC
// ========================================================
always@(*) begin
  // Sets every signal on zero
  fwd_mux_sel_wire = 2'b00;

  // Compares source register A
  if(fwd_if_ra_addr_in != 5'b00000)
    fwd_mux_sel_wire[0] = (fwd_if_ra_addr_in==fwd_id_rd_addr_in) ? 1'b1:1'b0;

  // Compares source register B
  if(fwd_if_rb_addr_in != 5'b00000)
    fwd_mux_sel_wire[1] = (fwd_if_rb_addr_in==fwd_id_rd_addr_in) ? 1'b1:1'b0;
end

// ========================================================
//                      OUTPUT LOGIC
// ========================================================
assign fwd_mux_sel_out = fwd_mux_sel_wire;

endmodule // FORWARDING_UNIT
