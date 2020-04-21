#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <ctime>

#include "verilated.h"
#include "VCore101_top.h"

// This will be stored on a simulation file
void print_sim_status(int data[19], FILE* output){ //std::ofstream& output){

  //output << "For CC" << data[0] << std::endl;
  //output << "    PC on IF/ID: " << data[1] << std::endl;

  std::fprintf(output, "For CC%03i: \n", data[0]);
  std::fprintf(output, "    PC on IF/ID: %08X \n", data[1]);
  std::fprintf( output,
                "    RD: %02i; E: %01i; Data: %08i \n",
                data[2], data[4], data[3]);
  std::fprintf(output, "    INT uOP: %02i; Enable \n", data[5]);
  std::fprintf(output, "    LSU uOP: %02i \n", data[6]);
  std::fprintf(output, "    VEC uOP: %02i \n", data[7]);
  std::fprintf(output, "    BRU uOP: %02i; Enable: %i \n", data[8], data[11]);
  std::fprintf(output, "    Branch taken: %i \n", data[12]);
  std::fprintf(output, "    BRU A: %08i B: %08i \n", data[13], data[14]);
  std::fprintf(output, "======================================\n");
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

  int halt;

  // Retrieves the current time
  time_t now = time(0);
  tm *ltm = localtime(&now);
  int date[6];
  date[0] = 1900 + ltm->tm_year;
  date[1] = ltm->tm_mon+1;
  date[2] = ltm->tm_mday;
  date[3] = ltm->tm_hour;
  date[4] = ltm->tm_min;
  date[5] = 1 + ltm->tm_sec;

  // Creates the file
  //std::ofstream output_file;
  //output_file.open("output_data.txt");
  //output_file << date_text << std::endl;

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
    int data[19];

    data[0] = cc_val;                         // Clock cycle value.
    data[1] = (int) core->pc_data_if_id_out;  // PC value on IF/ID
    data[2] = (int) core->rd_addr_ex_wb_out;  // RD on WB stage
    data[3] = (int) core->wb_data_out;        // Data to be written on RD
    data[4] = (int) core->rd_write_enable_out;// Enable signal for RD
    data[5] = (int) core->int_uop_out;        // INT uOP on EX
    data[6] = (int) core->lsu_uop_out;        // LSU uOP on EX
    data[7] = (int) core->vec_uop_out;        // VEC uOP on EX
    data[8] = (int) core->bru_uop_out;        // BRU uOP on EX
    data[11] = (int) core->bru_enable_out;    // BRU enable out
    data[12] = (int) core->branch_taken_out;  // Branch taken out
    data[13] = (int) core->bru_a_src_out;     // BRU A data
    data[14] = (int) core->bru_b_src_out;     // BRU B data

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
