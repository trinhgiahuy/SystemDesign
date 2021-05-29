/*---------------------------------------------------------------------------
*  File:	ip_sad.c
*
*  Purpose: SystemC model for Intra Prediction SAD
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_sad.h"

#define CLEAR(table) for(int s = 0; s < 35; s++){(table)[s] = 0;}

const double entropy_bits[128] =
{
    1.0, 1.0,
    0.92852783203125, 1.0751953125,
    0.86383056640625, 1.150390625,
    0.80499267578125, 1.225555419921875,
    0.751251220703125, 1.300750732421875,
    0.702056884765625, 1.375946044921875,
    0.656829833984375, 1.451141357421875,
    0.615203857421875, 1.526336669921875,
    0.576751708984375, 1.601531982421875,
    0.54119873046875, 1.67669677734375,
    0.508209228515625, 1.75189208984375,
    0.47760009765625, 1.82708740234375,
    0.449127197265625, 1.90228271484375,
    0.422637939453125, 1.97747802734375,
    0.39788818359375, 2.05267333984375,
    0.37481689453125, 2.127838134765625,
    0.353240966796875, 2.203033447265625,
    0.33306884765625, 2.278228759765625,
    0.31414794921875, 2.353424072265625,
    0.29644775390625, 2.428619384765625,
    0.279815673828125, 2.5037841796875,
    0.26422119140625, 2.5789794921875,
    0.24957275390625, 2.6541748046875,
    0.235809326171875, 2.7293701171875,
    0.222869873046875, 2.8045654296875,
    0.210662841796875, 2.879730224609375,
    0.199188232421875, 2.954925537109375,
    0.188385009765625, 3.030120849609375,
    0.17822265625, 3.105316162109375,
    0.168609619140625, 3.180511474609375,
    0.1595458984375, 3.255706787109375,
    0.1510009765625, 3.33087158203125,
    0.1429443359375, 3.40606689453125,
    0.135345458984375, 3.48126220703125,
    0.128143310546875, 3.55645751953125,
    0.121368408203125, 3.63165283203125,
    0.114959716796875, 3.706817626953125,
    0.10888671875, 3.782012939453125,
    0.1031494140625, 3.857208251953125,
    0.09771728515625, 3.932403564453125,
    0.09259033203125, 4.007598876953125,
    0.0877685546875, 4.082794189453125,
    0.083160400390625, 4.157958984375,
    0.078826904296875, 4.233154296875,
    0.07470703125, 4.308349609375,
    0.070831298828125, 4.383544921875,
    0.067138671875, 4.458740234375,
    0.06365966796875, 4.533935546875,
    0.06036376953125, 4.609100341796875,
    0.057220458984375, 4.684295654296875,
    0.05426025390625, 4.759490966796875,
    0.05145263671875, 4.834686279296875,
    0.048797607421875, 4.909881591796875,
    0.046295166015625, 4.985076904296875,
    0.043914794921875, 5.06024169921875,
    0.0416259765625, 5.13543701171875,
    0.03948974609375, 5.21063232421875,
    0.0374755859375, 5.285858154296875,
    0.035552978515625, 5.360992431640625,
    0.033721923828125, 5.43621826171875,
    0.031982421875, 5.51141357421875,
    0.03033447265625, 5.586578369140625,
    0.028778076171875, 5.661773681640625,
    0.027313232421875, 5.736968994140625,
};

//absolute value
sc_uint<9> sc_abs(sc_int<9> value)
{
    if(value < 0)
    {
        value = -value;
    }
    return (sc_uint<9>)value;
}

struct Best
{
    sc_uint<18> sad;
    sc_uint<6> index;
};

void ip_sad::ip_sad_main()
{
	// Variables
	uint_32 orig_block1[1024];
    uint_32 orig_block2[1024];
    
    uint_8 cost_init[128];
    uint_8 cost_init1[128];
    uint_8 cost_init2_3[128];
       
    sc_uint<6> a = 0;
    sc_uint<7> yy = 0;
    sc_uint<6> x,y = 0;
	
    uint_32 first_conf;
    sc_uint<3> byte_pos_hor = 0;
    sc_uint<3> byte_pos_ver = 0;
    sc_uint<4> hor_offset = 0;
    sc_uint<4> ver_offset = 0;
        
    uint_32 config_data_in;
    
    sc_uint<6> loops = 0;
    
    uint_16 orig_offset = 0;

    sc_uint<18> sad[35];
	one_bit done[35];

    //reset output signals
    config.lz.write(0);
    orig_data_in.lz.write(0);
	result.write(0);
    lcu_loaded.write(0);
	lambda_loaded.write(0);
	result_ready.write(0);
	
    for(int i = 0; i < 35;i++)
    {
		inputs[a]->lz.write(0);
    }
    wait();

	//eternal loop
    while(1)
    {
		lcu_loaded.write(0);
		lambda_loaded.write(0);
		result_ready.write(0);
		//read first config
		READ_C(config,first_conf);
		if(first_conf[30] == 1)
		{
			uint_8 q = 0;
			for(q = 0; q < 128; q++)
			{
				double cost_temp1 = first_conf.range(4,0).to_uint()*(entropy_bits[q] + 5);
				double cost_temp2 = first_conf.range(4,0).to_uint()*(entropy_bits[q] + 1);
				double cost_temp3 = first_conf.range(4,0).to_uint()*(entropy_bits[q] + 2);
				
				cost_init[q] = (int)cost_temp1;
				cost_init1[q] = (int)cost_temp2;
				cost_init2_3[q] = (int)cost_temp3;
			}
			lambda_loaded.write(1);
		}
		else if(first_conf[31] == 1)
		{
			for(yy = 0; yy < 64;yy++)
			{
				for(x = 0;x < 16;x++)
				{
					uint_32 temp;
					READ_C(orig_data_in,temp);
					orig_block1[yy*16+x] = temp;
					orig_block2[yy*16+x] = temp;
				}
			}
			lcu_loaded.write(1);
		}
		else
		{	
			uint_32 sad_result_temp = 0;
			Best cost;

			result_ready.write(0);
			
			byte_pos_hor = 0;
			byte_pos_ver = 0;
			hor_offset = 0;
			ver_offset = 0;
		
			uint_8 uc_state = first_conf.range(23,16);
			
			loops = first_conf.range(5,0)-1;
			
			for(y = 0; y < 35;y++)
			{
				sad[y] = cost_init[first_conf.range(23,16)];
			}
				
			READ_C(config,config_data_in);
			
			uc_state[0] = uc_state[0] ^ sc_uint<1>(1);
			
			sad[config_data_in.range(7,0)] = cost_init1[uc_state];
			sad[config_data_in.range(15,8)] = cost_init2_3[uc_state];
			sad[config_data_in.range(23,16)] = cost_init2_3[uc_state];
			
			READ_C(config,config_data_in);
			
			orig_offset = (config_data_in.range(15,0)>>2) + 16 * config_data_in.range(31,16);

			//calculate SAD
	/****************************************************************/

			for(y = 0; y < 32;y++)
			{
				for(x = 0; x < 32;x++)
				{
					CLEAR(done);
					uint_8 orig_ver1;
					uint_8 orig_hor1;
					uint_8 orig_ver2;
					uint_8 orig_hor2;
					
					uint_32 orig_temp;
					
					orig_temp = orig_block1[y*16+ver_offset+orig_offset];
					
					orig_ver1 = orig_temp.range(((byte_pos_ver+1)*8)-1,byte_pos_ver*8);
					byte_pos_ver++;
					orig_ver2 = orig_temp.range(((byte_pos_ver+1)*8)-1,byte_pos_ver*8);
					if(byte_pos_ver == 3)
					{
						ver_offset++;
						byte_pos_ver = 0;
					}
					else
					{
						byte_pos_ver++;
					}
					orig_hor1 = orig_block2[16*x+hor_offset+orig_offset].range(((byte_pos_hor+1)*8)-1,byte_pos_hor*8);

					x++;
					
					orig_hor2 = orig_block2[16*x+hor_offset+orig_offset].range(((byte_pos_hor+1)*8)-1,byte_pos_hor*8);
								
					for(a = 0;a < 35;a++)
					{
						inputs[a]->lz.write(1);
					}
					wait();
					while(1)
					{
						sc_int<9> temp1 = 0;
						sc_int<9> temp2 = 0;
						sc_uint<16> data = 0;
						bool do_break = true;
						for(a = 0;a < 35;a++)
						{
							if(inputs[a]->vz.read() && done[a] == 0)
							{
								done[a] = 1;
								data = inputs[a]->z.read();
								inputs[a]->lz.write(0);
								
								if((a == 0) || (a == 1) || (a > 17))
								{
									temp1 = orig_ver1 - data.range(7,0);
									temp2 = orig_ver2 - data.range(15,8);
								}
								else
								{
									temp1 = orig_hor1 - data.range(7,0);
									temp2 = orig_hor2 - data.range(15,8);      
								}
								sad[a] += (sc_abs(temp1) + sc_abs(temp2));
							}
						}
						for(int g = 0; g < 35;g++)
						{
							if(done[g] == 0)
							{
								do_break = false;
							}
						}
						if(do_break)
						{
							break;
						}
						wait();
					}		    
					if(x == loops)
					{
						break;
					}
				}
				if(y == loops)
				{
					break;
				}
				ver_offset = 0;
				if(byte_pos_hor == 3)
				{
					byte_pos_hor = 0;
					hor_offset++;
				}
				else
				{
					byte_pos_hor++;
				}
			}
	/****************************************************************/
			cost.sad = sad[0];
			cost.index = 0;
			for(unsigned int aa = 1; aa < 35; aa++)
			{
				if(cost.sad > sad[aa])
				{
					cost.sad = sad[aa];
					cost.index = aa;
				}
			}

			sad_result_temp = cost.sad;
			sad_result_temp.range(31,24) = cost.index;
			
			result.write(sad_result_temp);
			result_ready.write(1);
			wait();
		}
    }
}
