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
  input [4:0] dec_opcode_in,
  input [2:0] dec_funct3_in,
  input [6:0] dec_funct7_in,

  output dec_imm_mux_sel_out,     // Immediate mux selection signal
  output dec_pc_mux_sel_out,      // PC src mux selection signal
  output dec_rd_write_enable_out, // Enable a write on RD
  output dec_rd_data_sel_out,     // Data selection sel signal for RD
  output dec_jump_sel_out,        // Jump MUX sel signal

  // Exceptions signals
  output dec_invalid_ins_exception,

  // Execution unit selection bus
  output [3:0] dec_exec_unit_sel_out,
  output [3:0] dec_exec_unit_uop_out

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
parameter LOAD = 5'b00000;   // E U
parameter OPIMM = 5'b00100;  // E U
parameter AUIPC = 5'b00101;  // E U
parameter STORE = 5'b01000;  // E U
parameter OP = 5'b01100;     // E U
parameter LUI = 5'b01101;    // E U
parameter BRANCH = 5'b11000; // E U*
parameter JALR = 5'b11001;   // E
parameter JAL = 5'b11011;    // E
parameter SYSTEM = 5'b11100; // E
parameter OPV = 5'b10101;    // E

// Execution unit selection
parameter INT_EXEC_SEL = 4'b0001;
parameter BRU_EXEC_SEL = 4'b0010;
parameter LSU_EXEC_SEL = 4'b0100;
parameter VEC_EXEC_SEL = 4'b1000;
// ====================================


// ====================================
// Registers definition
// ====================================
reg [3:0] exec_sel_reg;
reg [3:0] exec_uop_reg;
reg pc_mux_sel_reg;
reg imm_mux_sel_reg;
// ====================================

wire rd_write_wire;     //
wire rd_data_sel_wire;  //
wire jump_sel_wire;

// ====================================
// COMBINATIONAL LOGIC
// ====================================
always@(*) begin

  // Execution unit selection.
  // LSU opcode: LOAD, STORE
  // INT opcode: E.E.
  // VEC opcode: OP-V
  case(dec_opcode_in)
    LOAD:     exec_sel_reg = LSU_EXEC_SEL;
    STORE:    exec_sel_reg = LSU_EXEC_SEL;
    OPV:      exec_sel_reg = VEC_EXEC_SEL;
    OPIMM:    exec_sel_reg = INT_EXEC_SEL;
    AUIPC:    exec_sel_reg = INT_EXEC_SEL;
    OP:       exec_sel_reg = INT_EXEC_SEL;
    LUI:      exec_sel_reg = INT_EXEC_SEL;
    BRANCH:   exec_sel_reg = BRU_EXEC_SEL;
    JAL:      exec_sel_reg = INT_EXEC_SEL;
    JALR:     exec_sel_reg = INT_EXEC_SEL;
    SYSTEM:   exec_sel_reg = INT_EXEC_SEL;
    default:  exec_sel_reg = 4'b0000; // No opcode identified. Raises exception
  endcase

  // uOp generation. The hard one
  case(dec_opcode_in)
    // OP opcode.
    OP:       begin
                case(dec_funct3_in)
                  3'b000: if (dec_funct7_in == 7'b0000000)
                              exec_uop_reg = 4'b0000; // ADD on INT_EXEC
                          else if (dec_funct7_in == 7'b0100000)
                              exec_uop_reg = 4'b0001; // SUB on INT_EXEC
                  3'b001: exec_uop_reg = 4'b1111;     // SLL on INT_EXEC
                  3'b010: exec_uop_reg = 4'b1010;     // SLT on INT_EXEC
                  3'b011: exec_uop_reg = 4'b1011;     // SLTU on INT_EXEC
                  3'b100: exec_uop_reg = 4'b0100;     // XOR on INT_EXEC
                  3'b101: if (dec_funct7_in == 7'b0000000)
                            exec_uop_reg = 4'b1110;   // SRL on INT_EXEC
                          else
                            exec_uop_reg = 4'b1101;   // SRA on INT_EXEC
                  3'b110: exec_uop_reg = 4'b0010;     // OR on INT_EXEC
                  3'b111: exec_uop_reg = 4'b0011;     // AND on INT_EXEC
                endcase
              end

    // OP-IMM opcode
    OPIMM:    case(dec_funct3_in)
                3'b000: exec_uop_reg = 4'b0000; // ADD on INT_EXEC
                3'b001: exec_uop_reg = 4'b1111; // SLL on INT_EXEC
                3'b010: exec_uop_reg = 4'b1010; // SLT on INT_EXEC
                3'b011: exec_uop_reg = 4'b1011; // SLTU on INT_EXEC
                3'b100: exec_uop_reg = 4'b0100; // XOR on INT_EXEC
                3'b101: if (dec_funct7_in == 7'b0000000)
                          exec_uop_reg = 4'b1110; // SRL on INT_EXEC
                        else
                          exec_uop_reg = 4'b1101; // SRA on INT_EXEC
                3'b110: exec_uop_reg = 4'b0010; // OR on INT_EXEC
                3'b111: exec_uop_reg = 4'b0011; // AND on INT_EXEC
              endcase

    // LOAD opcode
    LOAD:     case(dec_funct3_in)
                3'b000:   exec_uop_reg = 4'b0001; // LB on LSU_EXEC
                3'b001:   exec_uop_reg = 4'b0010; // LH on LSU_EXEC
                3'b010:   exec_uop_reg = 4'b0011; // LW on LSU_EXEC
                3'b100:   exec_uop_reg = 4'b0101; // LBU on LSU_EXEC
                3'b101:   exec_uop_reg = 4'b0110; // LHU on LSU_EXEC
                default:  exec_uop_reg = 4'b0000; // funct3 not valid. Raises exception.
              endcase

    // STORE opcode
    STORE:    case(dec_funct3_in)
                3'b000:   exec_uop_reg = 4'b1001; // SB on LSU_EXEC
                3'b001:   exec_uop_reg = 4'b1010; // SH on LSU_EXEC
                3'b010:   exec_uop_reg = 4'b1100; // SW on LSU_EXEC
                default   exec_uop_reg = 4'b0000; // funct3 not valid. Raises exception.
              endcase

    // BRANCH opcode
    BRANCH:   case(dec_funct3_in)
                3'b000:   exec_uop_reg = 4'b0000; // BEQ on BRU_EXEC
                3'b001:   exec_uop_reg = 4'b0001; // BNE on BRU_EXEC
                3'b100:   exec_uop_reg = 4'b0010; // BLT on BRU_EXEC
                3'b101:   exec_uop_reg = 4'b0011; // BGE on BRU_EXEC
                3'b110:   exec_uop_reg = 4'b0110; // BLTU on BRU_EXEC
                3'b111:   exec_uop_reg = 4'b0111; // BGEU on BRU_EXEC
                default:  exec_uop_reg = 4'b1111; // funct3 not valid. Raises exception.
              endcase

    // JAL opcode
    JAL:      exec_uop_reg = 4'b1000;

    // JALR opcode
    JALR:     exec_uop_reg = 4'b0000;

    // LUI opcode
    LUI:      exec_uop_reg = 4'b1001; // LUI on INT_EXEC (buffer rs2)

    // AUIPC opcode
    AUIPC:    exec_uop_reg = 4'b0000; // ADD on INT_EXEC


    default: exec_uop_reg = 4'b0000;
  endcase

  // Will use PC value?
  // opcodes: AUIPC, JAL, JALR, BRANCH
  case(dec_opcode_in)
    AUIPC:    pc_mux_sel_reg = 1'b1;
    JAL:      pc_mux_sel_reg = 1'b1;
    JALR:     pc_mux_sel_reg = 1'b0;
    BRANCH:   pc_mux_sel_reg = 1'b0;
    default:  pc_mux_sel_reg = 1'b0; // E.E.
  endcase

  // Will use an immediate value?
  // opcodes: LOAD, STORE, OP-IMM, JAL, JALR, AUIPC, LUI
  case(dec_opcode_in)
    LOAD:     imm_mux_sel_reg = 1'b1;
    STORE:    imm_mux_sel_reg = 1'b1;
    OPIMM:    imm_mux_sel_reg = 1'b1;
    JAL:      imm_mux_sel_reg = 1'b0;
    JALR:     imm_mux_sel_reg = 1'b1;
    AUIPC:    imm_mux_sel_reg = 1'b1;
    LUI:      imm_mux_sel_reg = 1'b1;
    BRANCH:   imm_mux_sel_reg = 1'b0;
    default:  imm_mux_sel_reg = 1'b0; // E.E.
  endcase

  // Will writeback on a register?
  // opcodes: LOAD, OPV, OPIMM, AUIPC, OP, LUI, JAL, JALR
  case (dec_opcode_in)
    LOAD:   rd_write_wire = 1'b1;
    OPV:    rd_write_wire = 1'b1;
    OPIMM:  rd_write_wire = 1'b1;
    AUIPC:  rd_write_wire = 1'b1;
    OP:     rd_write_wire = 1'b1;
    LUI:    rd_write_wire = 1'b1;
    JAL:    rd_write_wire = 1'b1;
    JALR:   rd_write_wire = 1'b1;
    BRANCH: rd_write_wire = 1'b0;
    default:rd_write_wire = 1'b0;
  endcase

  // Will write a data value or will write PC+4?
  case(dec_opcode_in)
    JAL:    rd_data_sel_wire = 1'b1;  //
    JALR:   rd_data_sel_wire = 1'b1;  //
    default: rd_data_sel_wire = 1'b0; // E.E.
  endcase

  // Is it a jump (JALR)
  case (dec_opcode_in)
    JALR: jump_sel_wire = 1'b1;
    default: jump_sel_wire = 1'b0;
  endcase

end


// ====================================
// OUTPUT LOGIC
// ====================================
// Execution unit selection output
assign dec_exec_unit_sel_out = exec_sel_reg;
assign dec_exec_unit_uop_out = exec_uop_reg;

// PC mux selection output
assign dec_pc_mux_sel_out = pc_mux_sel_reg;
assign dec_rd_write_enable_out = rd_write_wire;
assign dec_rd_data_sel_out = rd_data_sel_wire;
assign dec_jump_sel_out = jump_sel_wire;

// Immediate value selection output
assign dec_imm_mux_sel_out = imm_mux_sel_reg;

endmodule
