// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module LSU_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of clock input
	reg clock_in = 1'b0;

	// Definition of input registers
	reg lsu_enable_in;
	reg [3:0] lsu_uop_in;
  reg [XLEN-1:0] lsu_a_data_in;
  reg [XLEN-1:0] lsu_b_data_in;
	reg [XLEN-1:0] lsu_c_data_in;
	reg [XLEN-1:0] data_mem_data_in;

	// Definition of golden registers
	reg lsu_mem_valid_golden;
  reg [2:0] lsu_mem_opcode_golden;
  reg [XLEN-1:0] lsu_mem_addr_golden;
	reg [XLEN-1:0] lsu_mem_data_out_golden;
  reg [XLEN-1:0] lsu_result_golden;

	// Definition of results registers
	reg lsu_mem_valid_result;
	reg lsu_mem_opcode_result;
  reg lsu_mem_addr_result;
	reg lsu_mem_data_out_result;
  reg lsu_result_result;

	// Definition of output wires
  wire lsu_mem_valid_out;
  wire [2:0] lsu_mem_opcode_out;
  wire [XLEN-1:0] lsu_mem_addr_out;
	wire [XLEN-1:0] lsu_mem_data_out;
  wire [XLEN-1:0] lsu_result_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	LSU lsu0 (
    .lsu_enable_in(lsu_enable_in),                    // Enable signal input
    .lsu_uop_in(lsu_uop_in),                 // Input for uOP bus
    .lsu_a_data_in(lsu_a_data_in),         // A input bus (data)
    .lsu_b_data_in(lsu_b_data_in),         // B input bus (base)
    .lsu_c_data_in(lsu_c_data_in),         // C input bus (imm)

    // Data memory interface
    .lsu_mem_valid_out(lsu_mem_valid_out),           // Valid signal
    .lsu_mem_opcode_out(lsu_mem_opcode_out),    // Opcode signal
    .lsu_mem_addr_out(lsu_mem_addr_out), // Address memory bus
    .lsu_mem_data_out(lsu_mem_data_out), // Output data memory bus
    .lsu_mem_data_in(data_mem_data_in),       // Input memory bus

    // LSU output data
    .lsu_result_out(lsu_result_out)    // Result output data
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/LSU_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/LSU_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/LSU_results.txt", "w");

			// Checks golden file
			if (golden == `NULL) begin
				$display("Golden file was NULL");
				$finish;
			end

			// Checks inputs file
			if(inputs == `NULL) begin
				$display("Inputs file was NULL");
			end

			// Checks result file
			if(results == `NULL) begin
				$display("Results file was NULL");
			end

			// Main simulation loop
			while(!$feof(inputs)) begin

				// Reads inputs file
				status = $fscanf(
					inputs,
					"%d %d %d %d %d %d",
					lsu_enable_in,
					lsu_uop_in,
					lsu_a_data_in,
					lsu_b_data_in,
					lsu_c_data_in,
					data_mem_data_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d %d %d %d %d",
					lsu_mem_valid_golden,
					lsu_mem_opcode_golden,
          lsu_mem_addr_golden,
          lsu_mem_data_out_golden,
          lsu_result_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (lsu_mem_valid_out == lsu_mem_valid_golden)
					lsu_mem_valid_result = 1'b1;
				else begin
					lsu_mem_valid_result = 1'b0;
          $display("%d %d", lsu_mem_valid_out, lsu_mem_valid_golden);
				end

				// Asserts signals
				if (lsu_mem_opcode_out == lsu_mem_opcode_golden)
					lsu_mem_opcode_result = 1'b1;
				else begin
					lsu_mem_opcode_result = 1'b0;
          $display("%d %d %d", lsu_uop_in, lsu_mem_opcode_out, lsu_mem_opcode_golden);
				end

				// Writes to results file
				$fwrite(
					results,
					"%d %d\n",
					lsu_mem_valid_result,
					lsu_mem_opcode_result
				);

			end

			$display("Simulation has ended");

			$fclose(golden);
			$fclose(inputs);
			$fclose(results);

			@eachvec;
			$finish;

		end
endmodule
