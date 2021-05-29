#include "blinker_hal.h"
#include <stdlib.h>

int main(int argc, char *argv[])
{
	//TODO: Initialize HAL layer
	init_HAL();

	while ( 1 )
	{
		usleep(1000);
		
		//TODO: Control LEDs with buttons
		set_led( read_btn() );
	}

	return EXIT_SUCCESS;
}
