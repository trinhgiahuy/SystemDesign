#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#include <string.h>
#include <time.h>

#include <sys/mman.h>

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <sys/ioctl.h>


#define FPGA_REG         0xff800000
#define LWH2F_BASE       0xff200000
#define H2F_BASE         0xc0000000
#define FPGAPORTRST      0xffc25080
#define STATICCFG        0xffc2505c

#define DMA_WRITER         0x8200
#define DMA_READER         0x8000
#define POLL_READ          0x0010
#define POLL_WRITE         0x0000

#define CONFIG             0x8100

#define ONCHIP_TO_TESTER   0x1000
#define ONCHIP_FROM_TESTER 0x6000

#define ONCHIP_8_BIT       0x7000
#define ONCHIP_16_BIT      0x4000
#define ONCHIP_32_BIT      0x0000

#define DATA8       0x30000000
#define DATA16      0x31000000
#define DATA32      0x32000000

// width = 2^x <= 64
#define WIDTH 64

#define BYTES WIDTH*WIDTH

double tulokset[2][19];

struct user_mmap
{
    void* phys;
    void* vaddr;
    uint32_t size;
};

#define CHECK_NULL(val) if((val) == NULL) { printf("Error mapping memory :  %s, %s, %d\n",__FILE__,__func__,__LINE__); return 0; }

#define INIT_USER_MMAP {.phys = NULL,.vaddr = NULL,.size = 0}

static int fd;

struct user_mmap fpga_reg = INIT_USER_MMAP;
struct user_mmap fpgaportrst = INIT_USER_MMAP;
struct user_mmap onchip_to_tester = INIT_USER_MMAP;
struct user_mmap onchip_from_tester = INIT_USER_MMAP;
struct user_mmap onchip_8_bit = INIT_USER_MMAP;
struct user_mmap onchip_16_bit = INIT_USER_MMAP;
struct user_mmap onchip_32_bit = INIT_USER_MMAP;
struct user_mmap data8 = INIT_USER_MMAP;
struct user_mmap data16 = INIT_USER_MMAP;
struct user_mmap data32 = INIT_USER_MMAP;

struct user_mmap dma_writer = INIT_USER_MMAP;
struct user_mmap dma_reader = INIT_USER_MMAP;

struct user_mmap poll_reader = INIT_USER_MMAP;
struct user_mmap poll_writer = INIT_USER_MMAP;

struct user_mmap config = INIT_USER_MMAP;

void* map_phys_to_virt(uint32_t address,uint16_t size,struct user_mmap* mapped,int* fd)
{
    void* mem;
    unsigned long aligned_paddr;
  
    address &= ~(size - 1);
    aligned_paddr = address & ~(4096 - 1);
    mapped->size = address - aligned_paddr + size;
    mapped->size= (mapped->size + 4096 - 1) & ~(4096 - 1);


    mapped->vaddr = mmap(NULL, mapped->size, PROT_READ | PROT_WRITE, MAP_SHARED, *fd, aligned_paddr);

    if (mapped->vaddr == NULL) {
	printf("Error mapping address\n");
	return NULL;
    }
  
    mem = (void *)((uint32_t)mapped->vaddr + (address - aligned_paddr));
    return mem;
}


int init_fpga_mapping()
{
    if ((fd = open("/dev/mem", O_RDWR, 0)) < 0)
    {
	printf("Error opening /dev/mem\n");
	return 0;
    }
    
    printf("Initializing FPGA\n");
    
    fpga_reg.phys = map_phys_to_virt((uint32_t)FPGA_REG, 4, &fpga_reg, &fd);
    CHECK_NULL(fpga_reg.phys)
    
	fpgaportrst.phys = map_phys_to_virt((uint32_t)FPGAPORTRST, 4, &fpgaportrst, &fd);
    CHECK_NULL(fpgaportrst.phys);
    
    //H2F
    *(volatile uint32_t*)fpga_reg.phys = 0x18;
    printf("1. H2F & LWH2F enabled\n");
    
    *(volatile uint32_t*)fpgaportrst.phys = 0x3fff;
    printf("2. F2SDRAM enabled\n");
    
    return 1;
}

int main(int argc, char *argv[])
{
    int fd_mem = 0;
    uint32_t y,x;
    uint32_t bytes = BYTES;
    uint32_t width = WIDTH;
    uint8_t data8_local[BYTES];
    uint16_t data16_local[BYTES/2];
    uint32_t data32_local[BYTES/4];

    struct timespec t_start, t_end;
    double diff;
    
    if(!init_fpga_mapping())
    {
	printf("Error in FPGA initialization\n");
    }

    if ((fd_mem = open("/dev/benchmark_driver", O_RDWR, 0)) < 0)
    {
	printf("Error opening /dev/benchmark_driver\n");
    }

    onchip_to_tester.phys = map_phys_to_virt((uint32_t)H2F_BASE+ONCHIP_TO_TESTER,BYTES , &onchip_to_tester, &fd);
    CHECK_NULL(onchip_to_tester.phys);
    
    onchip_from_tester.phys = map_phys_to_virt((uint32_t)H2F_BASE+ONCHIP_FROM_TESTER,BYTES , &onchip_from_tester, &fd);
    CHECK_NULL(onchip_from_tester.phys);
    
    data8.phys = map_phys_to_virt((uint32_t)DATA8, BYTES, &data8, &fd);
    CHECK_NULL(data8.phys);

    data16.phys = map_phys_to_virt((uint32_t)DATA16, BYTES, &data16 ,&fd);
    CHECK_NULL(data16.phys);

    data32.phys = map_phys_to_virt((uint32_t)DATA32, BYTES, &data32, &fd);
    CHECK_NULL(data32.phys);

    onchip_8_bit.phys = map_phys_to_virt((uint32_t)H2F_BASE+ONCHIP_8_BIT, BYTES, &onchip_8_bit ,&fd);
    CHECK_NULL(onchip_8_bit.phys);

    onchip_16_bit.phys = map_phys_to_virt((uint32_t)H2F_BASE+ONCHIP_16_BIT, BYTES, &onchip_16_bit ,&fd);
    CHECK_NULL(onchip_16_bit.phys);
    
    onchip_32_bit.phys = map_phys_to_virt((uint32_t)H2F_BASE+ONCHIP_32_BIT, BYTES, &onchip_32_bit, &fd);
    CHECK_NULL(onchip_32_bit.phys);

    dma_writer.phys = map_phys_to_virt((uint32_t)H2F_BASE+DMA_WRITER, 32, &dma_writer, &fd);
    CHECK_NULL( dma_writer.phys);
    
    dma_reader.phys = map_phys_to_virt((uint32_t)H2F_BASE+DMA_READER, 32, &dma_reader, &fd);
    CHECK_NULL(dma_reader.phys);
    
    config.phys = map_phys_to_virt((uint32_t)H2F_BASE+CONFIG, 32, &config, &fd);
    CHECK_NULL(config.phys);

    poll_reader.phys = map_phys_to_virt((uint32_t)LWH2F_BASE+POLL_READ, 16, &poll_reader, &fd);
    CHECK_NULL(poll_reader.phys);
        
    poll_writer.phys = map_phys_to_virt((uint32_t)LWH2F_BASE+POLL_WRITE, 16, &poll_writer, &fd);
    CHECK_NULL(poll_writer.phys);

/*#####################################################################USER SPACE###########################################################################################*/

/***************************WRITING TO 8 BIT LOCAL ARRAY (U.1)********************************/
    printf("U.1\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	data8_local[y] = 0x11;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;
    
    tulokset[0][0] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/****************************************************************************************/

/***************************WRITING TO 16 BIT LOCAL ARRAY (U.2)********************************/

    printf("U.2\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	data16_local[y] = 0x1111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][1] = ((((double)bytes)/1024)/1024)/(diff/1000000000);
    
/****************************************************************************************/

/***************************WRITING TO 32 BIT LOCAL ARRAY (U.3)********************************/

    printf("U.3\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	data32_local[y] = 0x11111111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][2] = ((((double)bytes)/1024)/1024)/(diff/1000000000);
    
/******************************************************************************************/

/***************************WRITING TO 8 BIT ONCHIP ON FPGA (U.4)********************************/
    printf("U.4\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	((volatile uint8_t*)onchip_8_bit.phys)[y] = 0x11;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][3] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

     

/***************************WRITING TO 16 BIT ONCHIP ON FPGA (U.5)*******************************/
	printf("U.5\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	((volatile uint16_t*)onchip_16_bit.phys)[y] = 0x1111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][4] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/ 

/***************************WRITING TO 32 BIT ONCHIP ON FPGA (U.6)*******************************/
	printf("U.6\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	((volatile uint32_t*)onchip_32_bit.phys)[y] = 0x11111111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][5] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

     

/***************************WRITING TO 8 BIT NON CACHED ARRAY (U.7)******************************/
	printf("U.7\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	((volatile uint8_t*)data8.phys)[y] = 0x11;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][6] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************WRITING TO 16 BIT NON CACHED ARRAY (U.8)*****************************/
	printf("U.8\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	((volatile uint16_t*)data16.phys)[y] = 0x1111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][7] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************WRITING TO 32 BIT NON CACHED ARRAY (U.9)*****************************/
	printf("U.9\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	((volatile uint32_t*)data32.phys)[y] = 0x11111111;
    }
    clock_gettime( CLOCK_MONOTONIC, &t_end );

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][8] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/*################################################################################################################################################################*/
    data8_local[bytes-1] = 0;
    data16_local[(bytes/2)-1] = 0;
    data32_local[(bytes/4)-1] = 0;
    
    ((volatile uint8_t*)data8.phys)[bytes-1] = 0;
    ((volatile uint16_t*)data16.phys)[(bytes/2)-1] = 0;
    ((volatile uint32_t*)data32.phys)[(bytes/4)-1] = 0;

    ((volatile uint8_t*)onchip_8_bit.phys)[bytes-1] = 0;
    ((volatile uint16_t*)onchip_16_bit.phys)[(bytes/2)-1] = 0;
    ((volatile uint32_t*)onchip_32_bit.phys)[(bytes/4)-1] = 0;
/*################################################################################################################################################################*/

/***************************READING FROM 8 BIT LOCAL ARRAY (U.11)*********************************/
	printf("U.11\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	if(data8_local[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;
    
    tulokset[0][9] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 16 BIT LOCAL ARRAY (U.12)********************************/
	printf("U.12\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	if(data16_local[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;
    
    tulokset[0][10] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 32 BIT LOCAL ARRAY (U.13)********************************/
	printf("U.13\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	if(data32_local[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }

    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][11] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 8BIT ONCHIP ON FPGA (U.14)*******************************/
	printf("U.14\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	if(((volatile uint8_t*)onchip_8_bit.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][12] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 16BIT ONCHIP ON FPGA (U.15)******************************/
	printf("U.15\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	if(((volatile uint16_t*)onchip_16_bit.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][13] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 32BIT ONCHIP ON FPGA (U.16)******************************/
	printf("U.16\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	if(((volatile uint32_t*)onchip_32_bit.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][14] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 8 BIT NON CACHED ARRAY (U.17)****************************/
	printf("U.17\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes;y++)
    {
	if(((volatile uint8_t*)data8.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][15] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 16 BIT NON CACHED ARRAY (U.18)***************************/
	printf("U.18\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/2;y++)
    {
	if(((volatile uint16_t*)data16.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][16] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 32 BIT NON CACHED ARRAY (U.19)***************************/
	printf("U.19\n");
    clock_gettime( CLOCK_MONOTONIC, &t_start );
    for(y = 0; y < bytes/4;y++)
    {
	if(((volatile uint32_t*)data32.phys)[y] == 0)
	{
	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	}
    }
  
    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

    tulokset[0][17] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/*#####################################################################KERNEL SPACE###########################################################################################*/
    if(fd_mem != -1)
    {	
/***************************WRITING TO 8 BIT ONCHIP ON FPGA (K.4)********************************/
	printf("K.4\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,0);
    
	for(y = 0; y < bytes;y++)
	{
	    data8_local[y] = 0x11;
	}
	data8_local[bytes-1] = 0;

	write(fd_mem,data8_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][3] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************WRITING TO 16 BIT ONCHIP ON FPGA (K.5)*******************************/
	printf("K.5\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,3);
    
	for(y = 0; y < bytes/2;y++)
	{
	    data16_local[y] = 0x1111;
	}
	data16_local[(bytes/2)-1] = 0;

	write(fd_mem,data16_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][4] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************WRITING TO 32 BIT ONCHIP ON FPGA (K.6)*******************************/
	printf("K.6\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,4);
    
	for(y = 0; y < bytes/4;y++)
	{
	    data32_local[y] = 0x11111111;
	}
	data32_local[(bytes/4)-1] = 0;

	write(fd_mem,data32_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][5] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/**************************WRITING TO 8 BIT NON CACHED ARRAY (K.7)*******************************/
	printf("K.7\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,2);
    
	for(y = 0; y < bytes;y++)
	{
	    data8_local[y] = 0x11;
	}
	data8_local[bytes-1] = 0;

	write(fd_mem,data8_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][6] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/**************************WRITING TO 16 BIT NON CACHED ARRAY (K.8)******************************/
	printf("K.8\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,5);
    
	for(y = 0; y < bytes/2;y++)
	{
	    data16_local[y] = 0x1111;
	}
	data16_local[(bytes/2)-1] = 0;

	write(fd_mem,data16_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][7] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/**************************WRITING TO 32 BIT NON CACHED ARRAY (K.9)******************************/
	printf("K.9\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,6);
    
	for(y = 0; y < bytes/4;y++)
	{
	    data32_local[y] = 0x11111111;
	}
	data32_local[(bytes/4)-1] = 0;

	write(fd_mem,data32_local,bytes);

	clock_gettime( CLOCK_MONOTONIC, &t_end );

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;
    
	tulokset[1][8] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 8BIT ONCHIP ON FPGA (K.14)*******************************/
	printf("K.14\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,0);

	read(fd_mem,data8_local,bytes);

	for(y = 0; y < bytes;y++)
	{
	    if(data8_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][12] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 16BIT ONCHIP ON FPGA (K.15)******************************/
	printf("K.15\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,3);

	read(fd_mem,data16_local,bytes);

	for(y = 0; y < bytes/2;y++)
	{
	    if(data16_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][13] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 32BIT ONCHIP ON FPGA (K.16)******************************/
	printf("K.16\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,4);

	read(fd_mem,data32_local,bytes);

	for(y = 0; y < bytes/4;y++)
	{
	    if(data32_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][14] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 8 BIT NON CACHED ARRAY (K.17)****************************/
	printf("K.17\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,2);

	read(fd_mem,data8_local,bytes);

	for(y = 0; y < bytes;y++)
	{
	    if(data8_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][15] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 16 BIT NON CACHED ARRAY (K.18)***************************/
	printf("K.18\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,5);

	read(fd_mem,data16_local,bytes);

	for(y = 0; y < bytes/2;y++)
	{
	    if(data16_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][16] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/***************************READING FROM 32 BIT NON CACHED ARRAY (K.19)***************************/
	printf("K.19\n");
	clock_gettime( CLOCK_MONOTONIC, &t_start );
    
	ioctl(fd_mem,0,6);

	read(fd_mem,data32_local,bytes);

	for(y = 0; y < bytes/4;y++)
	{
	    if(data32_local[y] == 0)
	    {
		clock_gettime( CLOCK_MONOTONIC, &t_end );
	    }
	}

	diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	tulokset[1][17] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

/******************************************************************************************/

/*******************************TESTING DMA WRITER SPEED/FUNCTIONALITY (K.10)*********************/
	printf("K.10\n");
	{
	    int error = 0;
	    // clear ddr3
	    for(y = 0; y < width;y++)
	    {
		for(x = 0; x < width;x++)
		{
		    data8_local[y*width+x] = 0;
		}
	    }
	
	    ioctl(fd_mem,0,2);
	    write(fd_mem,data8_local,bytes);
	
	    // set dma reader
	    // HPS memory address to which data is written
	    ((volatile uint32_t*)dma_writer.phys)[2] = DATA8;
	    // Bytes to write
	    ((volatile uint32_t*)dma_writer.phys)[4] = width*width;
	    
	    // write data to onchip on fpga
	    for(y = 0; y < width;y++)
	    {
		for(x = 0; x < width;x++)
		{
		    data8_local[y*width+x] = (y*width+x)%255;
		}
	    }
	
	    ioctl(fd_mem,0,7);
	    write(fd_mem,data8_local,bytes);
	
	    // config tester
	    *((volatile uint32_t*)config.phys) = width;	    

	    clock_gettime( CLOCK_MONOTONIC, &t_start );

	    // start dma writer
	    ((volatile uint32_t*)dma_writer.phys)[0] = 1;
	    
	    // wait for dma to finish
	    //while(((volatile uint32_t*)poll_writer.phys)[3] != 1);
	    while(((volatile uint32_t*)dma_writer.phys)[1] != 1);

	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	    
	    ((volatile uint32_t*)dma_writer.phys)[1] = 0;
	    ((volatile uint32_t*)poll_writer.phys)[3] = 1;

	    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	    tulokset[0][18] = ((((double)bytes)/1024)/1024)/(diff/1000000000);
	       
	    // read data from DDR3
	    ioctl(fd_mem,0,2);
	    read(fd_mem,data8_local,bytes);
	
	    for(y = 0; y < width;y++)
	    {
		for(x = 0; x < width;x++)
		{
		    if(data8_local[y*width+x] != (y*width+x)%255)
		    {
			error = 1;
		    }
		}
	    }
	    
	    if(error)
	    {
		printf("DMA WRITER DATA DOES NOT MATCH\n");
	    }
	    else
	    {
		printf("DMA WRITER OK\n");
	    }

/******************************************************************************************/
/******************************TESTING DMA READER SPEED/FUNCTIONALITY (K.20)**********************/
		printf("K.20\n");
	    error = 0;

	    // set dma reader
	    // HPS memory address from which data is read
	    ((volatile uint32_t*)dma_reader.phys)[2] = DATA8;
	    // set bytes to read
	    ((volatile uint16_t*)dma_reader.phys)[7] = width*width;

	    // set DDR3
	    for(y = 0; y < width;y++)
	    {
		for(x = 0; x < width;x++)
		{
		    data8_local[y*width+x] = (y*width+x)%255;
		}
	    }
	
	    ioctl(fd_mem,0,2);
	    write(fd_mem,data8_local,bytes);
	
	    clock_gettime( CLOCK_MONOTONIC, &t_start );
	    
	    // start dma reader
	    ((volatile uint32_t*)dma_reader.phys)[0] = 2;
	    
	    // wait for dma to finish
	    //while(((volatile uint32_t*)poll_writer.phys)[3] != 1);
	    while(((volatile uint32_t*)dma_reader.phys)[1] != 2);

	    clock_gettime( CLOCK_MONOTONIC, &t_end );
	    
	    ((volatile uint32_t*)dma_reader.phys)[1] = 0;
	    ((volatile uint32_t*)poll_reader.phys)[3] = 1;
	    
	    diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
	    diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * 1000000000;

	    tulokset[1][18] = ((((double)bytes)/1024)/1024)/(diff/1000000000);

	    // read data from onchip on fpga
	    ioctl(fd_mem,0,1);
	    read(fd_mem,data8_local,bytes);
	
	    for(y = 0; y < width;y++)
	    {
		for(x = 0; x < width;x++)
		{
		    if(data8_local[y*width+x] != (y*width+x)%255)
		    {
			error = 1;
		    }
		}
	    }
	
	    if(error)
	    {
		printf("DMA READER DATA DOES NOT MATCH\n");
	    }
	    else
	    {
		printf("DMA READER OK\n");
	    }
	
	    error = 0;
	}
    }
/******************************************************************************************/

/********************************PRINT RESULTS*********************************************/
    printf("\n");
    printf("# Meas. #### WRITING ######### (U) USER SPACE (MB/s) ### (K) KERNEL SPACE (MB/s) #\n");
    printf("#  1    #  8 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][0]);
    printf("#  2    # 16 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][1]);
    printf("#  3    # 32 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][2]);
    printf("#  4    #  8 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][3],tulokset[1][3]);
    printf("#  5    # 16 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][4],tulokset[1][4]);
    printf("#  6    # 32 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][5],tulokset[1][5]);
    printf("#  7    #  8 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][6],tulokset[1][6]);
    printf("#  8    # 16 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][7],tulokset[1][7]);
    printf("#  9    # 32 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][8],tulokset[1][8]);
    printf("#  10   # 64 BIT DMA WRITER:               -                   %10.2f        #\n",tulokset[0][18]);
    printf("# Meas. #### READING ######### (U) USER SPACE (MB/s) ### (K) KERNEL SPACE (MB/s) #\n");
    printf("#  11   #  8 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][9]);
    printf("#  12   # 16 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][10]);
    printf("#  13   # 32 BIT LOCAL ARRAY:       %10.2f                        -          #\n",tulokset[0][11],tulokset[1][11]);
    printf("#  14   #  8 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][12],tulokset[1][12]);
    printf("#  15   # 16 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][13],tulokset[1][13]);
    printf("#  16   # 32 BIT ONCHIP ON FPGA:    %10.2f                 %10.2f        #\n",tulokset[0][14],tulokset[1][14]);
    printf("#  17   #  8 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][15],tulokset[1][15]);
    printf("#  18   # 16 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][16],tulokset[1][16]);
    printf("#  19   # 32 BIT MAPPED ARRAY:      %10.2f                 %10.2f        #\n",tulokset[0][17],tulokset[1][17]);
    printf("#  20   # 64 BIT DMA READER:               -                   %10.2f        #\n",tulokset[1][18]);
    printf("##################################################################################\n");
    
/******************************************************************************************/
    return 0;
}
