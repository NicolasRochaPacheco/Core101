// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module IMM_GEN_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
	reg [6:0] imm_gen_opcode_in;
	reg [24:0] imm_gen_ins_in;

	// Definition of golden registers
	reg [XLEN-1:0] imm_gen_data_golden;

	// Definition of results registers
	reg imm_gen_data_result;

	// Definition of output wires
	wire [XLEN-1:0] imm_gen_data_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	IMM_GEN imm_gen0 (
    .imm_gen_opcode_in(imm_gen_opcode_in),
    .imm_gen_ins_in(imm_gen_ins_in),
    .imm_gen_data_out(imm_gen_data_out)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/IMM_GEN_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/IMM_GEN_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/IMM_GEN_results.txt", "w");

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
			while(!$feof(golden)) begin

				// Reads inputs file
				status = $fscanf(
					inputs,
					"%d %d",
					imm_gen_opcode_in,
					imm_gen_ins_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d",
					imm_gen_data_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (imm_gen_data_out == imm_gen_data_golden)
					imm_gen_data_result = 1'b1;
				else
					imm_gen_data_result = 1'b0;

				// Writes to results file
				$fwrite(
					results,
					"%d\n",
					imm_gen_data_result
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
