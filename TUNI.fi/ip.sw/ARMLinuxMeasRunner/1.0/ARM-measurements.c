#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>

#include <unistd.h>

#include <stdio.h>
#include <pthread.h>

#include "fpga_map.h"

//How large are in bytes is reserved for access to on-chip memory.
#define ONCHIP_SIZE 4096
//Physical address for FPGA->DDR->HPS read location
#define READ_LOC 808452096
//Size of the above mentioned location. NOTICE: for some reason it must be much larger than actually transferred data.
#define READ_SIZE 8536000
#define REAL_READ_SIZE 1536000
//Physical address for HPS->DDR->FPGA write location
#define WRITE_LOC 805306368
//Size of the above mentioned location.
#define WRITE_SIZE 1536000

//Virtual addresses for all mapped memories.
uint32_t* onchip_virt = NULL;
uint32_t* read_virt = NULL;
uint32_t* write_virt = NULL;
uint32_t* control_virt = NULL;

//mutex used to signal that enough packets has been sent
static pthread_mutex_t mutex;
struct timespec thread_t_end;

void* query( void *ptr )
{
	//Force the process to core two.
	char mask = 2;
	sched_setaffinity( 0, sizeof(char), &mask );
	int i = 0;
	//return value of system calls
	int res;

	printf("Starting read\n");
	
	//Wait until first and last addresses are right
	while ( *(write_virt+383999) != 383999 || *(write_virt+1) != 1 )
	{
		//Count the iterations for curiosity.
		++i;
	}
		
	//Wait until each value in each address is right
	/*for ( i = 0; i < WRITE_SIZE /4; i += 1 )
	{
		//No match: decrease iterator
		if ( write_virt[i] != i )
		{
			i -= 1;
		}
	}*/
	
	//Done.
	clock_gettime( CLOCK_MONOTONIC, &thread_t_end );
	
	printf("iterations %d\n", i); 
	
	//unlock the mutex to pass
	res = pthread_mutex_unlock( &mutex );
	if ( res != 0 )
	{
		perror("When unlocking mutex");
		exit(1);
	}
}

int init_our_mapping(uint8_t init, int fd)
{
	//Variables needed when mapping memory.
	static void* onchip_vaddr = NULL;
	static uint32_t onchip_size = 0;
	static void* read_vaddr = NULL;
	static uint32_t read_size = 0;
	static void* write_vaddr = NULL;
	static uint32_t write_size = 0;
	static void* control_vaddr = NULL;
	static uint32_t control_size = 0;

	if(init == 0)
	{
		printf("start our mem map\n");
		
		//Mapping the memory for HPS->On-Chip->FPGA.
		onchip_virt = (uint32_t*)map_phys_to_virt((uint32_t)H2F_BASE,ONCHIP_SIZE,&onchip_vaddr,&onchip_size,&fd);
		if(onchip_virt == NULL)
		{
			printf("error mapping on chip");
			return 0;
		}

		//Mapping memory for FPGA->DDR->HPS.
		read_virt = (uint32_t*)map_phys_to_virt((uint32_t)READ_LOC, READ_SIZE,&read_vaddr,&read_size,&fd);
		if(read_virt == NULL)
		{
			printf("error mapping read ddr");
			return 0;
		}

		//Mapping memory for HPS->DDR->FPGA.
		write_virt = (uint32_t*)map_phys_to_virt((uint32_t)WRITE_LOC, WRITE_SIZE,&write_vaddr,&write_size,&fd);
		if(write_virt == NULL)
		{
			printf("error mapping write ddr");
			return 0;
		}

		//Mapping memory for control signals between HPS and FPGA.
		control_virt = (uint32_t*)map_phys_to_virt((uint32_t)LWH2F_BASE+0x40000,1,&control_vaddr,&control_size,&fd);
		if(control_virt == NULL)
		{
			printf("error mapping control register");
			return 0;
		}

		printf("our mem_map done\n");
	}
	else
	{
		//Unmappings.
		munmap(onchip_vaddr,onchip_size);
		munmap(read_vaddr,read_size);
		munmap(write_vaddr,write_size);
		munmap(control_vaddr,control_size);
		close(fd);
	}
	
	return 1;
}

static uint32_t read_buf[READ_SIZE/4];

/**
 * \brief Program main function.
 * \param argc Argument count from commandline
 * \param argv Argument list
 * \return Program exit state
 */
int main(int argc, char *argv[])
{
	//File descriptor for memory maps and the mapping proper.
	int fd;
	init_fpga_mapping(0, &fd);
	init_our_mapping(0, fd);
	//return value of system calls
	int res;
	//thread used to wait signal from the other end
	pthread_t thread;

	printf("inits done\n");

	//Iterator
	unsigned int i;
	//Time when measurement started and ended
	struct timespec t_start, t_end;
	//Mask to mark the first processor
	char mask = 1;
	//Use the mask to force the process to single core.
	sched_setaffinity( 0, sizeof(char), &mask );
	double diff;
	
	if ( argc < 2 )
	{
		//Starting with the on-chip measurement: the FPGA expects each address contain
		//value of address + 1
		for ( i = 0; i < ONCHIP_SIZE/4; ++i )
		{
			*(onchip_virt + i) = i + 1;
		}

		printf("HPS->On-Chip->FPGA done\n");

		//Zeroing the DDR for measurements
		for ( i = 0; i < READ_SIZE/4; ++i )
		{
			*(read_virt + i) = 0;
		}

		for ( i = 0; i < WRITE_SIZE/4; ++i )
		{
			*(write_virt + i) = 0;
		}

		printf("ram purge done\n");

		//Time to start measuring how fast FPGA writes to HPS DDR
		i = 0;
		clock_gettime( CLOCK_MONOTONIC, &t_start );
		//Give them the signal
		*control_virt = 0x01;
		*control_virt = 0x00;

		//Wait until first and last addresses are right
		while ( *(read_virt+383999) != 383999 || *(read_virt+1) != 1 )
		{
			//Count the iterations for curiosity.
			++i;
		}
		//...and the measurement is concluded
		clock_gettime( CLOCK_MONOTONIC, &t_end );

		//See how long it took, how many iterations, how high transfer rate.
		diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
		diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

		printf("iterations %d\n", i); 
		printf( "%f ns, %f MBps\n", diff, REAL_READ_SIZE/diff*1000);

		printf("FPGA->DDR->HPS done\n");

		//Now write for FPGA.
		for ( i = 0; i < WRITE_SIZE/4; ++i )
		{
			*(write_virt + i) = 0xDEADBEEF;
		}

		printf("HPS->DDR->FPGA done\n");
	}

	//Purge the write region, as it is used the next measurement
	for ( i = 0; i < WRITE_SIZE/4; ++i )
	{
		*(write_virt + i) = 0;
	}

	printf("write ram purge done (again)\n");
	
	//try to create a mutex
	res = pthread_mutex_init(&mutex, NULL);
	if ( res != 0 )
	{
		perror("When creating mutex");
		exit(1);
	}
	
	//try to lock it
	res = pthread_mutex_lock( &mutex );
	if ( res != 0 )
	{
		perror("When locking mutex");
		exit(1);
	}
	
	//now, it is safe to create a thread to signal through the mutex
	res = pthread_create( &thread, NULL, &query, NULL);
	if(res != 0)
	{
		fprintf(stderr,"Error - pthread_create() return code: %d\n",res);
		exit(EXIT_FAILURE);
	}

	printf("The auxilary thread launched\n");

	//Time to start measuring how fast HPS writes for itself.
	clock_gettime( CLOCK_MONOTONIC, &t_start );
	for ( i = 0; i < WRITE_SIZE/4; ++i )
	{
		*(write_virt + i) = i;
	}

	printf("Write done\n");
	
	//The stuff is written. Now wait until it is read in the other thread.
	res = pthread_mutex_lock( &mutex );
	if ( res != 0 )
	{
		perror("When locking mutex");
		exit(1);
	}

	//See how long it took, how many iterations, how high transfer rate.
	//NOTICE: This uses a shared variable, as the end time is read in another thread.
	diff = (double)(  thread_t_end.tv_nsec - t_start.tv_nsec );
	diff += (double)(  thread_t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	printf( "%f ns, %f MBps\n", diff, REAL_READ_SIZE/diff*1000);
	
	printf("HPS->DDR->HPS done\n");
	

	return EXIT_SUCCESS;
}
