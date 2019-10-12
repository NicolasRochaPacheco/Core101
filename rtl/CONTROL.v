// Control unit module definition
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
    output control_unit_pc_set_val_out,     // PC reg set
    output control_unit_ir_set_val_out,     // IR reg set
    output control_unit_pc_mux_sel_out,      // PC src mux sel

    input [6:0] control_unit_ins_data
);

  // REGISTER DEFINITION
  reg [3:0] state_reg;  // State register used for pipeline staging
                        // Status:  IF (3'b000), ID (3'b001), EX (3'b011),
                        //          MEM (3'b010), WB (3'b110)

  // Instruction fetch control signal registers
  reg pc_set_val_reg;
  reg ir_set_val_reg;
  reg pc_mux_sel_reg;


  always @ (negedge datapath_clock_in, posedge datapath_reset_in)
    begin
      // Reset condition
      if (datapath_reset_in == 1'b1)
        state_reg = 3'b000;

      // State machine control
      case (state_reg)
        3'b000: begin // IF
                  pc_set_val_reg = 1'b0;
                  ir_set_val_reg = 1'b1;
                  pc_mux_sel_reg = 2'b00;


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

    // OUTPUT
    // Instruction fetch
    assign control_unit_pc_set_val_out = pc_set_val_reg;
    assign control_unit_ir_set_val_out = ir_set_val_reg;
    assign control_unit_pc_mux_sel_out = pc_mux_sel_reg;

endmodule
