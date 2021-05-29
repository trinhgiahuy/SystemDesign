#include "process.hh"

void process4::decrypt ()
{
	sc_uint<32> decrypted_value; // The decrypted value, is to be fed to TB.

	while( true )
	{
		//Read a value from fifo.
		//NOTICE: blocking operation, so it may take more than one cycle!
		decrypted_value = fifo.read();
		//How long the fifo communication takes
		wait( P3_P4_DELAY, SC_NS );
		
		// Decrypt the value with the key
		decrypted_value = decrypted_value ^ KEY;
		// Undo the permutation
		decrypted_value = ( (decrypted_value.range( 15, 0 ) << 16 ) +
		decrypted_value.range( 31, 16 ) );

		// How long the processing takes
		wait( P4_LATENCY, SC_NS );

		// Feed decrypted value to output
		out_value = decrypted_value;

		// Inform that the output is valid
		output_valid.notify();
		wait();
	}
}
		
