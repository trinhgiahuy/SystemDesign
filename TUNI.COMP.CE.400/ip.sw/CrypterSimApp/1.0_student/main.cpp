#include "systemc.h"
#include "header.hh"
#include "process.hh"
#include "test_bench.hh"

// Events for input/output handshaking
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
	//The submodules
	value1* sm;
	process1* p1;
	process2* p2;
	sc_trace_file *wf;

	SC_CTOR( system_module )
	{
		//Initialization of  the modules
		sm = new value1();

		p1 = new process1("process1");
			p1->clock(the_clock);
			p1->reset(reset);
			p1->fifo( fifo1_2 );
			p1->in_value(in_value);

		p2 = new process2("process2");
			p2->clock(the_clock);
			p2->reset(reset);
			p2->fifo( fifo1_2 );
			p2->memory = sm;

		// Open VCD file
		wf = sc_create_vcd_trace_file("wave");
		// Dump the desired signals
		sc_trace(wf, the_clock, "the_clock");
		sc_trace(wf, reset, "reset");
		sc_trace(wf, in_value, "in_value");
		sc_trace(wf, out_value, "out_value");
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
		tb->memory = s->sm;
		
	//Start the simulation
	sc_start();

	return 0;
}
