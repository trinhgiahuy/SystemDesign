#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include "blinker_hal.h"

static int fd = 0; //file descriptor pointing to the device driver
	
void init_HAL()
{
	//Open the device driver for us to use.
	if ((fd = open("/dev/blinkerDriver", O_RDWR, 0)) < 0)
	{
		perror("error opening");
	}
}

uint8_t read_btn()
{
	uint8_t buf[1];
	buf[0] = 0xFF;
	size_t bytes_read = read( fd, buf, 1 );

	if ( bytes_read < 1)
	{
		fprintf( stderr, "Could not read the byte from driver!\n" );
	}
	
	return buf[0];
}

void set_led( uint8_t mask )
{
	uint8_t buf[1];
	buf[0] = mask;
	size_t bytes_written = write( fd, buf, 1 );
	
	if ( bytes_written < 1 )
	{
		fprintf( stderr, "Could not write the byte to driver!\n" );
	}
}