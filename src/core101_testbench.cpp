#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "verilated.h"
#include "VCore101_top.h"

// This will be stored on a simulation file
void print_sim_status(int data[21]){
  std::printf("CC%03i, ", data[0]);  // Clock cycle value
  std::printf("%08X, ", data[1]); // PC on IF/ID
  std::printf("%08X, ", data[2]); // PC on ID/IS
  std::printf("%08X, ", data[3]); // PC on IS/EX
  std::printf("%08X, ", data[4]); // PC on EX/WB
  std::printf("%02i, ", data[5]); // RD addr on IF/ID
  std::printf("%02i, ", data[6]);
  std::printf("%02i, ", data[7]);
  std::printf("%02i, ", data[8]);
  std::printf("%05i, ", data[9]);   // IMM value
  std::printf("%05i, ", data[10]);
  std::printf("%05i, ", data[11]);
  std::printf("%05i, ", data[12]);
  std::printf("%05i, ", data[13]);
  std::printf("%05i, ", data[14]);
  std::printf("%05i, ", data[15]);
  std::printf("%01i, ", data[16]);
  std::printf("%05i, ", data[17]); // Data to be written on RD
  std::printf("%01i, ", data[18]);
  std::printf("%01i, ", data[19]);
  std::printf("%01i, ", data[20]);
  std::cout << std::endl;
}


int main(int argc, char **argv){

  // Starts Verilator
  Verilated::commandArgs(argc, argv);

  // Creates the Core101 object
  VCore101_top* core = new VCore101_top;

  // Clock signal parameters
  const int N_CLOCKS = 32;
  const int RESOLUTION = 2;

  int clock_arr[N_CLOCKS*RESOLUTION];
  int cc_val;

  int halt;

  // Creates the clock array
  for(int i=0; i<N_CLOCKS*RESOLUTION; ++i){
    if (i%RESOLUTION <= (RESOLUTION/2-1)){
      clock_arr[i] = 1;
    } else {
      clock_arr[i] = 0;
    }
  }

  // Prints headers
  std::cout << "CC, PC_IF, PC_IS" << "\n";

  // Main simulation cicle
  for (int k=0; k < N_CLOCKS*RESOLUTION; ++k){

    // Sets clock signal
    core->clock_in = clock_arr[k];

    // Calculates clock cycle
    cc_val = k / RESOLUTION;

    // Resets the core
    if (cc_val < 5){
      if ( clock_arr[k] == 0 && cc_val == 4 ){
        core->reset_in = 0;
      }
      else {
        core->reset_in = 1;
      }
    } else {
      core->reset_in = 0;
    }

    // Halt test
    if (cc_val > 10 && cc_val < 15){
      halt = 1;
    } else {
      halt = 0;
    }

    core->halt_in = halt;

    // Generates core outputs
    core->eval();

    // An array to store outputs from the core as the simulation runs.
    int data[21];

    data[0] = cc_val; // Clock cycle value.
    data[1] = (int) core->pc_data_if_id_out;  // PC value on IF/ID
    data[2] = (int) core->pc_data_id_is_out;  // PC value on ID/IS
    data[3] = (int) core->pc_data_is_ex_out;  // PC value on IS/EX
    data[4] = (int) core->pc_data_ex_wb_out;  // PC value on EX/WB
    data[5] = (int) core->rd_addr_if_id_out;
    data[6] = (int) core->rd_addr_id_is_out;
    data[7] = (int) core->rd_addr_is_ex_out;
    data[8] = (int) core->rd_addr_ex_wb_out;
    data[9] = (int) core->imm_data_out;
    data[10] = (int) core->id_rs1_data_out;
    data[11] = (int) core->id_rs2_data_out;
    data[12] = (int) core->is_a_src_data_out;
    data[13] = (int) core->is_b_src_data_out;
    data[14] = (int) core->int_ex_a_src_data_out;
    data[15] = (int) core->int_ex_b_src_data_out;
    data[16] = (int) core->int_uop_out;
    data[17] = (int) core->wb_data_out;
    data[18] = (int) core->ifu_mux_sel_out;
    data[19] = (int) core->ifu_ctrl_data_out;
    data[20] = (int) core->exec_unit_sel_out;


    // Prints simulation status on screen
    print_sim_status(data);
  }

  // Exits
  exit(EXIT_SUCCESS);
}
