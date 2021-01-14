/*---------------------------------------------------------------------------
*  File:    sc_kvazaar_ip_sub.h
*
*  Purpose: Header file for sc_kvazaar_ip_sub.c
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 01/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef SC_KVAZAAR_IP_SUB_H
#define SC_KVAZAAR_IP_SUB_H
#include <systemc.h>
#include "ip_global.h"

#include <tlm.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>

#include "strategies-picture.h"
#include "intra.h"

#define CHECK_OVERFLOW(base,size) adr -= (base); if(adr + len > (size)){printf("TLM-2 Error: Data overflow, %s, %s, %d",__FILE__,__func__,__LINE__); sc_stop();}


SC_MODULE (kvazaar_ip_sub)
{
	// TLM socket slave
	tlm_utils::simple_target_socket<kvazaar_ip_sub> socket;
	
	// SystemC ports
	sc_in<bool> clk;
    sc_in<bool> rst;
	
	// Configuration data
    oPort<sc_uint<32> > config_out;
	
	// Reference pixels
    oPort<sc_uint<16> > top_ref_out;
    oPort<sc_uint<16> > left_ref_out;

	// Original LCU data
    oPort<sc_uint<32> > orig_out;
	
	// Result
    sc_in<sc_uint<32> > result_in;
	// Irq signals used for indication that the accelerator is ready (irq = interrupt request)
    sc_in<bool> lcu_loaded;
	sc_in<bool> lambda_loaded;
    sc_in<bool> result_ready;
	
	// Width, thread, uc_state, intra_pred0, intra_pred1, intra_pred2, x_pos, y_pos
    unsigned char config[12];
    // Original 64x64 block (LCU)
    unsigned char orig[4096];
    // refs.ref.top = top reference pixels
	// refs.ref.left = left reference pixels
	kvz_intra_references refs;
	
	// Event used for indication that the accelerator is ready (irq = interrupt request)
    sc_event *irq;
	
	// Result variable for best mode and cost
	unsigned int result;
	
	// Lambda value
	unsigned int lambda_cost;

	bool config_valid;
    bool unfilt1_valid;
    bool unfilt2_valid;
    bool orig_valid;
	bool lambda_valid;
	bool orig_config;

	// Functions translating from untimed to timed simulation
	void orig_block_sender();
    void top_ref_sender();
    void left_ref_sender();
    void config_sender();
    void irq_poller();

    // B_transport virtual function declaration
    virtual void b_transport(tlm::tlm_generic_payload& trans, sc_time& delay);
	
	// Constructor
    SC_CTOR(kvazaar_ip_sub) : socket("socket")
    {
		config_valid = 0;
		unfilt1_valid = 0;
		unfilt2_valid = 0;
		orig_valid = 0;
		lambda_valid = 0;
		orig_config = 0;
		
		// Assign the b_transport function declared and defined in this class to the socket
		socket.register_b_transport(this, &kvazaar_ip_sub::b_transport);

		SC_CTHREAD(orig_block_sender,clk.pos());
		SC_CTHREAD(top_ref_sender,clk.pos());
		SC_CTHREAD(left_ref_sender,clk.pos());
		SC_CTHREAD(config_sender,clk.pos());
		SC_CTHREAD(irq_poller,clk.pos());
		reset_signal_is(rst,true);
    }
};

#endif

