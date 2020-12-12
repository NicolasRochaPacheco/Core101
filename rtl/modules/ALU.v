// ALU module definition
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

module ALU
  #(parameter DATA_WIDTH = 32)(
    // Data sources input
    input [DATA_WIDTH-1:0]  a_data_in, // ALU_A
    input [DATA_WIDTH-1:0]  b_data_in, // ALU_B
    input [3:0]             uop_in,

    // OUTPUT
    output [DATA_WIDTH-1:0] result_out
);

// ==============================================
// MICRO-OPCODES DEFINITION
// ==============================================
// 4'b0000: ADD
// 4'b0001: SUB
// 4'b0010: OR
// 4'b0011: AND
// 4'b0100: XOR
// 4'b0101: Not implemented
// 4'b0110: Not implemented
// 4'b0111: Not implemented
// 4'b1000: BUFFER RS1
// 4'b1001: BUFFER RS2
// 4'b1010: SLT (Set lower Than)
// 4'b1011: SLTU (Set Lower Than Unsigned)
// 4'b1100: Not implemented
// 4'b1101: SRA (Shift Right Arithmetic)
// 4'b1110: SRL (Shift Right Logic)
// 4'b1111: SLL (Shift Left Logic)
// ==============================================

// WIRE DEFINITION
wire [DATA_WIDTH-1:0] alu_result_wire;

// COMBINATIONAL LOGIC
always@(*) begin
  case(uop_in)
    4'b0000: alu_result_wire = a_data_in + b_data_in;
    4'b0001: alu_result_wire = a_data_in - b_data_in;
    4'b0010: alu_result_wire = a_data_in|b_data_in;
    4'b0011: alu_result_wire = a_data_in&b_data_in;
    4'b0100: alu_result_wire = a_data_in^b_data_in;
    4'b1000: alu_result_wire = a_data_in;
    4'b1001: alu_result_wire = b_data_in;
    4'b1010: alu_result_wire = ($signed(a_data_in)<$signed(b_data_in))?32'd1:32'd0;
    4'b1011: alu_result_wire = (a_data_in<b_data_in)?32'd1:32'd0;
    4'b1101: alu_result_wire = $signed(a_data_in) >>> b_data_in[4:0];
    4'b1110: alu_result_wire = a_data_in >> b_data_in[4:0];
    4'b1111: alu_result_wire = a_data_in << b_data_in[4:0];
    default: alu_result_wire = 32'h00000000;
  endcase
end

assign result_out = alu_result_wire;

endmodule
