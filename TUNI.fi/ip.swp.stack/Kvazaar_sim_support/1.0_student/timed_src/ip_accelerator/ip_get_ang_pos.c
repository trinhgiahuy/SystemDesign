/*---------------------------------------------------------------------------
*  File:	ip_get_ang_pos.c
*
*  Purpose: SystemC model for Intra Prediction Get Angular Positive
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_get_ang_pos.h"

const uint_8 ang_table[9]     = {0,    2,    5,   9,  13,  17,  21,  26,  32};
const uint_16 inv_ang_table[9] = {0, 4096, 1638, 910, 630, 482, 390, 315, 256};

void ip_get_ang_pos::ip_get_ang_pos_main()
{
	//variables
    sc_uint<6> width = 0;
    sc_uint<7> a = 0;
    sc_uint<4> mode = 0;
	sc_uint<7> bytes = 0;
    uint_8  src1[65];
    uint_8  src2[65];
    uint_8  src3[65];
    uint_8  src4[65];

	sc_uint<6> k,l;
    sc_uint<6> loops;
	sc_uint<6> abs_ang;
	
	bool ver=0,hor=0;
	
    //reset outputs
	data_in.lz.write(0);
    data_out_hor.z.write(0);
    data_out_hor.lz.write(0);
	data_out_ver.z.write(0);
    data_out_ver.lz.write(0);
    wait();

	//eternal loop
    while(true)
    {
		//get config
		uint_32 config_temp;
		READ_C(data_in,config_temp);
		width = config_temp.range(5,0);
		mode = config_temp.range(10,7);
		
		if(width[2] == 1)
		{
			//bytes = 8;
			bytes = 3;
		}
		else if(width[3] == 1)
		{
			//bytes = 16;
			bytes = 4;
		}
		else if(width[4] == 1)
		{
			//bytes = 32;
			bytes = 5;
		}
		else if(width[5] == 1)
		{
			//bytes = 64;
			bytes = 6;
		}
		
		for(a = 0; a < 65;a++)
		{
			uint_32 temp;
			READ_C(data_in,temp);
			
			src1[a] = temp.range(7,0);
			src2[a] = temp.range(23,16);
			src3[a] = temp.range(7,0);
			src4[a] = temp.range(23,16);
				
			if(a[bytes] == 1)
			{
				break;
			}
				
			a++;
				
			src1[a] = temp.range(15,8);
			src2[a] = temp.range(31,24);
			src3[a] = temp.range(15,8);
			src4[a] = temp.range(31,24);
		}
		abs_ang = ang_table[mode];

		//ref_main = mode_ver ? src1 : src2;
		//ref_main2 = mode_ver ? src3 : src4;

		{
			sc_uint<11>  delta_pos=0;
			sc_uint<6>  delta_int;
			sc_uint<5>  delta_fract;
			sc_uint<6>  minus_delta_fract;
			loops = width-1;
			for (k = 0; k < 32; k++) 
			{
				delta_pos += abs_ang;
				delta_int   = delta_pos.range(10,5);//delta_pos >> 5;
				delta_fract = delta_pos.range(4,0);//delta_pos & (32 - 1);

				minus_delta_fract = (32 - delta_fract);
				// Do linear filtering
				for (l = 0; l < 32; l++) 
				{
					uint_8 value;
					sc_uint<16> temp_ver;
					sc_uint<16> temp_hor;
					if(delta_fract)
					{
						//ver
						value = (((minus_delta_fract * src1[l + delta_int + 1])+ (delta_fract * src1[l + delta_int + 2])) + 16) >> 5;
						temp_ver.range(7,0) = value;
					
						//hor
						value = (((minus_delta_fract * src2[l + delta_int + 1])+ (delta_fract * src2[l + delta_int + 2])) + 16) >> 5;
						temp_hor.range(7,0) = value;
					
						l++;
					
						//ver
						value = (((minus_delta_fract * src3[l + delta_int + 1])+ (delta_fract * src3[l + delta_int + 2])) + 16) >> 5;
						temp_ver.range(15,8) = value;
						
						
						//hor
						value = (((minus_delta_fract * src4[l + delta_int + 1])+ (delta_fract * src4[l + delta_int + 2])) + 16) >> 5;
						temp_hor.range(15,8) = value;
					}
					else
					{
						//ver
						value = src1[l + delta_int + 1];
						temp_ver.range(7,0) = value;
						
						//hor
						value = src2[l + delta_int + 1];
						temp_hor.range(7,0) = value;

						l++;
					
						//ver
						value = src3[l + delta_int + 1];
						temp_ver.range(15,8) = value;
						
						//hor
						value = src4[l + delta_int + 1];
						temp_hor.range(15,8) = value;
					}
					data_out_ver.lz.write(1);
					data_out_ver.z.write(temp_ver);
					data_out_hor.lz.write(1);
					data_out_hor.z.write(temp_hor);
					wait();
					while(1)
					{
						if(data_out_ver.vz.read() && !ver)
						{
							data_out_ver.lz.write(0);
							ver = 1;
						}
						if(data_out_hor.vz.read() && !hor)
						{
							data_out_hor.lz.write(0);
							hor = 1;
						}
						if(ver && hor)
						{
							break;
						}
						wait();
					}
					ver = 0;
					hor = 0;
					
					if(l == loops)
					{
						break;
					}
				}
				if(k == loops)
				{
					break;
				}
			}
		}
    }
}
