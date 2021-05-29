/*---------------------------------------------------------------------------
*  File:	ip_get_ang_neg.c
*
*  Purpose: SystemC model for Intra Prediction Get Angular Negative
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_get_ang_neg.h"

const sc_uint<6> ang_table[9] = {0,2,5,9,13,17,21,26,32};

const sc_uint<6> indexes[8][32] = {
{16,32},
{6,13,19,26,32},
{4,7,11,14,18,21,25,28,32},
{2,5,7,10,12,15,17,20,22,25,27,30,32},
{2,4,6,8,9,11,13,15,17,19,21,23,24,26,28,30,32},
{2,3,5,6,8,9,11,12,14,15,17,18,20,21,23,24,26,27,29,30,32},
{1,2,4,5,6,7,9,10,11,12,14,15,16,17,18,20,21,22,23,25,26,27,28,30,31,32},
{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32}
};

void ip_get_ang_neg::ip_get_ang_neg_main()
{
	//variables
    sc_uint<6> width = 0;
    sc_uint<6> a = 0;
    sc_uint<4> mode = 0;
    one_bit mode_ver = 0;
    uint_8  src1[33];
    uint_8  src2[33];
    uint_8  src3[33];
    uint_8  src4[33];
    uint_8  src5[33];
    uint_8  src6[33];

	sc_uint<6> k,l;
    sc_uint<6> loops;
    sc_uint<6> abs_ang;
	
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
	
		//get reference pixels
		for(a = 0; a < 33;a++)
		{
			uint_32 temp;
			READ_C(data_in,temp);
			
			src1[a] = temp.range(7,0);
			src2[a] = temp.range(23,16);
			src3[a] = temp.range(7,0);
			src4[a] = temp.range(23,16);
			src5[a] = temp.range(7,0);
			src6[a] = temp.range(23,16);
				
			if(a == width)
			{
				break;
			}
				
			a++;
				
			src1[a] = temp.range(15,8);
			src2[a] = temp.range(31,24);
			src3[a] = temp.range(15,8);
			src4[a] = temp.range(31,24);
			src5[a] = temp.range(15,8);
			src6[a] = temp.range(31,24);
		}
		
		// Do angular predictions
		uint_8 *ref_main;
		uint_8 *ref_side;
	  
		uint_8 *ref_main2;
		uint_8 *ref_side2;
	  
		uint_8 *ref_main3;
		uint_8 *ref_side3;

		abs_ang = ang_table[mode];

		// Initialise the Main and Left reference array.

		ref_main = (mode_ver ? src1 : src2);// + (width - 1);
		ref_side = (mode_ver ? src2 : src1);// + (width - 1);
		
		ref_main2 = (mode_ver ? src3 : src4);// + (width - 1);
		ref_side2 = (mode_ver ? src4 : src3);// + (width - 1);
		
		ref_main3 = (mode_ver ? src5 : src6);// + (width - 1);
		ref_side3 = (mode_ver ? src6 : src5);// + (width - 1);


		{
			sc_int<12> delta_pos=0;
			sc_int<7> delta_int;
			sc_int<7> delta_fract;
			sc_int<7> minus_delta_fract;
			sc_int<7> ref_main_index;
			loops = width-1;
			for (k = 0; k < 32; k++) 
			{
				delta_pos -= abs_ang;
				delta_int   = (delta_pos >> 5) + 1;
				delta_fract = delta_pos & (32 - 1);

				minus_delta_fract = (32 - delta_fract);
				// Do linear filtering
				for (l = 0; l < 32; l++) 
				{
					uint_8 value;
					sc_uint<16> temp;
					uint_8 yksi;
					uint_8 kaksi;
					uint_8 kolme;
				
					ref_main_index = l + delta_int;
				
					if(ref_main_index[6] == 1)
					{
						yksi = ref_side[indexes[mode-1][(-ref_main_index)-1]];
					}
					else
					{
						yksi = ref_main[ref_main_index];
					}
					ref_main_index++;
					if(ref_main_index[6] == 1)
					{
						kaksi = ref_side2[indexes[mode-1][(-ref_main_index)-1]];
					}
					else
					{
						kaksi = ref_main2[ref_main_index];
					}
					ref_main_index++;
					if(ref_main_index[6] == 1)
					{
						kolme = ref_side3[indexes[mode-1][(-ref_main_index)-1]];
					}
					else
					{
						kolme = ref_main3[ref_main_index];
					}
					if(delta_fract)
					{
						value = (((minus_delta_fract * yksi)+ (delta_fract * kaksi)) + 16) >> 5;
						temp.range(7,0) = value;

						l++;
						ref_main_index++;
						value = (((minus_delta_fract * kaksi)+ (delta_fract * kolme)) + 16) >> 5;
						temp.range(15,8) = value;

					}
					else
					{
						value = yksi;
						temp.range(7,0) = value;

						l++;
						ref_main_index++;
						value = kaksi;
						temp.range(15,8) = value;
					}
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
}
