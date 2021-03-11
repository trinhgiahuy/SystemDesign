#ifndef EXPLORATION_H_
#define EXPLORATION_H_

// Data transfers
typedef enum {CONFIG=0,UNFILT1,UNFILT2,ORIG,LAMBDA,RESULT} data_transfers_t;
extern int data_amount[6]; //bytes
extern int data_transfers[6]; // number of transfers

// ARM exploration
#define ARM_STOCK_MHZ 925
#define ARM_USED_CORES 1
const int arm_overclock_mhz_c = 925;

// Encoder simulation values
const int delay_c = 1;
const double search_intra_rough_percentage_c = 0;
const double rest_percentage_c = 0;

// HPS->FPGA->HPS simulation values
const double onchip_fpga_to_hps_ns_per_byte_c = 0;
const double hps_to_onchip_fpga_ns_per_byte_c = 0;
const double hps_ddr_to_fpga_ns_per_byte_c = 0;

// Accelerator exploration
#define NUMBER_OF_ACCS 1
#define FPGA_FREQ_MHZ 90
const int period_ns_c = 1000/FPGA_FREQ_MHZ;

#endif
