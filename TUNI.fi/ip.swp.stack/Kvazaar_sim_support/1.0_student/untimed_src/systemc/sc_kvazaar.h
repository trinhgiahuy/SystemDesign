#ifndef SC_KVAZAAR_H
#define SC_KVAZAAR_H
#include <systemc.h>

// TODO TLM includes

#include "global_supplement.h"

#define CHECK_FD(val) if((val) != fd_c ){printf("wrong fd, %s, %s, %d",__FILE__,__func__,__LINE__);return -1;}

SC_MODULE (kvazaar)
{	
	// Commandline parameters passed for Kvazaar
	int argc;
    char* argv[255];

	// TLM socket master
    // TODO

    // Original 64x64 block (LCU)
    unsigned char orig_block[4096];
	
    // Unfiltered reference pixels 
    unsigned char unfilt1[65+7];
    unsigned char unfilt2[65+7];

    // Configuration data
    unsigned int config[7];
	
	// Variable set in ioctl for read and write location
	int location;

	// Event used for indication that the accelerator is ready (irq = interrupt request)
    sc_event *irq;
	
	// Simulation exit
	void sc_exit();

	// Used for setting the simulation_error variable
	void set_simulation_error(int val);
	int simulation_error;
	
	// Used for calling kvazaar main function
    void sc_kvazaar_main();
        
    // Driver functions
    int ioctl(int fd,unsigned int cmd,unsigned long arg);
    int read(int fd, void* buff,unsigned int len);
    int write(int fd, void* buff,unsigned int len);
	int open(char const *filename, int flags, int mode);

	// Driver properties
	char* name;
	int fd_c;
	int driver_open;
	int flags_c;
	
	// Constructor
    SC_CTOR(kvazaar) // TODO
    {
		simulation_error = 0;
		
		name = (char*)"/dev/kvazaar_accelerator";
		fd_c = 1;
		flags_c = O_RDWR;
	
		location = 0;
		driver_open = 0;
		SC_THREAD(sc_kvazaar_main);
		set_stack_size(0xFFFFFFF);
    }

};

// Declaration for the kvazaar_global defined in sc_main.c
extern kvazaar* kvazaar_global;

#endif

