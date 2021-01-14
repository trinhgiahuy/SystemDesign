/*---------------------------------------------------------------------------
*  File:    sc_kvazaar_ip_sub.c
*
*  Purpose: Layer between untimed kvazaar and timed HW accelerator
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 01/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/

#include "sc_kvazaar_ip_sub.h"
#include "global_supplement.h"
#include "exploration.h"

// Arrays for calculating data transfer sizes and times
int data_amount[6];
int data_transfers[6];

//sends original 64x64 block to ip accelerator
void kvazaar_ip_sub::orig_block_sender()
{
    orig_out.z.write(0);
    orig_out.lz.write(0);
    wait();
    while(1)
    {
		// If orig data is valid
		if(orig_valid)
		{
			// Configure HW to receive orig
			orig_config = 1;
			// Wait configuration
			while(orig_config != 0)
			{
				wait();
			}
			// Send orig
			unsigned int a = 0;
			for(a = 0; a < 4096;a+=4)
			{
				uint_32 temp;
				temp = orig[a+3];
				temp <<= 8;
				temp |= orig[a+2];
				temp <<= 8;
				temp |= orig[a+1];
				temp <<= 8;
				temp |= orig[a];
				WRITE_C(orig_out,temp);
			}
			// Clear orig valid
			orig_valid = 0;
		}
		else
		{
			wait();
		}
	}
}

// Sends configuration data to ip accelerator
void kvazaar_ip_sub::config_sender()
{
    config_out.z.write(0);
    config_out.lz.write(0);
    wait();
    while(1)
    {	
		// If configuration data is valid
		if(config_valid)
		{
			uint32_t* config_32 = (uint32_t*)(&config[0]);
			
			// Send configuration data
			
			//uc_state width
			WRITE_C(config_out,config_32[0]);
			//intra_preds
			WRITE_C(config_out,config_32[1]);
			//coordinates
			WRITE_C(config_out,config_32[2]);
			config_valid = 0;
		}
		// Lambda is valid
		else if(lambda_valid)
		{
			// Send Lambda and set 30b to one to indicate lambda
			WRITE_C(config_out,lambda_cost|0x40000000);
			lambda_valid = 0;
		}
		// If orig is to be send
		else if(orig_config)
		{
			// Set 31b to one to indicate orig
			WRITE_C(config_out,0x80000000);
			orig_config = 0;
		}
		else
		{
			wait();
		}
    }
}

// Sends top unfiltered reference pixels to ip accelerator
void kvazaar_ip_sub::top_ref_sender()
{
    top_ref_out.z.write(0);
    top_ref_out.lz.write(0);
    wait();
    while(1)
    {
		// If top (unfilt1) reference pixels are valid
		if(unfilt1_valid)
		{
			int a = 0;
			// Send data two bytes at a time
			for(a = 0; a < 2*(config[0]&0xff)+1;a+=2)
			{
				uint_16 temp;
				temp |= refs.ref.top[a+1];
				temp <<= 8;
				temp |= refs.ref.top[a];
				WRITE_C(top_ref_out,temp);
			}
			unfilt1_valid = 0;
		}
		else
		{
			wait();
		}
	}
}

// Sends left unfiltered reference pixels to ip accelerator
void kvazaar_ip_sub::left_ref_sender()
{
    left_ref_out.z.write(0);
    left_ref_out.lz.write(0);
    wait();
    while(1)
    {
		// If left (unfilt2) reference pixels are valid
		if(unfilt2_valid)
		{
			int a = 0;
			// Send data two bytes at a time
			for(a = 0; a < 2*(config[0]&0xff)+1;a+=2)
			{
				uint_16 temp;
				temp |= refs.ref.left[a+1];
				temp <<= 8;
				temp |= refs.ref.left[a];
				WRITE_C(left_ref_out,temp);
			}
			unfilt2_valid = 0;
		}
		else
		{
			wait();
		}
	}
}

// Polls result_ready from ip accelerator
void kvazaar_ip_sub::irq_poller()
{
    while(1)
    {
		// If result ready...
		if(result_ready.read() == 1)
		{
			// ..get valid result..
			result = result_in.read();
			// ..and notify
			irq->notify(100,SC_NS);
		}
		wait();
    }
}

// TLM transaction function between kvazaar and kvazaar_ip_sub
void kvazaar_ip_sub::b_transport( tlm::tlm_generic_payload& trans, sc_time& delay )
{
	// get properties
    tlm::tlm_command cmd = trans.get_command();
    sc_dt::uint64    adr = trans.get_address();
    unsigned char*   ptr = trans.get_data_ptr();
    unsigned int     len = trans.get_data_length();
    unsigned char*   byt = trans.get_byte_enable_ptr();
    unsigned int     wid = trans.get_streaming_width();
    
    // Obliged to check address range and check for unsupported features,
    if ((adr & 0x0ffff) > sc_dt::uint64(4096) || len > 4096 || byt != 0 || wid != len)
    {
		printf("TLM-2 Error: Target does not support given payload transaction, %s, %s, %d",__FILE__,__func__,__LINE__);
		sc_stop();
    }
	
	// Wait while orig is configured/sent, lambda is configure and config+unfilt1+unfilt2 is sent
	while(orig_config != 0 || orig_valid != 0 || lambda_valid != 0 || (config_valid != 0 && unfilt1_valid != 0 && unfilt2_valid != 0))
	{
	    wait(10,SC_NS);
	}

	// translate the address
    switch(adr & 0xf0000)
    {
		case CONFIG_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(CONFIG_BASE,CONFIG_SIZE);
			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, (char*)(&config[adr]), len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy((char*)(&config[adr]), ptr, len);
				config_valid = 1;
			}
			break;
		}
		case UNFILT1_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(UNFILT1_BASE,UNFILT_SIZE);
			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, &refs.ref.top[adr], len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy(&refs.ref.top[adr], ptr, len);
				refs.filtered_initialized = 0;
				unfilt1_valid = 1;
			}
			break;
		}
		case UNFILT2_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(UNFILT2_BASE,UNFILT_SIZE);
			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, &refs.ref.left[adr], len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy(&refs.ref.left[adr], ptr, len);
				refs.filtered_initialized = 0;
				unfilt2_valid = 1;
			}
			break;
		}
		case ORIG_BLOCK_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(ORIG_BLOCK_BASE,ORIG_BLOCK_SIZE);
			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, &orig[adr], len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy(&orig[adr], ptr, len);
				orig_valid = 1;
			}
			break;
		}
		case LAMBDA_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(LAMBDA_BASE,LAMBDA_SIZE);

			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, (char*)&lambda_cost, len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy((char*)&lambda_cost, ptr, len);
				lambda_valid = 1;
			}
			break;
		}
		case RESULT_BASE:
		{
			//TODO: Save data amount + increment transfer num
			CHECK_OVERFLOW(RESULT_BASE,RESULT_SIZE);

			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, (char*)&result, len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy((char*)&result, ptr, len);
			}
			break;
		}
		
		default:
		{
			printf("TLM-2 Error: Segmentation fault, %s, %s, %d",__FILE__,__func__,__LINE__);
			sc_stop();
			break;
		}
    }

    // Obliged to set response status to indicate successful completion
    trans.set_response_status( tlm::TLM_OK_RESPONSE );
}
