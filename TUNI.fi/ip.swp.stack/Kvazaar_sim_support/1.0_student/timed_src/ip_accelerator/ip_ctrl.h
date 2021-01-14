/*---------------------------------------------------------------------------
*  File:	ip_ctrl.h
*
*  Purpose: SystemC model header for Intra Prediction Controller
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2015
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef IP_CTRL_H
#define IP_CTRL_H
#include <systemc.h>
#include "ip_global.h"

SC_MODULE (ip_ctrl)
{
    sc_in<bool> clk;
    sc_in<bool> rst;
    
    oPort<sc_uint<32> > out1;
    oPort<sc_uint<32> > out2;
    oPort<sc_uint<32> > out3;
    oPort<sc_uint<32> > out4;
    oPort<sc_uint<32> > out5;
    oPort<sc_uint<32> > out6;
    oPort<sc_uint<32> > out7;
    oPort<sc_uint<32> > out8;
    oPort<sc_uint<32> > out9;
    oPort<sc_uint<32> > out10;
    oPort<sc_uint<32> > out11;
    oPort<sc_uint<32> > out12;
    oPort<sc_uint<32> > out13;
    oPort<sc_uint<32> > out14;
    oPort<sc_uint<32> > out15;
    oPort<sc_uint<32> > out16;
    oPort<sc_uint<32> > out17;
    oPort<sc_uint<32> > out18;
    oPort<sc_uint<32> > out19;
    oPort<sc_uint<32> > out20;
    oPort<sc_uint<32> > out21;
    oPort<sc_uint<32> > out22;
    oPort<sc_uint<32> > out23;
    oPort<sc_uint<32> > out24;
    oPort<sc_uint<32> > out25;
    oPort<sc_uint<32> > out26;
    oPort<sc_uint<32> > out27;

    iPort<sc_uint<32> > config;
    iPort<sc_uint<16> > unfiltered1;
    iPort<sc_uint<16> > unfiltered2;

    oPort<sc_uint<32> >* outputs[27];

    void ip_ctrl_main();
    
    SC_CTOR(ip_ctrl)
    {
		outputs[0] = &out1;
		outputs[1] = &out2;
		outputs[2] = &out3;
		outputs[3] = &out4;
		outputs[4] = &out5;
		outputs[5] = &out6;
		outputs[6] = &out7;
		outputs[7] = &out8;
		outputs[8] = &out9;
		outputs[9] = &out10;
		outputs[10] = &out11;
		outputs[11] = &out12;
		outputs[12] = &out13;
		outputs[13] = &out14;
		outputs[14] = &out15;
		outputs[15] = &out16;
		outputs[16] = &out17;
		outputs[17] = &out18;
		outputs[18] = &out19;
		outputs[19] = &out20;
		outputs[20] = &out21;
		outputs[21] = &out22;
		outputs[22] = &out23;
		outputs[23] = &out24;
		outputs[24] = &out25;
		outputs[25] = &out26;
		outputs[26] = &out27;

		SC_CTHREAD(ip_ctrl_main, clk.pos());
		reset_signal_is(rst,true);
    }
};

#endif
