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
  input reset_in,
  input taken_branch_in,          // Taken branch feedback
  input feedback_enable_in,
  input [9:0] pc_indx_branch_in,  // Update data for branch
  input [31:0] ins_data_in,       // INS data input
  input [31:0] pc_addr_in,        // PC address input
  output taken_pred_out,
  output [31:0] pred_pc_out
);

// Parameter definition
parameter MEM_SIZE = 1024;
parameter BRANCH = 5'b11000;

// Memory definition
reg [1:0] branch_buffer [0:MEM_SIZE-1];

// Wire definition
wire taken_pred_wire;
wire [1:0] status_wire;
wire [1:0] old_status_wire;
wire [31:0] imm_value_wire;
wire [31:0] target_pc_wire;
// ------------------------------------

// Combinational logic
always @ ( * ) begin
  if(ins_data_in[6:2] == BRANCH) begin
    // Predict if the branch should be taken or not
    status_wire = branch_buffer[pc_addr_in[9:0]];
    taken_pred_wire = (status_wire==2'b00) || (status_wire==2'b01) ? 1'b0 : 1'b1;

    // Depending on prediction, PC target value is computed
    if (taken_pred_wire == 1'b1) begin
      imm_value_wire = {{ 20{ins_data_in[31]}},     // Generates immediate value
                          ins_data_in[7],
                          ins_data_in[30:25],
                          ins_data_in[11:8], 1'b0};
      target_pc_wire = imm_value_wire + pc_addr_in; // Computes target PC
    end else begin
      target_pc_wire = 32'h00000000;
    end
  // Executes if instruction is not a branch
  end else begin
    taken_pred_wire = 1'b0;
    target_pc_wire = 32'h00000000;
  end
end

// Sequential logic
always @ ( posedge clock_in, posedge reset_in ) begin
  // Resets memory if signal is asserted on high
  if(reset_in == 1'b1) begin
    integer j;
    for (j=0; j<MEM_SIZE; j=j+1) begin
      branch_buffer[j] = 2'b00;
    end
  end

  // Updates branch history according to feedback
  if(feedback_enable_in == 1'b1) begin
    old_status_wire = branch_buffer[pc_indx_branch_in];
    branch_buffer[pc_indx_branch_in] = {old_status_wire[0], taken_branch_in};
  end
end

assign taken_pred_out = taken_pred_wire;
assign pred_pc_out = target_pc_wire;


endmodule
