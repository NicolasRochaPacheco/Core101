// Encoder B module definition
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


module ENCODE_B (
  input [3:0] data_in,
  output [1:0] data_out
);

wire [1:0] data_wire;

// COMBINATIONAL LOGIC
always @ ( * ) begin
  case (data_in)
    4'b0001: data_wire = 2'b00;
    4'b0010: data_wire = 2'b01;
    4'b0100: data_wire = 2'b10;
    4'b1000: data_wire = 2'b11;
    default: data_wire = 2'b00;
  endcase
end

// OUTPUT ASSINGMENT
assign data_out = data_wire;

endmodule
