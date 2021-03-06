// Pipeline control module definition
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


module PIPELINE_CONTROL (
  input pipeline_clock_in,
  input pipeline_reset_in,

  // Instruction memory jump flags
  input pipeline_offset_flag_in,
  input pipeline_target_flag_in,
  input pipeline_prediction_flag_in,

  output pipeline_ins_mem_valid_out,
  input pipeline_ins_mem_ready_in,

  output pipeline_pc_if_set_out,
  output pipeline_if_dec_set_out
);


endmodule
