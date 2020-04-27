module Core101_top (
  input clock_in,
  input reset_in
);

//
Core101 core101 (
  .clock_in(clock_in),
  .reset_in(reset_in),
  .ins_mem_data_in(),
  .ins_mem_addr_out()
);

//
MAIN_MEMORY mem (
  .main_mem_addr_in(),
  .main_mem_data_out()
);

endmodule // Core101_top
