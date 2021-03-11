#include "global_supplement.h"
#include "search_intra_supplement.h"

// sends unfiltered reference pixels to the accelerator, used in searc_intra.c
void send_unfiltered(kvz_intra_references* refs, int8_t cu_width)
{
    if(ioctl(ip_acc_fd,0,0) < 0)
    {
        printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
        exit(0);
    }
    write(ip_acc_fd,refs->ref.top,cu_width*2+1);    
    //ioctl(ip_acc_fd,0,1);
    write(ip_acc_fd,refs->ref.left,cu_width*2+1);
}

// used for configuring the accelerator and reading the results from the accelerator, used in searc_intra.c
int8_t search_intra_rough_hw(encoder_state_t * const state, 
							 kvz_pixel *orig, int32_t origstride,
							 kvz_intra_references *refs,
							 int log2_width, int8_t *intra_preds,
							 int8_t modes[35], double costs[35],
							 uint16_t x_pos,uint16_t y_pos,int thread)
{
	const cabac_ctx_t *ctx = &(state->cabac.ctx.intra_mode_model);
    int_fast8_t width = 1 << log2_width;
    static uint8_t temp[24] = {0};
    uint32_t buf[2];
    
    temp[0] = (uint8_t)width;
    temp[1] = thread;
	
    temp[2] = ctx->uc_state;
    
    temp[6] = intra_preds[2];
    temp[5] = intra_preds[1];
    temp[4] = intra_preds[0];
    
    ((uint16_t*)temp)[5] = y_pos;
    ((uint16_t*)temp)[4] = x_pos;
    
    write(ip_acc_fd,temp,12);
    
    if(pread(ip_acc_fd,buf,8,thread) < 0)
    {
        printf("READ ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
    }
    modes[0] = buf[0];
    costs[0] = buf[1];

    return 1;
}