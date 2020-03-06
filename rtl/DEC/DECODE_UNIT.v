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
  // Instruction coding inputs
  input [4:0] opcode_in,
  input [2:0] funct3_in,
  input [6:0] funct7_in,

  // Execution unit selection bus
  output [2:0] exec_unit_sel_out,
  output [3:0] exec_unit_uop_out,

  // PC src mux selection signal
  output pc_mux_sel_out,

  // Immediate mux selection signal
  output imm_mux_sel_out,

  // ================================================================
  // Register selection will be moved directly to GPR module
  // ================================================================
  input [4:0] rs1_in,
  input [4:0] rs2_in,
  input [4:0] rd_in,
  output [4:0] dec_gpr_src_a_out,
  output [4:0] dec_gpr_src_b_out,
  output [4:0] dec_gpr_des_out
  // ================================================================
);

// ==========================
// RISC-V OUTPUT LOGIC
// ==========================
// opcode = ins[6:0]
// funct3 = ins[14:12]
// funct7 = ins[31:25]
//
// rs1 = ins[19:15]
// rs2 = ins[24:20]
// rd = ins[11:7]
// ==========================

// Parameter definition
parameter ALU_EXEC_SEL = 3'b001;
parameter LSU_EXEC_SEL = 3'b010;
parameter VEC_EXEC_SEL = 3'b100;

// Registers definition
reg [2:0] exec_sel_reg;

// ====================================
// COMBINATIONAL LOGIC
// ====================================
always@(*) begin
  // Execution unit selection
  if (opcode_in == 5'b00000 || opcode_in == 5'b01000)
    exec_sel_reg = LSU_EXEC_SEL;
  else if (opcode_in == 5'b10101)
    exec_sel_reg = VEC_EXEC_SEL;
  else // if (...)
    exec_sel_reg = ALU_EXEC_SEL;
  // else
  //   exec_sel_reg = 3'b000;

  // uOp generation

  // Will use PC value?

  // Will use an immediate value?

end


// Execution unit selection output
assign exec_unit_sel_out = exec_sel_reg;
assign exec_unit_uop_out = 4'b1010;

// General purpose registers output
assign dec_gpr_src_a_out = rs1_in;
assign dec_gpr_src_b_out = rs2_in;
assign dec_gpr_des_out = rd_in;

endmodule
