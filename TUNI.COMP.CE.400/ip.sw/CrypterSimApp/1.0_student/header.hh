#ifndef HEADER_HH
#define HEADER_HH

#include "systemc.h"
#include "value1.hh"
#include <string>

//Index, where read/write bit is located
#define ENABLE_INDEX 0
//Index, where value to be passed between processes is located
#define VALUE_INDEX 1
//The key used to encrypt the value
#define KEY 0xDEADBEEF

//The name of the input file
extern std::string input_file_name;

//Event used to signal to the user of the module that a new input may be written.
extern sc_event input_ready;

//Event used to signal to the user of the module that a new output may be read.
extern sc_event output_valid;

//How many nanoseconds it takes to access the shared memory
#define MEMORY_DELAY 10

//HOW MANY NANO SECONDS TAKES COMMUNICATION IN PROCESS1 -> PROCESS2
#define P1_P2_DELAY LOAD /  I2C_SPEED
//HOW MANY NANO SECONDS TAKES COMMUNICATION IN PROCESS3 -> PROCESS4
#define P3_P4_DELAY LOAD /  I2C_SPEED

//HOW MANY NANO SECONDS TAKES IT TAKES TO PROCESS FOR PROCESS1
#define P1_LATENCY P1_PROCESS_CYCLES / P1_PROCESSOR
//HOW MANY NANO SECONDS TAKES IT TAKES TO PROCESS FOR PROCESS4
#define P4_LATENCY P4_PROCESS_CYCLES / P4_PROCESSOR

//How much load per transfer
#define LOAD 100

//Speed of I2C bus ON THE PLATFORM
#define I2C_SPEED 10

//Speed of AMBA bus ON THE PLATFORM
#define AMBA_SPEED 30

//How many processor cycles the data processing will take
#define P1_PROCESS_CYCLES 100
#define P4_PROCESS_CYCLES 1600

//The processors of processes
#define P1_PROCESSOR PORIN_HERTTA
#define P4_PROCESSOR RAUMAN_AVAIN

//Clock frequencies of the processors
#define PORIN_HERTTA 400
#define RAUMAN_AVAIN 100

#endif
