// Core101 instruction cache controller module definition
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
module INS_CACHE_CONTROLLER(

  // Clock and reset inputs
  input ins_cache_controller_clock_in,
  input ins_cache_controller_reset_in,

  // Data inputs
  input [31:0] ins_mem_controller_addr_in,
  input [31:0] ins_cache_instruction_in,

  // Data outputs
  output [31:0] ins_mem_addr_out,
  output [31:0] ins_cache_addr_out

);




endmodule // INS_CACHE_CONTROLLER
