#include <algorithm>
#include "test_bench.hh"

std::string input_file_name;

void test_bench::input_p()
{
	//A single value read from the input.
	uint feed;

	wait();
	wait();

	// Assert reset
	reset = 0;
	// Deassert reset
	wait();
	wait();
	reset = 1;

	//Read the input values to vector.
	std::ifstream inputfile;
	inputfile.open(input_file_name);

	while(inputfile >> hex >> feed)
	{
		sc_uint<32> file_value = sc_uint<32>(feed);
		values.push_back(file_value);
	}
	
	//Ready to close file
	inputfile.close();
	
	//It is error, if there are too few
	if ( values.size() < 1 )
	{
		cerr << "NO INPUT VALUES!!! Closing..." << endl;
		sc_stop(); 
	}

	//Mark that we got them.
	values_ready.notify();
	
	for ( int i = 0; i < values.size(); ++i )
	{
		//One by one feed them to the DUT.
		in_value = values[i];
		
		//Do not feed new one before write enable!
		wait( input_ready );
	}
}

void test_bench::output_p()
{
	//Limit on how many times we wait for a single value.
	int limit_iter;

	//Wait until the values are read.
	wait( values_ready );
	
	for ( int i = 0; i < values.size(); ++i )
	{
		//Check that each value comes in correct order.
		sc_uint<32> correct_value = values[i];
		sc_uint<32> check_value;

		//Now wait for DUT output to be valid before reading.
		wait( output_valid );

		check_value = out_value;

		//...but fail, if the value is not expected!
		if ( check_value != correct_value  )
		{
			cerr << "SIMULATION FAILED: Incorrect output value! Expected: "
			<< correct_value << " Produced: " << check_value << endl;
			sc_stop();
		}
			
		cout << hex << check_value << endl;
	}
	
	//Once every value has come through, signal the processes to stop
	//and finish the simulation.
	cerr << "SIMULATION SUCCESS!!! Time in the simulated system: " <<  sc_time_stamp() << endl;

	//End the simulation.
	sc_stop(); 
}