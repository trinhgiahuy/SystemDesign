/*---------------------------------------------------------------------------
*  File:	ip_get_ang_neg.c
*
*  Purpose: SystemC model header for Intra Prediction Get Angular Negative
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef IP_GET_ANG_NEG_H
#define IP_GET_ANG_NEG_H
#include <systemc.h>
#include "ip_global.h"

SC_MODULE (ip_get_ang_neg)
{
    sc_in<bool> clk;
    sc_in<bool> rst;
    iPort<sc_uint<32> > data_in;
    oPort<sc_uint<16> > data_out;

    void ip_get_ang_neg_main();
    
    SC_CTOR(ip_get_ang_neg)
    {
		SC_CTHREAD( ip_get_ang_neg_main, clk.pos());
		reset_signal_is(rst,true);
    }
};
#endif
