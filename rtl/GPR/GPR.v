// Core101 general purpose registers module definition
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


module GPR (

    // Clock and reset in
    input clock_in,
    input reset_in,

    // Temp four bit addr mode since only int registers will be used
    input [4:0] rs1_addr_in,  // Selects rs1 output data
    input [4:0] rs2_addr_in,  // Selects rs2 output data
    input [4:0] rd_addr_in,   // Drives set signal for rd

    // Data output buses
    output [31:0] rs1_data_out,
    output [31:0] rs2_data_out,

    // Data input bus
    input [31:0] rd_data_in

    );

// ==============================================
// WIRE DEFINITION
// ==============================================
// Set signal for every integer register
wire int_reg_x00_set_wire;
wire int_reg_x01_set_wire;
wire int_reg_x02_set_wire;
wire int_reg_x03_set_wire;
wire int_reg_x04_set_wire;
wire int_reg_x05_set_wire;
wire int_reg_x06_set_wire;
wire int_reg_x07_set_wire;
wire int_reg_x08_set_wire;
wire int_reg_x09_set_wire;
wire int_reg_x10_set_wire;
wire int_reg_x11_set_wire;
wire int_reg_x12_set_wire;
wire int_reg_x13_set_wire;
wire int_reg_x14_set_wire;
wire int_reg_x15_set_wire;
wire int_reg_x16_set_wire;
wire int_reg_x17_set_wire;
wire int_reg_x18_set_wire;
wire int_reg_x19_set_wire;
wire int_reg_x20_set_wire;
wire int_reg_x21_set_wire;
wire int_reg_x22_set_wire;
wire int_reg_x23_set_wire;
wire int_reg_x24_set_wire;
wire int_reg_x25_set_wire;
wire int_reg_x26_set_wire;
wire int_reg_x27_set_wire;
wire int_reg_x28_set_wire;
wire int_reg_x29_set_wire;
wire int_reg_x30_set_wire;
wire int_reg_x31_set_wire;

// A data wire for every integer register
wire [31:0] int_reg_x00_data_wire;   // x00
wire [31:0] int_reg_x01_data_wire;   // x01
wire [31:0] int_reg_x02_data_wire;   // x02
wire [31:0] int_reg_x03_data_wire;   // x03
wire [31:0] int_reg_x04_data_wire;   // x04
wire [31:0] int_reg_x05_data_wire;   // x05
wire [31:0] int_reg_x06_data_wire;   // x06
wire [31:0] int_reg_x07_data_wire;   // x07
wire [31:0] int_reg_x08_data_wire;   // x08
wire [31:0] int_reg_x09_data_wire;   // x09
wire [31:0] int_reg_x10_data_wire;   // x10
wire [31:0] int_reg_x11_data_wire;   // x11
wire [31:0] int_reg_x12_data_wire;   // x12
wire [31:0] int_reg_x13_data_wire;   // x13
wire [31:0] int_reg_x14_data_wire;   // x14
wire [31:0] int_reg_x15_data_wire;   // x15
wire [31:0] int_reg_x16_data_wire;   // x16
wire [31:0] int_reg_x17_data_wire;   // x17
wire [31:0] int_reg_x18_data_wire;   // x18
wire [31:0] int_reg_x19_data_wire;   // x19
wire [31:0] int_reg_x20_data_wire;   // x20
wire [31:0] int_reg_x21_data_wire;   // x21
wire [31:0] int_reg_x22_data_wire;   // x22
wire [31:0] int_reg_x23_data_wire;   // x23
wire [31:0] int_reg_x24_data_wire;   // x24
wire [31:0] int_reg_x25_data_wire;   // x25
wire [31:0] int_reg_x26_data_wire;   // x26
wire [31:0] int_reg_x27_data_wire;   // x27
wire [31:0] int_reg_x28_data_wire;   // x28
wire [31:0] int_reg_x29_data_wire;   // x29
wire [31:0] int_reg_x30_data_wire;   // x30
wire [31:0] int_reg_x31_data_wire;   // x31

// Wire for RS1 data and RS2 data
wire [31:0] rs1_data_wire;
wire [31:0] rs2_data_wire;


// ============================================================================
// MODULE INSTANCE
// ============================================================================

// SET DECODE
DECODE_F x_decoder(
  // Sel addre input
  .sel_addr_in(rd_addr_in),

  // Output signal for each register
  .sel_x00_out(int_reg_x00_set_wire),
  .sel_x01_out(int_reg_x01_set_wire),
  .sel_x02_out(int_reg_x02_set_wire),
  .sel_x03_out(int_reg_x03_set_wire),
  .sel_x04_out(int_reg_x04_set_wire),
  .sel_x05_out(int_reg_x05_set_wire),
  .sel_x06_out(int_reg_x06_set_wire),
  .sel_x07_out(int_reg_x07_set_wire),
  .sel_x08_out(int_reg_x08_set_wire),
  .sel_x09_out(int_reg_x09_set_wire),
  .sel_x10_out(int_reg_x10_set_wire),
  .sel_x11_out(int_reg_x11_set_wire),
  .sel_x12_out(int_reg_x12_set_wire),
  .sel_x13_out(int_reg_x13_set_wire),
  .sel_x14_out(int_reg_x14_set_wire),
  .sel_x15_out(int_reg_x15_set_wire),
  .sel_x16_out(int_reg_x16_set_wire),
  .sel_x17_out(int_reg_x17_set_wire),
  .sel_x18_out(int_reg_x18_set_wire),
  .sel_x19_out(int_reg_x19_set_wire),
  .sel_x20_out(int_reg_x20_set_wire),
  .sel_x21_out(int_reg_x21_set_wire),
  .sel_x22_out(int_reg_x22_set_wire),
  .sel_x23_out(int_reg_x23_set_wire),
  .sel_x24_out(int_reg_x24_set_wire),
  .sel_x25_out(int_reg_x25_set_wire),
  .sel_x26_out(int_reg_x26_set_wire),
  .sel_x27_out(int_reg_x27_set_wire),
  .sel_x28_out(int_reg_x28_set_wire),
  .sel_x29_out(int_reg_x29_set_wire),
  .sel_x30_out(int_reg_x30_set_wire),
  .sel_x31_out(int_reg_x31_set_wire)
);


// X0 REGISTER
REG x00 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x00_set_wire),

  // Data input (hard wired to zero)
  .data_in(32'h00000000),

  // Data output
  .data_out(int_reg_x00_data_wire)
);

// X1 REGISTER
REG x01 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x01_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x01_data_wire)
);

// X2 REGISTER
REG x02 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x02_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x02_data_wire)
);

// X3 REGISTER
REG x03 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x03_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x03_data_wire)
);

// X4 REGISTER
REG x04 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x04_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x04_data_wire)
);

// X5 REGISTER
REG x05 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x05_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x05_data_wire)
);

// X6 REGISTER
REG x06 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x06_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x06_data_wire)
);

// X7 REGISTER
REG x07 (
  // Clock and reset input
  .clock_in(clock_in),
  .reset_in(reset_in),

  // Set signal input
  .set_in(int_reg_x07_set_wire),

  // Data input
  .data_in(rd_data_in),

  // Data output
  .data_out(int_reg_x07_data_wire)
);

// OUTPUT MUX RS1
MUX_F rs1_output_mux (
  // RS1 selectionn input
  .mux_sel_in(rs1_addr_in),

  // Data wires inputs from integer registers
  .x00_data_in(int_reg_x00_data_wire),
  .x01_data_in(int_reg_x01_data_wire),
  .x02_data_in(int_reg_x02_data_wire),
  .x03_data_in(int_reg_x03_data_wire),
  .x04_data_in(int_reg_x04_data_wire),
  .x05_data_in(int_reg_x05_data_wire),
  .x06_data_in(int_reg_x06_data_wire),
  .x07_data_in(int_reg_x07_data_wire),
  .x08_data_in(int_reg_x08_data_wire),
  .x09_data_in(int_reg_x09_data_wire),
  .x10_data_in(int_reg_x10_data_wire),
  .x11_data_in(int_reg_x11_data_wire),
  .x12_data_in(int_reg_x12_data_wire),
  .x13_data_in(int_reg_x13_data_wire),
  .x14_data_in(int_reg_x14_data_wire),
  .x15_data_in(int_reg_x15_data_wire),
  .x16_data_in(int_reg_x16_data_wire),
  .x17_data_in(int_reg_x17_data_wire),
  .x18_data_in(int_reg_x18_data_wire),
  .x19_data_in(int_reg_x19_data_wire),
  .x20_data_in(int_reg_x20_data_wire),
  .x21_data_in(int_reg_x21_data_wire),
  .x22_data_in(int_reg_x22_data_wire),
  .x23_data_in(int_reg_x23_data_wire),
  .x24_data_in(int_reg_x24_data_wire),
  .x25_data_in(int_reg_x25_data_wire),
  .x26_data_in(int_reg_x26_data_wire),
  .x27_data_in(int_reg_x27_data_wire),
  .x28_data_in(int_reg_x28_data_wire),
  .x29_data_in(int_reg_x29_data_wire),
  .x30_data_in(int_reg_x30_data_wire),
  .x31_data_in(int_reg_x31_data_wire),

  // Integer registers data output
  .x_data_out(rs1_data_wire)
);


// OUTPUT MUX RS2
MUX_F rs2_output_mux (
  // RS1 selectionn input
  .mux_sel_in(rs2_addr_in),

  // Data wires inputs from integer registers
  .x00_data_in(int_reg_x00_data_wire),
  .x01_data_in(int_reg_x01_data_wire),
  .x02_data_in(int_reg_x02_data_wire),
  .x03_data_in(int_reg_x03_data_wire),
  .x04_data_in(int_reg_x04_data_wire),
  .x05_data_in(int_reg_x05_data_wire),
  .x06_data_in(int_reg_x06_data_wire),
  .x07_data_in(int_reg_x07_data_wire),
  .x08_data_in(int_reg_x08_data_wire),
  .x09_data_in(int_reg_x09_data_wire),
  .x10_data_in(int_reg_x10_data_wire),
  .x11_data_in(int_reg_x11_data_wire),
  .x12_data_in(int_reg_x12_data_wire),
  .x13_data_in(int_reg_x13_data_wire),
  .x14_data_in(int_reg_x14_data_wire),
  .x15_data_in(int_reg_x15_data_wire),
  .x16_data_in(int_reg_x16_data_wire),
  .x17_data_in(int_reg_x17_data_wire),
  .x18_data_in(int_reg_x18_data_wire),
  .x19_data_in(int_reg_x19_data_wire),
  .x20_data_in(int_reg_x20_data_wire),
  .x21_data_in(int_reg_x21_data_wire),
  .x22_data_in(int_reg_x22_data_wire),
  .x23_data_in(int_reg_x23_data_wire),
  .x24_data_in(int_reg_x24_data_wire),
  .x25_data_in(int_reg_x25_data_wire),
  .x26_data_in(int_reg_x26_data_wire),
  .x27_data_in(int_reg_x27_data_wire),
  .x28_data_in(int_reg_x28_data_wire),
  .x29_data_in(int_reg_x29_data_wire),
  .x30_data_in(int_reg_x30_data_wire),
  .x31_data_in(int_reg_x31_data_wire),

  // Integer registers data output
  .x_data_out(rs2_data_wire)
);

// Assigns output for RS1 and RS2
assign rs1_data_out = rs1_data_wire;
assign rs2_data_out = rs2_data_wire;



endmodule
