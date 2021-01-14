#ifndef HEADER_HH
#define HEADER_HH

#include "systemc.h"
#include <string>

//The key used to encrypt the value
#define KEY 0xDEADBEEF

//The name of the input file
extern std::string input_file_name;

//Event used to signal to the user of the module that a new input may be written.
extern sc_event input_ready;

//Event used to signal to the user of the module that a new output may be read.
extern sc_event output_valid;

#endif
