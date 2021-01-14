//The header file systemc.h is required for systemc modules.
#include "systemc.h"

//Module macro gets name of the module as parameter,
SC_MODULE (some_module)
{
	//The constructor: Nothing in it this time.
	SC_CTOR (some_module)
	{
	}
  
	void print_hello()
	{
		cout << "Hello World\n";
	}
};

//sc_main is the top level function, like in main in C
int sc_main(int argc, char* argv[])
{
	//make an instance of the module for us,
	some_module hello("hi");
	//Call its function.
	hello.print_hello();
 
	return(0);
}