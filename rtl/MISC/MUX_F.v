// Core101 32-entry multiplexer module definition
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


module MUX_F (

  input [4:0] mux_sel_in,

  input [31:0] x00_data_in,
  input [31:0] x01_data_in,
  input [31:0] x02_data_in,
  input [31:0] x03_data_in,
  input [31:0] x04_data_in,
  input [31:0] x05_data_in,
  input [31:0] x06_data_in,
  input [31:0] x07_data_in,
  input [31:0] x08_data_in,
  input [31:0] x09_data_in,
  input [31:0] x10_data_in,
  input [31:0] x11_data_in,
  input [31:0] x12_data_in,
  input [31:0] x13_data_in,
  input [31:0] x14_data_in,
  input [31:0] x15_data_in,
  input [31:0] x16_data_in,
  input [31:0] x17_data_in,
  input [31:0] x18_data_in,
  input [31:0] x19_data_in,
  input [31:0] x20_data_in,
  input [31:0] x21_data_in,
  input [31:0] x22_data_in,
  input [31:0] x23_data_in,
  input [31:0] x24_data_in,
  input [31:0] x25_data_in,
  input [31:0] x26_data_in,
  input [31:0] x27_data_in,
  input [31:0] x28_data_in,
  input [31:0] x29_data_in,
  input [31:0] x30_data_in,
  input [31:0] x31_data_in,

  output [31:0] x_data_out

);

// Wire to store output data
wire [31:0] data_wire;

always @(*) begin
  case (mux_sel_in)
    5'b00000: data_wire = x00_data_in;
    5'b00001: data_wire = x01_data_in;
    5'b00010: data_wire = x02_data_in;
    5'b00011: data_wire = x03_data_in;
    5'b00100: data_wire = x04_data_in;
    5'b00101: data_wire = x05_data_in;
    5'b00110: data_wire = x06_data_in;
    5'b00111: data_wire = x07_data_in;
    5'b01000: data_wire = x08_data_in;
    5'b01001: data_wire = x09_data_in;
    5'b01010: data_wire = x10_data_in;
    5'b01011: data_wire = x11_data_in;
    5'b01100: data_wire = x12_data_in;
    5'b01101: data_wire = x13_data_in;
    5'b01110: data_wire = x14_data_in;
    5'b01111: data_wire = x15_data_in;
    5'b10000: data_wire = x16_data_in;
    5'b10001: data_wire = x17_data_in;
    5'b10010: data_wire = x18_data_in;
    5'b10011: data_wire = x19_data_in;
    5'b10100: data_wire = x20_data_in;
    5'b10101: data_wire = x21_data_in;
    5'b10110: data_wire = x22_data_in;
    5'b10111: data_wire = x23_data_in;
    5'b11000: data_wire = x24_data_in;
    5'b11001: data_wire = x25_data_in;
    5'b11010: data_wire = x26_data_in;
    5'b11011: data_wire = x27_data_in;
    5'b11100: data_wire = x28_data_in;
    5'b11101: data_wire = x29_data_in;
    5'b11110: data_wire = x30_data_in;
    5'b11111: data_wire = x31_data_in;
  endcase
end

assign x_data_out = data_wire;

endmodule
