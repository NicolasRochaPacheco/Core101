// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module FWD_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

	// Definition of input registers
	reg [4:0] fwd_if_ra_addr_in;
  reg [4:0] fwd_if_rb_addr_in;
  reg [4:0] fwd_id_rd_addr_in;

	// Definition of golden registers
	reg [1:0] fwd_mux_sel_golden;

	// Definition of results registers
	reg fwd_mux_sel_result;

	// Definition of output wires
	wire [1:0] fwd_mux_sel_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	FORWARDING_UNIT fwd0 (
    .fwd_if_ra_addr_in(fwd_if_ra_addr_in),
    .fwd_if_rb_addr_in(fwd_if_rb_addr_in),
    .fwd_id_rd_addr_in(fwd_id_rd_addr_in),
    .fwd_mux_sel_out(fwd_mux_sel_out)
	);


	initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/FWD_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/FWD_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/FWD_results.txt", "w");

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
					fwd_if_ra_addr_in,
					fwd_if_rb_addr_in,
					fwd_id_rd_addr_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d",
					fwd_mux_sel_golden
				);

				// Waits
				#period;

				// Asserts signals
				if (fwd_mux_sel_out == fwd_mux_sel_golden)
					fwd_mux_sel_result = 1'b1;
				else begin
					fwd_mux_sel_result = 1'b0;
				end

				// Writes to results file
				$fwrite(
					results,
					"%d\n",
					fwd_mux_sel_result
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
