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
  input pred_in,                      // Prediction input
  input enable_in,                    // Enable input
  input [3:0] uop_in,                 // uOP input
  input [DATA_WIDTH-1:0] pc_in,       // Program counter address
  input [DATA_WIDTH-1:0] rs1_in,      // R[rs1] data input
  input [DATA_WIDTH-1:0] rs2_in,      // R[rs2] data input
  input [DATA_WIDTH-1:0] imm_in,      // Immediate value.
  output flush_out,                   // Flush signal output
  output taken_out,                   // Signal indicating if a branch was taken
  output enable_out,                  // Enable signal for predictor
  output mux_out,                     // PC mux selection output
  output [DATA_WIDTH-1:0] target_out  // PC new address output
);


// WIRE DEFINITION
wire flush_wire;
wire taken_wire;
wire feedback_wire;
wire pc_mux_sel_wire; // 1'b1 if the branch is taken, 1'b0 otherwise
wire [31:0] pc_target_wire;  //


// COMBINATIONAL LOGIC
always @ (*) begin
  if (enable_in==1'b1) begin        // If a branch is being executed
    feedback_wire = 1'b1;           // Sets feedback enable

    case(uop_in)  // Resolves the branch
      4'b0000: taken_wire = (rs1_in == rs2_in) ? 1'b1:1'b0; // BEQ
      4'b0001: taken_wire = (rs1_in != rs2_in) ? 1'b1:1'b0;
      4'b0010: taken_wire = (rs1_in <  rs2_in) ? 1'b1:1'b0;  // BLT
      4'b0011: taken_wire = (rs1_in >= rs2_in) ? 1'b1:1'b0; //
      4'b0110: taken_wire = 1'b0; //(rs1_data_in<rs2_data_in) ? 1'b1:1'b0;  // BLTU
      4'b0111: taken_wire = (rs1_in >  rs2_in) ? 1'b1:1'b0;
      default: taken_wire = 1'b0;
    endcase

    if(pred_in==taken_wire) begin   // If the prediction was correct
      flush_wire = 1'b0;            // Flush not needed
      pc_mux_sel_wire = 1'b0;       // PC update not needed
    end else begin                  // If the prediction was not correct
      flush_wire = 1'b1;            // Flush needed
      pc_mux_sel_wire = 1'b1;       // PC update needed
      if(taken_wire==1'b1)          // If the branch is taken
        pc_target_wire = pc_in + imm_in;
      else
        pc_target_wire = pc_in + 32'h00000004;
    end
  end else begin
    // Set outputs for instructions that are not branches
    feedback_wire = 1'b0;
    pc_mux_sel_wire = 1'b0;
    flush_wire = 1'b0;
    taken_wire = 1'b0;
    pc_target_wire = 32'h00000000;
  end
end

// OUTPUT ASSIGNMENT
assign flush_out = flush_wire;
assign taken_out = taken_wire;
assign enable_out = feedback_wire;
assign mux_out = pc_mux_sel_wire;
assign target_out = pc_target_wire;

endmodule
