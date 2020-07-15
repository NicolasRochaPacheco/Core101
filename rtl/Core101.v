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
  input clock_in,
  input reset_in,

  input [31:0] ins_mem_data_in,
  output [31:0] ins_mem_addr_out,

  // Debug from IF/ID
  output if_id_prediction_out,
  output [31:0] ir_data_if_id_out,
  output [31:0] pc_data_if_id_out,

  // Debug from ID/IS
  output [1:0] id_is_fwd_out,
  output [31:0] imm_id_is_data_out,
  output [31:0] pc_id_is_data_out,

  // Debug from IS/EX
  output bru_enable_out,
  output branch_taken_out,
  output rd_write_enable_out,
  output jump_mux_sel_out,
  output [3:0] int_uop_out,
  output [3:0] lsu_uop_out,
  output [3:0] vec_uop_out,
  output [3:0] bru_uop_out,
  output [4:0] rd_addr_ex_wb_out,
  output [31:0] wb_data_out,
  output [31:0] ex_a_data_out,
  output [31:0] ex_b_data_out,

  output [31:0] jump_target_wb_out
);

//---------------------------
//  WIRE DEFINITION
//---------------------------

// Pipeline registers
wire [64:0] if_id_reg_data_wire;
wire [94:0] id_is_reg_data_wire;
wire [160:0] is_ex_reg_data_wire;
wire [71:0] ex_wb_reg_data_wire;

// IFU
wire jump_mux_sel_wire;
wire branch_mux_sel_wire;
wire [31:0] branch_addr_wire;
wire [31:0] jump_addr_wire;
wire [31:0] pc_addr_wire;
wire [31:0] ir_data_wire;

// Branch predictor
wire pred_taken_wire;
wire [31:0] pred_target_wire;

// Decode signal
wire pc_mux_sel_wire;
wire imm_mux_sel_wire;
wire rd_write_enable_wire;
wire rd_mux_sel_wire;
wire dec_jump_sel_wire;
wire [3:0] exec_unit_uop_wire;
wire [3:0] exec_unit_sel_wire;

// Forwarding unit
wire [1:0] fwd_mux_sel_wire;

// Immediate generator
wire [31:0] imm_data_wire;

// General purpose registers
wire [31:0] rs1_data_wire;
wire [31:0] rs2_data_wire;

// Issue unit
wire int_enable_wire;
wire lsu_enable_wire;
wire vec_enable_wire;
wire bru_enable_wire;
wire [3:0] int_uop_wire;
wire [3:0] lsu_uop_wire;
wire [3:0] vec_uop_wire;
wire [3:0] bru_uop_wire;

// EX FWD MUX wires
wire [31:0] fwd_mux_a_data_wire;
wire [31:0] fwd_mux_b_data_wire;
wire [31:0] a_data_wire;
wire [31:0] b_data_wire;

// BRU
wire bru_flush_wire;
wire taken_wire;
wire branch_enable_wire;
wire bru_ifu_mux_sel_wire;
wire [31:0] bru_target_address_wire;

// Integer execution unit
wire [31:0] int_exec_result_wire;

// Load/Store Execution Unit
wire [31:0] lsu_exec_result_wire;

// EX output MUX
wire [31:0] ex_result_wire;

// PC INC on WB
wire [31:0] wb_pc_inc_wire;

// Output encoder SEL signal
wire [1:0] ex_encoder_sel_wire;

// Output MUX
wire [31:0] writeback_wire;

// Jump MUX
wire [31:0] jump_mux_pc_wire;

// Control unit
wire [3:0] pipeline_reset_wire;

//---------------------------
// FETCH STAGE
//---------------------------

// Instruction fetch unit module
IFU ifu0(
  .ifu_clock_in(clock_in),                // Clock input.
  .ifu_reset_in(reset_in),                // Reset input.
  .ifu_pc_set_in(1'b1),                   // PC set input.
  .ifu_ir_set_in(1'b1),                   // IR set input.
  .ifu_jump_sel_in(bru_ifu_mux_sel_wire|ex_wb_reg_data_wire[71]), // Jump MUX sel.
  .ifu_jump_in(jump_mux_pc_wire),  // Jump PC address input.
  .ifu_branch_sel_in(pred_taken_wire),    // Prediction MUX sel.
  .ifu_branch_in(pred_target_wire),       // Prediction PC target input.
  .ifu_ir_data_in(ins_mem_data_in),       // IR data input
  .ifu_pc_addr_out(pc_addr_wire),         // PC data output
  .ifu_ir_data_out(ir_data_wire)          // IR data input
);

// Branch predictor and return address buffer
PREDICTOR pred0 (
  .pred_clock_in(clock_in),                   // Clock input
  .pred_reset_in(reset_in),                   // Reset input
  .pred_write_enable_in(branch_enable_wire),  // From BRU (EX)
  .pred_taken_in(taken_wire),           // From BRU (EX)
  .pred_indx_in(is_ex_reg_data_wire[9:0]),  // From BRU (IS/EX)
  .pred_ins_in(ir_data_wire),           // IR data input
  .pred_addr_in(pc_addr_wire),          // PC addr input
  .pred_taken_out(pred_taken_wire),     // To IFU and IF/ID
  .pred_pc_out(pred_target_wire)        // To IFU
);

// Instruction fetch/instruction decode (IF/ID) pipeline register
REG #(.DATA_WIDTH(65)) if_id_reg (
  .clock_in(clock_in),                  // Clock input
  .reset_in(pipeline_reset_wire[3]),       // Reset signal or flush signal
  .set_in(1'b1),                        // Set signal
  .data_in( { pred_taken_wire,          // Prediction signal
              ir_data_wire,             // IR data
              pc_addr_wire}),           // PC addr
  .data_out(if_id_reg_data_wire)        // IF/ID data output
);


//---------------------------
// DECODE STAGE
//---------------------------

// Main decode unit
DECODE_UNIT decode0 (
  .dec_opcode_in(if_id_reg_data_wire[38:34]),     // OPCODE input
  .dec_funct3_in(if_id_reg_data_wire[46:44]),     // FUNCT3 field input
  .dec_funct7_in(if_id_reg_data_wire[63:57]),     // FUNCT7 field input
  .dec_pc_mux_sel_out(pc_mux_sel_wire),           // PC SEL signal output
  .dec_imm_mux_sel_out(imm_mux_sel_wire),         // IMM SEL signal output
  .dec_rd_write_enable_out(rd_write_enable_wire), // Write enable signal output
  .dec_rd_data_sel_out(rd_mux_sel_wire),
  .dec_jump_sel_out(dec_jump_sel_wire),            //
  .dec_invalid_ins_exception(),
  .dec_exec_unit_uop_out(exec_unit_uop_wire),     // EXEC uOP output
  .dec_exec_unit_sel_out(exec_unit_sel_wire)      // EXEC SEL output
);

// Forwarding unit
FORWARDING_UNIT fwd_unit0 (
  .fwd_if_ra_addr_in(if_id_reg_data_wire[51:47]), // RS1 from ID
  .fwd_if_rb_addr_in(if_id_reg_data_wire[56:52]), // RS2 from ID
  .fwd_id_rd_addr_in(id_is_reg_data_wire[68:64]), // RD from IS
  .fwd_mux_sel_out(fwd_mux_sel_wire)              // MUX signals output
);

// Immediate generator unit
IMM_GEN imm_gen0 (
  .imm_gen_opcode_in(if_id_reg_data_wire[38:34]), // OPCODE input
  .imm_gen_ins_in(if_id_reg_data_wire[63:39]),    // Instruction input
  .imm_gen_data_out(imm_data_wire)                // Generated immediate output
);

// Instruction decode/instruction issue (ID/IS) pipeline register
REG #(.DATA_WIDTH(95)) id_is_reg (
  .clock_in(clock_in),                            // Clock input
  .reset_in(pipeline_reset_wire[2]),              // Reset or flush signal
  .set_in(1'b1),
  .data_in({  if_id_reg_data_wire[64],            // Prediction bit [94]
              dec_jump_sel_wire,                  // Jump MUX sel wire [93]
              rd_mux_sel_wire,                    // RD data or PC INC [92]
              rd_write_enable_wire,               // RD write enable [91]
              imm_mux_sel_wire,                   // IMM or RS2 [90]
              pc_mux_sel_wire,                    // PC or RS1 [89]
              fwd_mux_sel_wire,                   // FWD MUX selection [88:87]
              exec_unit_sel_wire,                 // EXEC unit uOP [86:83]
              exec_unit_uop_wire,                 // EXEC unit sel [82:79]
              if_id_reg_data_wire[56:52],         // RS2 [78:74]
              if_id_reg_data_wire[51:47],         // RS1 [73:69]
              if_id_reg_data_wire[43:39],         // RD [68:64]
              imm_data_wire,                      // IMM [63:32]
              if_id_reg_data_wire[31:0]}),        // PC [31:0]
  .data_out(id_is_reg_data_wire)                  // Data output
);

// ---------------------------------
// ISSUE STAGE
// ---------------------------------

// General purpose registers
GPR gpr0 (
  .clock_in(clock_in),
  .reset_in(reset_in),
  .write_enable_in(ex_wb_reg_data_wire[69]),
  .rs1_addr_in(id_is_reg_data_wire[73:69]),
  .rs2_addr_in(id_is_reg_data_wire[78:74]),
  .rd_addr_in(ex_wb_reg_data_wire[68:64]),
  .rs1_data_out(rs1_data_wire),
  .rs2_data_out(rs2_data_wire),
  .rd_data_in(writeback_wire)
);

// Issue unit
ISSUE_UNIT issue0 (
  .exec_unit_sel_in(id_is_reg_data_wire[86:83]),  //
  .exec_uop_in(id_is_reg_data_wire[82:79]),       //
  .int_enable_out(int_enable_wire),
  .vec_enable_out(vec_enable_wire),
  .lsu_enable_out(lsu_enable_wire),
  .bru_enable_out(bru_enable_wire),
  .int_exec_uop_out(int_uop_wire),
  .vec_exec_uop_out(vec_uop_wire),
  .lsu_exec_uop_out(lsu_uop_wire),
  .bru_exec_uop_out(bru_uop_wire)
);

// IS/EX pipeline register
REG #(.DATA_WIDTH(161)) is_ex_reg (
  .clock_in(clock_in),                        // Clock input
  .reset_in(pipeline_reset_wire[1]),                        // Reset input
  .set_in(1'b1),                              // Set signal input
  .data_in({  id_is_reg_data_wire[94],        // PREDICTION? [160]
              id_is_reg_data_wire[93],        // Jump MUX selection [159]
              id_is_reg_data_wire[92],        // PC INC? [158]
              id_is_reg_data_wire[91],        // RD write enable [157]
              id_is_reg_data_wire[90],        // RS2 or IMM [156]
              id_is_reg_data_wire[89],        // RS1 or PC [155]
              int_enable_wire,                // INT enable wire [154]
              lsu_enable_wire,                // LSU enable wire [153]
              vec_enable_wire,                // VEC enable wire [152]
              bru_enable_wire,                // BRU enable wire [151]
              id_is_reg_data_wire[88:87],     // FWD MUX selection [150:149]
              int_uop_wire,                   // INT uOP data [148:145]
              lsu_uop_wire,                   // LSU UOP data [144:141]
              vec_uop_wire,                   // VEC uOP data [140:137]
              bru_uop_wire,                   // BRU uOP data [136:133]
              id_is_reg_data_wire[68:64],     // RD [132:128]
              rs2_data_wire,                  // RS2 data [127:96]
              rs1_data_wire,                  // RS1 data [95:64]
              id_is_reg_data_wire[63:32],     // IMM data [63:32]
              id_is_reg_data_wire[31:0] }),   // PC value [31:0]
  .data_out(is_ex_reg_data_wire)
);

// ---------------------------------
// EXECUTION STAGE
// ---------------------------------

//
MUX_A #(.DATA_WIDTH(32)) mux_fwd_a (
  .data_sel_in(is_ex_reg_data_wire[149]),
  .a_data_src_in(is_ex_reg_data_wire[95:64]),
  .b_data_src_in(writeback_wire),
  .data_out(fwd_mux_a_data_wire)
);

//
MUX_A #(.DATA_WIDTH(32)) mux_fwd_b (
  .data_sel_in(is_ex_reg_data_wire[150]),
  .a_data_src_in(is_ex_reg_data_wire[127:96]),
  .b_data_src_in(writeback_wire),
  .data_out(fwd_mux_b_data_wire)
);

//
MUX_A pc_mux (
  .data_sel_in(is_ex_reg_data_wire[155]),
  .a_data_src_in(fwd_mux_a_data_wire),
  .b_data_src_in(is_ex_reg_data_wire[31:0]),
  .data_out(a_data_wire)
);

//
MUX_A imm_mux (
  .data_sel_in(is_ex_reg_data_wire[156]),
  .a_data_src_in(fwd_mux_b_data_wire),
  .b_data_src_in(is_ex_reg_data_wire[63:32]),
  .data_out(b_data_wire)
);

// Integer execution unit
INT_EXEC int_exec0 (
  .a_data_in(a_data_wire),
  .b_data_in(b_data_wire),
  .enable_in(is_ex_reg_data_wire[154]),
  .uop_in(is_ex_reg_data_wire[148:145]),
  .res_data_out(int_exec_result_wire)
);

// Load store unit
LSU_EXEC lsu_exec0 (
  .enable_in(is_ex_reg_data_wire[153]),
  .uop_in(),
  .a_data_in(),
  .b_data_in(),
  .res_data_out()
);

BRU bru_exec0 (
  .pred_in(is_ex_reg_data_wire[160]),     // Prediction input
  .enable_in(is_ex_reg_data_wire[151]),   // Enable input
  .uop_in(is_ex_reg_data_wire[136:133]),  // uOP input
  .pc_in(is_ex_reg_data_wire[31:0]),      // Program counter address
  .rs1_in(a_data_wire),                   // R[rs1] data input
  .rs2_in(b_data_wire),                   // R[rs2] data input
  .imm_in(is_ex_reg_data_wire[63:32]),    // Immediate value.
  .flush_out(bru_flush_wire),             // Flush signal output
  .taken_out(taken_wire),                 // High if a branch was taken
  .enable_out(branch_enable_wire),        // Enable signal for predictor
  .mux_out(bru_ifu_mux_sel_wire),         // PC mux selection output
  .target_out(bru_target_address_wire)    // PC new address output
);

// MEncoder used for selecting the appropriate output value
ENCODE_B ex_encoder0 (
  .data_in(is_ex_reg_data_wire[154:151]),
  .data_out(ex_encoder_sel_wire)
);

// Output selection
MUX_B ex_out_mux0 (
  .data_sel_in(ex_encoder_sel_wire),
  .a_data_src_in(int_exec_result_wire),
  .b_data_src_in(lsu_exec_result_wire),
  .c_data_src_in(),
  .d_data_src_in(),
  .data_out(ex_result_wire)
);

// IS/EX pipeline register
REG #(.DATA_WIDTH(72)) ex_wb_reg (
  .clock_in(clock_in),                        // Clock input
  .reset_in(pipeline_reset_wire[0]),                        // Reset input
  .set_in(1'b1),                              // Set signal input
  .data_in({  is_ex_reg_data_wire[159],       // Jump MUX sel signal [71]
              is_ex_reg_data_wire[158],       // EX or PC INC? [70]
              is_ex_reg_data_wire[157],       // Write enable for RD [69]
              is_ex_reg_data_wire[132:128],   // RD address [68:64]
              ex_result_wire,                 // EX result wire [63:32]
              is_ex_reg_data_wire[31:0]}),    // PC value [31:0]
  .data_out(ex_wb_reg_data_wire)
);

// ---------------------------------
// WRITEBACK STAGE
// ---------------------------------

ADDER wb_pc_inc0 (
  .a_operand_in(ex_wb_reg_data_wire[31:0]),
  .b_operand_in(32'h00000004),
  .add_result_out(wb_pc_inc_wire)
);

MUX_A jump_mux (
  .data_sel_in(ex_wb_reg_data_wire[71]),
  .a_data_src_in(bru_target_address_wire),
  .b_data_src_in(ex_wb_reg_data_wire[63:32]),
  .data_out(jump_mux_pc_wire)
);

MUX_A ex_mux (
  .data_sel_in(ex_wb_reg_data_wire[70]),
  .a_data_src_in(ex_wb_reg_data_wire[63:32]),
  .b_data_src_in(wb_pc_inc_wire),
  .data_out(writeback_wire)
);

// ---------------------------------
// CONTROL UNIT
// ---------------------------------
CONTROL control0 (
  .reset_in(reset_in),
  .bru_flush_in(bru_flush_wire),
  .jump_flush_in(ex_wb_reg_data_wire[71]),
  .pipeline_reset_out(pipeline_reset_wire)
);

// Memory interface output
assign ins_mem_addr_out = pc_addr_wire;

// Debug for IF stage
assign if_id_prediction_out = if_id_reg_data_wire[64];
assign pc_data_if_id_out = if_id_reg_data_wire[31:0];
assign ir_data_if_id_out = if_id_reg_data_wire[63:32];

// Debug for ID stage
assign id_is_fwd_out = id_is_reg_data_wire[88:87];
assign imm_id_is_data_out = id_is_reg_data_wire[63:32];
assign pc_id_is_data_out = id_is_reg_data_wire[31:0];

assign int_uop_out = is_ex_reg_data_wire[148:145];
assign lsu_uop_out = is_ex_reg_data_wire[144:141];
assign vec_uop_out = is_ex_reg_data_wire[140:137];
assign bru_uop_out = is_ex_reg_data_wire[136:133];
assign bru_enable_out = is_ex_reg_data_wire[151];
assign branch_taken_out = 1'b0;
assign ex_a_data_out = a_data_wire;
assign ex_b_data_out = b_data_wire;

// Debug for IS/EX pipeline

// Debug for EX/WB pipeline register
assign jump_mux_sel_out = ex_wb_reg_data_wire[71];
assign rd_write_enable_out = ex_wb_reg_data_wire[69];
assign rd_addr_ex_wb_out = ex_wb_reg_data_wire[68:64];
assign wb_data_out = writeback_wire;
assign jump_target_wb_out = jump_mux_pc_wire;

endmodule
