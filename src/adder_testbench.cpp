#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "VADDER.h"
#include "verilated.h"

int main(int argc, char **argv){
  // Initialize Verilators variables
  Verilated::commandArgs(argc, argv);

  // Create an instance of the module under test
  VADDER *tb = new VADDER;

  // Perform the tests
  tb->a_operand_in = 5;
  tb->b_operand_in = 10;
  tb->eval();
  std::printf("%i \n", tb->add_result_out);
  
  tb->a_operand_in = 5;
  tb->b_operand_in = -10;
  tb->eval();
  std::printf("%i \n", tb->add_result_out);

  tb->a_operand_in = -5;
  tb->b_operand_in = -10;
  tb->eval();
  std::printf("%i \n", tb->add_result_out);
  
  exit(EXIT_SUCCESS);
}
