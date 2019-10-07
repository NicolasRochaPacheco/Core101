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
    input general_register_clock_in,

    // INPUT
    input [DATA_WIDTH-1:0] reg_input_data,
    input general_register_set_in,
    input general_register_reset_in,

    // OUTPUT
    output [DATA_WIDTH-1:0] general_register_data_out
  );

  // REGISTER DEFINITION
  reg [DATA_WIDTH-1:0] general_register_signal_reg;
  reg [DATA_WIDTH-1:0] general_register_data_reg;

  // COMBINATIONAL LOGIC
  always @ ( * )
    begin
      if (general_register_set_in == 1'b1)
        general_register_signal_reg = reg_input_data;
      else
        general_register_signal_reg = general_register_data_reg;
    end

  // SEQUENTIAL LOGIC
  always @ (posedge general_register_clock_in)
    begin
      general_register_data_reg = general_register_signal_reg;
    end

  // OUTPUT LOGIC
  assign general_register_data_out = general_register_data_reg;

endmodule
