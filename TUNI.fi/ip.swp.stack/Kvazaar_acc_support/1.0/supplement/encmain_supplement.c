#include "encmain_supplement.h"

// definitions for semaphore, mutexes, ip_acc file driver and thread ids
// declared in global_supplement.h
sem_t acc_sem;
pthread_mutex_t thread[2];
int ip_acc_fd;

// Initialization function used in encmain.c
int initializator(int acc)
{
	ip_acc_fd = -1;
    if ((ip_acc_fd = open("/dev/kvazaar_ip_acc", O_RDWR, 0)) < 0)
    {
        fprintf(stderr,"error opening /dev/kvazaar_ip_acc\n");
        return -1;
    }
    sem_init(&acc_sem,0,acc);
    if(pthread_mutex_init(&thread[0],NULL) != 0)
    {
        fprintf(stderr,"Accelerator mutex 1 error\n");
        return -1;
    }
    if(pthread_mutex_init(&thread[1],NULL) != 0)
    {
        fprintf(stderr,"Accelerator mutex 2 error\n");
        return -1;
    }
    return 1;
}