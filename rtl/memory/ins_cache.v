// Core101 instruction cache module definition
// Copyright (C) 2020 Nicolas Rocha Pacheco
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
module INS_CACHE (

  input ins_cache_clock_in,
  input ins_cache_reset_in,

  input [7:0] ins_cache_addr_in,
  input [19:0] ins_cache_tag_in,
  input [1:0] ins_cache_offset_in

  output ins_cache_hit_out

);

endmodule // INS_CACHE
