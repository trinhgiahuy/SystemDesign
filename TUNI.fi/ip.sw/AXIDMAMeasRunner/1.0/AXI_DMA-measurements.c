#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>

#include <unistd.h>

#include <stdio.h>

#include "fpga_map.h"

#define AXI_DMA_READ_LOC 0x1000
#define AXI_DMA_WRITE_LOC 0x2000
#define AXI_DMA_SIZE 0x100
#define AXI_DMA_DDR_LOC 0x30300000
//#define AXI_DMA_DDR_SIZE 4194304
#define AXI_DMA_DDR_SIZE 4096

//Virtual addresses for all mapped memories.
uint32_t* axi_dma_read_virt = NULL;
uint32_t* axi_dma_write_virt = NULL;

int init_our_mapping(uint8_t init, int fd)
{
	//Variables needed when mapping memory.
	static void* axi_dma_read_vaddr = NULL;
	static uint32_t axi_dma_read_size = 0;
	static void* axi_dma_write_vaddr = NULL;
	static uint32_t axi_dma_write_size = 0;

	if(init == 0)
	{
		printf("start our mem map\n");
		
		axi_dma_read_virt = (uint32_t*)map_phys_to_virt((uint32_t)H2F_BASE+AXI_DMA_READ_LOC,AXI_DMA_SIZE,&axi_dma_read_vaddr,&axi_dma_read_size,&fd);
		if(axi_dma_read_virt == NULL)
		{
			printf("error mapping read dma");
			return 0;
		}
		
		/*axi_dma_write_virt = (uint32_t*)map_phys_to_virt((uint32_t)H2F_BASE+AXI_DMA_WRITE_LOC,AXI_DMA_SIZE,&axi_dma_write_vaddr,&axi_dma_write_size,&fd);
		if(axi_dma_write_virt == NULL)
		{
			printf("error mapping write dma");
			return 0;
		}*/

		printf("our mem_map done\n");
	}
	else
	{
		//Unmappings.
		munmap(axi_dma_read_virt,axi_dma_read_size);
		munmap(axi_dma_write_virt,axi_dma_write_size);
		close(fd);
	}
	
	return 1;
}

int main(int argc, char *argv[])
{
	//File descriptor for memory maps and the mapping proper.
	int fd;
	init_fpga_mapping(0, &fd);
	init_our_mapping(0, fd);

	printf("inits done\n");

	((volatile uint32_t*)axi_dma_read_virt)[2] = AXI_DMA_DDR_LOC;
	((volatile uint16_t*)axi_dma_read_virt)[7] = AXI_DMA_DDR_SIZE;
	((volatile uint32_t*)axi_dma_read_virt)[0] = 2;

	/*((volatile uint32_t*)axi_dma_write_virt)[2] = AXI_DMA_DDR_LOC;
	((volatile uint16_t*)axi_dma_write_virt)[7] = AXI_DMA_DDR_SIZE;
	((volatile uint32_t*)axi_dma_write_virt)[0] = 2;*/

	return EXIT_SUCCESS;
}
