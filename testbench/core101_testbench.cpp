#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <ctime>

#include "verilated.h"
#include "VCore101_top.h"


int main(int argc, char **argv){

  // Starts Verilator
  Verilated::commandArgs(argc, argv);

  // Creates the Core101 object
  VCore101_top* core = new VCore101_top;

  // Clock signal parameters
  const int N_CLOCKS = 64;
  const int RESOLUTION = 2;

  int clock_arr[N_CLOCKS*RESOLUTION];
  int cc_val;

  // Creates the clock array
  for(int i=0; i<N_CLOCKS*RESOLUTION; ++i){
    if (i%RESOLUTION <= (RESOLUTION/2-1)){
      clock_arr[i] = 1;
    } else {
      clock_arr[i] = 0;
    }
  }

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

    // Generates core outputs
    core->eval();
  }

  // Exits
  exit(EXIT_SUCCESS);
}
