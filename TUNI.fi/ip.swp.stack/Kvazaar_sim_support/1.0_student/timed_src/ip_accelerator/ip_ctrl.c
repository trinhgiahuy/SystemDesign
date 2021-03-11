/*---------------------------------------------------------------------------
*  File:	ip_ctrl.c
*
*  Purpose: SystemC model for Intra Prediction Controller
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2015
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_ctrl.h"

#define CLEAR(table) for(int s = 0; s < 27; s++){(table)[s] = 0;}

//mode_ver 1bit # distance 4bit # filter 1bit # WIDTH ADDED LATER 6bit
/*
0b00000,0b00000,0b01000,0b00111,0b00110,0b00101,0b00100,0b00011,0b00010,0b00001,0b00000,
0b00001,0b00010,0b00011,0b00100,0b00101,0b00110,0b00111,
0b11000,0b10111,0b10110,0b10101,0b10100,0b10011,0b10010,0b10001,0b10000,0b10001,0b10010,
0b10011,0b10100,0b10101,0b10110,0b10111,0b11000
*/
const sc_uint<5> configs[27] = {0,0,8,7,6,5,4,3,2,1,0,1,2,3,4,5,6,7,
                               24,23,22,21,20,19,18,17,16/*,17,18,19,20,21,22,23,24*/};

const sc_uint<4> distances[27] = {0,0,8,7,6,5,4,3,2,1,0,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,0/*,1,2,3,4,5,6,7,8*/};


//component
void ip_ctrl::ip_ctrl_main()
{
    //variables
	sc_uint<6> width = 0;
    sc_uint<4> threshold = 0;
    uint_16 a = 0;
    uint_16 b = 0;

    uint_8 mode = 0;
    uint_8 bytes = 0;
	
	uint_16 unfiltered1_temp;
	uint_16 unfiltered2_temp;
	
    uint_8  unfiltered1_d[5];
    uint_8  unfiltered2_d[5];
	
	one_bit control[27];
	
	bool done[27];
	bool do_break;
	bool unfilt1_done = false;
	bool unfilt2_done = false;
  
    uint_8 limit;
    uint_32 temp;

    //reset signals
	config.lz.write(0);
    for(int i = 0; i < 35;i++)
    {
		outputs[a]->lz.write(0);
		outputs[a]->z.write(0);
    }
    wait();

    //eternal loop
    while(1)
    {
		unfilt1_done = false;
		unfilt2_done = false;
		do_break = true;
		one_bit offset = 0;
		
		threshold = 0;
		
		READ_C(config,temp);

		// Save width
	    width = temp.range(6,0);
		// Width 8
		if(width[3])
        {
            threshold = 7;
        }
		// Width 16
        else if(width[4])
        {
            threshold = 1;
        }

		limit = width+1;
	    bytes = width<<1;
		

		// Calculate which predictors get unfiltered pixels and filtered pixels in one cycle
	    for(mode = 0; mode < 27;mode++)
	    {
			if(width == 4 || mode == 1)
			{
				control[mode] = 0;
			}
			else if(mode == 0)
			{
				control[mode] = 1;
			}
			else
			{
				if(distances[mode] > threshold)
				{
					control[mode] = 1;
				}
				else 
				{
					control[mode] = 0;
				}
			}
	    }
		wait();

		// Configure predictors
/******************************************************************************************/
		for(mode = 0; mode < 27; mode++)
        {
            sc_uint<12> config_temp;
			config_temp.range(11,7) = configs[mode];
            if((mode == 1 || mode == 10 || mode == 26) && width[5] != 1)
            {
				config_temp[6] = 1;
            }
			config_temp.range(5,0) = width;
			outputs[mode]->lz.write(1);
            outputs[mode]->z.write(config_temp);
        }
		wait();
		
		for(mode = 0; mode < 27; mode++)
        {
            while(!outputs[mode]->vz.read())
			{
				wait();
			}
			outputs[mode]->lz.write(0);
        }
		
		//send pixels to predictors
 /******************************************************************************************/
		//READ_C(unfiltered1,unfiltered1_temp);
        //READ_C(unfiltered2,unfiltered2_temp);
		unfiltered1.lz.write(1);
		unfiltered2.lz.write(1);
		wait();
		while(1)
		{
			if(unfiltered1.vz.read() && !unfilt1_done)
			{
				unfilt1_done = true;
				unfiltered1_temp = unfiltered1.z.read();
				unfiltered1.lz.write(0);
			}
			if(unfiltered2.vz.read() && !unfilt2_done)
			{
				unfilt2_done = true;
				unfiltered2_temp = unfiltered2.z.read();
				unfiltered2.lz.write(0);
			}
			if(unfilt1_done && unfilt2_done)
			{
				break;
			}
		}
		
		wait();
		
        unfiltered1_d[0] = unfiltered1_temp.range(7,0);
        unfiltered2_d[0] = unfiltered2_temp.range(7,0);
        
        unfiltered1_d[1] = unfiltered1_temp.range(15,8);
        unfiltered2_d[1] = unfiltered2_temp.range(15,8);
 
		unfiltered1.lz.write(1);
		unfiltered2.lz.write(1);
		wait();
		
		for(a = 0; a < 65;a+=2)
        {
            uint_32 unfilt = 0;
            uint_32 filt = 0;
            uint_16 filt1 = 0;
            uint_16 filt2 = 0;
            sc_uint<2> index_d = 0;
            sc_uint<2> pixels;
 
			unfilt1_done = false;
			unfilt2_done = false;
 
			CLEAR(done);
			
            // stop reading pixels
            if(a != bytes)
            {
                //READ_C(unfiltered1,unfiltered1_temp);
				//READ_C(unfiltered2,unfiltered2_temp);
				unfiltered1.lz.write(1);
				unfiltered2.lz.write(1);
				//wait();
				while(1)
				{
					if(unfiltered1.vz.read())
					{
						unfilt1_done = true;
						unfiltered1_temp = unfiltered1.z.read();
						//unfiltered1.lz.write(0);
					}
					if(unfiltered2.vz.read())
					{
						unfilt2_done = true;
						unfiltered2_temp = unfiltered2.z.read();
						//unfiltered2.lz.write(0);
					}
					if(unfilt1_done && unfilt2_done)
					{
						break;
					}
				}
                unfiltered1_d[2+offset] = unfiltered1_temp.range(7,0);
                unfiltered2_d[2+offset] = unfiltered2_temp.range(7,0);
                                          
                unfiltered1_d[3+offset] = unfiltered1_temp.range(15,8);
                unfiltered2_d[3+offset] = unfiltered2_temp.range(15,8);
            }
			else
			{
				unfiltered1.lz.write(0);
				unfiltered2.lz.write(0);
			}
            
            // set unfiltered pixel variable
            unfilt.range(7,0) = unfiltered1_d[0+offset];
            unfilt.range(15,8) = unfiltered1_d[1+offset];
            
            unfilt.range(23,16) = unfiltered2_d[0+offset];
            unfilt.range(31,24) = unfiltered2_d[1+offset];
            
            // filter
            for(pixels = 0; pixels < 2;pixels++)
            {
                sc_uint<7> index = a + pixels;
                if(index == 0)
                {
                    uint_8 filt_temp = (unfiltered2_d[1] + 2*unfiltered1_d[0] + unfiltered1_d[1] + 2) >> 2;
                    
                    filt1.range(7,0) = filt_temp;
                    filt2.range(7,0) = filt_temp;
                }
                else if(index != bytes)
                {
					filt1.range((8*(pixels+1))-1,8*pixels) = (uint_8)((unfiltered1_d[index_d+2] + 2*unfiltered1_d[index_d+1] + unfiltered1_d[index_d] + 2) >> 2);
                    filt2.range((8*(pixels+1))-1,8*pixels) = (uint_8)((unfiltered2_d[index_d+2] + 2*unfiltered2_d[index_d+1] + unfiltered2_d[index_d] + 2) >> 2);
                    index_d++;
                }
                else
                {
					filt1.range(7,0) = unfiltered1_d[3];
                    filt2.range(7,0) = unfiltered2_d[3];
                    break;
                }
            }
            
            // set filtered pixel variable
			filt.range(15,0) = filt1;
            filt.range(31,16) = filt2;

            // modes 0(planar) & 11-25(neg)
            if(a < limit)
            {
                if(control[0] == 0)
                {
                    outputs[0]->lz.write(1);
					outputs[0]->z.write(unfilt);
                }
                else
                {
                    outputs[0]->lz.write(1);
					outputs[0]->z.write(filt);
                }
                
                for(b = 11; b < 26;b++)
                {
                    if(control[b] == 0)
                    {
                        outputs[b]->lz.write(1);
						outputs[b]->z.write(unfilt);
                    }   
                    else
                    {
                        outputs[b]->lz.write(1);
						outputs[b]->z.write(filt);
                    } 
                }
            }
			
			// modes 1-10(dc + pos + zero)
            for(b = 1; b < 11;b++)
            {
				if(control[b] == 0)
				{
					outputs[b]->lz.write(1);
					outputs[b]->z.write(unfilt);	
				}
				else
				{
					outputs[b]->lz.write(1);
					outputs[b]->z.write(filt);
				}
            }
            
            // mode 26(zero)
            if(control[26] == 0)
            {
                outputs[26]->lz.write(1);
				outputs[26]->z.write(unfilt);
            }
            else
            {
                outputs[26]->lz.write(1);
				outputs[26]->z.write(filt);
            }

			wait();
			
			while(1)
			{
				do_break = true;
				if(a < limit)
				{
					if(outputs[0]->vz.read() && !done[0])
					{
						outputs[0]->lz.write(0);
						done[0] = 1;
					}
					for(b = 11; b < 26;b++)
					{
						if(outputs[b]->vz.read() && !done[b])
						{
							outputs[b]->lz.write(0);
							done[b] = 1;
						}
					}
				}
				for(b = 1; b < 11;b++)
				{
					if(outputs[b]->vz.read() && !done[b])
					{
						outputs[b]->lz.write(0);
						done[b] = 1;
					}
				}
				if(outputs[26]->vz.read() && !done[26])
				{
					outputs[26]->lz.write(0);
					done[26] = 1;
				}
				
				if(a < limit)
				{
					if(done[0] == 0)
					{
						do_break = false;
					}
					for(mode = 11; mode < 26;mode++)
					{
						if(done[mode] == 0)
						{
							do_break = false;
						}
					}
				}
				if(done[26] == 0)
				{
					do_break = false;
				}
				for(mode = 1; mode < 11;mode++)
				{
					if(done[mode] == 0)
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
			
            if(a == bytes){break;}
            
            // shift buffer
            if(a == 0)
            {
                unfiltered1_d[0] = unfiltered1_d[1];
                unfiltered1_d[1] = unfiltered1_d[2];
                unfiltered1_d[2] = unfiltered1_d[3];
            
                unfiltered2_d[0] = unfiltered2_d[1];
                unfiltered2_d[1] = unfiltered2_d[2];
                unfiltered2_d[2] = unfiltered2_d[3];
                offset = 1;
            }
            else
            {
                unfiltered1_d[0] = unfiltered1_d[2];
                unfiltered1_d[1] = unfiltered1_d[3];
                unfiltered1_d[2] = unfiltered1_d[4];
            
                unfiltered2_d[0] = unfiltered2_d[2];
                unfiltered2_d[1] = unfiltered2_d[3];
                unfiltered2_d[2] = unfiltered2_d[4];               
            }
        }
	}
}
