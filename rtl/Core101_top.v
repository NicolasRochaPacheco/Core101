// Core101 top module definition
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

module Core101_top(

  // Clock and reset
  input clock_in,
  input reset_in,

  // ================================================================
  // Debug_signals. Will be deprecated as the core is finished
  // ================================================================
  input halt_in,
  output [2:0] exec_unit_sel_out,
  output [4:0] gpr_a_out,
  output [4:0] gpr_b_out,
  output [4:0] gpr_rd_out,
  output [3:0] int_uop_out,
  output [3:0] vec_uop_out,
  output [3:0] lsu_uop_out,
  output [31:0] imm_value_out,
  // ================================================================
  // Phase two debugging. Only pipeline registers.
  // ================================================================
  output [63:0] if_id_reg_data_out,
  output [142:0] id_is_reg_data_out,
  output [122:0] is_ex_reg_data_out,
  output [69:0] ex_wb_reg_data_out,
  // ================================================================

  // Ins. mem. interface
  output [31:0] ins_mem_addr_out,
  output [31:0] ins_data_out,

  // Memory interfaces
  inout mem_addr_inout,
  inout mem_data_inout,
  output mem_read_out,
  input mem_valid_in
);

// ========================================================
//                      WIRE DEFINITION
// ========================================================

// Control signals wires
wire pc_set_wire;  // PC set signal
wire ir_set_wire;  // IR set signal
wire [31:0] pc_addr_wire;  // PC new addr bus
wire [31:0] ir_data_wire;  // IR-driven data bus
wire [31:0] ins_mem_data_wire;  // $I driven data bus
wire [2:0] exec_unit_sel_wire;
wire [3:0] exec_unit_uop_wire;
wire rd_mux_sel_wire;
wire pc_mux_sel_wire;
wire imm_mux_sel_wire;

// GPR data wires
wire [31:0] rs1_data_wire;
wire [31:0] rs2_data_wire;
wire [31:0] rd_data_wire;
wire [31:0] imm_value_wire;

// --------------------------
// Issue wires
// --------------------------
wire [31:0] a_data_wire; // Either R[rs1] or pc value
wire [31:0] b_data_wire; // Either R[rs2] or imm value

// --------------------------
// Execution wires
// --------------------------
wire [3:0] int_uop_wire; // INT uOP wire
wire [3:0] vec_uop_wire; // VEC uOP wire
wire [3:0] lsu_uop_wire; // LSU uOP wire
wire [31:0] int_a_src_data_wire; // INT A data src wire
wire [31:0] int_b_src_data_wire; // INT B data src wire
wire [31:0] lsu_a_src_data_wire; // LSU A data src wire
wire [31:0] lsu_b_src_data_wire; // LSU B data src wire
wire [31:0] vec_a_src_data_wire; // VEC A data src wire
wire [31:0] vec_b_src_data_wire; // VEC B data src wire
wire [31:0] int_result_wire; // INT result wire
wire [31:0] lsu_result_wire; // LSU result wire
wire [31:0] vec_result_wire; // VEC result wire
wire [1:0] result_sel_wire; // Output MUX selection wire
wire [31:0] ex_result_wire; // EX result wire

// --------------------------
// Writeback wires
// --------------------------
wire [31:0] writeback_data_wire;
wire [31:0] inc_pc_wire;

// --------------------------
// Pipeline registers wires
// --------------------------
wire [63:0] if_id_reg_data_wire;    // IF/ID register
wire [142:0] id_is_reg_data_wire;   // ID/IS register
wire [122:0] is_ex_reg_data_wire;   // IS/EX register
wire [69:0] ex_wb_reg_data_wire;    // EX/WB register


// ========================================================
//                      INSTANCE DEFINITION
// ========================================================
// INSTRUCTON FETCH STAGE
// ========================================================

// Main memory definition. Temporal module. Acts as the main memory.
MAIN_MEMORY mem0(
  .main_mem_addr_in(pc_addr_wire),

  .main_mem_data_out(ins_mem_data_wire)
);

// Instruction fetch unit module
IFU ifu0(
 .ifu_clock_in(clock_in),
 .ifu_reset_in(reset_in),

 .pc_addr_in(32'h00000000),
 .pc_offset_in(32'h0000008),

 .ir_data_in(ins_mem_data_wire),
 .pc_addr_out(pc_addr_wire),
 .ir_data_out(ir_data_wire),

 .pc_set_in(pc_set_wire),
 .pc_mux_sel_in(2'b10),
 .ir_set_in(1'b1)
);

// The IFU control unit. A state machine for enabling or halting the IFU
IFU_CONTROL ifu_ctrl0 (
  // Clock and reset signals
  .ifu_ctrl_clock_in(clock_in),
  .ifu_ctrl_reset_in(reset_in),

  // Halt signal in
  .halt_signal_in(halt_in),

  // Control signals output
  .ifu_ctrl_pc_set_out(pc_set_wire),
  .ifu_ctrl_ir_set_out(ir_set_wire)
);

// Instruction fetch/instruction decode (IF/ID) pipeline register
// IR (32b); PC (32b); TOTAL 64b;
REG #(.DATA_WIDTH(64)) if_id_reg (
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Control signals
  .set_in(1'b1),

  // Data input
  .data_in({ir_data_wire, pc_addr_wire}),

  // Data output
  .data_out(if_id_reg_data_wire)
);


// --------------------------
// Instruction decode stage
// --------------------------

// General purpose registers
GPR gpr0 (
  // Clock and reset inputs
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Registers addresses input signals
  .rs1_addr_in(ir_data_wire[19:15]),
  .rs2_addr_in(ir_data_wire[24:20]),
  .rd_addr_in(if_id_reg_data_wire[43:39]), // Directly from IR! Must be pipelined

  // Read data outputs
  .rs1_data_out(rs1_data_wire),
  .rs2_data_out(rs2_data_wire),

  // Write data output
  .rd_data_in(rd_data_wire)
);

// Main decode unit
DECODE_UNIT decode0 (
  // Opcodes inputs
  .opcode_in(if_id_reg_data_wire[38:34]),
  .funct3_in(if_id_reg_data_wire[46:44]),
  .funct7_in(if_id_reg_data_wire[63:57]),

  // Execution unit selection outputs
  .exec_unit_sel_out(exec_unit_sel_wire),
  .exec_unit_uop_out(exec_unit_uop_wire),

  // PC mux selection signal outputs
  .pc_mux_sel_out(pc_mux_sel_wire),

  // Immediate value mux selection signal outputs
  .imm_mux_sel_out(imm_mux_sel_wire),

  // Invalid isntruction exception signal output
  .invalid_ins_exception()
);

// Immediate value generator unit
IMM_GEN imm_gen0 (
  // OP to select the appropiate format
  .opcode_in(if_id_reg_data_wire[38:34]),

  // Instruction source values
  .instruction_in(if_id_reg_data_wire[63:39]),

  // Immediate value output
  .immediate_out(imm_value_wire)
);


// Instruction decode/instruction issue (ID/IS) pipeline register
REG #(.DATA_WIDTH(143)) id_is_reg (
  // Clock and reset inputs
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(1'b1),

  // Data input
  .data_in({rs1_data_wire,
            rs2_data_wire,
            if_id_reg_data_wire[43:39],
            imm_value_wire,
            rd_mux_sel_wire,
            imm_mux_sel_wire,
            pc_mux_sel_wire,
            exec_unit_uop_wire,
            exec_unit_sel_wire,
            if_id_reg_data_wire[31:0]}),

  // Data output
  .data_out(id_is_reg_data_wire)
);

// --------------------------
// Instruction issue stage
// --------------------------

// Forward MUX for RS1 and PC
MUX_A #(.DATA_WIDTH(32)) is1_fwd_mux (
  .data_sel_in(<from_pipeline_register>),
  .a_data_src_in(<from_pipeline_register>),
  .b_data_src_in(writeback_data_wire),
  .data_out(<to_pc_mux>)
);

// Forward MUX for IMM and RS2
MUX_A #(.DATA_WIDTH(32)) is1_fwd_mux (
  .data_sel_in(<from_pipeline_register>),
  .a_data_src_in(<from_pipeline_register>),
  .b_data_src_in(writeback_data_wire),
  .data_out(<to_imm_mux>)
);

// MUX for choosing either PC or RS1
MUX_A #(.DATA_WIDTH(32)) pc_mux (
  .data_sel_in(pc_mux_sel_wire),
  .a_data_src_in(id_is_reg_data_wire[100:69]),  // R[rs1]
  .b_data_src_in(id_is_reg_data_wire[31:0]),    // PC
  .data_out(a_data_wire)
);

// MUX for choosing either IMM or RS2
MUX_A #(.DATA_WIDTH(32)) imm_mux (
  .data_sel_in(imm_mux_sel_wire),
  .a_data_src_in(id_is_reg_data_wire[68:37]), // R[rs2]
  .b_data_src_in(id_is_reg_data_wire[73:42]), // IMM
  .data_out(b_data_wire)
);

// Issue unit
ISSUE_UNIT issue0 (
  .exec_unit_sel_in(exec_unit_sel_wire),
  .exec_uop_in(exec_unit_uop_wire),
  .int_enable_out(int_enable_wire),
  .vec_enable_out(vec_enable_wire),
  .lsu_enable_out(lsu_enable_wire),
  .int_exec_uop_out(int_uop_wire),
  .vec_exec_uop_out(vec_uop_wire),
  .lsu_exec_uop_out(lsu_uop_wire)
);

// IS/EX pipeline register
REG #(.DATA_WIDTH(123)) is_ex_reg (
  .clock_in(clock_in),                      // Clock input
  .reset_in(reset_in),                      // Reset input
  .set_in(1'b1),                            // Set signal input
  .data_in({  id_is_reg_data_wire[122],     //
              id_is_reg_data_wire[148:143], //
              int_enable_wire,
              lsu_result_wire,
              vec_enable_wire,
              int_uop_wire,
              lsu_uop_wire,
              vec_uop_wire,
              id_is_reg_data_wire[78:74],
              b_data_wire,
              a_data_wire,
              id_is_reg_data_wire[31:0]}),    // PC value
  .data_out(is_ex_reg_data_wire)
);

// --------------------------
// Execution stage
// --------------------------

// Forward value multiplexer for data source A on INT execution unit.
MUX_A #(.DATA_WIDTH(32)) ex0_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[121]),     //
  .a_data_src_in(is_ex_reg_data_wire[63:32]), //
  .b_data_src_in(writeback_data_wire),
  .data_out(int_a_src_data_wire)
);

// Forward value multiplexer for data source B on INT execution unit.
MUX_A #(.DATA_WIDTH(32)) ex1_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[120]),
  .a_data_src_in(is_ex_reg_data_wire[95:64]),
  .b_data_src_in(writeback_data_wire),
  .data_out(int_b_src_data_wire)
);

// Forward value multiplexer for data source A on LSU execution unit.
MUX_A #(.DATA_WIDTH(32)) ex2_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[119]),
  .a_data_src_in(is_ex_reg_data_wire[63:32]),
  .b_data_src_in(writeback_data_wire),
  .data_out(lsu_a_src_data_wire)
);

// Forward value multiplexer for data source B on LSU execution unit.
MUX_A #(.DATA_WIDTH(32)) ex3_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[118]),
  .a_data_src_in(is_ex_reg_data_wire[95:64]),
  .b_data_src_in(writeback_data_wire),
  .data_out(lsu_b_src_data_wire)
);

// Forward value multiplexer for data source A on VEC execution unit.
MUX_A #(.DATA_WIDTH(32)) ex4_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[117]),     // MUX selection signal
  .a_data_src_in(is_ex_reg_data_wire[63:32]), // A data
  .b_data_src_in(writeback_data_wire),        // Forwarded value
  .data_out(vec_a_src_data_wire)              // A operand for VEC
);

// Forward value multiplexer for data source B on VEC execution unit.
MUX_A #(.DATA_WIDTH(32)) ex5_fwd_mux (
  .data_sel_in(is_ex_reg_data_wire[116]),     // MUX selection signal
  .a_data_src_in(is_ex_reg_data_wire[95:64]), // B data
  .b_data_src_in(writeback_data_wire),        // Forwarded value
  .data_out(vec_b_src_data_wire)              // B operand for VEC
);

// Integer execution unit
INT_EXEC int0 (
  .a_data_in(int_a_src_data_wire),
  .b_data_in(int_b_src_data_wire),
  .enable_in(<from_pipeline_register>),
  .uop_in(<from_pipeline_register>),
  .res_data_out(int_result_wire) //
);

// Load/Store unit
// LSU_EXEC lsu0 (


// );

// Vector execution unit
// VEC_EXEC vec0 (


// );

// EX output MUX to select the appropiate output value
MUX_B #(.DATA_WIDTH(32)) ex_out_mux (
  .data_sel_in(<from_ex_dec_unit>),   //! MUX selection bus
  .a_data_src_in(int_result_wire),    // INT result data input
  .b_data_src_in(lsu_result_wire),    // LSU result data input
  .c_data_src_in(vec_result_wire),    // VEC result data input
  .d_data_src_in(32'h00000000),       // Unused data input
  .data_out(ex_result_wire)           // EX result data
);

// EX/WB pipeline register
REG #(.DATA_WIDTH(69)) ex_wb_reg (
  .clock_in(clock_in),                      // Clock input
  .reset_in(reset_in),                      // Reset input
  .set_in(1'b1),                            // Set signal input
  .data_in({  is_ex_reg_data_wire[122],     // RD MUX sel signal
              is_ex_reg_data_wire[100:96],  // RD address
              ex_result_wire,               // EX result data
              is_ex_reg_data_wire[31:0]}),  // PC value
  .data_out(ex_wb_reg_data_wire)            // Data output for pipeline REG
);

// --------------------------
// Register writeback stage
// --------------------------

// Adder to do a PC increment.
ADDER #(.DATA_WIDTH(32)) wb_pc_inc (
  .a_operand_in(ex_wb_reg_data_wire[31:0]), // From EX/WB register
  .b_operand_in(32'h00000004),              // Fixed on 4
  .add_result_out(inc_pc_wire)              // To WB mux
);

// MUX to select the value that will be stored on RD.
MUX_A #(.DATA_WIDTH(32)) wb_rd_mux (
  .data_sel_in(ex_wb_reg_data_wire[69]),      // From EX/WB register
  .a_data_src_in(ex_wb_reg_data_wire[63:32]), // From EX/WB register
  .b_data_src_in(inc_pc_wire),                // From PC INC adder
  .data_out(writeback_data_wire)              // To GPR data in AKA forward bus
);


// ========================================================
//                      OUTPUT ASSIGNMENT
// ========================================================
assign ins_mem_addr_out = if_id_reg_data_wire[31:0];  // Deprecation warning
assign ins_data_out = if_id_reg_data_wire[63:32];     // Deprecation warning
assign gpr_a_out = ir_data_wire[19:15];               // Deprecation warning
assign gpr_b_out = if_id_reg_data_wire[56:52];        // Deprecation warning
assign gpr_rd_out = if_id_reg_data_wire[43:39];       // Deprecation warning
assign exec_unit_sel_out = exec_unit_sel_wire;        // Deprecation warning
assign imm_value_out = id_is_reg_data_wire[31:0];     // Deprecation warning
assign int_uop_out = int_uop_wire;                    // Deprecation warning
assign vec_uop_out = vec_uop_wire;                    // Deprecation warning
assign lsu_uop_out = lsu_uop_wire;                    // Deprecation warning

// Pipeline registers outputs for debug purposes.
assign if_id_reg_data_out = if_id_reg_data_wire;
assign id_is_reg_data_out = id_is_reg_data_wire;
assign is_ex_reg_data_out = is_ex_reg_data_wire;
assign ex_wb_reg_data_out = ex_wb_reg_data_wire;

endmodule
