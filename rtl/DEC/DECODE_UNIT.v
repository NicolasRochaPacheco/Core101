// Core101 decode module definition
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


module DECODE_UNIT (

  input [31:0] dec_ins_in,

  output [4:0] dec_gpr_src_a_out
  output [4:0] dec_gpr_src_b_out
);

// RISC-V OUTPUT LOGIC
// opcode = ins[6:0]
// src1 = ins[19:15]
// src2 = ins[24:20]


// General purpose registers output
assign dec_gpr_src_a_out = dec_ins_in[19:15];
assign dec_gpr_src_b_out = dec_ins_in[24:20];

endmodule
