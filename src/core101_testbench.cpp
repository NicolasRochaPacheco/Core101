#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "verilated.h"
#include "VCore101_top.h"

void print_sim_status(int data[12]){
  std::printf("%03i ", data[0]);  // Clack cycle value
  std::printf("%i ",   data[1]);  // Clock signal value
  std::printf("%08X ", data[2]);  //
  std::printf("%08X ", data[3]);
  std::printf("%02i ", data[4]);
  std::printf("%02i ", data[5]);
  std::printf("%02i ", data[6]);
  std::printf("%01i ", data[7]);
  std::printf("%01X ", data[8]);
  std::printf("%01X ", data[9]);
  std::printf("%01X ", data[10]);
  std::printf("%i \n", data[11]);
}


int main(int argc, char **argv){

  // Starts Verilator
  Verilated::commandArgs(argc, argv);

  // Creates the Core101 object
  VCore101_top* core = new VCore101_top;

  // Clock signal parameters
  const int N_CLOCKS = 20;
  const int RESOLUTION = 10;

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

  // Prints some info
  std::cout << "CC_VAL; CC; INS_ADDR; INS_DATA; GPRA; GPRB; GPRD; EXEC_SEL; INT_UOP; VEC_UOP; LSU_UOP; IMM_VAL;" << std::endl;

  // Main simulation cicle
  for (int k=0; k < N_CLOCKS*RESOLUTION; ++k){

    // Sets clock signal
    core->clock_in = clock_arr[k];

    // Calculates clock cycle
    cc_val = k / RESOLUTION;

    // Resets the core
    if (cc_val < 5){
      core->reset_in = 1;
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

    int data[12];

    data[0] = cc_val;
    data[1] = clock_arr[k];
    data[2] = (int) core->ins_mem_addr_out;
    data[3] = (int) core->ins_data_out;
    data[4] = (int) core->gpr_a_out;
    data[5] = (int) core->gpr_b_out;
    data[6] = (int) core->gpr_rd_out;
    data[7] = (int) core->exec_unit_sel_out;
    data[8] = (int) core->int_uop_out;
    data[9] = (int) core->vec_uop_out;
    data[10] = (int) core->lsu_uop_out;
    data[11] = (int) core->imm_value_out;

    // Prints simulation status
    print_sim_status(data);

    // Generates core outputs
    core->eval();

  }

  // Exits
  exit(EXIT_SUCCESS);
}
