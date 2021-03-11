#ifndef FPGA_MAP_H
#define FPGA_MAP_H

#include <stdint.h>

//Register used to enable access to FPGA from HPS
#define FPGA_REG         0xff800000
//Base address for accessing FPGA via LWH2F channel
#define LWH2F_BASE       0xff200000
//Base address for accessing FPGA via H2F channel
#define H2F_BASE        0xc0000000
//Used to enable FPGA access to HPS sdram, aka HPS DDR
#define FPGAPORTRST      0xffc25080

// Maps to memory the given physical  address to a virtual address, if successful. If not, prints an error.
// RETURNS the virtual address if successful, else returns NULL.
// address: The physical address
// size: The size of the mapped memory
// aligned_vaddr: Pointer to the start of the reserved page in virtual memory.
// aligned_size: Number of reserved pages in virtual memory.
// fd: An open file descriptor needed in the mapping.
void* map_phys_to_virt(uint32_t address,uint32_t size,void** aligned_vaddr,uint32_t* aligned_size, int* fd);

// Maps certain mandatory thing to memory, to make FPGA access via H2F, LWH2F, and FPGA2SDRAM usable.
// Also opens a file descriptor needed in further mappings.
// RETURNS zero if failure, one if success.
// init: Zero if mapping, else unmapping.
// fd: Pointer to the opened file descriptor.
int init_fpga_mapping(uint8_t init, int* fd);

#endif