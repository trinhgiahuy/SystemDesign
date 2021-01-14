#include "fpga_map.h"

#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>

#include <unistd.h>

uint32_t* fpga_reg_virt = NULL;
uint32_t* fpgaportrst_virt = NULL;

void* map_phys_to_virt(uint32_t address,uint32_t size,void** aligned_vaddr,uint32_t* aligned_size,int* fd)
{
	void* mem;
	unsigned long aligned_paddr;

	address &= ~(size - 1);
	aligned_paddr = address & ~(4096 - 1);
	*aligned_size = address - aligned_paddr + size;
	*aligned_size = (*aligned_size + 4096 - 1) & ~(4096 - 1);

	*aligned_vaddr = mmap(NULL, *aligned_size, PROT_READ | PROT_WRITE, MAP_SHARED, *fd, aligned_paddr);

	if (*aligned_vaddr == NULL) {
		printf("Error mapping address\n");
		return NULL;
	}

	mem = (void *)((uint32_t)*aligned_vaddr + (address - aligned_paddr));
	return mem;
}

int init_fpga_mapping(uint8_t init, int* fd)
{
	static void* fpga_reg_vaddr = NULL;
	static uint32_t fpga_reg_size = 0;
	static void* fpgaportrst_vaddr = NULL;
	static uint32_t fpgaportrst_size = 0;
	
	if (fd == NULL )
	{
		printf("Fed null file descriptor to FPGA mapping!");
		return 0;
	}

	if(init == 0)
	{
		if ((*fd = open("/dev/mem", O_RDWR, 0)) < 0)
		{
			printf("error opening /dev/mem\n");
			return 0;
		}

		printf("start mem map\n");

		fpga_reg_virt = (uint32_t*)map_phys_to_virt((uint32_t)FPGA_REG,4,&fpga_reg_vaddr,&fpga_reg_size,fd);
		if(fpga_reg_virt == NULL)
		{
			printf("error mapping fpga reg");
			return 0;
		}

		fpgaportrst_virt = (uint32_t*)map_phys_to_virt((uint32_t)FPGAPORTRST,4,&fpgaportrst_vaddr,&fpgaportrst_size,fd);
		if(fpgaportrst_virt == NULL)
		{
			printf("error mapping port rst");
			return 0;
		}

		printf("mem_map_done\n");
		*fpga_reg_virt = 0x18; 
		printf("h2f enabled\n");
		*fpgaportrst_virt = 0x3fff;
		printf("f2sdram enabled\n");
	}
	else
	{
		munmap(fpga_reg_vaddr, fpga_reg_size);
		munmap(fpgaportrst_vaddr,fpgaportrst_size);
		close(*fd);
	}
	
	return 1;
}
