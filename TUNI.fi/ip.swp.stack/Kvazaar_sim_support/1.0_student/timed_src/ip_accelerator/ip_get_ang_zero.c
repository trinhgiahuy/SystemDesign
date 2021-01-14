/*---------------------------------------------------------------------------
*  File:	ip_get_ang_zero.c
*
*  Purpose: SystemC model for Intra Prediction Get Angular Zero
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_get_ang_zero.h"

void ip_get_ang_zero::ip_get_ang_zero_main()
{
	//variables
    sc_uint<6> width = 0;
    sc_uint<7> a = 0;
    sc_uint<4> mode = 0;
	sc_uint<7> bytes = 0;
    one_bit mode_ver = 0;
    one_bit filter = 0;
    uint_8 ref_zero;
    uint_8  src1[65];
    uint_8  src2[65];
	int_8 src2_temp;
	
	sc_uint<6> k,l;
	
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
		mode = config_temp.range(10,7);
		mode_ver = config_temp[11];
		filter = config_temp[6];
	
		if(width[2] == 1)
		{
			bytes = 3;
		}
		else if(width[3] == 1)
		{
			bytes = 4;
		}
		else if(width[4] == 1)
		{
			bytes = 5;
		}
		else if(width[5] == 1)
		{
			bytes = 6;
		}
		
		//get reference pixels
		for(a = 0; a < 65;a++)
		{
			uint_32 temp;
			READ_C(data_in,temp);
			if(mode_ver && a == 0)
			{
				ref_zero = temp.range(23,16);
			}
			else if(a == 0)
			{
				ref_zero = temp.range(7,0);
			}
			if(mode_ver)
			{
				src1[a] = temp.range(7,0);
				src2[a] = temp.range(23,16);
					
				if(a[bytes] == 1)
				{
					break;
				}
					
				a++;
				src1[a] = temp.range(15,8);
				src2[a] = temp.range(31,24);
			}
			else
			{
				src1[a] = temp.range(23,16);
				src2[a] = temp.range(7,0);
				
				if(a[bytes] == 1)
				{
					break;
				}
				
				a++;
				src1[a] = temp.range(31,24);
				src2[a] = temp.range(15,8);
			}
		}
		
		for (k = 1; k < 33; k++)
		{
			src2_temp = (src2[k]-ref_zero)>>1;
			for (l = 1; l < 33; l++)
			{
				sc_uint<10> value;
				uint_8 value2;
				uint_16 temp;
				value2 = src1[l];

				if(filter && (l == 1))
				{
					value = value2+src2_temp;
					if(value[8] == 1)
					{
						value = 255;
					}
					else if(value[9] == 1)
					{
						value = 0;
					}
					value2 = (uint_8)value;
				}
				temp.range(7,0) = value2;

				l++;
				temp.range(15,8) = src1[l];

				WRITE_C(data_out,temp);
				if(l == width)
				{
					break;
				}
			}
			if(k == width)
			{
				break;
			}
		}
    }
}
