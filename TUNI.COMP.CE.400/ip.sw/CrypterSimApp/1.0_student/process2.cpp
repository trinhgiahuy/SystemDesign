#include "process.hh"

void process2::write_value ()
{
	sc_uint<32> in_value; //Value from the fifo
	sc_uint<32> write_enable; //Becomes zero, when we may write.
	
	while( true )
	{
		//Read a value from fifo.
		//NOTICE: blocking operation, so it may take more than one cycle!
		in_value = fifo.read();
		//How long the fifo communication takes
		wait( P1_P2_DELAY, SC_NS );
		
		//Wait until we get write enable
		//NOTICE: accessing shared memory WILL take clock cycles!
		do
		{
			wait();
			write_enable = memory->read( ENABLE_INDEX );
		}
		while ( write_enable == 1 );
		
		//Write value, set read enable
		memory->write( in_value, VALUE_INDEX );
		memory->write( 1, ENABLE_INDEX );
	}
}
