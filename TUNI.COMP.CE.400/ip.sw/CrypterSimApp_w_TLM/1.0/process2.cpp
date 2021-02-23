#include "process.hh"

void process2::b_transport( tlm::tlm_generic_payload& trans, sc_time& delay )
{
	// Extract the attributes from the payload
	tlm::tlm_command cmd = trans.get_command();
	sc_dt::uint64    adr = trans.get_address();
	unsigned char*   ptr = trans.get_data_ptr();
	unsigned int     len = trans.get_data_length();
	unsigned char*   byt = trans.get_byte_enable_ptr();
	unsigned int     wid = trans.get_streaming_width();
	
	// Check that the payload is compatible
	if (adr >= sc_dt::uint64(MAX_ADDR) || byt != 0 || len > 4 || wid < len)
    		SC_REPORT_ERROR("TLM-2", "Target does not support given generic payload transaction");

	// Actual operation
	if ( cmd == tlm::TLM_READ_COMMAND && values_available > 0 )
	{
		memcpy(ptr, (&values[adr]), len);
		values_available--;
	}
	else if ( cmd == tlm::TLM_WRITE_COMMAND )
	{
		memcpy((&values[adr]), ptr, len);
		values_available++;
		index = adr;
	}

	// Set the response status to OK
	trans.set_response_status( tlm::TLM_OK_RESPONSE );

}


void process2::write_value ()
{
	sc_uint<32> read_value; //Value from the local memory
	sc_uint<32> write_enable; //Becomes zero, when we may write.
	
	while( true )
	{
		// Wait for data to be ready
		while ( values_available == 0 )
		{
			wait();		
		}
		
		// printf("Value available %d\n", values_available.to_int());

		// Read the transfered value
		read_value = values[index];
		values_available--;

		//Wait until we get write enable
		//NOTICE: accessing shared memory WILL take clock cycles!
		do
		{
			wait();
			write_enable = memory->read( ENABLE_INDEX );
		}
		while ( write_enable == 1 );
		
		//Write value, set read enable
		memory->write( read_value, VALUE_INDEX );
		memory->write( 1, ENABLE_INDEX );
	}
}
