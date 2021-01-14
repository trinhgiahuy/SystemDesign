#include "global_supplement.h"
#include "search_intra_supplement.h"
#include "sc_kvazaar.h"

// sends unfiltered reference pixels to the accelerator, used in searc_intra.c
void send_unfiltered(kvz_intra_references* refs, int8_t cu_width)
{
	// use ioctl function to set the write location for IOCTL_LOCATION_UNFILT1
	if(ip_acc_driver->ioctl(ip_acc_fd,IOCTL_SET_LOCATION,IOCTL_LOCATION_UNFILT1) < 0)
	{
      printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
      ip_acc_driver->sc_exit();
	}
 
	// use write function to write the top (unfilt1) reference pixels to the accelerator
	ip_acc_driver->write(ip_acc_fd,refs->ref.top,cu_width*2+1);

	// use ioctl function to set the write location for IOCTL_LOCATION_UNFILT2	
	if(ip_acc_driver->ioctl(ip_acc_fd,IOCTL_SET_LOCATION,IOCTL_LOCATION_UNFILT2) < 0)
	{
      printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
      ip_acc_driver->sc_exit();
	}
	
	// use write function to write the left (unfilt2) reference pixels to the accelerator
    ip_acc_driver->write(ip_acc_fd,refs->ref.left,cu_width*2+1);
}

// used for configuring the accelerator and reading the results from the accelerator, used in searc_intra.c
int8_t search_intra_rough_hw(encoder_state_t * const state, 
							 kvz_pixel *orig, int32_t origstride,
							 kvz_intra_references *refs,
							 int log2_width, int8_t *intra_preds,
							 int8_t modes[35], double costs[35],
							 uint16_t x_pos,uint16_t y_pos,int thread)
{
	// get the current cabac ctx
	const cabac_ctx_t *ctx = &(state->cabac.ctx.intra_mode_model);
    int_fast8_t width = 1 << log2_width;
    uint8_t temp[12] = {0};
    uint32_t result;

	// set the temp array with the configuration values
	
	// ### 1. word ###
    temp[0] = (uint8_t)width;
	// ! thread set but not used in the simulation !
    temp[1] = thread;
    temp[2] = ctx->uc_state;
	// ################
	
	// ### 2. word ###
	temp[4] = intra_preds[0];
	temp[5] = intra_preds[1];
    temp[6] = intra_preds[2];
    // ################
	
	// ### 3. word ###
	// notice the typecast
    ((uint16_t*)temp)[5] = y_pos;
    ((uint16_t*)temp)[4] = x_pos;
	// ################
    
	// use ioctl function to set the write location for IOCTL_LOCATION_CONFIG	
	if(ip_acc_driver->ioctl(ip_acc_fd,IOCTL_SET_LOCATION,IOCTL_LOCATION_CONFIG) < 0)
	{
      printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
      ip_acc_driver->sc_exit();
	  //exit(0);
	}

	// use write function to write the config values to the accelerator
    ip_acc_driver->write(ip_acc_fd,temp,12);
    
	// use read function to read the results from the accelerator
    if(ip_acc_driver->read(ip_acc_fd,&result,4) < 0)
    {
		printf("READ ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
    }
    
	// mode is the upper 8bit
	modes[0] = result >> 24;
	// cost is the lower 24bit
    costs[0] = result & 0xffffff;

    return 1;
}

void search_intra_rough_delay(int delay)
{
	ip_acc_driver->delay_ns(delay,1);
}

void search_delay(int delay)
{
	ip_acc_driver->delay_ns(delay,0);
}

// sets the error flag in the kvazaar object
void simulation_error()
{
	// call the set_simulation_error from kvazaar object
	ip_acc_driver->set_simulation_error(1);
}