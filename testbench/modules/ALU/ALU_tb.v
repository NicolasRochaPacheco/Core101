// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module ALU_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
	reg [XLEN-1:0] a_data_in;
  reg [XLEN-1:0] b_data_in;
	reg [3:0] opcode_in;

	// Definition of golden registers
	reg [XLEN-1:0] alu_result_golden;

	// Definition of results registers
	reg alu_result;

	// Definition of output wires
	wire [XLEN-1:0] alu_result_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	ALU alu0 (
    .a_data_in(a_data_in),
    .b_data_in(b_data_in),
    .uop_in(opcode_in),
    .result_out(alu_result_out)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/ALU_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/ALU_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/ALU_results.txt", "w");

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
					"%d %d %d",
					a_data_in,
					b_data_in,
          opcode_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d",
					alu_result_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (alu_result_out == alu_result_golden)
					alu_result = 1'b1;
				else begin
					alu_result = 1'b0;
          $display("%d %d %d %d %d", a_data_in, b_data_in, opcode_in, alu_result_out, alu_result_golden);
				end

				// Writes to results file
				$fwrite(
					results,
					"%d\n",
					alu_result
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
