// Core101 main memory (dummy) module definition
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


module MAIN_MEMORY (
  input [31:0] main_mem_addr_in,

  output [31:0] main_mem_data_out
);

reg [7:0] memory [0:255];
reg [31:0] data_out;

reg [7:0] red_addr;

initial begin
  $readmemh("/opt/L0G1C101/Core101/rtl/MEM/tp1.hex", memory);
end

always@(*) begin
  red_addr = main_mem_addr_in[7:0];
  data_out = {memory[red_addr+3],
              memory[red_addr+2],
              memory[red_addr+1],
              memory[red_addr]};
end

assign main_mem_data_out = data_out;

endmodule
