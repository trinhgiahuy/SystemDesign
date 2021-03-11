/*---------------------------------------------------------------------------
*  File:	ip_config.c
*
*  Purpose: SystemC model for Intra Prediction Configer
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2015
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "ip_config.h"

void ip_config::ip_config_main()
{
    uint_32 temp = 0;
	ctrl_config.lz.write(0);
    sad_config.lz.write(0);
    wait();
    while(1)
    {
		READ_C(config,temp);
		if(temp[31] == 1 || temp[30] == 1)
		{
			// temp[31] == 1 read orig
			// temp[30] == 1 lamda
			WRITE_C(sad_config,temp);
		}
		else
		{   
			bool sad=0,ctrl=0;
			// Width to ctrl
			ctrl_config.lz.write(1);
			ctrl_config.z.write(temp.range(5,0));
			
			// Width & uc_state to sad
			sad_config.lz.write(1);
			sad_config.z.write(temp);
			wait();
			while(1)
			{
				if(sad_config.vz.read() && !sad)
				{
					sad_config.lz.write(0);
					sad = 1;
				}
				if(ctrl_config.vz.read() &&  !ctrl)
				{
					ctrl_config.lz.write(0);
					ctrl = 1;
				}
				if(sad && ctrl)
				{
					break;
				}
				wait();
			}
			
			// Intra_preds to sad
			READ_C(config,temp);
			WRITE_C(sad_config,temp);
			
			// Coordinates to sad
			READ_C(config,temp);
			WRITE_C(sad_config,temp);
		}
    }
}