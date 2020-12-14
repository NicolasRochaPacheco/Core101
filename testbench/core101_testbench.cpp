#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <ctime>

#include "verilated.h"
#include "VCore101_top.h"

#if VM_TRACE
  #include <verilated_vcd_c.h>
#endif

// Instansiates the module
VCore101_top* core;

// Current simulation time
vluint64_t main_time = 0;

//
double sc_time_stamp() {
  return main_time;
}

int main(int argc, char **argv){

  // Starts Verilator
  Verilated::commandArgs(argc, argv);

  // Creates the Core101 object
  core = new VCore101_top;

#if VM_TRACE
  VerilatedVcdC* tfp = new VerilatedVcdC;
  Verilated::traceEverOn(true);  // Verilator must compute traced signals
  VL_PRINTF("Enabling waves into /output.vcd...\n");
  tfp = new VerilatedVcdC;
  core->trace(tfp, 99);  // Trace 99 levels of hierarchy
  tfp->open("./out/output.vcd");  // Open the dump file
#endif

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

    #if VM_TRACE
      if (tfp) tfp->dump(main_time);
    #endif

    // Time passes
    main_time++;

  }

  //
  if (tfp) { tfp->close(); }

  // Exits
  exit(EXIT_SUCCESS);
}
