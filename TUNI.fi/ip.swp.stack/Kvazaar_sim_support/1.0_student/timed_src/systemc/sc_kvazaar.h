/*---------------------------------------------------------------------------
*  File:    sc_kvazaar.h
*
*  Purpose: Header file for sc_kvazaar.c
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 01/02/2015
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef SC_KVAZAAR_H
#define SC_KVAZAAR_H
#include <systemc.h>

#include <tlm.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>

#include "global_supplement.h"

#define CHECK_FD(val) if((val) != fd_c ){printf("wrong fd, %s, %s, %d",__FILE__,__func__,__LINE__);return -1;}

SC_MODULE (kvazaar)
{	
	// Commandline parameters passed for Kvazaar
	int argc;
    char* argv[255];

	// TLM socket master
    tlm_utils::simple_initiator_socket<kvazaar> socket;
	
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
	
	// Exploration functions
	void start_time();
    void delay_ns(int a,int sel);
    void end_time();
    void increment_frame();
        
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
    SC_CTOR(kvazaar) : socket("socket")
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

