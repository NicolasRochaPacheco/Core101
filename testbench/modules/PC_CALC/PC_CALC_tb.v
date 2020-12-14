// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module PC_CALC_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
	reg pc_calc_correction_en_in;
	reg pc_calc_prediction_en_in;
	reg [XLEN-1:0] pc_calc_current_in;
	reg [XLEN-1:0] pc_calc_correction_in;
	reg [XLEN-1:0] pc_calc_prediction_in;

	// Definition of golden registers
	reg pc_calc_pred_golden;
	reg [XLEN-1:0] pc_calc_addr_golden;

	// Definition of results registers
	reg pc_calc_pred_result;
	reg pc_calc_addr_result;

	// Definition of output wires
	wire pc_calc_pred_out;
	wire [XLEN-1:0] pc_calc_addr_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	PC_CALC #(.XLEN(XLEN)) pc_calc0 (
		.pc_calc_correction_en_in(pc_calc_correction_en_in),
		.pc_calc_prediction_en_in(pc_calc_prediction_en_in),
		.pc_calc_current_in(pc_calc_current_in),
		.pc_calc_correction_in(pc_calc_correction_in),
		.pc_calc_prediction_in(pc_calc_prediction_in),
		.pc_calc_pred_out(pc_calc_pred_out),
		.pc_calc_addr_out(pc_calc_addr_out)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/PC_CALC_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/PC_CALC_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/PC_CALC_results.txt", "w");

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
					"%d %d %d %d %d",
					pc_calc_correction_en_in,
					pc_calc_prediction_en_in,
					pc_calc_current_in,
					pc_calc_correction_in,
					pc_calc_prediction_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d %d",
					pc_calc_pred_golden,
					pc_calc_addr_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (pc_calc_pred_out == pc_calc_pred_golden)
					pc_calc_pred_result = 1'b1;
				else
					pc_calc_pred_result = 1'b0;

				if (pc_calc_addr_out == pc_calc_addr_golden)
					pc_calc_addr_result = 1'b1;
				else
					pc_calc_addr_result = 1'b0;

				// Writes to results file
				$fwrite(
					results,
					"%d %d\n",
					pc_calc_pred_result,
					pc_calc_addr_result
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
