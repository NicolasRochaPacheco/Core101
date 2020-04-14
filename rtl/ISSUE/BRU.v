// Branch resolver unit module definition
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

module BRU #(
  DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] rs1_data_in,   // R[rs1] data input
  input [DATA_WIDTH-1:0] rs2_data_in,   // R[rs2] data input
  input [DATA_WIDTH-1:0] imm_data_in,   // Immediate value.
  input [DATA_WIDTH-1:0] pc_data_in,    // Program counter address
  input [2:0] sel_in,                   // SEL in. (enable)
  input [3:0] uop_in,                   // uOP input
  input pred_in,                        // Prediction input
  output flush_out,                     // Flush signal output
  output feedback_out,
  output taken_out,
  output pc_mux_sel_out,                // PC mux selection output
  output [DATA_WIDTH-1:0] pc_addr_out   // PC new address output
);

// WIRE DEFINITION
wire flush_wire;
wire feedback_wire;
wire pc_mux_sel_wire; // 1'b1 if the branch is taken, 1'b0 otherwise
wire [31:0] pc_target_wire;  //
wire taken_wire;

// COMBINATIONAL LOGIC
always @ (*) begin
  if (sel_in==3'b011) begin         // If a branch is being executed
    feedback_wire = 1'b1;           // Enables feedback

    case(uop_in)  // Resolves the branch
      4'b0000: taken_wire = (rs1_data_in==rs2_data_in) ? 1'b1 : 1'b0;
      4'b0001: taken_wire = (rs1_data_in!=rs2_data_in) ? 1'b1 : 1'b0;
      default: taken_wire = 1'b0;
    endcase

    if(pred_in==taken_wire) begin   // Decides if a flush is needed
      flush_wire = 1'b0;            // Flush not needed
      pc_mux_sel_wire = 1'b0;       // PC update not needed
    end else begin
      flush_wire = 1'b1;            // Flush needed
      pc_mux_sel_wire = 1'b1;       // PC update needed
      if(taken_wire==1'b1)          // If the branch is taken
        pc_target_wire = pc_data_in + imm_data_in;
      else
        pc_target_wire = pc_data_in + 32'h00000004;
    end
  end else begin
    // Set outputs for instructions that are not branches
    feedback_wire = 1'b0;
    pc_mux_sel_wire = 1'b0;
    flush_wire = 1'b0;
    pc_target_wire = 32'h00000000;
  end
end

// OUTPUT ASSIGNMENT
assign flush_out = flush_wire;
assign taken_out = pc_mux_sel_wire;
assign feedback_out = feedback_wire;
assign pc_mux_sel_out = pc_mux_sel_wire;
assign pc_addr_out = pc_target_wire;

endmodule
