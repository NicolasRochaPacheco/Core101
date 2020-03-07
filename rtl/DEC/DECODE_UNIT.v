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


// ====================================
// Parameter definition
// ====================================
// Opcode in possible values
parameter LOAD = 5'b00000;
parameter OPIMM = 5'b00100;
parameter AUIPC = 5'b00101;
parameter STORE = 5'b01000;
parameter OP = 5'b01100;
parameter LUI = 5'b01101;
parameter BRANCH = 5'b11000;
parameter JALR = 5'b11001;
parameter JAL = 5'b11011;
parameter SYSTEM = 5'b11100;
parameter OPV = 5'b10101;

// Execution unit selection values
parameter ALU_EXEC_SEL = 3'b001;
parameter LSU_EXEC_SEL = 3'b010;
parameter VEC_EXEC_SEL = 3'b100;
// ====================================


// ====================================
// Registers definition
// ====================================
reg [2:0] exec_sel_reg;
reg pc_mux_sel_reg;
reg imm_mux_sel_reg;
// ====================================


// ====================================
// COMBINATIONAL LOGIC
// ====================================
always@(*) begin

  // Execution unit selection.
  // LSU opcode: LOAD, STORE
  // INT opcode: E.E.
  // VEC opcode: OP-V
  case(opcode_in)
    LOAD:     exec_sel_reg = LSU_EXEC_SEL;
    STORE:    exec_sel_reg = LSU_EXEC_SEL;
    OPV:      exec_sel_reg = VEC_EXEC_SEL;
    default:  exec_sel_reg = 3'b000; // No opcode identified. Raises exception
  endcase

  // uOp generation

  // Will use PC value? opcodes: AUIPC, JAL, JALR, BRANCH
  case(opcode_in)
    AUIPC:    pc_mux_sel_reg = 1'b1;
    JAL:      pc_mux_sel_reg = 1'b1;
    JALR:     pc_mux_sel_reg = 1'b1;
    BRANCH:   pc_mux_sel_reg = 1'b1;
    default:  pc_mux_sel_reg = 1'b0;
  endcase

  // Will use an immediate value? opcodes: LOAD, STORE, OP-IMM, JAL, JALR, AUIPC, LUI
  case(opcode_in)
    LOAD:     imm_mux_sel_reg = 1'b1;
    STORE:    imm_mux_sel_reg = 1'b1;
    OPIMM:    imm_mux_sel_reg = 1'b1;
    JAL:      imm_mux_sel_reg = 1'b1;
    JALR:     imm_mux_sel_reg = 1'b1;
    AUIPC:    imm_mux_sel_reg = 1'b1;
    LUI:      imm_mux_sel_reg = 1'b1;
    default:  imm_mux_sel_reg = 1'b0; // E.E.
  endcase
end


// ====================================
// OUTPUT LOGIC
// ====================================
// Execution unit selection output
assign exec_unit_sel_out = exec_sel_reg;
assign exec_unit_uop_out = 4'b1010;

// PC mux selection output
assign pc_mux_sel_out = pc_mux_sel_reg;

// Immediate value selection output
assign imm_mux_sel_out = imm_mux_sel_reg;

// ====================================
// General purpose registers output. To be deprecated
assign dec_gpr_src_a_out = rs1_in;
assign dec_gpr_src_b_out = rs2_in;
assign dec_gpr_des_out = rd_in;
// ====================================

endmodule
