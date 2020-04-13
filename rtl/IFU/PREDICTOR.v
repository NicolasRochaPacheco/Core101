// Branch predictor unit module definition
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


module PREDICTOR (
  input clock_in,
  input feedback_enable_in,
  input [9:0] pc_indx_branch_in,  // Update data for branch
  input [31:0] ins_data_in,       // INS data input
  input [31:0] pc_addr_in,        // PC address input
  input [31:0] taken_branch_in,   // Taken branch feedback

  output taken_pred_out,
  output pc_branch_sel_out,
  output [31:0] pred_pc_out
);

// Parameter definition
parameter BRANCH = 5'b11000;

// Wire definition
wire pc_branch_sel_wire;

// Combinational logic
always @ ( * ) begin
  if(ins_data_in[6:2] == BRANCH) begin
    // Predict if the branch should be taken or not taken
    pc_branch_sel_wire = 1'b1;
  end else begin
    // Branch should not be taken => MUX_SEL unset
    // PC_PRED output same as PC
    pc_branch_sel_wire = 1'b0;
  end
end


always @ ( posedge clock_in ) begin
  // Updates branch history according to feedback
end



assign taken_pred_out = 1'b1;
assign pred_pc_out = 32'h00000000;


endmodule
