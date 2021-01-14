/*---------------------------------------------------------------------------
*  File:	main.c
*
*  Purpose: SystemC top level for Intra Prediction Accelerator and Kvazaar
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 11/12/2014
*
**---------------------------------------------------------------------------
*/
#include "sc_kvazaar.h"
#include "sc_kvazaar_ip_sub.h"
#include <string>
#include <sstream>

// Definition for kvazaar_global declared in sc_kvazaar.h
kvazaar* kvazaar_global;

// TOP LEVEL
SC_MODULE(SYSTEM)
{
    kvazaar *kvazaar0;
    kvazaar_ip_sub *kvazaar_ip_sub0;
	
	// IRQ event
    sc_event irq;
    
	// Constructor
    SC_CTOR(SYSTEM)
    {
		// Create instances of kvazaar and kvazaar_ip_sub
		kvazaar0 = new kvazaar("kvazaar");
		kvazaar_ip_sub0 = new kvazaar_ip_sub("kvazaar_ip_sub");
		kvazaar_global = kvazaar0;
		
		// assign event between kvazaar and kvazaar_ip_sub
		kvazaar0->irq = &irq;
		kvazaar_ip_sub0->irq = &irq;

		// Connect slave socket to master socket
		// TODO bind
    }

	// Destructor
    ~SYSTEM()
    {
		delete kvazaar0;
		delete kvazaar_ip_sub0;
    }
};

SYSTEM *top = NULL;

// SystemC main function
int sc_main(int argc, char* argv[])
{
	// Create top level
    top = new SYSTEM("top");
    
	// Copy commandline arguments to kvazaar
    top->kvazaar0->argc = argc;
    for(int a = 0; a < argc;a++)
    {
		top->kvazaar0->argv[a] = argv[a];
    }

	// Start simulation
	sc_start();
	
    return 0;
}
