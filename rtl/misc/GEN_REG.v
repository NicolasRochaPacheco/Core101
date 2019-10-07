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


module GEN_REG #(parameter DATA_WIDTH=32)(
    // CLOCK
    input reg_clock_input,

    // INPUT
    input [DATA_WIDTH-1:0] reg_input_data,
    input reg_input_set,
    input reg_input_reset,

    // OUTPUT
    output [DATA_WIDTH-1:0] reg_output_data
  );

  // REGISTER DEFINITION
  reg [DATA_WIDTH-1:0] reg_input_signal;
  reg [DATA_WIDTH-1:0] reg_stored_data;

  // COMBINATIONAL LOGIC
  always @ ( * )
    begin
      if (reg_input_set == 1'b1)
        reg_input_signal = reg_input_data;
      else
        reg_input_signal = reg_stored_data;
    end

  // SEQUENTIAL LOGIC
  always @ (posedge reg_clock_input)
    begin
      reg_stored_data = reg_input_signal;
    end

  // OUTPUT LOGIC
  assign reg_output_data = reg_stored_data;

endmodule
