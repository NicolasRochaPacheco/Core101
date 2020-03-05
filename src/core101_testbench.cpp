#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "verilated.h"
#include "VCore101_top.h"

void print_sim_status(int& cc_val, const int& clock_val, const int& mem_read_out){
  std::printf("%i \t %i \t %08x \n", cc_val, clock_val, mem_read_out);
}


int main(int argc, char **argv){

  // Starts Verilator
  Verilated::commandArgs(argc, argv);

  // Creates the Core101 object
  VCore101_top* core = new VCore101_top;

  // Clock signal parameters
  const int N_CLOCKS = 100;
  int clock_arr[N_CLOCKS*2];
  int cc_val;

  // Creates the clock array
  for(int i=0; i<N_CLOCKS*2; ++i){
    if (i%2==0){
      clock_arr[i] = 0;
    } else {
      clock_arr[i] = 1;
    }
  }

  // Main simulation cicle
  for (int k=0; k < N_CLOCKS*2; ++k){
    // Sets clock signal
    core->clock_in = clock_arr[k];

    // Calculates clock cycle
    cc_val = k / 2;

    // Resets the core
    if (cc_val < 5){
      core->reset_in = 1;
    } else {
      core->reset_in = 0;
    }

    if (cc_val > 15 && cc_val < 20){
      core->halt_in = 1;
    } else {
      core->halt_in = 0;
    }

    // Generates core outputs
    core->eval();

    // Prints simulation status
    print_sim_status(cc_val, clock_arr[k], core->ins_mem_addr_out);

  }

  // Exits
  exit(EXIT_SUCCESS);
}
