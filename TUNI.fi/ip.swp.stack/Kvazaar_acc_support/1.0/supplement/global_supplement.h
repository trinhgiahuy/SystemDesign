#ifndef GLOBAL_SUPPLEMENT_H_
#define GLOBAL_SUPPLEMENT_H_

#include <pthread.h>
#include <semaphore.h>

#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

//declarations for semaphore, mutexes, ip_acc file driver and thread ids
extern sem_t acc_sem;
extern pthread_mutex_t thread[2];
extern int ip_acc_fd;
//extern unsigned int thread_id[2];

#define IOCTL_SET_LOCATION 0
#define IOCTL_LOCATION_UNFILT1 0
#define IOCTL_LOCATION_UNFILT2 1
#define IOCTL_LOCATION_ORIG_BLOCK 2
#define IOCTL_LOCATION_CONFIG 3
#define IOCTL_LOCATION_LAMBDA 4

#endif // GLOBAL_SUPPLEMENT_H_