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
// A data wire for every int register
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

// X0 REGISTER


// OUTPUT MUX RS1
MUX_32 rs1_output_mux (

    // RS1 selectionn input
    .mux_sel_in(),

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
MUX_32 rs2_output_mux (

    // RS1 selectionn input
    .mux_sel_in(),

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

// Source and target registers encoded as six bits address

// Assigns output for RS1 and RS2
assign rs1_data_out = rs1_data_wire;
assign rs2_data_out = rs2_data_wire;



endmodule
