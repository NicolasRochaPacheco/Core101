// License removed for breverity
module CASCADE(
  input [31:0] cascade_adder_a_in,
  input [31:0] cascade_adder_b_in,
  input [31:0] cascade_adder_c_in,
  output [31:0] cascade_adder_sum_out
);

wire [31:0] add_wire;

//=======================
// Module instantiation
//=======================
ADDER #(.DATA_WIDTH(32)) adder0 (
  .a_operand_in(cascade_adder_a_in),
  .b_operand_in(cascade_adder_b_in),
  .add_result_out(add_wire)
);

ADDER #(.DATA_WIDTH(32)) adder1 (
  .a_operand_in(add_wire),
  .b_operand_in(cascade_adder_c_in),
  .add_result_out(cascade_adder_sum_out)
);

endmodule
