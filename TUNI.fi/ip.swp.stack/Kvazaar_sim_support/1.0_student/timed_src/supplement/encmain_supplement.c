#include "encmain_supplement.h"

// Definitions for ip_acc_driver and ip_acc_fd delcared in global_supplement.h
kvazaar* ip_acc_driver = NULL;
int ip_acc_fd = -1;

// Initialization function used in encmain.c
int initializator(int acc)
{
	// Assign kvazaar_global, declared in sc_kvazaar.h, to ip_acc_driver
	ip_acc_driver = kvazaar_global;
	// Use open function to open the driver
	if ((ip_acc_fd = ip_acc_driver->open("/dev/kvazaar_accelerator",O_RDWR,0)) < 0)
	{
		printf("error opening /dev/kvazaar_accelerator\n");
		return -1;
	}
	return 1;
}

void start_exploration()
{
	ip_acc_driver->start_time();
}

void end_exploration()
{
	ip_acc_driver->end_time();
}

void inc_frame()
{
	ip_acc_driver->increment_frame();
}