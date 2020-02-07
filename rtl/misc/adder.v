// General adder module definition
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


//-----------------------------------------------
//  MODULE DEFINITION
//-----------------------------------------------
module ADDER #(parameter DATA_WIDTH=32)(

  // Data inputs
  input [DATA_WIDTH-1:0] a_operand_in,
  input [DATA_WIDTH-1:0] b_operand_in,

  // Data outputs
  output [DATA_WIDTH-1:0] add_result_out

);


//-----------------------------------------------
//  COMBINATIONAL LOGIC
//-----------------------------------------------
assign add_result_out = a_operand_in + b_operand_in;


endmodule // ADD
