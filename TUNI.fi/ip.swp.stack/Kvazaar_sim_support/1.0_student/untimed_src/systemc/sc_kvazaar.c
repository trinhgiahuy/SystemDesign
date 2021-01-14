#include "sc_kvazaar.h"
#include "global_supplement.h"
#include <string.h>

// Simulation exit
void kvazaar::sc_exit()
{
	sc_stop();
}

// Used for setting the simulation_error variable
void kvazaar::set_simulation_error(int val)
{
	simulation_error = val;
}

// Used for calling kvazaar main function
void kvazaar::sc_kvazaar_main()
{
	if(kvazaar_main(argc,argv) || simulation_error)
	{
		printf("\nSimulation finished with errors!\n");
		#ifndef IP_DEBUG
		printf("Compile with IP_DEBUG to see more...");
		#endif
	}
	else
	{
		printf("\nSimulation finished successfully!\n");
		SIMULATION_SUCCESSFUL;
	}
    sc_exit();
}

// open() is used for opening the driver, function expects to get the right filename and flags.
// Parameters: filename -- name of the driver
//             flags 	-- access mode
//             mode 	-- not used
// Return value: returns the integer for the opened driver
int kvazaar::open(char const *filename, int flags, int mode)
{
	if((driver_open == 0) && !strcmp(name,filename) && (flags == O_RDWR))
	{
		driver_open = 1;
		return fd_c;
	}
	return -1;
}

// ioctl() is used to control the driver, in this case it set the location variable according to arg
// Parameters: fd  -- integer that determines the opened driver
//             cmd -- command
//			   arg -- additional argument
int kvazaar::ioctl(int fd,unsigned int cmd,unsigned long arg)
{
	CHECK_FD(fd);
    switch( cmd )
	{
		case IOCTL_SET_LOCATION:
		{
			location = arg;
			break;
		}
		default:
			return -1;
	}
	return 1;
}

// read() is used to read data from the class
// Parameters: fd    -- integer that determines the opened driver
//             buff  -- void pointer for data that is allocated in user space
//             len   -- number of bytes to read
int kvazaar::read(int fd, void* buff,unsigned int len)
{
	CHECK_FD(fd);
    unsigned int* values = (unsigned int*)buff;

	// TODO read

    return len;
}

// write() is used to write data to the class
// Parameters: fd    -- integer that determines the opened driver
//             buff  -- void pointer for data that is allocated in user space
//             len   -- number of bytes to write
int kvazaar::write(int fd, void* buff,unsigned int len)
{
	CHECK_FD(fd);

	// TODO write
	
    return len;
}
