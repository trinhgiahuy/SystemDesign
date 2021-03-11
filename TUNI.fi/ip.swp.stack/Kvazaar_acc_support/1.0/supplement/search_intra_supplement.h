#ifndef SEARCH_INTRA_SUPPLEMENT_H_
#define SEARCH_INTRA_SUPPLEMENT_H_

#include "intra.h"
#include "kvazaar.h"
#include "encoderstate.h"
#include "cabac.h"

// sends unfiltered referencepixels to the accelerator, used in searc_intra.c
extern void send_unfiltered(kvz_intra_references* refs, int8_t cu_width);

// used for configuring the accelerator and reading the results from the accelerator, used in searc_intra.c
extern int8_t search_intra_rough_hw(encoder_state_t * const state, 
							 kvz_pixel *orig, int32_t origstride,
							 kvz_intra_references *refs,
							 int log2_width, int8_t *intra_preds,
							 int8_t modes[35], double costs[35],
							 uint16_t x_pos,uint16_t y_pos,int thread);
							 
#endif // SEARCH_INTRA_SUPPLEMENT_H_