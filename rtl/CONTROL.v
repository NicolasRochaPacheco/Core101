// General register module definition
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

// A state machine that will control how the datapath behaves :)
module CONTROL(
    // Clock and reset
    input control_unit_clock_in,
    input control_unit_reset_in,

    // Instruction fetch control signals
    output pc_set_val_out,
    output [1:0] pc_src_out,
    output ir_set_val_out
);

  // REGISTER DEFINITION
  reg [3:0] state_reg;  // State register used for pipeline staging
                        // Status:  IF (3'b000), ID (3'b001), EX (3'b011),
                        //          MEM (3'b010), WB (3'b110)

  // Program counter control signal registers
  reg pc_set_val_reg;
  reg [1:0] pc_src_reg;

  // Instruction register control signal registers
  reg ir_set_val_reg;



  always @ (negedge datapath_clock_in, posedge datapath_reset_in)
    begin
      // Reset condition
      if (datapath_reset_in == 1'b1)
        state_reg = 3'b000;

      // State machine control
      case (state_reg)
        3'b000: begin // IF
                  // Program counter
                  pc_set_val_reg = 1'b0;
                  pc_src_reg = 2'b00;
                  // Instruction register
                  ir_set_val_reg = 1'b1;

                  // Update state register
                  state_reg = 3'b001;
                end
        3'b001: begin // ID

                  // Update state register
                  state_reg = 3'b011;
                end
        3'b011: begin // EX

                  // Update state register
                  state_reg = 3'b010;
                end
        3'b010: begin // MEM

                  // Update state register
                  state_reg = 3'b110;
                end
        3'b110: begin // WB

                  // Update state register
                  state_reg = 3'b000;
                end
      endcase
    end


    // Program counter control signals
    assign pc_set_val_out = pc_set_val_reg;
    assign pc_src_out = pc_src_reg;

    // Instrucion register
    assign ir_set_val_out = ir_set_val_reg;

endmodule
