#include "global_supplement.h"
#include "encoderstate_supplement.h"
#include "sc_kvazaar.h"

// send_lambda used to send lambda value to accelerator, used in encodestate.c
void send_lambda(double lambda)
{
	static int lambda_int = 0;
	// double lambda value is rounded up
	lambda_int = (uint32_t)(lambda + 0.5);
	// use ioctl function to set the write location for IOCTL_LOCATION_LAMBDA
	if(ip_acc_driver->ioctl(ip_acc_fd,IOCTL_SET_LOCATION,IOCTL_LOCATION_LAMBDA) < 0)
	{
		printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
		exit(0);
	}
	// use write function to write lambda to the accelerator
	ip_acc_driver->write(ip_acc_fd,&lambda_int,4);
}