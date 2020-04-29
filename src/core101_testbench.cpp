#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <ctime>

#include "verilated.h"
#include "VCore101_top.h"

// This will be stored on a simulation file
void print_sim_status(int data[19], FILE* output){
  std::fprintf(output, "For CC%03i: \n", data[0]);
  std::fprintf(output, "    ---------- IF/ID ----------\n");
  std::fprintf(output, "    Prediction: %01d \n", data[1]);
  std::fprintf(output, "    PC: %08X; IR: %08X \n", data[2], data[3]);
  std::fprintf(output, "    ---------- ID/IS ----------\n");
  std::fprintf(output, "    IMM: %i; FWD: %i; \n", data[4], data[5]);
  std::fprintf(output, "    ---------- IS/EX ----------\n");
  std::fprintf(output, "    INT uOP: %01i;\n", data[12]);

  // Output for debug stage
  std::fprintf(output, "    ---------- EX/WB ----------\n");
  std::fprintf(output, "    WB data: %i; RD: %02i; E: %01i; \n",
                       data[17], data[18], data[16]);
  std::fprintf(output, "=======================================\n");
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

  // Output file
  FILE *output_file;
  output_file = fopen("output_data.txt", "w");


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

    // An array to store outputs from the core as the simulation runs.
    int data[19];

    data[0] = cc_val;                           // Clock cycle value.
    // IF/ID
    data[1] = (int) core->if_id_prediction_out; // Prediction on IF/ID
    data[2] = (int) core->pc_data_if_id_out;    // PC value on IF/ID
    data[3] = (int) core->ir_data_if_id_out;    // IR value on IF/ID
    // ID/IS
    data[4] = (int) core->imm_data_out;         // Immediate value
    data[5] = (int) core->id_is_fwd_out;        // FWD sel signal

    // IS/EX
    data[12] = (int) core->int_uop_out;         // INT uOP data

    // EX/WB
    data[16] = (int) core->rd_write_enable_out; // RD write enable
    data[17] = (int) core->wb_data_out;         // WB data output
    data[18] = (int) core->rd_addr_ex_wb_out;   // RD address


    // Prints simulation status on screen
    if(clock_arr[k] == 1){
      print_sim_status(data, output_file);
    }
  }

  //output_file.close();
  fclose(output_file);

  // Exits
  exit(EXIT_SUCCESS);
}
