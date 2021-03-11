//External interface for HAL used by the LED blinker.
#ifndef BLINKERHAL_H
#define BLINKERHAL_H

#include <stdint.h>
//Initializes the hall PRE REQUISITE FOR OTHER FUNCTIONS TO FUNCTION
void init_HAL();

//Reads all FPGA buttons, with LSB being button 0, the next one button 1, etc.
uint8_t read_btn();

//Sets all FPGA LEDs, with LSB being LED 0, the next one LED 1, etc.
void set_led( uint8_t mask );

#endif