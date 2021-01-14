#include <iostream>
#include <iomanip>
#include <stdint.h>
#include "systemc.h"
#include "test_bench.hh"
#include "header.hh"

sc_event input_ready;
sc_event output_valid;

//the clock
sc_clock the_clock("my_the_clock",1,SC_NS);

//Variables and signals shared with the process
sc_signal<bool>  reset; //Reset, active high
sc_fifo<sc_uint<32> > fifo1_2(5); //Fifo between p1->p2
sc_fifo<sc_uint<32> > fifo3_4(5); //Fifo between p3->p4
sc_signal<sc_uint<32> >  in_value; //The input of the system
sc_signal<sc_uint<32> >  out_value; //The output of the system

SC_MODULE ( system_module )
{
	void app()
	{
		//Enrypted value
		sc_uint<32> encrypted_value;
		//Decrypted value
		sc_uint<32> decrypted_value;
			
		//As many loops as there are values.
		while( true )
		{
			//Ready for next value, wait for input
			//WAIT IS MANDATORY. Otherwise the feeder of input cannot proceed.
			input_ready.notify();
			wait();
			
			//TODO: Add the processing here
			
			//Signal to the user of the system so that it knows about new output.
			//NOTICE: blocking operation, so it may take more than one cycle!
			output_valid.notify();
			wait();
		}
	}

	SC_CTOR( system_module )
	{
		sc_in_clk in_clock(the_clock);
			
		//Initialize process as a thread, with reset active high
		SC_CTHREAD(app, in_clock.pos());
		reset_signal_is(reset, false);
		
		//Start the simulation
		sc_start();
	}
}; 

int sc_main (int argc, char* argv[])
{
	//Must have input file
	if ( argc < 2 )
	{
		cerr << "ERROR: Must provide input file as the program argument!" << endl;
		return 1;
	}
	
	//Read the file name
	input_file_name = std::string( argv[1] );
	
	//Disable false positives
	sc_core::sc_report_handler::set_actions( "/IEEE_Std_1666/deprecated",
                                            sc_core::SC_DO_NOTHING );
	sc_core::sc_report_handler::set_actions( SC_ID_END_MODULE_NOT_CALLED_,
                                SC_DO_NOTHING);

	//Initialization of the test bench
	test_bench* tb = new test_bench("test_bench");
		tb->clock(the_clock);
		tb->reset(reset);
		tb->in_value( in_value );
		tb->out_value(out_value);

	//Initialization of the DUT
	system_module* s  = new system_module( "sydemi" );
	
	return 0;
}