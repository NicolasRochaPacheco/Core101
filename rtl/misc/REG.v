// General register module definition
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


module REG #(parameter DATA_WIDTH=32)(
    // CLOCK
    input clock_in,
    input reset_in,

    // Data input
    input [DATA_WIDTH-1:0] data_in,

    // Data output
    output [DATA_WIDTH-1:0] data_out,

    // Control signals
    input set_in
  );

  // REGISTER DEFINITION
  reg [DATA_WIDTH-1:0] general_register_signal_reg;
  reg [DATA_WIDTH-1:0] general_register_data_reg;

  // COMBINATIONAL LOGIC
  always @ ( * )
    begin
      if (set_in == 1'b1)
        general_register_signal_reg = data_in;
      else
        general_register_signal_reg = general_register_data_reg;
    end

  // SEQUENTIAL LOGIC
  always @ (posedge clock_in, posedge reset_in)
    begin
      if (reset_in == 1'b1)
        general_register_data_reg <= 0;
      else
        general_register_data_reg <= general_register_signal_reg;
    end

  // OUTPUT LOGIC
  assign data_out = general_register_data_reg;

endmodule
