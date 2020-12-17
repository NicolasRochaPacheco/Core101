// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module PREDICTOR_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
	reg predictor_clock_in;
  reg predictor_reset_in;
	reg [XLEN-1:0] predictor_pred_addr_in;
  reg predictor_feedback_result_in;
  reg predictor_feedback_write_enable_in;
  reg [XLEN-1:0] predictor_feedback_addr_in;
  reg [XLEN-1:0] predictor_feedback_return_in;

	// Definition of golden registers
	reg predictor_pred_enable_golden;
  reg [XLEN-1:0] predictor_pred_addr_golden;

	// Definition of results registers
	reg predictor_pred_enable_result;
  reg predictor_pred_addr_result;

	// Definition of output wires
  wire predictor_pred_enable_out;
	wire [XLEN-1:0] predictor_pred_addr_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	PREDICTOR predictor0 (
    .predictor_clock_in(predictor_clock_in),
    .predictor_reset_in(predictor_reset_in),
    .predictor_pred_addr_in(predictor_pred_addr_in),
    .predictor_pred_enable_out(predictor_pred_enable_out),
    .predictor_pred_addr_out(predictor_pred_addr_out),
    .predictor_feedback_result_in(predictor_feedback_result_in),
    .predictor_feedback_write_enable_in(predictor_feedback_write_enable_in),
    .predictor_feedback_addr_in(predictor_feedback_addr_in),
    .predictor_feedback_return_in(predictor_feedback_return_in)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/PREDICTOR_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/PREDICTOR_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/PREDICTOR_results.txt", "w");

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

      // Starts clock on 0
      predictor_clock_in = 1'b1;

			// Main simulation loop
			while(!$feof(inputs)) begin

				// Reads inputs file
				status = $fscanf(
					inputs,
					"%d %d %d %d %d %d",
					predictor_reset_in,
          predictor_pred_addr_in,
          predictor_feedback_result_in,
          predictor_feedback_write_enable_in,
          predictor_feedback_addr_in,
          predictor_feedback_return_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d %d",
					predictor_pred_enable_golden,
          predictor_pred_addr_golden
				);

				// Waits
				#period;

        predictor_clock_in = ~predictor_clock_in;

				// Asserts signals
				if (predictor_pred_enable_out == predictor_pred_enable_golden)
					predictor_pred_enable_result = 1'b1;
				else
					predictor_pred_enable_result = 1'b0;

        if (predictor_pred_addr_out == predictor_pred_addr_golden)
					predictor_pred_addr_result = 1'b1;
				else
					predictor_pred_addr_result = 1'b0;

        if (!predictor_pred_enable_result | !predictor_pred_addr_result) begin
          $display("========================");
          $display("%d, %d", predictor_pred_enable_out, predictor_pred_addr_out);
          $display("%d, %d", predictor_pred_enable_golden, predictor_pred_addr_golden);
        end

        #period;

        predictor_clock_in = ~predictor_clock_in;

				// Writes to results file
				$fwrite(
					results,
					"%d %d\n",
					predictor_pred_enable_result,
          predictor_pred_addr_result
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
