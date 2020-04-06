// 2-1 multiplexer module definition
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

module MUX_A
  #(parameter DATA_WIDTH = 32) (
    // Multiplexer source select signal
    input data_sel_in,

    // Multiplexer inputs
    input [DATA_WIDTH-1:0] a_data_src_in,
    input [DATA_WIDTH-1:0] b_data_src_in,

    // Multiplexer output
    output [DATA_WIDTH-1:0] data_out
  );

wire [DATA_WIDTH-1:0] data_wire;

always @ (*) begin
  case(data_sel_in)
    1'b0: data_wire = a_data_src_in;
    1'b1: data_wire = b_data_src_in;
  endcase
end

assign data_out = data_wire;

endmodule
