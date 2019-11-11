// Adder module definition
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

module ADDER
  #(parameter DATA_WIDTH=64)(
    // Adder A data input
    input [DATA_WIDTH-1:0] adder_A_data_in,
    // Adder B data input
    input [DATA_WIDTH-1:0] adder_B_data_in,
    // Adder data output
    output [DATA_WIDTH-1:0] adder_data_out
  );

  // Combinational logic
  assign adder_data_out = adder_A_data_in + adder_B_data_in

endmodule // ADDER
