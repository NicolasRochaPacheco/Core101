// Load/Store Unit module definition
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

module LSU
  #(parameter XLEN=32) (
  input lsu_enable_in,                    // Enable signal input
  input [3:0] lsu_uop_in,                 // Input for uOP bus
  input [XLEN-1:0] lsu_a_data_in,         // A input bus
  input [XLEN-1:0] lsu_b_data_in,         // B input bus
  input [XLEN-1:0] lsu_c_data_in,         // C input bus
  input [XLEN-1:0] lsu_mem_data_in,       // Input memory bus
  output reg [3:0] lsu_mem_op_out,        // Memory opcode
  output reg [XLEN-1:0] lsu_result_out,   // Result output data
  output reg [XLEN-1:0] lsu_mem_data_out, // Output memory bus
  output reg [XLEN-1:0] lsu_mem_addr_out  // Address memory bus
);

// ==================================
// WIRE AND REGISTER DEFINITION
// ==================================
reg [XLEN-1:0] lsu_effective_addr_reg;


// Combinational logic
always @ ( * ) begin

  if (lsu_enable_in == 1'b1) begin

    // Effective address is calculated
    lsu_effective_addr_reg = lsu_b_data_in + lsu_c_data_in;

    // MSB from uop signal is LOW for LOADS
    if (lsu_uop_in[3] == 1'b0) begin

      // Sets up the outputs for memory
      lsu_mem_addr_out = lsu_effective_addr_reg;
      lsu_mem_op_out = lsu_uop_in;

      // If data is loaded as a byte
      if(lsu_uop_in[1:0] == 2'b01)

        // Checks if value is signed, sign-extension is done
        if(lsu_uop_in[2] == 1'b0)
          lsu_result_out = {{24{lsu_mem_data_in[7]}}, lsu_mem_data_in[7:0]};

        // If value is unsigned, zero-extends value
        else
          lsu_result_out = {{24{1'b0}}, lsu_mem_data_in[7:0]};

      // If data is loaded as a halfword
      else if(lsu_uop_in[1:0] == 2'b10)

        // Checks if value is signed, sign-extension is done
        if(lsu_uop_in[2] == 1'b0)
          lsu_result_out = {{16{lsu_mem_data_in[15]}}, lsu_mem_data_in[15:0]};

        // If value is unsigned, zero-extends value
        else
          lsu_result_out = {{16{1'b0}}, lsu_mem_data_in[15:0]};

      // If data is loaded as a word
      else
        lsu_result_out = lsu_mem_data_in;

    // MSB from uop signal is HIGH for STORES
    end else begin

      // Sets data address and op code
      lsu_mem_addr_out = lsu_effective_addr_reg;
      lsu_mem_op_out = lsu_uop_in;

      // Sends data over memory bus
      lsu_mem_data_out = lsu_a_data_in;

    end
  end
end

endmodule
