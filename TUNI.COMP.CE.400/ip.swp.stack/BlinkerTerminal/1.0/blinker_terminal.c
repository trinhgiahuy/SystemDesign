#include "blinker_hal.h"

#include <stdio.h>

void init_HAL()
{
}

uint8_t read_btn()
{
	//Read button press...
	char c = getc( stdin );
	
	//And choose mask based on press
	if ( c == '1' )
		return 0x01;
	
	if ( c == '2' )
		return 0x02;
	
	//Something else means zero mask.
	return 0x00;
}

void set_led( uint8_t mask )
{	
	if ( mask == 0x01 )
	{
		//One: make it blue
		printf("\e[94m");
	}
	else if ( mask == 0x02)
	{
		//Two: make it red
		printf("\e[91m");
	}
	else
	{
		//Something else: termiate colouring
		printf("\e[0m");
	}
	
	//Print the message
	printf("blink\n");
}
