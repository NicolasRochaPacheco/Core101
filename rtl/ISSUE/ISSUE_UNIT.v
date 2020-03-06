

module ISSUE_UNIT (
  // Execution unit selection bus
  input [2:0] exec_unit_sel_in,
  input [3:0] exec_uop_in,

  // Execution units opcode
  output [3:0] int_exec_uop_out,
  output [3:0] vec_exec_uop_out,
  output [3:0] lsu_exec_uop_out
);

// Registers to hold each micro operation
reg [3:0] int_uop;
reg [3:0] vec_uop;
reg [3:0] lsu_uop;

// Combinational logic
always@(*) begin
  case(exec_unit_sel_in)
    3'b001:   begin
                int_uop = exec_uop_in;
                vec_uop = 4'b0000;
                lsu_uop = 4'b0000;
              end

    3'b010:   begin
                int_uop = 4'b0000;
                vec_uop = exec_uop_in;
                lsu_uop = 4'b0000;
              end

    3'b100:   begin
                int_uop = 4'b0000;
                vec_uop = 4'b0000;
                lsu_uop = exec_uop_in;
              end

    default:  begin
                int_uop = 4'b0000;
                vec_uop = 4'b0000;
                lsu_uop = 4'b0000;
              end
  endcase
end

// Drives each execution unit uOp bus
assign int_exec_uop_out = int_uop;
assign vec_exec_uop_out = vec_uop;
assign lsu_exec_uop_out = lsu_uop;

endmodule
