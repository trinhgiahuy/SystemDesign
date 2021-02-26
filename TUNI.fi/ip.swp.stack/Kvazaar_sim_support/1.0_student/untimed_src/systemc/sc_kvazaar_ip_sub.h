#ifndef SC_KVAZAAR_IP_SUB_H
#define SC_KVAZAAR_IP_SUB_H
#include <systemc.h>

// TODO TLM includes
#include <tlm.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>

#include "strategies-picture.h"
#include "intra.h"

#define CHECK_OVERFLOW(base,size) adr -= (base); if(adr + len > (size)){printf("TLM-2 Error: Data overflow, %s, %s, %d",__FILE__,__func__,__LINE__); sc_stop();}


SC_MODULE (kvazaar_ip_sub)
{
	// TLM socket slave
	// TODO
    tlm_utils::simple_target_socket<kvazaar_ip_sub> socket;
	
	// Width, thread, uc_state, intra_pred0, intra_pred1, intra_pred2, x_pos, y_pos
    char config[12];
    // Original 64x64 block (LCU)
    unsigned char orig[4096];
    // Unfiltered1 = top reference pixels
	// Unfiltered2 = left reference pixels
	kvz_intra_references refs;

	// Array for the corresponding original pixels for the CU in prediction
    unsigned char orig_block[1024];
	
	// Accelerator properties
	unsigned int width;
	unsigned int uc_state;
	unsigned int lambda_cost;
    signed char intra_preds[3];
    int log2_width;
    cost_pixel_nxn_func *sad_func;
	 
	// Result memory for ip accelerator
    unsigned char modes[35];
    double costs[35];
	
	// Result variable for best mode and cost
	unsigned int result;

	// All events used
    sc_event intra_get_angular_start;
    sc_event intra_get_planar_start;
    sc_event intra_get_dc_start;

    sc_event intra_get_angular_1_done;
sc_event intra_get_angular_2_done;
sc_event intra_get_angular_3_done;
sc_event intra_get_angular_4_done;
    sc_event intra_get_planar_done;
    sc_event intra_get_dc_done;

    sc_event unfilt1_valid;
    sc_event unfilt2_valid;
    sc_event config_valid;

	// Event used for indication that the accelerator is ready (irq = interrupt request)
    sc_event *irq;

	// Functions implementing the accelerator
    void intra_control();
    void intra_get_angular_1();
    void intra_get_angular_2();
    void intra_get_angular_3();
    void intra_get_angular_4();
    void intra_get_planar();
    void intra_get_dc();

	// B_transport virtual function declaration
    // TODO
    virtual void b_transport(tlm::tlm_generic_payload& trans, sc_time& delay);

	// Constructor
    SC_CTOR(kvazaar_ip_sub) : socket("socket") // TODO
    {
		// Assign the b_transport function declared and defined in this class to the socket
		// TODO
		socket.register_b_transport(this, &kvazaar_ip_sub::b_transport);
		
		SC_THREAD(intra_control);
		SC_THREAD(intra_get_angular_1);
SC_THREAD(intra_get_angular_2);
SC_THREAD(intra_get_angular_3);
SC_THREAD(intra_get_angular_4);
		SC_THREAD(intra_get_planar);
		SC_THREAD(intra_get_dc);
    }
};

#endif

