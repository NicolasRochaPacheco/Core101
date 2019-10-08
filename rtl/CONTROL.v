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

module CONTROL(
    input control_clock
  );

  // REGISTER DEFINITION
  reg [3:0] state_reg; // State register used for pipeline staging

  always @ (posedge datapath_clock)
    begin

      state_reg = state_reg + 1'b1; // Increment state register
    end


endmodule
