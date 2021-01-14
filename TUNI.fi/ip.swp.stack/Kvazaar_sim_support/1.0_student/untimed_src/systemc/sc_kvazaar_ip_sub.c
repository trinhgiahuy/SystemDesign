#include "sc_kvazaar_ip_sub.h"

#include "kvazaar.h"
#include "encoderstate.h"
#include "cabac.h"
#include "rdo.h"
#include "global_supplement.h"

// static function for selecting the best mode
static uint8_t select_best_mode_index(unsigned char *modes, double *costs, uint8_t length)
{
  uint8_t best_index = 0;
  double best_cost = costs[0];
  for (uint8_t i = 1; i < length; ++i) {
    if ((int)costs[i] < (int)best_cost) {
      best_cost = costs[i];
      best_index = i;
    }
  }
  return best_index;
}

// static function used for getting the luma mode bits
static double kvz_luma_mode_bits(uint8_t uc_state, int8_t luma_mode, const int8_t *intra_preds)
{
  double mode_bits;

  bool mode_in_preds = false;
  for (int i = 0; i < 3; ++i) {
    if (luma_mode == intra_preds[i]) {
      mode_in_preds = true;
    }
  }

  cabac_ctx_t ctx = {0};
  ctx.uc_state = uc_state;
  mode_bits = CTX_ENTROPY_FBITS(&ctx, mode_in_preds);

  if (mode_in_preds) {
    mode_bits += ((luma_mode == intra_preds[0]) ? 1 : 2);
  } else {
    mode_bits += 5;
  }
  return mode_bits;
}

// waits for all data to be valid,
// configures the accelerator,
// calculates the log2_width, 
// copies the corresponding original pixels for the predicted CU,
// starts prediction threads,
// selects the best mode
void kvazaar_ip_sub::intra_control()
{
    while(1)
    {	
		// wait for events
		wait(config_valid & unfilt1_valid & unfilt2_valid);
		
		int best_mode_index = 0;
		
		// configure the accelerator
		width = config[0];
		uc_state = config[2];
		intra_preds[0] = config[4];
		intra_preds[1] = config[5];
		intra_preds[2] = config[6];
		unsigned int x_pos = config[8];
		x_pos |= config[9]<<8;
		unsigned int y_pos = config[10];
		y_pos |= config[11]<<8;
		
		// get the right sad function
		sad_func = kvz_pixels_get_sad_func(width);
		
		// calculate the log2_width
		if(width == 32)
		{
			log2_width = 5;
		}
		else if(width == 16)
		{
			log2_width = 4;
		}
		else if(width == 8)
		{
			log2_width = 3;
		}
		else if(width == 4)
		{
			log2_width = 2;
		}
		
		// copy the corresponding original pixels for the CU in prediction
		kvz_pixels_blit(&orig[x_pos+y_pos*LCU_WIDTH], orig_block, width, width, LCU_WIDTH, width);
		
		// start the prediction threads
		intra_get_angular_start.notify();
		intra_get_planar_start.notify();
		intra_get_dc_start.notify();

		// wait for them to finish
		wait(intra_get_angular_done & intra_get_planar_done & intra_get_dc_done);
		
		// select best mode
		best_mode_index = select_best_mode_index(modes, costs, 35);
		
		// set the best mode and cost in on 32bit variable
		result = costs[best_mode_index];
		result |= modes[best_mode_index] << 24;
		
		// notify that the accelerator is done
		irq->notify(1,SC_NS);
    }
}

// Angular prediction thread function
void kvazaar_ip_sub::intra_get_angular()
{
    while(1)
    {
		// wait for start
		wait(intra_get_angular_start);

		unsigned char pred[LCU_WIDTH * LCU_WIDTH + 1];
		
		// loop angular predictions
		for(int a = 2; a <= 34;a++)
		{
			// do prediction
			kvz_intra_predict(&refs, log2_width, a, COLOR_Y, pred);
			
			// calculate cost
			costs[a] = sad_func(pred, orig_block);
			modes[a] = a;
			costs[a] += lambda_cost * kvz_luma_mode_bits(uc_state, a, intra_preds);
		}
		
		// notify that prediction is ready
		intra_get_angular_done.notify();
    }
}

// Planar prediction thread function
void kvazaar_ip_sub::intra_get_planar()
{
    while(1)
    {
		// wait for start
		wait(intra_get_planar_start);
		
		unsigned char pred[LCU_WIDTH * LCU_WIDTH + 1];
		
		// do prediction
		kvz_intra_predict(&refs, log2_width, 0, COLOR_Y, pred);
		
		// calculate cost
		costs[0] = sad_func(pred, orig_block);
		modes[0] = 0;
		costs[0] += lambda_cost * kvz_luma_mode_bits(uc_state, 0, intra_preds);
		
		// notify that prediction is ready
		intra_get_planar_done.notify();
    }
}

// DC prediction thread function
void kvazaar_ip_sub::intra_get_dc()
{
    while(1)
    {
		// wait for start
		wait(intra_get_dc_start);
		
		unsigned char pred[LCU_WIDTH * LCU_WIDTH + 1];
		
		// do prediction
		kvz_intra_predict(&refs, log2_width, 1, COLOR_Y, pred);
		
		// calculate cost
		costs[1] = sad_func(pred, orig_block);
		modes[1] = 1;
		costs[1] += lambda_cost * kvz_luma_mode_bits(uc_state, 1, intra_preds);
		
		// notify that prediction is ready
		intra_get_dc_done.notify();
    }
}

// TLM transaction function between kvazaar and kvazaar_ip_sub
void kvazaar_ip_sub::b_transport( tlm::tlm_generic_payload& trans, sc_time& delay )
{
	// get properties
    tlm::tlm_command cmd = trans.get_command();
    sc_dt::uint64    adr = trans.get_address();
    unsigned char*   ptr = trans.get_data_ptr();
    unsigned int     len = trans.get_data_length();
    unsigned char*   byt = trans.get_byte_enable_ptr();
    unsigned int     wid = trans.get_streaming_width();
    
    // Obliged to check address range and check for unsupported features,
    if ((adr & 0x0ffff) > sc_dt::uint64(4096) || len > 4096 || byt != 0 || wid != len)
    {
		printf("TLM-2 Error: Target does not support given payload transaction, %s, %s, %d",__FILE__,__func__,__LINE__);
		sc_stop();
    }

	// translate the address
    switch(adr & 0xf0000)
    {
		case CONFIG_BASE:
		{
			CHECK_OVERFLOW(CONFIG_BASE,CONFIG_SIZE);
			if ( cmd == tlm::TLM_READ_COMMAND )
			{
				memcpy(ptr, (char*)(&config[adr]), len);
			}
			else if ( cmd == tlm::TLM_WRITE_COMMAND )
			{
				memcpy((char*)(&config[adr]), ptr, len);
				config_valid.notify();
			}
			break;
		}
		// TODO
		
		default:
		{
			printf("TLM-2 Error: Segmentation fault, %s, %s, %d",__FILE__,__func__,__LINE__);
			sc_stop();
			break;
		}
    }

    // Obliged to set response status to indicate successful completion
    trans.set_response_status( tlm::TLM_OK_RESPONSE );
}
