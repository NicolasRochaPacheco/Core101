#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <ctime>

#include "verilated.h"
#include "VCore101_top.h"

#define DEBUG_SIGNALS 20

// This will be stored on a simulation file
void print_sim_status(int data[DEBUG_SIGNALS], FILE* output){
  std::fprintf(output, "For CC%03i: \n", data[0]);
  std::fprintf(output, "\t ---------- IF/ID ----------\n");
  std::fprintf(output, "\t \t PRED: \t %01d \n", data[1]);
  std::fprintf(output, "\t \t IR:   \t %08X \n", data[2]);
  std::fprintf(output, "\t \t PC:   \t %08X \n", data[3]);
  std::fprintf(output, "\t ---------- ID/IS ----------\n");
  std::fprintf(output, "\t \t FWD:  \t %i   \n", data[5]);
  std::fprintf(output, "\t \t IMM:  \t %02d \n", data[6]);
  std::fprintf(output, "\t \t PC:   \t %08X \n", data[7]);
  std::fprintf(output, "\t ---------- IS/EX ----------\n");
  std::fprintf(output, "\t \t INTOP:\t %01i;\n", data[12]);
  std::fprintf(output, "\t ---------- EX/WB ----------\n");
  std::fprintf(output, "\t \t E:    \t %03d \n", data[15]);
  std::fprintf(output, "\t \t RD:   \t %02d \n", data[16]);
  std::fprintf(output, "\t \t WB:   \t %03d \n", data[17]);
  std::fprintf(output, "\t \t JMUX: \t %01d \n", data[18]);
  std::fprintf(output, "\t \t JUMP: \t %08X \n", data[19]);
  std::fprintf(output, "=======================================\n");
}


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
    int data[DEBUG_SIGNALS];

    // Clock cycle value
    data[0] = cc_val;                           // Clock cycle value.
    // IF/ID
    data[1] = (int) core->if_id_prediction_out; // Prediction on IF/ID
    data[2] = (int) core->ir_data_if_id_out;    // IR value on IF/ID
    data[3] = (int) core->pc_data_if_id_out;    // PC value on IF/ID
    // ID/IS
    data[5] = (int) core->id_is_fwd_out;        // FWD sel signal
    data[6] = (int) core->imm_data_id_is_out;   // IMM value on ID/IS
    data[7] = (int) core->pc_data_id_is_out;    // PC value on ID/IS

    // IS/EX
    data[12] = (int) core->int_uop_out;         // INT uOP data

    // EX/WB
    data[15] = (int) core->rd_write_enable_out; // RD write enable
    data[16] = (int) core->rd_addr_ex_wb_out;   // RD address
    data[17] = (int) core->wb_data_out;         // WB data output
    data[18] = (int) core->jump_mux_sel_out;
    data[19] = (int) core->jump_target_wb_out;  // Jump target address


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
