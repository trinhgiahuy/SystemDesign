/*---------------------------------------------------------------------------
*  File:	ip_get_dc.c
*
*  Purpose: SystemC model for Intra Prediction Get DC
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_get_dc.h"

void ip_get_dc::ip_get_dc_main()
{
		//variables
    sc_uint<6> width = 0;
    sc_uint<7> a = 0;
	sc_uint<7> bytes = 0;
	one_bit filter = 0;
	uint_8  src1[65];
    uint_8  src2[65];
    uint_8  src3[65];
	uint_32 sum = 0;

	sc_uint<6> c = 0;
    sc_uint<6> b = 0;
    sc_uint<11> d = 0;
    sc_uint<11> loops;
    uint_8 i,dc_value;
    sc_uint<3> divider;
    sc_uint<6> limit;
	
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
		filter = config_temp[6];
	
		sum = 0;
	
		if(width[2] == 1)
		{
			bytes = 3;
			loops = 15;
		}
		else if(width[3] == 1)
		{
			bytes = 4;
			loops = 63;
		}
		else if(width[4] == 1)
		{
			bytes = 5;
			loops = 255;
		}
		else if(width[5] == 1)
		{
			bytes = 6;
			loops = 1023;
		}
		
		limit = width-1;
		
		//get reference pixels
		for(a = 0; a < 65;a++)
		{
			uint_32 temp;
			READ_C(data_in,temp);
			
			src1[a] = temp.range(7,0);
			src2[a] = temp.range(23,16);
			src3[a] = temp.range(7,0);
			if(a != 0 && a <=  width)
			{
				sum += temp.range(7,0);
				sum += temp.range(23,16);
			}
			
			if(a[bytes] == 1)
			{
				break;
			}
				
			a++;
			
			src1[a] = temp.range(15,8);
			src2[a] = temp.range(31,24);
			src3[a] = temp.range(15,8);
				
			if(a <= width)
			{
				sum += temp.range(15,8);
				sum += temp.range(31,24);
			}
		}

		if(width[2] == 1)
		{
			divider = 3;
		}
		else if(width[3] == 1)
		{
			divider = 4;
		}
		else if(width[4] == 1)
		{
			divider = 5;
		}
		else
		{
			divider = 6;
		}
		dc_value = (sum+width) >> divider;
	  
		if(filter)
		{
			uint_8 value;
			uint_16 temp;
		  
			for(c = 0; c < 32;c++)
			{
				for(b = 0; b < 32; b++)
				{
					if(c == 0)
					{
						if(b == 0)
						{
							value = (src1[b+1] + src2[b+1] + 2*dc_value + 2)>>2;
							temp.range(7,0) = value;
				  
							b++;

							value = (src3[b+1] + 3*dc_value + 2)>>2;
							temp.range(15,8) = value;
						}
						else
						{
							value = (src1[b+1] + 3*dc_value + 2)>>2;
							temp.range(7,0) = value;
			  
							b++;
							value = (src3[b+1] + 3*dc_value + 2)>>2;
							temp.range(15,8) = value;
						}
					}
					else
					{
						if(b == 0)
						{
							value = (src2[c+1] + 3*dc_value + 2)>>2;
						}
						else
						{
							value = dc_value;
						}
						temp.range(7,0) = value;
				  
						b++;
						temp.range(15,8) = dc_value;
					}
			  
					WRITE_C(data_out,temp);
					if(b == limit)
					{
						break;
					}
				}
				if(c == limit)
				{
					break;
				}
			}
		}
		else
		{
			for(d = 0; d < 1024;d++)
			{
				uint_16 temp;
				temp.range(7,0) = dc_value;
				
				d++;
				temp.range(15,8) = dc_value;
			
				WRITE_C(data_out,temp);
				if(d==loops)
				{
					break;
				}
			}
		} 
	}
}
