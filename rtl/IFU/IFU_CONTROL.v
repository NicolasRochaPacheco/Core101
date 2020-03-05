// Core101 instruction fetch unit (IFU) control unit module definition
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

//-----------------------------------------------
//  MODULE DEFINITION
//-----------------------------------------------
module IFU_CONTROL (
  // Clock and reset signals
  input ifu_ctrl_clock_in,
  input ifu_ctrl_reset_in,

  // Halt signal in
  input halt_signal_in,

  // Control signals output
  output ifu_ctrl_pc_set_out,
  output ifu_ctrl_ir_set_out
);

// Parameters
parameter FETCH_STATE = 1'b0;
parameter HALT_STATE = 1'b1;


// Registers definition
reg state_reg;

// Output registers
reg pc_set_reg;
reg ir_set_reg;

// Combinational logic
always@(*) begin
  case(state_reg)
  	FETCH_STATE: begin
  							   pc_set_reg = 1'b1;
                   ir_set_reg = 1'b1;
  						   end
  	HALT_STATE:	begin
  							   pc_set_reg = 1'b0;
                   ir_set_reg = 1'b0;
  						  end
  endcase
end

// ====================================
// Sequential logic
// ====================================
always@(negedge ifu_ctrl_clock_in) begin
  case(state_reg)
    FETCH_STATE:  if (halt_signal_in == 1'b0)
                    state_reg = FETCH_STATE;
                  else
                    state_reg = HALT_STATE;

    HALT_STATE:   if (halt_signal_in == 1'b0)
                    state_reg = FETCH_STATE;
                  else
                    state_reg = HALT_STATE;
  endcase
end

// ====================================
// Output logic
// ====================================
assign ifu_ctrl_pc_set_out = pc_set_reg;

endmodule
