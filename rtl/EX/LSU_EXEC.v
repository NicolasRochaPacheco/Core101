


module LSU_EXEC(
  // Enable signal input
  input enable_in,

  // Input for uOP bus
  input [3:0] uop_in,

  // A and B bus input
  input [31:0] a_data_in,
  input [31:0] b_data_in,

  // Result output data
  output [31:0] res_data_out
);

//===============================================
// MICRO OPCODES DEFINITION
//===============================================
// 4'b0000:
// 4'b0001: LB
// 4'b0010: LH
// 4'b0011: LW
// 4'b0101: LBU
// 4'b0110: LHU
// 4'b1001: SB
// 4'b1010: SH
// 4'b1100: SW
//===============================================


// Effective address calculation
// A bus takes data from base register
// B bus takes data from immediate number generation
assign res_data_out = a_data_in + b_data_in;



endmodule
