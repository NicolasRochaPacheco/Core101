// Core101 32-output decode module definition
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


module DECODE_F (
  input [4:0] sel_addr_in,

  output sel_x00_out,
  output sel_x01_out,
  output sel_x02_out,
  output sel_x03_out,
  output sel_x04_out,
  output sel_x05_out,
  output sel_x06_out,
  output sel_x07_out,
  output sel_x08_out,
  output sel_x09_out,
  output sel_x10_out,
  output sel_x11_out,
  output sel_x12_out,
  output sel_x13_out,
  output sel_x14_out,
  output sel_x15_out,
  output sel_x16_out,
  output sel_x17_out,
  output sel_x18_out,
  output sel_x19_out,
  output sel_x20_out,
  output sel_x21_out,
  output sel_x22_out,
  output sel_x23_out,
  output sel_x24_out,
  output sel_x25_out,
  output sel_x26_out,
  output sel_x27_out,
  output sel_x28_out,
  output sel_x29_out,
  output sel_x30_out,
  output sel_x31_out
);

// Wire definiton
wire sel_x00_wire;
wire sel_x01_wire;
wire sel_x02_wire;
wire sel_x03_wire;
wire sel_x04_wire;
wire sel_x05_wire;
wire sel_x06_wire;
wire sel_x07_wire;
wire sel_x08_wire;
wire sel_x09_wire;
wire sel_x10_wire;
wire sel_x11_wire;
wire sel_x12_wire;
wire sel_x13_wire;
wire sel_x14_wire;
wire sel_x15_wire;
wire sel_x16_wire;
wire sel_x17_wire;
wire sel_x18_wire;
wire sel_x19_wire;
wire sel_x20_wire;
wire sel_x21_wire;
wire sel_x22_wire;
wire sel_x23_wire;
wire sel_x24_wire;
wire sel_x25_wire;
wire sel_x26_wire;
wire sel_x27_wire;
wire sel_x28_wire;
wire sel_x29_wire;
wire sel_x30_wire;
wire sel_x31_wire;


// ========================================================
// COMBINATIONAL LOGIC
// ========================================================
always @ (*) begin
  // Sets output of selection to zero
  sel_x00_wire = 1'b0;
  sel_x01_wire = 1'b0;
  sel_x02_wire = 1'b0;
  sel_x03_wire = 1'b0;
  sel_x04_wire = 1'b0;
  sel_x05_wire = 1'b0;
  sel_x06_wire = 1'b0;
  sel_x07_wire = 1'b0;
  sel_x08_wire = 1'b0;
  sel_x09_wire = 1'b0;
  sel_x10_wire = 1'b0;
  sel_x11_wire = 1'b0;
  sel_x12_wire = 1'b0;
  sel_x13_wire = 1'b0;
  sel_x14_wire = 1'b0;
  sel_x15_wire = 1'b0;
  sel_x16_wire = 1'b0;
  sel_x17_wire = 1'b0;
  sel_x18_wire = 1'b0;
  sel_x19_wire = 1'b0;
  sel_x20_wire = 1'b0;
  sel_x21_wire = 1'b0;
  sel_x22_wire = 1'b0;
  sel_x23_wire = 1'b0;
  sel_x24_wire = 1'b0;
  sel_x25_wire = 1'b0;
  sel_x26_wire = 1'b0;
  sel_x27_wire = 1'b0;
  sel_x28_wire = 1'b0;
  sel_x29_wire = 1'b0;
  sel_x30_wire = 1'b0;
  sel_x31_wire = 1'b0;

  // Sets corresponding selection wire high
  case(sel_addr_in)
    5'b00000: sel_x00_wire = 1'b1;
    5'b00001: sel_x01_wire = 1'b1;
    5'b00010: sel_x02_wire = 1'b1;
    5'b00011: sel_x03_wire = 1'b1;
    5'b00100: sel_x04_wire = 1'b1;
    5'b00101: sel_x05_wire = 1'b1;
    5'b00110: sel_x06_wire = 1'b1;
    5'b00111: sel_x07_wire = 1'b1;
    5'b01000: sel_x08_wire = 1'b1;
    5'b01001: sel_x09_wire = 1'b1;
    5'b01010: sel_x10_wire = 1'b1;
    5'b01011: sel_x11_wire = 1'b1;
    5'b01100: sel_x12_wire = 1'b1;
    5'b01101: sel_x13_wire = 1'b1;
    5'b01110: sel_x14_wire = 1'b1;
    5'b01111: sel_x15_wire = 1'b1;
    5'b10000: sel_x16_wire = 1'b1;
    5'b10001: sel_x17_wire = 1'b1;
    5'b10010: sel_x18_wire = 1'b1;
    5'b10011: sel_x19_wire = 1'b1;
    5'b10100: sel_x20_wire = 1'b1;
    5'b10101: sel_x21_wire = 1'b1;
    5'b10110: sel_x22_wire = 1'b1;
    5'b10111: sel_x23_wire = 1'b1;
    5'b11000: sel_x24_wire = 1'b1;
    5'b11001: sel_x25_wire = 1'b1;
    5'b11010: sel_x26_wire = 1'b1;
    5'b11011: sel_x27_wire = 1'b1;
    5'b11100: sel_x28_wire = 1'b1;
    5'b11101: sel_x29_wire = 1'b1;
    5'b11110: sel_x30_wire = 1'b1;
    5'b11111: sel_x31_wire = 1'b1;
  endcase
end

// Assigns the output of sel wires
assign sel_x00_out = sel_x00_wire;
assign sel_x01_out = sel_x01_wire;
assign sel_x02_out = sel_x02_wire;
assign sel_x03_out = sel_x03_wire;
assign sel_x04_out = sel_x04_wire;
assign sel_x05_out = sel_x05_wire;
assign sel_x06_out = sel_x06_wire;
assign sel_x07_out = sel_x07_wire;
assign sel_x08_out = sel_x08_wire;
assign sel_x09_out = sel_x09_wire;
assign sel_x10_out = sel_x10_wire;
assign sel_x11_out = sel_x11_wire;
assign sel_x12_out = sel_x12_wire;
assign sel_x13_out = sel_x13_wire;
assign sel_x14_out = sel_x14_wire;
assign sel_x15_out = sel_x15_wire;
assign sel_x16_out = sel_x16_wire;
assign sel_x17_out = sel_x17_wire;
assign sel_x18_out = sel_x18_wire;
assign sel_x19_out = sel_x19_wire;
assign sel_x20_out = sel_x20_wire;
assign sel_x21_out = sel_x21_wire;
assign sel_x22_out = sel_x22_wire;
assign sel_x23_out = sel_x23_wire;
assign sel_x24_out = sel_x24_wire;
assign sel_x25_out = sel_x25_wire;
assign sel_x26_out = sel_x26_wire;
assign sel_x27_out = sel_x27_wire;
assign sel_x28_out = sel_x28_wire;
assign sel_x29_out = sel_x29_wire;
assign sel_x30_out = sel_x30_wire;
assign sel_x31_out = sel_x31_wire;

endmodule
