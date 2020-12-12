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
  input pred_clock_in,            // Predictor clock input
  input pred_reset_in,            // Predictor reset input
  input pred_write_enable_in,     // Enable for writing feedback
  input pred_taken_in,            // Taken branch feedback
  input [9:0] pred_indx_in,       // Update addr from branch
  input [31:0] pred_addr_in,       // PC address input
  input [31:0] pred_ins_in,       // INS data input
  output pred_taken_out,          // Prediction output
  output [31:0] pred_pc_out       // Predicted PC output
);

// Parameter definition
parameter MEM_SIZE = 1024;

// Opcodes
parameter BRANCH = 5'b11000;
parameter JAL = 5'b11011;

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
  // Immediate generation
  case(pred_ins_in[6:2])
    BRANCH:   imm_value_wire = {{ 20{pred_ins_in[31]}},
                                  pred_ins_in[7],
                                  pred_ins_in[30:25],
                                  pred_ins_in[11:8], 1'b0};
    JAL:      imm_value_wire = {{ 21{pred_ins_in[31]}},
                                  pred_ins_in[30:20]};
    default:  imm_value_wire = 32'h00000000;
  endcase

  // Prediction if taken or not
  case(pred_ins_in[6:2])
    BRANCH:   taken_pred_wire = branch_buffer[pred_addr_in[9:0]][1];
    JAL:      taken_pred_wire = 1'b1;
    default:  taken_pred_wire = 1'b0;
  endcase

  // Computes target PC address
  if(taken_pred_wire==1'b1)
    target_pc_wire = pred_addr_in + imm_value_wire;
  else
    target_pc_wire = 32'h00000000;
end


// Sequential logic
always @ ( posedge pred_clock_in, posedge pred_reset_in ) begin
  // Resets memory if signal is asserted on high
  if(pred_reset_in == 1'b1) begin
    integer j;
    for (j=0; j<MEM_SIZE; j=j+1) begin
      branch_buffer[j] = 2'b00;
    end
  end

  // Updates branch history according to feedback
  if(pred_write_enable_in == 1'b1) begin
    old_status_wire = branch_buffer[pred_indx_in];
    branch_buffer[pred_indx_in] = {old_status_wire[0], pred_taken_in};
  end
end

assign pred_pc_out = target_pc_wire;
assign pred_taken_out = taken_pred_wire;


endmodule
