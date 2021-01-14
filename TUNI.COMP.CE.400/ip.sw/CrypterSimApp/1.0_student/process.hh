#include "header.hh"
#include "systemc.h"

SC_MODULE (process1)
{
	sc_in_clk	 clock; //Clock input
	sc_in<bool>   reset; //Reset, active high
	sc_fifo_out<sc_uint<32> > fifo; //Fifo where the values are fed.
	sc_in<sc_uint<32> > in_value; //Value that is to be crypted in the system.
	
	void encrypt ();

	SC_CTOR(process1)
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
	sc_fifo_in<sc_uint<32> > fifo; //Fifo where from the values are obtained.
	value1* memory; //The shared memory

	void write_value ();

	SC_CTOR(process2)
	{
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(write_value, clock.pos());
		reset_signal_is(reset, false);
	}
};
