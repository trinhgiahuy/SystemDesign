#include "global_supplement.h"
#include "encoderstate_supplement.h"

// send_lambda used to send lambda value to accelerator, used in encodestate.c
void send_lambda(double lambda)
{
    uint32_t lambda_int = (uint32_t)(lambda + 0.5);
    if(ioctl(ip_acc_fd,0,4) < 0)
    {
        fprintf(stderr,"IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
        exit(0);
    }
    write(ip_acc_fd,&lambda_int,4);
}