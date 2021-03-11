/*---------------------------------------------------------------------------
*  File:	ip_get_planar.c
*
*  Purpose: SystemC model for Intra Prediction Get Planar
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_get_planar.h"

void ip_get_planar::ip_get_planar_main()
{
	sc_uint<6> width = 0;
    sc_uint<6> a = 0;
	uint_8  src1[33];
    uint_8  src2[33];
	uint_8 bottom_left;
    uint_8 top_right;

	sc_uint<6> k, l;
    sc_uint<13> hor_pred;
    
    sc_uint<3> shift_1d;
    sc_uint<3> shift_2d;
    sc_uint<6> loops;
	
    //reset outputs
	data_in.lz.write(0);
    data_out.z.write(0);
    data_out.lz.write(0);
    wait();

    //eternal loop
    while(true)
    {
		//get config
		uint_32 config_temp;
		READ_C(data_in,config_temp);
		width = config_temp.range(5,0);
	
		for(a = 0; a < 33;a++)
		{
			uint_32 temp;
			READ_C(data_in,temp);
			if(a == 0)
			{
				src1[a] = temp.range(15,8);
				src2[a] = temp.range(31,24);
			}
			else
			{
			   src1[a] = temp.range(7,0);
			   src2[a] = temp.range(23,16);
			   
			   a++;
			   src1[a] = temp.range(15,8);
			   src2[a] = temp.range(31,24);
			   
			   if(a == width)
			   {
				   top_right = temp.range(15,8);
				   bottom_left = temp.range(31,24);
				   break;
			   }
			}
		}
		
		if(width[2] == 1)
		{
			shift_1d = 2;
		}
		else if(width[3] == 1)
		{
			shift_1d = 3;
		}
		else if(width[4] == 1)
		{
			shift_1d = 4;
		}
		else if(width[5] == 1)
		{
			shift_1d = 5;
		}
	
		shift_2d = shift_1d + 1;
		
		
		// Prepare intermediate variables used in interpolation
		loops = width-1;
	 
		// Generate prediction signal
		for (k = 0; k < 32; k++) 
		{
			uint_8 src2_temp = src2[k];
			sc_int<9> right_temp = top_right - src2_temp;
			hor_pred = ((uint_16)src2_temp << shift_1d) + width;

			for (l = 0; l < 32; l++)
			{
				uint_8 value;
				uint_16 temp;
				uint_8 src1_temp;
			
				src1_temp = src1[l];
				value = (hor_pred + right_temp*(l+1) + ((uint_16)src1_temp << shift_1d) + (k+1)*(bottom_left-src1_temp)) >> shift_2d;
				temp.range(7,0) = value;
			
				l++;
				src1_temp = src1[l];
				value = (hor_pred + right_temp*(l+1) + ((uint_16)src1_temp << shift_1d) + (k+1)*(bottom_left-src1_temp)) >> shift_2d;
				temp.range(15,8) = value;
			
				WRITE_C(data_out,temp);
			
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
