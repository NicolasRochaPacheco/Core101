// Core101 control module definition
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

module CONTROL (
  // Reset input
  input reset_in,
  input bru_flush_in,
  input jump_flush_in,

  // Reset output for pipeline registers
  output [3:0] pipeline_reset_out
);

// Wire definition
wire [3:0] pipeline_reset_wire;

// Combinational logic
always @(*) begin

  // Default values
  pipeline_reset_wire = 4'b0000;

  // If a reset is enabled
  if(reset_in == 1'b1) begin
    pipeline_reset_wire = 4'b1111;
  end

  // If a BRU flush is enabled
  if(bru_flush_in == 1'b1) begin
    pipeline_reset_wire = 4'b1100;
  end

  // If a Jump flush is enabled
  if(jump_flush_in == 1'b1) begin
    pipeline_reset_wire = 4'b0110;
  end
end

// Output logic
assign pipeline_reset_out = pipeline_reset_wire;


endmodule
