#ifndef VALUE1_HH
#define VALUE1_HH

#include "systemc.h"

//How many words fit in the memory.
#define MEM_SIZE 2

class value1
{
	public:
		//The constructor. Initializes the whole memory as zero.
		value1();
	
		//Writes data to index addr. Thread safe.
		void write( sc_uint<32> data, sc_uint<6> addr );
		
		//Returns data from index addr. Thread safe.
		sc_uint<32> read( sc_uint<6> addr );
		
		//Unsafely returns data from index addr.
		sc_uint<32> debug_read( sc_uint<6> addr );
		
	private:
		//This mutex is used to implement the thread safety.
		sc_mutex guard_mutex; 
		//The stored values come here, indexed by address.
		sc_uint<32>memory[MEM_SIZE];
};

#endif