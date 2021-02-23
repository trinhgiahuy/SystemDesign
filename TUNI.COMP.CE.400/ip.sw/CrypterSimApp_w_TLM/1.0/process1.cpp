#include "process.hh"

void process1::encrypt ()
{
	sc_uint<32> encrypted_value; //The encrypted value, is to be fed to the socket.

	tlm::tlm_generic_payload* trans = new tlm::tlm_generic_payload; // TLM payload
	sc_time delay = sc_time( 10, SC_NS ); // TLM payload delay	
	
	while( true )
	{
		//Inform that we're ready for next input value
		//WAIT IS MANDATORY. Otherwise the feeder of input cannot proceed.
		input_ready.notify();
		wait();
		
		//Read input value...
		encrypted_value = in_value;

		//Switch places between first and last 16 bits.
		encrypted_value = ( (encrypted_value.range( 15, 0 ) << 16 ) +
		encrypted_value.range( 31, 16 ) );
		//Encrypt the value with the key.
		encrypted_value = encrypted_value ^ KEY;

		//Convert data to b_transport
		int data = encrypted_value.to_int();

		// Set the payload attributes
		trans->set_command( tlm::TLM_WRITE_COMMAND );
		trans->set_address( addr.to_uint() );
		trans->set_data_ptr( (unsigned char*)(&data) );
		trans->set_data_length( 4 );
		trans->set_streaming_width( 4 );
		trans->set_byte_enable_ptr( 0 );
		trans->set_dmi_allowed( false );
		trans->set_response_status( tlm::TLM_INCOMPLETE_RESPONSE );
		
		// Call the b_transport
		socket->b_transport( *trans, delay );

		// Realize the delay
		wait( delay );

		// Check the response status
		if ( trans->is_response_error() )
  			SC_REPORT_ERROR("TLM-2", "Response error from b_transport");

		// Advance the address index
		if ( addr < MAX_ADDR )
			addr += 1;			
		else
			addr = 0;
	}
}
