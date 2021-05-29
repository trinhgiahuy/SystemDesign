/*---------------------------------------------------------------------------
*  File:	ip_sad.c
*
*  Purpose: SystemC model header for Intra Prediction SAD
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef IP_SAD_H
#define IP_SAD_H
#include <systemc.h>
#include "ip_global.h"

SC_MODULE (ip_sad)
{
    sc_in<bool> clk;
    sc_in<bool> rst;
    
    iPort<sc_uint<16> > in1;
    iPort<sc_uint<16> > in2;
    iPort<sc_uint<16> > in3;
    iPort<sc_uint<16> > in4;
    iPort<sc_uint<16> > in5;
    iPort<sc_uint<16> > in6;
    iPort<sc_uint<16> > in7;
    iPort<sc_uint<16> > in8;
    iPort<sc_uint<16> > in9;
    iPort<sc_uint<16> > in10;
    iPort<sc_uint<16> > in11;
    iPort<sc_uint<16> > in12;
    iPort<sc_uint<16> > in13;
    iPort<sc_uint<16> > in14;
    iPort<sc_uint<16> > in15;
    iPort<sc_uint<16> > in16;
    iPort<sc_uint<16> > in17;
    iPort<sc_uint<16> > in18;
    iPort<sc_uint<16> > in19;
    iPort<sc_uint<16> > in20;
    iPort<sc_uint<16> > in21;
    iPort<sc_uint<16> > in22;
    iPort<sc_uint<16> > in23;
    iPort<sc_uint<16> > in24;
    iPort<sc_uint<16> > in25;
    iPort<sc_uint<16> > in26;
    iPort<sc_uint<16> > in27;
    iPort<sc_uint<16> > in28;
    iPort<sc_uint<16> > in29;
    iPort<sc_uint<16> > in30;
    iPort<sc_uint<16> > in31;
    iPort<sc_uint<16> > in32;
    iPort<sc_uint<16> > in33;
    iPort<sc_uint<16> > in34;
    iPort<sc_uint<16> > in35;

    iPort<sc_uint<32> > orig_data_in;
    iPort<sc_uint<32> > config;
	sc_out<sc_uint<32> > result;
	sc_out<bool> lcu_loaded;
	sc_out<bool> lambda_loaded;
    sc_out<bool> result_ready;
    
    iPort<sc_uint<16> >* inputs[35];

    void ip_sad_main();
    
    SC_CTOR(ip_sad)
    {
		inputs[0] = &in1;
		inputs[1] = &in2;
		inputs[2] = &in3;
		inputs[3] = &in4;
		inputs[4] = &in5;
		inputs[5] = &in6;
		inputs[6] = &in7;
		inputs[7] = &in8;
		inputs[8] = &in9;
		inputs[9] = &in10;
		inputs[10] = &in11;
		inputs[11] = &in12;
		inputs[12] = &in13;
		inputs[13] = &in14;
		inputs[14] = &in15;
		inputs[15] = &in16;
		inputs[16] = &in17;
		inputs[17] = &in18;
		inputs[18] = &in19;
		inputs[19] = &in20;
		inputs[20] = &in21;
		inputs[21] = &in22;
		inputs[22] = &in23;
		inputs[23] = &in24;
		inputs[24] = &in25;
		inputs[25] = &in26;
		inputs[26] = &in27;
		inputs[27] = &in28;
		inputs[28] = &in29;
		inputs[29] = &in30;
		inputs[30] = &in31;
		inputs[31] = &in32;
		inputs[32] = &in33;
		inputs[33] = &in34;
		inputs[34] = &in35;

		SC_CTHREAD(ip_sad_main, clk.pos());
		reset_signal_is(rst,true);
    }
};

#endif
