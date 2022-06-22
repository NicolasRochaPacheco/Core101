// Core101 module definition
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



module Core101 (
  // Clock and reset in
  input clock_in,
  input reset_in,

  // Instruction memory interface
  output ins_mem_valid_out,
  output [31:0] ins_mem_addr_out,
  input ins_mem_ready_in,
  input [31:0] ins_mem_data_in,

  // Data memory interface
  output data_mem_valid_out,
  output data_mem_write_out,
  output [31:0] data_mem_addr_out,
  output [31:0] data_mem_data_out,
  input data_mem_ready_in,
  input [31:0] data_mem_data_in
);

// =======================================================================
// ISA width parameter definition
parameter XLEN = 32;

// Pipeline registers width definition
parameter PC_IF_WIDTH = 33;
parameter IF_DEC_WIDTH = 65;
parameter DEC_REG_WIDTH = 95;
parameter REG_EX_WIDTH = 161;
parameter EX_WB_WIDTH = 10;
// =======================================================================

// =======================================================================

// Program counter calculation
wire pc_calc_pred_wire;
wire [31:0] pc_calc_addr_wire;

// PC/IF pipeline register
wire [PC_IF_WIDTH-1:0] pc_if_pipeline_data_wire;

// Predictor
wire predictor_pred_enable_wire;
wire [31:00] predictor_pred_addr_wire;

// IF/DEC
wire [IF_DEC_WIDTH-1:0] if_dec_pipeline_data_wire;

// Forwarding unit
wire [1:0] fwd_mux_sel_wire;

// Immediate generation
wire [XLEN-1:0] imm_gen_data_wire;

// Decode unit
wire decode_imm_mux_sel_wire;
wire decode_pc_mux_sel_wire;
wire decode_rd_write_en_wire;
wire decode_rd_mux_sel_wire;
wire decode_jump_mux_sel_wire;
wire decode_invalid_ins_wire;
wire [3:0] decode_exec_unit_sel_wire;
wire [3:0] decode_exec_uop_sel_wire;

// DEC/REG pipeline register
wire [DEC_REG_WIDTH-1:0] dec_reg_pipeline_data_wire;

// General purpose registers
wire [XLEN-1:0] gpr_rs1_data_wire;
wire [XLEN-1:0] gpr_rs2_data_wire;

// Issue unit
wire issue_int_en_wire;
wire issue_vec_en_wire;
wire issue_lsu_en_wire;
wire issue_bru_en_wire;
wire [3:0] issue_int_uop_wire;
wire [3:0] issue_vec_uop_wire;
wire [3:0] issue_lsu_uop_wire;
wire [3:0] issue_bru_uop_wire;

// REG/EX pipeline register
wire [REG_EX_WIDTH-1:0] reg_ex_pipeline_data_wire;

// FWD MUXes
wire [XLEN-1:0] fwd_mux_rs1_data_wire;
wire [XLEN-1:0] fwd_mux_rs2_data_wire;

// PC_MUX and IMM_MUX
wire [XLEN-1:0] pc_mux_data_wire;
wire [XLEN-1:0] imm_mux_data_wire;

// Branch resolver unit
wire bru_pipeline_flush_wire;
wire bru_predictor_taken_wire;
wire bru_predictor_en_wire;
wire bru_pc_enable_wire;
wire [XLEN-1:0] bru_pc_address_wire;

// Arithmetic/Logic Unit
wire [XLEN-1:0] alu_result_wire;

// Load/Store Unit
wire [3:0] lsu_mem_op_wire;
wire [XLEN-1:0] lsu_data_wire;
wire [XLEN-1:0] lsu_addr_wire;
wire [XLEN-1:0] lsu_result_wire;

// EX/WB pipeline register
wire [EX_WB_WIDTH-1:0] ex_wb_pipeline_data_wire;

// Pipeline control wire definition
wire pipeline_ins_mem_valid_wire;

wire pipeline_pc_if_set_wire;
wire pipeline_if_dec_set_wire;
wire pipeline_dec_reg_set_wire;
wire pipeline_reg_ex_set_wire;
wire pipeline_ex_wb_set_wire;

wire pipeline_pc_if_clear_wire;
wire pipeline_if_dec_clear_wire;
wire pipeline_dec_reg_clear_wire;
wire pipeline_reg_ex_clear_wire;
wire pipeline_ex_wb_clear_wire;
// =======================================================================

// Program counter calculation
PC_CALC #(.XLEN(XLEN)) pc_calc (

  .pc_calc_correction_en_in(bru_pc_enable_wire),
  .pc_calc_prediction_en_in(predictor_pred_enable_wire),

  .pc_calc_current_in(pc_if_pipeline_data_wire[XLEN-1:0]),

  .pc_calc_correction_in(bru_pc_address_wire),
  .pc_calc_prediction_in(predictor_pred_addr_wire),

  .pc_calc_addr_out(pc_calc_addr_wire),
  .pc_calc_pred_out(pc_calc_pred_wire)
);


// PC/IF pipeline register
REG #(.DATA_WIDTH(PC_IF_WIDTH)) pc_if_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_pc_if_clear_wire),
  .reg_set_in(pipeline_pc_if_set_wire),
  .reg_data_in({
      pc_calc_pred_wire,  // [32]   Prediction flag
      pc_calc_addr_wire   // [31:0] PC
    }),
  .reg_data_out(pc_if_pipeline_data_wire)
);

// Assigns instruction memory address output
assign ins_mem_addr_out = pc_if_pipeline_data_wire[XLEN-1:0];
assign ins_mem_valid_out = pipeline_ins_mem_valid_wire;

// Branch predictor
PREDICTOR predictor0 (
  .predictor_clock_in(clock_in),
  .predictor_reset_in(reset_in),

  .predictor_pred_addr_in(pc_if_pipeline_data_wire[XLEN-1:0]),
  .predictor_pred_enable_out(predictor_pred_enable_wire),
  .predictor_pred_addr_out(predictor_pred_addr_wire),

  .predictor_feedback_result_in(),
  .predictor_feedback_write_enable_in(),
  .predictor_feedback_addr_in(),
  .predictor_feedback_return_in()
);

// IF/DEC pipeline register
REG #(.XLEN(IF_DEC_WIDTH)) if_dec_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_if_dec_clear_wire),
  .reg_set_in(pipeline_if_dec_set_wire),
  .reg_data_in({
      pc_if_pipeline_data_wire[XLEN],     // [64]    PRED flag
      ins_mem_data_in,                    // [63:32] IR value
      pc_if_pipeline_data_wire[XLEN-1:0]  // [31:00] PC value
    }),
  .reg_data_out(if_dec_pipeline_data_wire)
);


// Forwarding unit
FORWARDING_UNIT forwarding_unit0 (
  .fwd_if_ra_addr_in(if_dec_pipeline_data_wire[51:47]), // RS1 on ID
  .fwd_if_rb_addr_in(if_dec_pipeline_data_wire[56:52]), // RS2 on ID
  .fwd_id_rd_addr_in(if_dec_pipeline_data_wire[43:39]), // RD on IS
  .fwd_mux_sel_out(fwd_mux_sel_wire)                    // FWD MUX values
);

// Immediate generation
IMM_GEN imm_gen (
  .imm_gen_opcode_in(if_dec_pipeline_data_wire[38:32]), // INS[6:0]
  .imm_gen_ins_in(if_dec_pipeline_data_wire[63:39]),
  .imm_gen_data_out(imm_gen_data_wire)
);

// Instruction decoding
DECODE_UNIT decode0 (
  .dec_opcode_in(if_dec_pipeline_data_wire[38:32]),     // INS[6:0]
  .dec_funct3_in(if_dec_pipeline_data_wire[46:44]),     // INS[14:12]
  .dec_funct7_in(if_dec_pipeline_data_wire[63:57]),     // INS[31:25]

  .dec_imm_mux_sel_out(decode_imm_mux_sel_wire),        // IMM_MUX sel
  .dec_pc_mux_sel_out(decode_pc_mux_sel_wire),          // PC_MUX sel
  .dec_rd_write_enable_out(decode_rd_write_en_wire),    // RD write enable
  .dec_rd_data_sel_out(decode_rd_mux_sel_wire),         // RD_MUX sel
  .dec_jump_sel_out(decode_jump_mux_sel_wire),          // JUMP_MUX sel

  // Exceptions signals
  .dec_invalid_ins_exception(decode_invalid_ins_wire),  // Invalid INS exception

  // Execution unit selection bus
  .dec_exec_unit_sel_out(decode_exec_unit_sel_wire),    // EXEC_UNIT sel
  .dec_exec_unit_uop_out(decode_exec_uop_sel_wire)      // EXEC_UNIT uOP
);

// DEC/REG pipeline register
REG #(.XLEN(DEC_REG_WIDTH)) dec_reg_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_dec_reg_clear_wire),
  .reg_set_in(pipeline_dec_reg_set_wire),
  .reg_data_in({
      if_dec_pipeline_data_wire[64],      // PRED flag [94]
      decode_jump_mux_sel_wire,           // JUMP_MUX sel [93]
      decode_rd_mux_sel_wire,             // RD_MUX sel [92]
      decode_rd_write_en_wire,            // RD write enable [91]
      decode_imm_mux_sel_wire,            // IMM_MUX sel  [90]
      decode_pc_mux_sel_wire,             // PC_MUX sel   [89]
      fwd_mux_sel_wire,                   // FWD_MUX sel  [88:87]
      decode_exec_unit_sel_wire,          // EXEC_UNIT sel [86:83]
      decode_exec_uop_sel_wire,           // EXEC_UNIT uOP [82:79]
      if_dec_pipeline_data_wire[56:52],   // RS2 [78:74]
      if_dec_pipeline_data_wire[51:47],   // RS1 [73:69]
      if_dec_pipeline_data_wire[43:39],   // RD [68:64]
      imm_gen_data_wire,                  // IMM [63:32]
      if_dec_pipeline_data_wire[31:0]     // PC [31:0]
    }),
  .reg_data_out(dec_reg_pipeline_data_wire)
);

// General purpose registers
GPR gpr0 (
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Data write interface
  .write_enable_in(),
  .rd_addr_in(),   // Drives set signal for rd
  .rd_data_in(),

  // Data read interface
  .rs1_addr_in(dec_reg_pipeline_data_wire[73:69]),  // Selects rs1 output data
  .rs2_addr_in(dec_reg_pipeline_data_wire[78:74]),  // Selects rs2 output data
  .rs1_data_out(gpr_rs1_data_wire),
  .rs2_data_out(gpr_rs2_data_wire)
);

// Issue unit
ISSUE_UNIT issue0 (
  // Execution unit selection bus
  .exec_unit_sel_in(dec_reg_pipeline_data_wire[86:83]),
  .exec_uop_in(dec_reg_pipeline_data_wire[82:79]),

  // Execution units enable signals
  .int_enable_out(issue_int_en_wire),
  .vec_enable_out(issue_vec_en_wire),
  .lsu_enable_out(issue_lsu_en_wire),
  .bru_enable_out(issue_bru_en_wire),

  // Execution units opcode
  .int_exec_uop_out(issue_int_uop_wire),
  .vec_exec_uop_out(issue_vec_uop_wire),
  .lsu_exec_uop_out(issue_lsu_uop_wire),
  .bru_exec_uop_out(issue_bru_uop_wire)
);

// REG/EX pipeline register
REG #(.XLEN(REG_EX_WIDTH)) reg_ex_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_reg_ex_clear_wire),
  .reg_set_in(pipeline_reg_ex_set_wire),
  .reg_data_in({
      dec_reg_pipeline_data_wire[94],     // PRED flag [160]
      dec_reg_pipeline_data_wire[93],     // JUMP_MUX [159]
      dec_reg_pipeline_data_wire[92],     // RD_MUX [158]
      dec_reg_pipeline_data_wire[91],     // RD write enable [157]
      dec_reg_pipeline_data_wire[90],     // IMM_MUX sel [156]
      dec_reg_pipeline_data_wire[89],     // PC_MUX sel [155]
      issue_int_en_wire,                  // INTe [154]
      issue_lsu_en_wire,                  // LSEe [153]
      issue_vec_en_wire,                  // VECe [152]
      issue_bru_en_wire,                  // BRUe [151]
      dec_reg_pipeline_data_wire[88:87],  // FWD_MUX [150:149]
      issue_int_uop_wire,                 // INTu [148:145]
      issue_lsu_uop_wire,                 // LSUu [144:141]
      issue_vec_uop_wire,                 // VECu [140:137]
      issue_bru_uop_wire,                 // BRUu [136:133]
      dec_reg_pipeline_data_wire[68:64],  // RD   [132:128]
      gpr_rs2_data_wire,                  // RS2  [127:96]
      gpr_rs1_data_wire,                  // RS1  [95:64]
      dec_reg_pipeline_data_wire[63:32],  // IMM  [63:32]
      dec_reg_pipeline_data_wire[31:0]    // PC   [31:0]
    }),
  .reg_data_out(reg_ex_pipeline_data_wire)
);

MUX_A rs1_fwd (
  .data_sel_in(reg_ex_pipeline_data_wire[149]),
  .a_data_src_in(reg_ex_pipeline_data_wire[95:64]),
  .b_data_src_in(),
  .data_out(fwd_mux_rs1_data_wire)
);

MUX_A rs2_fwd (
  .data_sel_in(reg_ex_pipeline_data_wire[150]),
  .a_data_src_in(reg_ex_pipeline_data_wire[127:96]),
  .b_data_src_in(),
  .data_out(fwd_mux_rs2_data_wire)
);

MUX_A pc_mux (
  .data_sel_in(reg_ex_pipeline_data_wire[155]),
  .a_data_src_in(fwd_mux_rs1_data_wire),
  .b_data_src_in(reg_ex_pipeline_data_wire[31:0]),
  .data_out(pc_mux_data_wire)
);

MUX_A imm_mux (
  .data_sel_in(reg_ex_pipeline_data_wire[156]),
  .a_data_src_in(fwd_mux_rs2_data_wire),
  .b_data_src_in(reg_ex_pipeline_data_wire[63:32]),
  .data_out(imm_mux_data_wire)
);

// Branch Resolver
BRU bru0 (
  .pred_in(),                      // Prediction input
  .enable_in(),                    // Enable input
  .uop_in(),                 // uOP input
  .pc_in(),       // Program counter address
  .rs1_in(),      // R[rs1] data input
  .rs2_in(),      // R[rs2] data input
  .imm_in(),      // Immediate value.
  .flush_out(),                   // Flush signal output
  .taken_out(),                   // Signal indicating if a branch was taken
  .enable_out(),                  // Enable signal for predictor
  .mux_out(),                     // PC mux selection output
  .target_out()  // PC new address output
);

// ALU
ALU alu0 (
  .a_data_in(pc_mux_data_wire),   // ALU_A
  .b_data_in(imm_mux_data_wire),  // ALU_B
  .uop_in(reg_ex_pipeline_data_wire[148:145]),  //
  .result_out(alu_result_wire)
);

// Load/Store Unit
LSU lsu0 (
  .lsu_enable_in(),                    // Enable signal input
  .lsu_uop_in(),                 // Input for uOP bus
  .lsu_a_data_in(),         // A input bus
  .lsu_b_data_in(),         // B input bus
  .lsu_c_data_in(),         // C input bus
  .lsu_mem_data_in(),       // Input memory bus
  .lsu_mem_op_out(),        // Memory opcode
  .lsu_result_out(),   // Result output data
  .lsu_mem_data_out(), // Output memory bus
  .lsu_mem_addr_out()  // Address memory bus
);

ENCODE_B ex_encoder0 (
  .data_in(),
  .data_out()
);

// Output selection
MUX_B ex_out_mux0 (
  .data_sel_in(),
  .a_data_src_in(),
  .b_data_src_in(),
  .c_data_src_in(),
  .d_data_src_in(),
  .data_out()
);

// EX/WB pipeline register
REG #() ex_wb_pipeline_reg (
  .reg_clock_in(clock_in),
  .reg_reset_in(reset_in),
  .reg_clear_in(pipeline_ex_wb_clear_wire),
  .reg_set_in(pipeline_ex_wb_set_wire),
  .reg_data_in(),
  .reg_data_out()
);



// ==================================================================

// Pipeline control
PIPELINE_CONTROL pipeline_control (

  // Clock and reset inputs
  .pipeline_clock_in(clock_in),
  .pipeline_reset_in(reset_in),

  .pipeline_correction_flag_in(),
  .pipeline_prediction_flag_in(),

  // Instruction memory interface control
  .pipeline_ins_mem_valid_out(pipeline_ins_mem_valid_wire),
  .pipeline_ins_mem_ready_in(ins_mem_ready_in),

  // Pipeline registers write enable
  .pipeline_pc_if_set_out(pipeline_pc_if_set_wire),
  .pipeline_if_dec_set_out(pipeline_if_dec_set_wire),
  .pipeline_dec_reg_set_out(pipeline_dec_reg_set_wire),
  .pipeline_reg_ex_set_out(pipeline_reg_ex_set_wire),
  .pipeline_ex_wb_set_out(pipeline_ex_wb_set_wire),

  //Pipeline registers clear
  .pipeline_pc_if_clear_out(pipeline_pc_if_clear_wire),
  .pipeline_if_dec_clear_out(pipeline_if_dec_clear_wire),
  .pipeline_dec_reg_clear_out(pipeline_dec_reg_clear_wire),
  .pipeline_reg_ex_clear_out(pipeline_reg_ex_clear_wire),
  .pipeline_ex_wb_clear_out(pipeline_ex_wb_clear_wire)
);



endmodule
