/*---------------------------------------------------------------------------
*  File:    sc_kvazaar.c
*
*  Purpose: Kvazaar in SystemC module + driver functions + design exploration
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 01/02/2015
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "sc_kvazaar.h"
#include "global_supplement.h"
#include <string.h>
#include "exploration.h"

// Global variables for exploration times
sc_time start,end;
int frames;
long long int intra_rough_search_time;
long long int rest_of_the_encoder_time;
long long int transfer_time;

// Flag for if SystemC wait is called
bool wait_ns_called;

// Simulation exit
void kvazaar::sc_exit()
{
	sc_stop();
}

// SystemC wait calling
void wait_ns(int ns)
{
    wait(ns,SC_NS);
    wait_ns_called = true;
}

// Delay function called from Kvazaar
void kvazaar::delay_ns(int ns,int sel)
{   
    //wait_ns(ns);
    if(sel == 0)
    {
		rest_of_the_encoder_time += ns;
    }
    else if(sel == 1)
    {
		intra_rough_search_time += ns;
    }
}

// Encoded frame counter
void kvazaar::increment_frame()
{
    frames++;
}

// Get SystemC start time
void kvazaar::start_time()
{
    start = sc_time_stamp();
}

// Get SystemC end time
void kvazaar::end_time()
{
    end = sc_time_stamp();
}

// Used for setting the simulation_error variable
void kvazaar::set_simulation_error(int val)
{
	simulation_error = val;
}

// Used for calling kvazaar main function
void kvazaar::sc_kvazaar_main()
{
	// time values ns
    double total_time = 0;
    double irs_time = 0;
    double rote_time = 0;
    double hw_time = 0;
    double t_time = 0;

	// Clear memories
    memset(data_transfers,0,sizeof(data_transfers));
    memset(data_amount,0,sizeof(data_amount));
    
	// Clear global variables
	frames = 0;
    intra_rough_search_time = 0;
    rest_of_the_encoder_time = 0;
    transfer_time = 0;
    wait_ns_called = false;

	// Run Kvazaar
	if(!kvazaar_main(argc,argv))
	{
		// Calculate execution times
		// Data transfer time
		t_time = ((double)transfer_time)/1000000000;
		// Intra prediction HW time
		hw_time = end.to_seconds() - start.to_seconds();
		// Intra prediction SW time
		irs_time = ((double)intra_rough_search_time)/1000000000;
		// Rest of the encoder time
		rote_time = ((double)rest_of_the_encoder_time)/1000000000;

		// If SystemC wait was called, subtract function times from SystemC simulation time to get accurate hw time
		if(wait_ns_called)
		{
			hw_time -= irs_time;
			hw_time -= rote_time;
		}

		// Exploration
		t_time = t_time/ARM_USED_CORES;
		hw_time = hw_time/NUMBER_OF_ACCS;
		irs_time = ((irs_time*ARM_STOCK_MHZ)/arm_overclock_mhz_c)/ARM_USED_CORES;
		rote_time = ((rote_time*ARM_STOCK_MHZ)/arm_overclock_mhz_c)/ARM_USED_CORES;

		// Total time
		total_time = irs_time + rote_time + hw_time + t_time;

		printf("\n####################### SIMULATION DATA #######################\n");

		printf("# %-22s : %10.2lf seconds                 #\n", "Simulation time",total_time);
		printf("# %-22s : %10.2lf                         #\n", "FPS",frames/(total_time));
#ifdef EXPLORATION_HW
		printf("# %-22s : %10d Writes %10d Bytes #\n", "Config data",data_transfers[CONFIG],data_amount[CONFIG]);
		printf("# %-22s : %10d Writes %10d Bytes #\n", "Unfilt1 data",data_transfers[UNFILT1],data_amount[UNFILT1]);
		printf("# %-22s : %10d Writes %10d Bytes #\n", "Unfilt2 data",data_transfers[UNFILT2],data_amount[UNFILT2]);
		printf("# %-22s : %10d Writes %10d Bytes #\n", "Orig data",data_transfers[ORIG],data_amount[ORIG]);
		printf("# %-22s : %10d Reads  %10d Bytes #\n", "Lambda",data_transfers[LAMBDA],data_amount[LAMBDA]);
		printf("# %-22s : %10d Reads  %10d Bytes #\n", "Results",data_transfers[RESULT],data_amount[RESULT]);
		printf("# %-22s : %10.2lf %%                       #\n", "Transfers to/from HW",0.0/*TODO*/);
		printf("# %-22s : %10.2lf %%                       #\n", "Intra rough search HW",0.0/*TODO*/);
#endif
#ifdef EXPLORATION_SW
		printf("# %-22s : %10.2lf %%                       #\n","Intra rough search",0.0/*TODO*/);
#endif
		printf("# %-22s : %10.2lf %%                       #\n","Rest of the encoder",0.0/*TODO*/);
		printf("###############################################################\n");
	}
    sc_exit();
}

// open() is used for opening the driver, function expects to get the right filename and flags.
// Parameters: filename -- name of the driver
//             flags 	-- access mode
//             mode 	-- not used
// Return value: returns the integer for the opened driver
int kvazaar::open(char const *filename, int flags, int mode)
{
	if((driver_open == 0) && !strcmp(name,filename) && (flags == O_RDWR))
	{
		driver_open = 1;
		return fd_c;
	}
	return -1;
}

// ioctl() is used to control the driver, in this case it set the location variable according to arg
// Parameters: fd  -- integer that determines the opened driver
//             cmd -- command
//			   arg -- additional argument
int kvazaar::ioctl(int fd,unsigned int cmd,unsigned long arg)
{
	CHECK_FD(fd);
    switch( cmd )
	{
		case IOCTL_SET_LOCATION:
		{
			location = arg;
			break;
		}
		default:
			return -1;
	}
	return 1;
}

// read() is used to read data from the class
// Parameters: fd    -- integer that determines the opened driver
//             buff  -- void pointer for data that is allocated in user space
//             len   -- number of bytes to read
int kvazaar::read(int fd, void* buff,unsigned int len)
{
	CHECK_FD(fd);
    unsigned int* values = (unsigned int*)buff;

    unsigned int result = 0;
	
	// wait for accelerator to be ready
    wait(*irq);
	
	// create payload
    static tlm::tlm_generic_payload* trans = new tlm::tlm_generic_payload;
    sc_time delay = sc_time(SC_ZERO_TIME);
    
	// set properties
    trans->set_command(tlm::TLM_READ_COMMAND);
    trans->set_address(RESULT_BASE);
    trans->set_data_ptr((unsigned char*)&result);
    trans->set_data_length(len);
    trans->set_streaming_width(len); // = data_length to indicate no streaming
    trans->set_byte_enable_ptr( 0 ); // 0 indicates unused
    trans->set_dmi_allowed( false ); // Mandatory initial value
    trans->set_response_status( tlm::TLM_INCOMPLETE_RESPONSE ); // Mandatory initial value
    
	// initiate the transfer
    socket->b_transport( *trans, delay );  // Blocking transport call
    
    // Initiator obliged to check response status and delay
    if ( trans->is_response_error() )
    {
		SC_REPORT_ERROR("TLM-2", "Response error from b_transport");
    }
    // Realize the delay annotated onto the transport call
    wait(delay);
	
	transfer_time += onchip_fpga_to_hps_ns_per_byte_c*len;
    
	// copy results to values
    *values = result;

    return len;
}

// write() is used to write data to the class
// Parameters: fd    -- integer that determines the opened driver
//             buff  -- void pointer for data that is allocated in user space
//             len   -- number of bytes to write
int kvazaar::write(int fd, void* buff,unsigned int len)
{
	CHECK_FD(fd);
	
	// create payload
	static tlm::tlm_generic_payload* trans = new tlm::tlm_generic_payload;
	sc_time delay = sc_time(SC_ZERO_TIME);
	
	// set properties
	trans->set_command(tlm::TLM_WRITE_COMMAND);
	trans->set_data_ptr((unsigned char*)buff);
	trans->set_data_length(len);
	trans->set_streaming_width(len); // = data_length to indicate no streaming
	trans->set_byte_enable_ptr( 0 ); // 0 indicates unused
	trans->set_dmi_allowed( false ); // Mandatory initial value
	trans->set_response_status( tlm::TLM_INCOMPLETE_RESPONSE ); // Mandatory initial value	
	
	// set address according to location
	switch(location)
	{
		case IOCTL_LOCATION_UNFILT1:
		{
			trans->set_address(UNFILT1_BASE);
			transfer_time += hps_ddr_to_fpga_ns_per_byte_c*len;
			break;
		}
		case IOCTL_LOCATION_UNFILT2:
		{
			trans->set_address(UNFILT2_BASE);
			transfer_time += hps_ddr_to_fpga_ns_per_byte_c*len;
			break;
		}
		case IOCTL_LOCATION_ORIG_BLOCK:
		{
			trans->set_address(ORIG_BLOCK_BASE);
			transfer_time += hps_ddr_to_fpga_ns_per_byte_c*len;
			break;
		}
		case IOCTL_LOCATION_CONFIG:
		{
			trans->set_address(CONFIG_BASE);
			transfer_time += hps_to_onchip_fpga_ns_per_byte_c*len;

			break;
		}
		case IOCTL_LOCATION_LAMBDA:
		{
			trans->set_address(LAMBDA_BASE);
			transfer_time += hps_to_onchip_fpga_ns_per_byte_c*len;
			break;
		}
		default:
		{
			return -1;
		}
    }
	
	// initiate the transfer
	socket->b_transport( *trans, delay );  // Blocking transport call
				
	// Initiator obliged to check response status and delay
	if ( trans->is_response_error() )
	{
		SC_REPORT_ERROR("TLM-2", "Response error from b_transport");
	}
	// Realize the delay annotated onto the transport call
	wait(delay);
	
    return len;
}
