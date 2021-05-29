#include "process.hh"

void process3::read_value ()
{
	sc_uint<32> out_value; // Value to be fed to FIFO
	sc_uint<32> read_enable; // Becomes one, when we can read from share memory

	while( true)
	{
		// Wait until we get read enable.
		// NOTICE: accessing shared memory WILL take clock cycles!
		do
		{
			wait();
			read_enable = memory->read( ENABLE_INDEX );
		}
		while ( read_enable == 0 );

		// Read the value from shared memory, set write enable
		out_value = memory->read( VALUE_INDEX );
		memory->write( 0, ENABLE_INDEX );

		// Write data to FIFO
		fifo.write(out_value);
		// How long the FIFO communication takes
		wait( P3_P4_DELAY, SC_NS );
	}
}
