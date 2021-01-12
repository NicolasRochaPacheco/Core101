// forwarding_unit_tb.v


// Sets timescale for simulation
// time-unit 1ns, precision 10ps
`timescale 1ns/1ps

// Defines NULL value
`define NULL 0

// Declaration of testbench module
module PIPELINE_tb;

	// Defines XLEN
	parameter XLEN = 32;

	// General purpose
	reg eachvec;

  // Module clock in
  reg pipeline_clock_in;

	// Definition of input registers
	reg pipeline_reset_in;
	reg pipeline_bru_correction_flag_in;
	reg pipeline_check_correction_flag_in;
	reg pipeline_ins_mem_ready_in;
  reg pipeline_data_mem_valid_in;
  reg pipeline_data_mem_ready_in;
  reg pipeline_invalid_ins_in;

	// Definition of golden registers
	reg pipeline_ins_mem_valid_golden;
  reg pipeline_pc_if_set_golden;
  reg pipeline_if_dec_set_golden;
  reg pipeline_dec_reg_set_golden;
  reg pipeline_reg_ex_set_golden;
  reg pipeline_ex_wb_set_golden;
  reg pipeline_pc_if_clear_golden;
  reg pipeline_if_dec_clear_golden;
  reg pipeline_dec_reg_clear_golden;
  reg pipeline_reg_ex_clear_golden;
  reg pipeline_ex_wb_clear_golden;

	// Definition of results registers
	reg pipeline_ins_mem_valid_result;
  reg pipeline_pc_if_set_result;
  reg pipeline_if_dec_set_result;
  reg pipeline_dec_reg_set_result;
  reg pipeline_reg_ex_set_result;
  reg pipeline_ex_wb_set_result;
  reg pipeline_pc_if_clear_result;
  reg pipeline_if_dec_clear_result;
  reg pipeline_dec_reg_clear_result;
  reg pipeline_reg_ex_clear_result;
  reg pipeline_ex_wb_clear_result;

	// Definition of output wires
	wire pipeline_ins_mem_valid_out;
  wire pipeline_pc_if_set_out;
  wire pipeline_if_dec_set_out;
  wire pipeline_dec_reg_set_out;
  wire pipeline_reg_ex_set_out;
  wire pipeline_ex_wb_set_out;
  wire pipeline_pc_if_clear_out;
  wire pipeline_if_dec_clear_out;
  wire pipeline_dec_reg_clear_out;
  wire pipeline_reg_ex_clear_out;
  wire pipeline_ex_wb_clear_out;

	// Definition of period parameter
	localparam period = 5;

	// Definition of iteration index value
	integer golden, inputs, results, status;

	// Instantiation of module
	PIPELINE_CONTROL pipeline_ctrl (
		.pipeline_clock_in(pipeline_clock_in),
    .pipeline_reset_in(pipeline_reset_in),
    .pipeline_bru_correction_flag_in(pipeline_bru_correction_flag_in),
    .pipeline_check_correction_flag_in(pipeline_check_correction_flag_in),
    .pipeline_ins_mem_ready_in(pipeline_ins_mem_ready_in),
    .pipeline_ins_mem_valid_out(pipeline_ins_mem_valid_out),
    .pipeline_data_mem_valid_in(pipeline_data_mem_valid_in),
    .pipeline_data_mem_ready_in(pipeline_data_mem_ready_in),
    .pipeline_invalid_ins_in(pipeline_invalid_ins_in),
    .pipeline_pc_if_set_out(pipeline_pc_if_set_out),
    .pipeline_if_dec_set_out(pipeline_if_dec_set_out),
    .pipeline_dec_reg_set_out(pipeline_dec_reg_set_out),
    .pipeline_reg_ex_set_out(pipeline_reg_ex_set_out),
    .pipeline_ex_wb_set_out(pipeline_ex_wb_set_out),
    .pipeline_pc_if_clear_out(pipeline_pc_if_clear_out),
    .pipeline_if_dec_clear_out(pipeline_if_dec_clear_out),
    .pipeline_dec_reg_clear_out(pipeline_dec_reg_clear_out),
    .pipeline_reg_ex_clear_out(pipeline_reg_ex_clear_out),
    .pipeline_ex_wb_clear_out(pipeline_ex_wb_clear_out)
	);

  initial begin

			// Opens golden file
			$display("Opening golden file");
			golden = $fopen("./out/PIPELINE_outputs.txt", "r");

			// Opens inputs file
			$display("Opening inputs file");
			inputs = $fopen("./out/PIPELINE_inputs.txt", "r");

			// Opens results file
			$display("Opening results file");
			results = $fopen("./out/PIPELINE_results.txt", "w");

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

      pipeline_clock_in = 1'b0;

			// Main simulation loop
			while(!$feof(golden)) begin

				// Reads inputs file
				status = $fscanf(
					inputs,
					"%d %d %d %d %d %d %d",
          pipeline_reset_in,
          pipeline_bru_correction_flag_in,
          pipeline_check_correction_flag_in,
          pipeline_ins_mem_ready_in,
          pipeline_data_mem_valid_in,
          pipeline_data_mem_ready_in,
          pipeline_invalid_ins_in
				);

				// Read the golden file
				status = $fscanf(
					golden,
					"%d %d %d %d %d %d %d %d %d %d %d",
					pipeline_ins_mem_valid_golden,
          pipeline_pc_if_set_golden,
          pipeline_if_dec_set_golden,
          pipeline_dec_reg_set_golden,
          pipeline_reg_ex_set_golden,
          pipeline_ex_wb_set_golden,
          pipeline_pc_if_clear_golden,
          pipeline_if_dec_clear_golden,
          pipeline_dec_reg_clear_golden,
          pipeline_reg_ex_clear_golden,
          pipeline_ex_wb_clear_golden
				);

        // Waits
        //#period; pipeline_clock_in = !pipeline_clock_in;
        //#period; pipeline_clock_in = !pipeline_clock_in;

        #period;

				// Asserts signals
				if (pipeline_ins_mem_valid_out == pipeline_ins_mem_valid_golden)
					pipeline_ins_mem_valid_result = 1'b1;
				else begin
					pipeline_ins_mem_valid_result = 1'b0;
          $display("State: %d", pipeline_ctrl.ins_mem_state);
          $display("%d %d", pipeline_ins_mem_valid_out, pipeline_ins_mem_valid_golden);
        end

				if (pipeline_pc_if_set_out == pipeline_pc_if_set_golden)
					pipeline_pc_if_set_result = 1'b1;
				else
					pipeline_pc_if_set_result = 1'b0;

        if (pipeline_if_dec_set_out == pipeline_if_dec_set_golden)
					pipeline_if_dec_set_result = 1'b1;
				else
					pipeline_if_dec_set_result = 1'b0;

        if (pipeline_dec_reg_set_out == pipeline_dec_reg_set_golden)
					pipeline_dec_reg_set_result = 1'b1;
				else begin
					pipeline_dec_reg_set_result = 1'b0;
        end

        if (pipeline_reg_ex_set_out == pipeline_reg_ex_set_golden)
					pipeline_reg_ex_set_result = 1'b1;
				else begin
					pipeline_reg_ex_set_result = 1'b0;
        end

        if (pipeline_ex_wb_set_out == pipeline_ex_wb_set_golden)
					pipeline_ex_wb_set_result = 1'b1;
				else
					pipeline_ex_wb_set_result = 1'b0;


        if (pipeline_pc_if_clear_out == pipeline_pc_if_clear_golden)
					pipeline_pc_if_clear_result = 1'b1;
				else begin
					pipeline_pc_if_clear_result = 1'b0;
          $display("ERROR PC/IF");
        end

        if (pipeline_if_dec_clear_out == pipeline_if_dec_clear_golden)
					pipeline_if_dec_clear_result = 1'b1;
				else begin
					pipeline_if_dec_clear_result = 1'b0;
          $display("ERROR IF/DEC");
        end

        if (pipeline_dec_reg_clear_out == pipeline_dec_reg_clear_golden)
					pipeline_dec_reg_clear_result = 1'b1;
				else begin
					pipeline_dec_reg_clear_result = 1'b0;
          $display("ERROR DEC/REG");
        end

        if (pipeline_reg_ex_clear_out == pipeline_reg_ex_clear_golden)
					pipeline_reg_ex_clear_result = 1'b1;
				else begin
					pipeline_reg_ex_clear_result = 1'b0;
          $display("ERROR REG/EX");
        end

        if (pipeline_ex_wb_clear_out == pipeline_ex_wb_clear_golden)
					pipeline_ex_wb_clear_result = 1'b1;
				else begin
					pipeline_ex_wb_clear_result = 1'b0;
          $display("ERROR EX/WB");
          $display("C: %d G: %d", pipeline_ex_wb_clear_out, pipeline_ex_wb_clear_golden);
        end

        // Waits
        #period; pipeline_clock_in = !pipeline_clock_in;
        #period; pipeline_clock_in = !pipeline_clock_in;

        #period;

				// Writes to results file
				$fwrite(
					results,
					"%d %d %d %d %d %d %d %d %d %d %d\n",
					pipeline_ins_mem_valid_result,
					pipeline_pc_if_set_result,
          pipeline_if_dec_set_result,
          pipeline_dec_reg_set_result,
          pipeline_reg_ex_set_result,
          pipeline_ex_wb_set_result,
          pipeline_pc_if_clear_result,
          pipeline_if_dec_clear_result,
          pipeline_dec_reg_clear_result,
          pipeline_reg_ex_clear_result,
          pipeline_ex_wb_clear_result
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
