
#include "../include/Core101/ifu_testbench.h"

#include "VIFU.h"
#include "verilated.h"

int main(int argc, char **argv){
  // Initialize Verilators variables
  Verilated::commandArgs(argc, argv);

  // Create an instance of the module under test
  VIFU *tb = new VIFU;

  // Array containing clocks
  N_CLOCKS = 100;
  int clocks_arr[N_CLOCKS*2];
  int cc_val;

  // Intializes clock array
  for(int i =0; i<N_CLOCKS*2; ++i){
    if(i % 2 == 0){
      clocks_arr[i] = 0;
    } else {
      clocks_arr[i] = 1;
    }
  }


  // Main simulation for IFU
  for(int k=0; k<N_CLOCKS*2; ++k){
    
    // The clock signal status is assigned
    tb->ifu_clock_in = clocks_arr[k];
    
    cc_val = k / 2;
    
    // Reset signal test
    if(cc_val <= 5){
      tb->ifu_reset_in = 1;
    } else {
      tb->ifu_reset_in = 0;
    }

    // Change PC address to 0x400
    if(cc_val==40){
      if(k % 2 == 0){
        tb->pc_mux_sel_in = 0;
        tb->pc_addr_in = 0x400;
        tb->pc_set_in = 1;
      } else {
        tb->ir_data_in = 0x3287641F;
        tb->ir_set_in = 1;
      }
    } 

    // Increment PC address by 0x200
    else if (cc_val==50){
      if(k % 2 == 0){
        tb->pc_mux_sel_in = 1;
        tb->pc_offset_in = 0x200;
        tb->pc_set_in = 1;
      } else {
        tb->ir_data_in = 0xA64F53E0;
        tb->ir_set_in = 1;
        tb->pc_mux_sel_in = 3;
      }
    }

    // Avoid updating the IR data
    else if (cc_val == 60){
      if(k % 2 == 0){
        tb->pc_mux_sel_in = 2;
        tb->pc_set_in = 1;
      } else {
        tb->ir_data_in = 0x0000FFFF;
        tb->ir_set_in = 1;
        tb->pc_set_in = 0;
      }
    }

    // Update IR data
    else if (cc_val==61){
      if(k % 2 == 0){
        tb->pc_mux_sel_in = 2;
        tb->pc_set_in = 1;
      } else {
        tb->ir_data_in = 0x0000FFFF;
        tb->ir_set_in = 1;
        tb->pc_set_in = 0;
      }
    }

    // PC halt test
    else if (cc_val == 70){
      tb->pc_set_in = 0;
    } 

    // Finish test
    else {
      tb->pc_mux_sel_in = 2;
      tb->pc_set_in = 1;
    }  
    
    tb->eval();

    // Prints outputs for debug purposes
    std::printf("%i \t", cc_val);
    std::printf("%i \t", tb->ifu_clock_in);
    std::printf("%X \t", tb->pc_addr_out);
    std::printf("%X \n", tb->ir_data_out);
  }

  exit(EXIT_SUCCESS);
}