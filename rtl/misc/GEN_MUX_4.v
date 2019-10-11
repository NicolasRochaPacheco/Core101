// 4-1 multiplexer module definition
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

module GEN_MUX_4
  #(parameter DATA_WIDTH = 32) (
    // Multiplexer source select signal.
    input [1:0] mux_four_sel_in,

    // Multiplexer inputs
    input [DATA_WIDTH-1:0] mux_four_zero_in,
    input [DATA_WIDTH-1:0] mux_four_one_in,
    input [DATA_WIDTH-1:0] mux_four_two_in,
    input [DATA_WIDTH-1:0] mux_four_three_in,

    // Multiplexer output
    output [DATA_WIDTH-1:0] mux_output_out
  );

  // Register to store output value
  reg [DATA_WIDTH-1:0] mux_output_reg;

  // Combinational logic
  always @ ( * )
    begin
      case (mux_four_sel_in)
        2'b00: mux_output_reg <= mux_four_zero_in;
        2'b01: mux_output_reg <= mux_four_one_in;
        2'b10: mux_output_reg <= mux_four_two_in;
        2'b11: mux_output_reg <= mux_four_three_in;
      endcase
    end

  // Output assignments
  assign mux_output_out <= mux_output_reg;

endmodule
