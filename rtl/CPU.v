// 101core top module definition
// Copyright (C) 2019 <name of author>
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

module 101core(

  // CLOCK
  input CLOCK_50,

  // INPUT
  input [31:0] ins_mem_ins,

  // OUTPUT
  output [31:0] ins_mem_addr

);

  //------------------------
  // WIRE DEFINITION
  //------------------------

    // ALU
    wire  [31:0]  alu_operand_a_wire;
    wire  [31:0]  alu_operand_b_wire;
    wire  [31:0]  alu_output_wire;
    wire  [3:0]   alu_opcode_wire;

    // IMM GENERATOR
    wire  [31:0]  imm_gen_input_wire;
    wire  [31:0]  imm_gen_output_wire;


  //------------------------
  // INSTANCE DEFINITION
  //------------------------

  ALU alu0( .alu_input_a(alu_operand_a_wire),
            .alu_input_b(alu_operand_b_wire),
            .alu_opcode(alu_opcode_wire),

            .alu_output(alu_output_wire)
          );


endmodule
