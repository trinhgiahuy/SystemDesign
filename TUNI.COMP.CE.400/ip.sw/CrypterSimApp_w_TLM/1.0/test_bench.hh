#include "systemc.h"
#include "header.hh"
#include <vector>

SC_MODULE (test_bench)
{
	sc_in_clk clock; //Clock input.
	sc_out<bool> reset; //Reset, active high.
	sc_out<sc_uint<32> >  in_value; //Value fed to the DUT.
	sc_in<sc_uint<32> >  out_value; //Value produced by the DUT.
	value1* memory; //The shared memory

	//All the values read from the input
	std::vector<sc_uint<32> > values;
	//True, if the input file is read.
	sc_event values_ready;

	void input_p();

	void output_p();

	void sm_monitor();

	SC_CTOR(test_bench)
	{ 
		//Initialize processes as threads, with reset active high
		SC_CTHREAD(input_p,clock.pos());
		SC_CTHREAD(output_p,clock.pos());
		//SC_CTHREAD(sm_monitor,clock.pos());
	}
}; 
