/*---------------------------------------------------------------------------
*  File:	global.c
*
*  Purpose: SystemC macros,typedefs and templates for Intra Prediction Accelerator
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#ifndef IP_GLOBAL_H
#define IP_GLOBAL_H

#include <systemc.h>

#define READ_C(var,value) (var).lz.write(1);do{wait();/*cout << __LINE__<< " " << __FILE__ << endl;*/}while(!(var).vz.read());(value)=(var).z.read();(var).lz.write(0);

#define WRITE_C(var,value) (var).lz.write(1);(var).z.write((value));do{wait();}while(!(var).vz.read());(var).lz.write(0);

#define CONNECT(chan,sig) (chan).lz((sig).vz); (chan).vz((sig).lz); (chan).z((sig).z);

#define CONNECT_CHANNELS(chan1,chan2,sig) (chan1).lz((sig).vz); (chan1).vz((sig).lz); (chan1).z((sig).z); (chan2).vz((sig).vz); (chan2).lz((sig).lz); (chan2).z((sig).z);
 
typedef sc_uint<8> uint_8;
typedef sc_uint<16> uint_16;
typedef sc_uint<32> uint_32;
typedef sc_uint<1> one_bit;
typedef sc_int<8> int_8;
typedef sc_int<16> int_16;
typedef sc_int<12> int_12;
typedef sc_int<7> int_7;

template<typename port_size>
struct iPort
{
    sc_in<port_size> z;
    sc_out<bool> lz;
    sc_in<bool> vz;
};

template<typename port_size>
struct oPort
{
    sc_out<port_size> z;
    sc_out<bool> lz;
    sc_in<bool> vz;
};

template<typename port_size>
struct Signal
{
    sc_signal<port_size> z;
    sc_signal<bool> lz;
    sc_signal<bool> vz;
};

#endif
