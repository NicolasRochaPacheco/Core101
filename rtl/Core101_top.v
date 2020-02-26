// Core101 top module definition
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

module Core101_top(
  // Clock and reset
  input clock_in,
  input reset_in,

  // Memory interfaces
  inout mem_addr_inout,
  inout mem_data_inout,
  output mem_read_out,
  input mem_valid_in
);


assign mem_read_out = 1'b1;


endmodule