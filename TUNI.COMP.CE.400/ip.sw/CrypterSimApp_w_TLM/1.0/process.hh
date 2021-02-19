#include "header.hh"
#include "systemc.h"

#include <tlm.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>

// Maximum amount of data in process 2
#define MAX_ADDR 64

SC_MODULE (process1)
{
	sc_in_clk	 clock; //Clock input
	sc_in<bool>   reset; //Reset, active high
	sc_in<sc_uint<32> > in_value; //Value that is to be crypted in the system.
	sc_uint<6> addr; // Current address

	// TLM2.0 initiator socket
	tlm_utils::simple_initiator_socket<process1> socket;
	
	void encrypt ();

	SC_CTOR(process1) : socket("socket")
	{
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(encrypt, clock.pos());
		reset_signal_is(reset, false);
	}
}; 

SC_MODULE (process2)
{
	sc_in_clk	 clock; //Clock input
	sc_in<bool>   reset; //Reset, active high
	value1* memory; //The shared memory	
	sc_uint<32> values[MAX_ADDR]; //Local memory to store the incoming data
	sc_uint<6> values_available; //Available data at the moment
	sc_dt::uint64 index; //Current address

	void write_value ();
	
	// TLM2.0 target socket
	tlm_utils::simple_target_socket<process2> socket;
	// Blocking transport
	virtual void b_transport( tlm::tlm_generic_payload& trans, sc_time& delay );

	SC_CTOR(process2) : socket("socket")
	{
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(write_value, clock.pos());
		reset_signal_is(reset, false);
		socket.register_b_transport(this, &process2::b_transport);
	}
};

SC_MODULE (process3)
{
	sc_in_clk	 clock; //Clock input
	sc_in<bool>   reset; //Reset, active high
	sc_fifo_out<sc_uint<32> > fifo; //Fifo where from the values are fed.
	value1* memory; //The shared memory

	void read_value ();

	SC_CTOR(process3)
	{
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(read_value, clock.pos());
		reset_signal_is(reset, false);
	}
};

SC_MODULE (process4)
{
	sc_in_clk	 clock; //Clock input
	sc_in<bool>   reset; //Reset, active high
	sc_fifo_in<sc_uint<32> > fifo; //Fifo where the values are obtained.
	sc_out<sc_uint<32> > out_value; //Value that is decrypted and output of the system.
	
	void decrypt ();

	SC_CTOR(process4)
	{
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(decrypt, clock.pos());
		reset_signal_is(reset, false);
	}
};
