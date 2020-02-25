#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "VCASCADE.h"
#include "verilated.h"


int main(int argc, char **argv){
  // Initialize Verilators variables
  Verilated::commandArgs(argc, argv);

  // Create an instance of the module under test
  VCASCADE *tb = new VCASCADE;

  // Perform the tests
  tb->cascade_adder_a_in = 5;
  tb->cascade_adder_b_in = 10;
  tb->cascade_adder_c_in = 15;
  tb->eval();
  std::printf("%i \n", tb->cascade_adder_sum_out);

  tb->cascade_adder_a_in = 5;
  tb->cascade_adder_b_in = 2;
  tb->cascade_adder_c_in = -20;
  tb->eval();
  std::printf("%i \n", tb->cascade_adder_sum_out);

  tb->cascade_adder_a_in = 5;
  tb->cascade_adder_b_in = 0;
  tb->cascade_adder_c_in = -5;
  tb->eval();
  std::printf("%i \n", tb->cascade_adder_sum_out);

  exit(EXIT_SUCCESS);
}