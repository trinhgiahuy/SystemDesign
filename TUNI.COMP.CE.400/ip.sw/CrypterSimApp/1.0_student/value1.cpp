#include "header.hh"

value1::value1()
{
	for ( int i = 0; i < MEM_SIZE; ++i )
	{
		memory[i] = 0;
	}
}

void value1::write( sc_uint<32> data, sc_uint<6> addr )
{
	guard_mutex.lock();
	
	memory[addr] = data;
	
	guard_mutex.unlock();
	
	wait( MEMORY_DELAY, SC_NS );
}

sc_uint<32> value1::read( sc_uint<6> addr )
{
	guard_mutex.lock();
	
	sc_uint<32> retval = memory[addr];
	
	guard_mutex.unlock();
	
	wait( MEMORY_DELAY, SC_NS );
	
	return retval;
}

sc_uint<32> value1::debug_read( sc_uint<6> addr )
{
	return memory[addr];
}
