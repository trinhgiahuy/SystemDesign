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
#include "blinker_hal.h"

//Base addresses for physical addresses of accessed FPGA components
#define BUTTON_BASE <INSERT_ADDRESS_HERE>
#define LED_BASE <INSERT_ADDRESS_HERE>

//Virtual addresses for mapped memories.
uint8_t* btn_virt = NULL;
uint8_t* led_virt = NULL;

int init_our_mapping(uint8_t init, int fd)
{
	//Variables needed when mapping memory.
	static void* btn_vaddr = NULL;
	static uint32_t btn_size = 0;
	static void* led_vaddr = NULL;
	static uint32_t led_size = 0;

	if(init == 0)
	{
		printf("start our mem map\n");

		//Mapping memory for button signals between HPS and FPGA.
		btn_virt = (uint8_t*)map_phys_to_virt((uint32_t)<INSERT_ADDRESS_HERE>,1,&btn_vaddr,&btn_size,&fd);
		if(btn_virt == NULL)
		{
			printf("error mapping control register");
			return 0;
		}

		//Mapping memory for led signals between HPS and FPGA.
		//TODO: Make memory mapping for the LED PIO!

		printf("our mem_map done\n");
	}
	else
	{
		//Unmappings.
		munmap(btn_vaddr,btn_size);
		munmap(led_vaddr,led_size);
		close(fd);
	}
	
	return 1;
}

void init_HAL()
{
	//File descriptor for memory maps and the mapping proper.
	int fd;
	//initialize the access to the fpga
	init_fpga_mapping(0, &fd);
	//initialize the access to specific devices.
	init_our_mapping(0, fd);
}

uint8_t read_btn()
{
	return *btn_virt;
}

void set_led( uint8_t mask )
{
	*led_virt = mask;
}
