

module MEMORY #(
  parameter DATA_WIDTH    = 32,
  parameter INS_MEM_ADDR  = 8,
  parameter DATA_MEM_ADDR = 6
) (

  // Clock and reset in
  input       clock_in,
  input       reset_in,

  // Instruction memory interface
  input       ins_mem_valid_in,
  input       [DATA_WIDTH-1:0] ins_mem_addr_in,
  output reg  ins_mem_ready_out,
  output reg  [DATA_WIDTH-1:0] ins_mem_data_out,

  // Data memory interface
  input       data_mem_valid_in,
  input       [2:0] data_mem_opcode_in,
  input       [DATA_WIDTH-1:0] data_mem_addr_in,
  input       [DATA_WIDTH-1:0] data_mem_data_in,
  output reg  data_mem_ready_out,
  output reg  [DATA_WIDTH-1:0] data_mem_data_out

);

// Calculates memories length
localparam INS_MEM_LEN  = 2 ** INS_MEM_ADDR;
localparam DATA_MEM_LEN = 2 ** DATA_MEM_ADDR;

// MEMORY DEFINITION
reg [7:0] ins_mem [0:INS_MEM_LEN-1];
reg [7:0] data_mem [0:DATA_MEM_LEN-1];

// Signal reg for data memory writes

// Initializes instruction memory with HEX file
initial
  $readmemh("./rtl/memory/ins_mem.hex", ins_mem);

// Defines combinational memory behaviour
always @ ( * ) begin

  // Instruction memory
  if(ins_mem_valid_in == 1'b1) begin

    // Sets output data
    ins_mem_data_out = {
      ins_mem[ins_mem_addr_in[MEM_ADDR-1:0] + 3],
      ins_mem[ins_mem_addr_in[MEM_ADDR-1:0] + 2],
      ins_mem[ins_mem_addr_in[MEM_ADDR-1:0] + 1],
      ins_mem[ins_mem_addr_in[MEM_ADDR-1:0]]
    };

    // Sets ready signal on HIGH
    ins_mem_ready_out = 1'b1;

  end

  // Data memory
  if(data_mem_valid_in == 1'b1) begin


  end

end


endmodule
