// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module BRU_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
  reg bru_enable_in;
  reg bru_prediction_in;
  reg [3:0] bru_uop_in;
	reg [XLEN-1:0] bru_pc_in;
  reg [XLEN-1:0] bru_rs1_in;
  reg [XLEN-1:0] bru_rs2_in;
  reg [XLEN-1:0] bru_imm_in;

	// Definition of golden registers
	reg bru_correction_golden;
  reg [XLEN-1:0] bru_target_golden;
  reg bru_feedback_result_golden;
  reg bru_feedback_write_en_golden;

	// Definition of results registers
	reg bru_correction_result;
  reg bru_target_result;
  reg bru_feedback_result_result;
  reg bru_feedback_write_en_result;

	// Definition of output wires
	wire bru_correction_out;
  wire [XLEN-1:0] bru_target_out;
  wire bru_feedback_result_out;
  wire bru_feedback_write_en_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	BRU bru0 (
    .bru_enable_in(bru_enable_in),
    .bru_prediction_in(bru_prediction_in),
    .bru_uop_in(bru_uop_in),
    .bru_pc_in(bru_pc_in),
    .bru_rs1_in(bru_rs1_in),
    .bru_rs2_in(bru_rs2_in),
    .bru_imm_in(bru_imm_in),
    .bru_correction_out(bru_correction_out),
    .bru_target_out(bru_target_out),
    .bru_feedback_result_out(bru_feedback_result_out),
    .bru_feedback_write_en_out(bru_feedback_write_en_out)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/BRU_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/BRU_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/BRU_results.txt", "w");

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
					"%d %d %d %d %d %d %d",
					bru_enable_in,
          bru_prediction_in,
          bru_uop_in,
          bru_pc_in,
          bru_rs1_in,
          bru_rs2_in,
          bru_imm_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d %d %d %d",
					bru_correction_golden,
          bru_target_golden,
          bru_feedback_result_golden,
          bru_feedback_write_en_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (bru_correction_out == bru_correction_golden)
					bru_correction_result = 1'b1;
				else begin
					bru_correction_result = 1'b0;
          $display("ERROR!");
				end

        if(bru_target_out == bru_target_golden)
          bru_target_result = 1'b1;
        else begin
          bru_target_result = 1'b0;
        end

        if(bru_feedback_result_out == bru_feedback_result_golden)
          bru_feedback_result_result = 1'b1;
        else begin
          bru_feedback_result_result = 1'b0;
          $display("ERROR: %d %d", bru_feedback_result_out, bru_feedback_result_golden);
        end

        if(bru_feedback_write_en_out == bru_feedback_write_en_golden)
          bru_feedback_write_en_result = 1'b1;
        else
          bru_feedback_write_en_result = 1'b0;

				// Writes to results file
				$fwrite(
					results,
					"%d %d %d %d\n",
					bru_correction_result,
          bru_target_result,
          bru_feedback_result_result,
          bru_feedback_write_en_result
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
