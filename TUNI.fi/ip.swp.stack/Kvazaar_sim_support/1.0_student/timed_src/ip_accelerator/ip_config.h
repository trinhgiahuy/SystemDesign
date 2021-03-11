/*---------------------------------------------------------------------------
*  File:	ip_ctrl.h
*
*  Purpose: SystemC model header for Intra Prediction Controller
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef IP_CONFIG_H
#define IP_CONFIG_H
#include <systemc.h>
#include "ip_global.h"

SC_MODULE (ip_config)
{
    sc_in<bool> clk;
    sc_in<bool> rst;
    
    iPort<sc_uint<32> > config;
	oPort<sc_uint<32> > ctrl_config;
    oPort<sc_uint<32> > sad_config;

    void ip_config_main();

    SC_CTOR(ip_config)
    {
		SC_CTHREAD(ip_config_main, clk.pos());
		reset_signal_is(rst,true);
    }
};

#endif
