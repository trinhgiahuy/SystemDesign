/*****************************************************************************
* This file is part of Kvazaar HEVC encoder.
*
* Copyright (C) 2013-2015 Tampere University of Technology and others (see
* COPYING file).
*
* Kvazaar is free software: you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the
* Free Software Foundation; either version 2.1 of the License, or (at your
* option) any later version.
*
* Kvazaar is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along
* with Kvazaar.  If not, see <http://www.gnu.org/licenses/>.
****************************************************************************/

/*
* \file
*/

#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
#include <iostream>
using namespace std;
#endif

#include "search_intra.h"

#include "encoderstate.h"
#include "videoframe.h"
#include "strategies/strategies-picture.h"
#include "rdo.h"
#include "search.h"
#include "intra.h"

#if defined(IP_ACC) || defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW) || defined(EXPLORATION_SW)
#include "global_supplement.h"
#include "search_intra_supplement.h"
#endif

#if defined(EXPLORATION_HW) || defined(EXPLORATION_SW)
#include "exploration.h"
#endif

#ifdef IP_DEBUG
#define IP_DEBUG_ALL
//#define CU_LIMIT 1
#endif

// Normalize SAD for comparison against SATD to estimate transform skip
// for 4x4 blocks.
#ifndef TRSKIP_RATIO
#define TRSKIP_RATIO 1.7
#endif

/**
 * \brief Sort modes and costs to ascending order according to costs.
 */
void sort_modes(int8_t *__restrict modes, double *__restrict costs, uint8_t length)
{
  // Length is always between 5 and 23, and is either 21, 17, 9 or 8 about
  // 60% of the time, so there should be no need for anything more complex
  // than insertion sort.
  for (uint8_t i = 1; i < length; ++i) {
    const double cur_cost = costs[i];
    const int8_t cur_mode = modes[i];
    uint8_t j = i;
    while (j > 0 && cur_cost < costs[j - 1]) {
      costs[j] = costs[j - 1];
      modes[j] = modes[j - 1];
      --j;
    }
    costs[j] = cur_cost;
    modes[j] = cur_mode;
  }
}


/**
* \brief Select mode with the smallest cost.
*/
uint8_t select_best_mode_index(const int8_t *modes, const double *costs, uint8_t length)
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


/**
 * \brief Calculate quality of the reconstruction.
 *
 * \param pred  Predicted pixels in continous memory.
 * \param orig_block  Orignal (target) pixels in continous memory.
 * \param satd_func  SATD function for this block size.
 * \param sad_func  SAD function this block size.
 * \param width  Pixel width of the block.
 *
 * \return  Estimated RD cost of the reconstruction and signaling the
 *     coefficients of the residual.
 
 */
 #if !defined(IP_ACC) || defined(IP_DEBUG)
double get_cost(encoder_state_t * const state, 
                       kvz_pixel *pred, kvz_pixel *orig_block,
                       cost_pixel_nxn_func *satd_func,
                       cost_pixel_nxn_func *sad_func,
                       int width)
{
  double sad_cost = sad_func(pred, orig_block);
  return sad_cost;
  /*double satd_cost = satd_func(pred, orig_block);
  if (TRSKIP_RATIO != 0 && width == 4 && state->encoder_control->trskip_enable) {
    // If the mode looks better with SAD than SATD it might be a good
    // candidate for transform skip. How much better SAD has to be is
    // controlled by TRSKIP_RATIO.

    // Add the offset bit costs of signaling 'luma and chroma use trskip',
    // versus signaling 'luma and chroma don't use trskip' to the SAD cost.
    const cabac_ctx_t *ctx = &state->cabac.ctx.transform_skip_model_luma;
    double trskip_bits = CTX_ENTROPY_FBITS(ctx, 1) - CTX_ENTROPY_FBITS(ctx, 0);
    ctx = &state->cabac.ctx.transform_skip_model_chroma;
    trskip_bits += 2.0 * (CTX_ENTROPY_FBITS(ctx, 1) - CTX_ENTROPY_FBITS(ctx, 0));

    double sad_cost = TRSKIP_RATIO * sad_func(pred, orig_block) + state->global->cur_lambda_cost_sqrt * trskip_bits;
    if (sad_cost < satd_cost) {
      return sad_cost;
    }
  }
  return satd_cost;*/
}
#endif


/**
* \brief Perform search for best intra transform split configuration.
*
* This function does a recursive search for the best intra transform split
* configuration for a given intra prediction mode.
*
* \return RD cost of best transform split configuration. Splits in lcu->cu.
* \param depth  Current transform depth.
* \param max_depth  Depth to which TR split will be tried.
* \param intra_mode  Intra prediction mode.
* \param cost_treshold  RD cost at which search can be stopped.
*/
static double search_intra_trdepth(encoder_state_t * const state,
                                   int x_px, int y_px, int depth, int max_depth,
                                   int intra_mode, int cost_treshold,
                                   cu_info_t *const pred_cu,
                                   lcu_t *const lcu)
{
  assert(depth >= 0 && depth <= MAX_PU_DEPTH);

  const int width = LCU_WIDTH >> depth;
  const int width_c = width > TR_MIN_WIDTH ? width / 2 : width;

  const int offset = width / 2;
  const vector2d_t lcu_px = { x_px & 0x3f, y_px & 0x3f };
  cu_info_t *const tr_cu = &lcu->cu[LCU_CU_OFFSET + (lcu_px.x >> 3) + (lcu_px.y >> 3)*LCU_T_CU_WIDTH];

  const bool reconstruct_chroma = !(x_px & 4 || y_px & 4);

  struct {
    kvz_pixel y[TR_MAX_WIDTH*TR_MAX_WIDTH];
    kvz_pixel u[TR_MAX_WIDTH*TR_MAX_WIDTH];
    kvz_pixel v[TR_MAX_WIDTH*TR_MAX_WIDTH];
  } nosplit_pixels;
  cu_cbf_t nosplit_cbf = { .y = 0, .u = 0, .v = 0 };

  double split_cost = INT32_MAX;
  double nosplit_cost = INT32_MAX;

  if (depth > 0) {
    tr_cu->tr_depth = depth;
    pred_cu->tr_depth = depth;

    nosplit_cost = 0.0;

    cbf_clear(&pred_cu->cbf.y, depth + PU_INDEX(x_px / 4, y_px / 4));

    kvz_intra_recon_lcu_luma(state, x_px, y_px, depth, intra_mode, pred_cu, lcu);
    nosplit_cost += kvz_cu_rd_cost_luma(state, lcu_px.x, lcu_px.y, depth, pred_cu, lcu);

    if (reconstruct_chroma) {
      cbf_clear(&pred_cu->cbf.u, depth);
      cbf_clear(&pred_cu->cbf.v, depth);

      kvz_intra_recon_lcu_chroma(state, x_px, y_px, depth, intra_mode, pred_cu, lcu);
      nosplit_cost += kvz_cu_rd_cost_chroma(state, lcu_px.x, lcu_px.y, depth, pred_cu, lcu);
    }

    // Early stop codition for the recursive search.
    // If the cost of any 1/4th of the transform is already larger than the
    // whole transform, assume that splitting further is a bad idea.
    if (nosplit_cost >= cost_treshold) {
      return nosplit_cost;
    }

    nosplit_cbf = pred_cu->cbf;

    kvz_pixels_blit(lcu->rec.y, nosplit_pixels.y, width, width, LCU_WIDTH, width);
    if (reconstruct_chroma) {
      kvz_pixels_blit(lcu->rec.u, nosplit_pixels.u, width_c, width_c, LCU_WIDTH_C, width_c);
      kvz_pixels_blit(lcu->rec.v, nosplit_pixels.v, width_c, width_c, LCU_WIDTH_C, width_c);
    }
  }

  // Recurse further if all of the following:
  // - Current depth is less than maximum depth of the search (max_depth).
  //   - Maximum transform hierarchy depth is constrained by clipping
  //     max_depth.
  // - Min transform size hasn't been reached (MAX_PU_DEPTH).
  if (depth < max_depth && depth < MAX_PU_DEPTH) {
    split_cost = 3 * state->global->cur_lambda_cost;

    split_cost += search_intra_trdepth(state, x_px, y_px, depth + 1, max_depth, intra_mode, nosplit_cost, pred_cu, lcu);
    if (split_cost < nosplit_cost) {
      split_cost += search_intra_trdepth(state, x_px + offset, y_px, depth + 1, max_depth, intra_mode, nosplit_cost, pred_cu, lcu);
    }
    if (split_cost < nosplit_cost) {
      split_cost += search_intra_trdepth(state, x_px, y_px + offset, depth + 1, max_depth, intra_mode, nosplit_cost, pred_cu, lcu);
    }
    if (split_cost < nosplit_cost) {
      split_cost += search_intra_trdepth(state, x_px + offset, y_px + offset, depth + 1, max_depth, intra_mode, nosplit_cost, pred_cu, lcu);
    }

    double tr_split_bit = 0.0;
    double cbf_bits = 0.0;

    // Add bits for split_transform_flag = 1, because transform depth search bypasses
    // the normal recursion in the cost functions.
    if (depth >= 1 && depth <= 3) {
      const cabac_ctx_t *ctx = &(state->cabac.ctx.trans_subdiv_model[5 - (6 - depth)]);
      tr_split_bit += CTX_ENTROPY_FBITS(ctx, 1);
    }

    // Add cost of cbf chroma bits on transform tree.
    // All cbf bits are accumulated to pred_cu.cbf and cbf_is_set returns true
    // if cbf is set at any level >= depth, so cbf chroma is assumed to be 0
    // if this and any previous transform block has no chroma coefficients.
    // When searching the first block we don't actually know the real values,
    // so this will code cbf as 0 and not code the cbf at all for descendants.
    {
      const uint8_t tr_depth = depth - pred_cu->depth;

      const cabac_ctx_t *ctx = &(state->cabac.ctx.qt_cbf_model_chroma[tr_depth]);
      if (tr_depth == 0 || cbf_is_set(pred_cu->cbf.u, depth - 1)) {
        cbf_bits += CTX_ENTROPY_FBITS(ctx, cbf_is_set(pred_cu->cbf.u, depth));
      }
      if (tr_depth == 0 || cbf_is_set(pred_cu->cbf.v, depth - 1)) {
        cbf_bits += CTX_ENTROPY_FBITS(ctx, cbf_is_set(pred_cu->cbf.v, depth));
      }
    }

    double bits = tr_split_bit + cbf_bits;
    split_cost += bits * state->global->cur_lambda_cost;
  } else {
    assert(width <= TR_MAX_WIDTH);
  }

  if (depth == 0 || split_cost < nosplit_cost) {
    return split_cost;
  } else {
    kvz_lcu_set_trdepth(lcu, x_px, y_px, depth, depth);

    pred_cu->cbf = nosplit_cbf;

    // We only restore the pixel data and not coefficients or cbf data.
    // The only thing we really need are the border pixels.kvz_intra_get_dir_luma_predictor
    kvz_pixels_blit(nosplit_pixels.y, lcu->rec.y, width, width, width, LCU_WIDTH);
    if (reconstruct_chroma) {
      kvz_pixels_blit(nosplit_pixels.u, lcu->rec.u, width_c, width_c, width_c, LCU_WIDTH_C);
      kvz_pixels_blit(nosplit_pixels.v, lcu->rec.v, width_c, width_c, width_c, LCU_WIDTH_C);
    }

    return nosplit_cost;
  }
}


void search_intra_chroma_rough(encoder_state_t * const state,
                                      int x_px, int y_px, int depth,
                                      const kvz_pixel *orig_u, const kvz_pixel *orig_v, int16_t origstride,
                                      kvz_intra_references *refs_u, kvz_intra_references *refs_v,
                                      int8_t luma_mode,
                                      int8_t modes[5], double costs[5])
{
  assert(!(x_px & 4 || y_px & 4));

  const unsigned width = MAX(LCU_WIDTH_C >> depth, TR_MIN_WIDTH);
  const int_fast8_t log2_width_c = MAX(LOG2_LCU_WIDTH - (depth + 1), 2);

  for (int i = 0; i < 5; ++i) {
    costs[i] = 0;
  }

  cost_pixel_nxn_func *const satd_func = kvz_pixels_get_satd_func(width);
  //cost_pixel_nxn_func *const sad_func = kvz_pixels_get_sad_func(width);

  kvz_pixel _pred[32 * 32 + SIMD_ALIGNMENT];
  kvz_pixel *pred = (kvz_pixel*)ALIGNED_POINTER(_pred, SIMD_ALIGNMENT);

  kvz_pixel _orig_block[32 * 32 + SIMD_ALIGNMENT];
  kvz_pixel *orig_block = (kvz_pixel*)ALIGNED_POINTER(_orig_block, SIMD_ALIGNMENT);

  kvz_pixels_blit(orig_u, orig_block, width, width, origstride, width);
  for (int i = 0; i < 5; ++i) {
    if (modes[i] == luma_mode) continue;
    kvz_intra_predict(refs_u, log2_width_c, modes[i], COLOR_U, pred);
    //costs[i] += get_cost(encoder_state, pred, orig_block, satd_func, sad_func, width);
    costs[i] += satd_func(pred, orig_block);
  }

  kvz_pixels_blit(orig_v, orig_block, width, width, origstride, width);
  for (int i = 0; i < 5; ++i) {
    if (modes[i] == luma_mode) continue;
    kvz_intra_predict(refs_v, log2_width_c, modes[i], COLOR_V, pred);
    //costs[i] += get_cost(encoder_state, pred, orig_block, satd_func, sad_func, width);
    costs[i] += satd_func(pred, orig_block);
  }

  sort_modes(modes, costs, 5);
}


/**
 * \brief  Order the intra prediction modes according to a fast criteria.
 *
 * This function uses SATD to order the intra prediction modes. For 4x4 modes
 * SAD might be used instead, if the cost given by SAD is much better than the
 * one given by SATD, to take into account that 4x4 modes can be coded with
 * transform skip.
 *
 * The modes are searched using halving search and the total number of modes
 * that are tried is dependent on size of the predicted block. More modes
 * are tried for smaller blocks.
 *
 * \param orig  Pointer to the top-left corner of current CU in the picture
 *     being encoded.
 * \param orig_stride  Stride of param orig.
 * \param rec  Pointer to the top-left corner of current CU in the picture
 *     being encoded.
 * \param rec_stride  Stride of param rec.
 * \param width  Width of the prediction block.
 * \param intra_preds  Array of the 3 predicted intra modes.
 *
 * \param[out] modes  The modes ordered according to their RD costs, from best
 *     to worst. The number of modes and costs output is given by parameter
 *     modes_to_check.
 * \param[out] costs  The RD costs of corresponding modes in param modes.
 *
 * \return  Number of prediction modes in param modes.
 */

#if !(defined(IP_ACC) || defined(EXPLORATION_HW)) || defined(IP_DEBUG) || defined(EXPLORATION_SW) || defined(UNTIMED_SIMULATION)
int8_t search_intra_rough(encoder_state_t * const state, 
                                 kvz_pixel *orig, int32_t origstride,
                                 kvz_intra_references *refs,
                                 int log2_width, int8_t *intra_preds,
                                 int8_t modes[35], double costs[35])
{
  assert(log2_width >= 2 && log2_width <= 5);
  int_fast8_t width = 1 << log2_width;
  cost_pixel_nxn_func *satd_func = kvz_pixels_get_satd_func(width);
  cost_pixel_nxn_func *sad_func = kvz_pixels_get_sad_func(width);

  // Temporary block arrays
  kvz_pixel _pred[32 * 32 + SIMD_ALIGNMENT];
  kvz_pixel *pred = (kvz_pixel*)ALIGNED_POINTER(_pred, SIMD_ALIGNMENT);
  
  kvz_pixel _orig_block[32 * 32 + SIMD_ALIGNMENT];
  kvz_pixel *orig_block = (kvz_pixel*)ALIGNED_POINTER(_orig_block, SIMD_ALIGNMENT);
  
#if defined(EXPLORATION_SW)
  search_intra_rough_delay((int)(width*delay_c*search_intra_rough_percentage_c));
#endif
  // Store original block for SAD computation
  kvz_pixels_blit(orig, orig_block, width, width, origstride, width);
  
  int8_t modes_selected = 0;
  unsigned min_cost = UINT_MAX;
  unsigned max_cost = 0;
  
  // Initial offset decides how many modes are tried before moving on to the
  // recursive search.
  int offset = 1;
  // Calculate SAD for evenly spaced modes to select the starting point for 
  // the recursive search.
  
  for (int mode = 0; mode <= 34; mode += offset) {
    kvz_intra_predict(refs, log2_width, mode, COLOR_Y, pred);

    costs[modes_selected] = get_cost(state, pred, orig_block, satd_func, sad_func, width);
    modes[modes_selected] = mode;

    min_cost = MIN(min_cost, costs[modes_selected]);
    max_cost = MAX(max_cost, costs[modes_selected]);

    ++modes_selected;
  }

  // Add prediction mode coding cost as the last thing. We don't want this
  // affecting the halving search.
  int lambda_cost = (int)(state->global->cur_lambda_cost_sqrt + 0.5);
  for (int mode_i = 0; mode_i < modes_selected; ++mode_i) {
    costs[mode_i] += lambda_cost * kvz_luma_mode_bits(state, modes[mode_i], intra_preds);
  }

  return modes_selected;
}

#endif

/**
 * \brief  Find best intra mode out of the ones listed in parameter modes.
 *
 * This function perform intra search by doing full quantization,
 * reconstruction and CABAC coding of coefficients. It is very slow
 * but results in better RD quality than using just the rough search.
 *
 * \param x_px  Luma picture coordinate.
 * \param y_px  Luma picture coordinate.
 * \param orig  Pointer to the top-left corner of current CU in the picture
 *     being encoded.
 * \param orig_stride  Stride of param orig.
 * \param rec  Pointer to the top-left corner of current CU in the picture
 *     being encoded.
 * \param rec_stride  Stride of param rec.
 * \param intra_preds  Array of the 3 predicted intra modes.
 * \param modes_to_check  How many of the modes in param modes are checked.
 * \param[in] modes  The intra prediction modes that are to be checked.
 * 
 * \param[out] modes  The modes ordered according to their RD costs, from best
 *     to worst. The number of modes and costs output is given by parameter
 *     modes_to_check.
 * \param[out] costs  The RD costs of corresponding modes in param modes.
 * \param[out] lcu  If transform split searching is used, the transform split
 *     information for the best mode is saved in lcu.cu structure.
 */
static int8_t search_intra_rdo(encoder_state_t * const state, 
                             int x_px, int y_px, int depth,
                             kvz_pixel *orig, int32_t origstride,
                             int8_t *intra_preds,
                             int modes_to_check,
                             int8_t modes[35], double costs[35],
                             lcu_t *lcu)
{
  const int tr_depth = CLIP(1, MAX_PU_DEPTH, depth + state->encoder_control->tr_depth_intra);
  const int width = LCU_WIDTH >> depth;

  kvz_pixel orig_block[LCU_WIDTH * LCU_WIDTH + 1];

  kvz_pixels_blit(orig, orig_block, width, width, origstride, width);

  // Check that the predicted modes are in the RDO mode list
  if (modes_to_check < 35) {
    for (int pred_mode = 0; pred_mode < 3; pred_mode++) {
      int mode_found = 0;
      for (int rdo_mode = 0; rdo_mode < modes_to_check; rdo_mode++) {
        if (intra_preds[pred_mode] == modes[rdo_mode]) {
          mode_found = 1;
          break;
        }
      }
      // Add this prediction mode to RDO checking
      if (!mode_found) {
        modes[modes_to_check] = intra_preds[pred_mode];
        modes_to_check++;
      }
    }
  }

  for(int rdo_mode = 0; rdo_mode < modes_to_check; rdo_mode ++) {
    int rdo_bitcost = kvz_luma_mode_bits(state, modes[rdo_mode], intra_preds);
    costs[rdo_mode] = rdo_bitcost * (int)(state->global->cur_lambda_cost + 0.5);

    // Perform transform split search and save mode RD cost for the best one.
    cu_info_t pred_cu;
    pred_cu.depth = depth;
    pred_cu.type = CU_INTRA;
    pred_cu.part_size = ((depth == MAX_PU_DEPTH) ? SIZE_NxN : SIZE_2Nx2N);
    pred_cu.intra[0].mode = modes[rdo_mode];
    pred_cu.intra[1].mode = modes[rdo_mode];
    pred_cu.intra[2].mode = modes[rdo_mode];
    pred_cu.intra[3].mode = modes[rdo_mode];
    pred_cu.intra[0].mode_chroma = modes[rdo_mode];
    FILL(pred_cu.cbf, 0);

    // Reset transform split data in lcu.cu for this area.
    kvz_lcu_set_trdepth(lcu, x_px, y_px, depth, depth);

    double mode_cost = search_intra_trdepth(state, x_px, y_px, depth, tr_depth, modes[rdo_mode], MAX_INT, &pred_cu, lcu);
    costs[rdo_mode] += mode_cost;
  }

  // The best transform split hierarchy is not saved anywhere, so to get the
  // transform split hierarchy the search has to be performed again with the
  // best mode.
  if (tr_depth != depth) {
    cu_info_t pred_cu;
    pred_cu.depth = depth;
    pred_cu.type = CU_INTRA;
    pred_cu.part_size = ((depth == MAX_PU_DEPTH) ? SIZE_NxN : SIZE_2Nx2N);
    pred_cu.intra[0].mode = modes[0];
    pred_cu.intra[1].mode = modes[0];
    pred_cu.intra[2].mode = modes[0];
    pred_cu.intra[3].mode = modes[0];
    pred_cu.intra[0].mode_chroma = modes[0];
    FILL(pred_cu.cbf, 0);
    search_intra_trdepth(state, x_px, y_px, depth, tr_depth, modes[0], MAX_INT, &pred_cu, lcu);
  }

  return modes_to_check;
}


double kvz_luma_mode_bits(const encoder_state_t *state, int8_t luma_mode, const int8_t *intra_preds)
{
  double mode_bits;

  bool mode_in_preds = false;
  for (int i = 0; i < 3; ++i) {
    if (luma_mode == intra_preds[i]) {
      mode_in_preds = true;
    }
  }

  const cabac_ctx_t *ctx = &(state->cabac.ctx.intra_mode_model);
  mode_bits = CTX_ENTROPY_FBITS(ctx, mode_in_preds);

  if (mode_in_preds) {
    mode_bits += ((luma_mode == intra_preds[0]) ? 1 : 2);
  } else {
    mode_bits += 5;
  }

  return mode_bits;
}


double kvz_chroma_mode_bits(const encoder_state_t *state, int8_t chroma_mode, int8_t luma_mode)
{
  const cabac_ctx_t *ctx = &(state->cabac.ctx.chroma_pred_model[0]);
  double mode_bits;
  if (chroma_mode == luma_mode) {
    mode_bits = CTX_ENTROPY_FBITS(ctx, 0);
  } else {
    mode_bits = 2.0 + CTX_ENTROPY_FBITS(ctx, 1);
  }

  return mode_bits;
}


int8_t kvz_search_intra_chroma_rdo(encoder_state_t * const state,
                                  int x_px, int y_px, int depth,
                                  int8_t intra_mode,
                                  int8_t modes[5], int8_t num_modes,
                                  lcu_t *const lcu)
{
  const bool reconstruct_chroma = !(x_px & 4 || y_px & 4);

  if (reconstruct_chroma) {
    const vector2d_t lcu_px = { x_px & 0x3f, y_px & 0x3f };
    cu_info_t *const tr_cu = &lcu->cu[LCU_CU_OFFSET + (lcu_px.x >> 3) + (lcu_px.y >> 3)*LCU_T_CU_WIDTH];

    struct {
      double cost;
      int8_t mode;
    } chroma, best_chroma;

    best_chroma.mode = 0;
    best_chroma.cost = MAX_INT;

    for (int8_t chroma_mode_i = 0; chroma_mode_i < num_modes; ++chroma_mode_i) {
      chroma.mode = modes[chroma_mode_i];

      kvz_intra_recon_lcu_chroma(state, x_px, y_px, depth, chroma.mode, NULL, lcu);
      chroma.cost = kvz_cu_rd_cost_chroma(state, lcu_px.x, lcu_px.y, depth, tr_cu, lcu);

      double mode_bits = kvz_chroma_mode_bits(state, chroma.mode, intra_mode);
      chroma.cost += mode_bits * state->global->cur_lambda_cost;

      if (chroma.cost < best_chroma.cost) {
        best_chroma = chroma;
      }
    }

    return best_chroma.mode;
  }

  return 100;
}


int8_t kvz_search_cu_intra_chroma(encoder_state_t * const state,
                              const int x_px, const int y_px,
                              const int depth, lcu_t *lcu)
{
  const vector2d_t lcu_px = { x_px & 0x3f, y_px & 0x3f };
  const vector2d_t lcu_cu = { lcu_px.x >> 3, lcu_px.y >> 3 };
  const int cu_index = LCU_CU_OFFSET + lcu_cu.x + lcu_cu.y * LCU_T_CU_WIDTH;

  cu_info_t *cur_cu = &lcu->cu[cu_index];
  int8_t intra_mode = cur_cu->intra[PU_INDEX(x_px >> 2, y_px >> 2)].mode;

  double costs[5];
  int8_t modes[5] = { 0, 26, 10, 1, 34 };
  if (intra_mode != 0 && intra_mode != 26 && intra_mode != 10 && intra_mode != 1) {
    modes[4] = intra_mode;
  }

  // The number of modes to select for slower chroma search. Luma mode
  // is always one of the modes, so 2 means the final decision is made
  // between luma mode and one other mode that looks the best
  // according to search_intra_chroma_rough.
  const int8_t modes_in_depth[5] = { 1, 1, 1, 1, 2 };
  int num_modes = modes_in_depth[depth];

  if (state->encoder_control->rdo == 3) {
    num_modes = 5;
  }

  // Don't do rough mode search if all modes are selected.
  // FIXME: It might make more sense to only disable rough search if
  // num_modes is 0.is 0.
  if (num_modes != 1 && num_modes != 5) {
    const int_fast8_t log2_width_c = MAX(LOG2_LCU_WIDTH - depth - 1, 2);
    const vector2d_t pic_px = { state->tile->frame->width, state->tile->frame->height };
    const vector2d_t luma_px = { x_px, y_px };

    kvz_intra_references refs_u;
    kvz_intra_build_reference(log2_width_c, COLOR_U, &luma_px, &pic_px, lcu, &refs_u);

    kvz_intra_references refs_v;
    kvz_intra_build_reference(log2_width_c, COLOR_V, &luma_px, &pic_px, lcu, &refs_v);

    vector2d_t lcu_cpx = { lcu_px.x / 2, lcu_px.y / 2 };
    kvz_pixel *ref_u = &lcu->ref.u[lcu_cpx.x + lcu_cpx.y * LCU_WIDTH_C];
    kvz_pixel *ref_v = &lcu->ref.v[lcu_cpx.x + lcu_cpx.y * LCU_WIDTH_C];

    search_intra_chroma_rough(state, x_px, y_px, depth,
                              ref_u, ref_v, LCU_WIDTH_C,
                              &refs_u, &refs_v,
                              intra_mode, modes, costs);
  }

  int8_t intra_mode_chroma = intra_mode;
  if (num_modes > 1) {
    intra_mode_chroma = kvz_search_intra_chroma_rdo(state, x_px, y_px, depth, intra_mode, modes, num_modes, lcu);
  }

  return intra_mode_chroma;
}


/**
 * Update lcu to have best modes at this depth.
 * \return Cost of best mode.
 */
double kvz_search_cu_intra(encoder_state_t * const state,
                           const int x_px, const int y_px,
                           const int depth, lcu_t *lcu)
{
    const vector2d_t lcu_px = { x_px & 0x3f, y_px & 0x3f };
    const vector2d_t lcu_cu = { lcu_px.x >> 3, lcu_px.y >> 3 };
    const int8_t cu_width = (LCU_WIDTH >> (depth));
    const int cu_index = LCU_CU_OFFSET + lcu_cu.x + lcu_cu.y * LCU_T_CU_WIDTH;
    const int_fast8_t log2_width = LOG2_LCU_WIDTH - depth;
    
#if defined(EXPLORATION_HW) || defined(EXPLORATION_SW)
	search_delay((int)(cu_width*delay_c*rest_percentage_c));
#endif
	
    cu_info_t *cur_cu = &lcu->cu[cu_index];
    
    kvz_intra_references refs;
    
    int8_t candidate_modes[3];
    
    cu_info_t *left_cu = 0;
    cu_info_t *above_cu = 0;

    // Select left and top CUs if they are available.
    // Top CU is not available across LCU boundary.
    if ((x_px >> 3) > 0) {
	left_cu = &lcu->cu[cu_index - 1];
    }
    if ((y_px >> 3) > 0 && lcu_cu.y != 0) {
	above_cu = &lcu->cu[cu_index - LCU_T_CU_WIDTH];
    }
    kvz_intra_get_dir_luma_predictor(x_px, y_px, candidate_modes, cur_cu, left_cu, above_cu);
    
    if (depth > 0) {
	const vector2d_t luma_px = { x_px, y_px };
	const vector2d_t pic_px = { state->tile->frame->width, state->tile->frame->height };
	kvz_intra_build_reference(log2_width, COLOR_Y, &luma_px, &pic_px, lcu, &refs);
    }
#if defined(IP_ACC) || defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
	// Unfiltered reference pixels are sent here

	// Calling send_unfiltered function implemented in search_intra_supplement.c
	// implementation differs depending on the system design
	send_unfiltered(&refs,cu_width);
#endif
    int8_t modes[35];
    double costs[35];
#if defined(IP_DEBUG) || defined(SIMULATION_UNTIMED)
	// Variables for saving the simulated hw or actual hw results for debug
    int8_t hw_mode = 0;
    double hw_cost = 0;
#endif

    // Find best intra mode for 2Nx2N.
    kvz_pixel *ref_pixels = &lcu->ref.y[lcu_px.x + lcu_px.y * LCU_WIDTH];
    unsigned pu_index = PU_INDEX(x_px >> 2, y_px >> 2);
    
    int8_t number_of_modes;
    bool skip_rough_search = (depth == 0 || state->encoder_control->rdo >= 3);
    if (!skip_rough_search) {
#if defined(IP_ACC) || defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
	// This function is used to calculate the best intra prediction mode
	// with simulated hw or on actual hw

	// Calling search_intra_rough_hw function implemented in search_intra_supplement.c
	// implementation differs depending on the system design
	number_of_modes = search_intra_rough_hw(state,
					    ref_pixels, LCU_WIDTH,
						&refs,
						log2_width, candidate_modes,
						modes, costs,lcu_px.x,lcu_px.y
#ifdef IP_ACC
						// Threads are supported with the actual hw
						,lcu->thread);
#else
						// Threads not supported in hw simulation
						,0);
#endif

#if defined(IP_DEBUG) || defined(SIMULATION_UNTIMED)
	// Save simulated hw results or actual hw results for debug
	hw_mode = modes[0];
	hw_cost = costs[0];
#endif
#endif
#if !(defined(IP_ACC) || defined(EXPLORATION_HW)) || defined(IP_DEBUG) || defined(SIMULATION_UNTIMED) || defined(EXPLORATION_SW)
	// SW implementation of intra prediction called in pure SW and debug
	number_of_modes = search_intra_rough(state,
					     ref_pixels, LCU_WIDTH,
					     &refs,
					     log2_width, candidate_modes,
					     modes, costs);
#endif
    } else {
	number_of_modes = 35;
	for (int i = 0; i < number_of_modes; ++i) {
	    modes[i] = i;
	    costs[i] = MAX_INT;
	}
    }
    
    // Set transform depth to current depth, meaning no transform splits.
    kvz_lcu_set_trdepth(lcu, x_px, y_px, depth, depth);
    
    // Refine results with slower search or get some results if rough search was skipped.
    if (state->encoder_control->rdo >= 2 || skip_rough_search) {
	int number_of_modes_to_search;
	if (state->encoder_control->rdo == 3) {
	    number_of_modes_to_search = 35;
	} else if (state->encoder_control->rdo == 2) {
	    number_of_modes_to_search = (cu_width <= 8) ? 8 : 3;
	} else {
	    // Check only the predicted modes.
	    number_of_modes_to_search = 0;
	}
	int num_modes_to_check = MIN(number_of_modes, number_of_modes_to_search);
	sort_modes(modes, costs, number_of_modes);
	number_of_modes = search_intra_rdo(state,
					   x_px, y_px, depth,
					   ref_pixels, LCU_WIDTH,
					   candidate_modes,
					   num_modes_to_check,
					   modes, costs, lcu);
    }
#if (defined(IP_ACC) || defined(EXPLORATION_HW)) && !defined(IP_DEBUG)
	// Accelerated, no debug, return values
    cur_cu->intra[pu_index].mode = modes[0];
    return costs[0];
#else
	// Pure SW + debug best mode selection
	uint8_t best_mode_i = select_best_mode_index(modes, costs, number_of_modes);
#if defined(IP_DEBUG) || defined(EXPLORATION_SW) || !(defined(IP_ACC) && defined(SIMULATION_UNTIMED) && defined(EXPLORATION_HW))
	// With debug result always correct
    cur_cu->intra[pu_index].mode = modes[best_mode_i];
#else
	// Without debug result determined by hw simulation
	cur_cu->intra[pu_index].mode = hw_mode;
#endif
#if defined(IP_DEBUG) || defined(SIMULATION_UNTIMED)
	// Check that simulation matches pure SW
    if((hw_mode != modes[best_mode_i]) || ((hw_mode == modes[best_mode_i]) && ((int)hw_cost != (int)costs[best_mode_i])))
    {
		#ifdef SIMULATION_UNTIMED
		simulation_error();
		#endif
		#ifdef IP_DEBUG
		printf("ERR: ");
		#ifdef IP_ACC
			printf("Thread %d, ",lcu->thread);
		#endif
		printf("Width %2d, X %2d, Y %2d : SW mode %2d SW cost %6d : HW mode %2d HW cost %6d\n",cu_width,lcu_px.x,lcu_px.y, modes[best_mode_i], (int)costs[best_mode_i], hw_mode, (int)hw_cost);
		#endif
	
	// BUNCH OF HELPFUL DEBUG CODES COMMENTED OUT
	/*const cabac_ctx_t *ctx = &(state->cabac.ctx.intra_mode_model);
	
	printf("lambda %d, uc_state %d, candidate_modes %d, %d, %d\n",
	       (uint32_t)(state->global->cur_lambda_cost_sqrt + 0.5),ctx->uc_state,candidate_modes[0],candidate_modes[1],candidate_modes[2]);
	*/
	/*{
	    int a,b;
	    printf("LCU: \n");
	    for(a = 0; a < LCU_WIDTH;a++)
	    {
			for(b = 0; b < LCU_WIDTH;b++)
			{
				int value = lcu->ref.y[a*LCU_WIDTH+b];
				#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
				cout << std::hex << "0x" << value << ", ";
				#else
				printf("0x%x, ",value);
				#endif
			}
			#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
			cout << endl;
			#else
			printf("\n");
			#endif
	    }
	}*/
	
	//{
	    //uint8_t pred[1024];
	    /*int a,b;
	    int width = 1<<log2_width;
	    
		#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
			cout  << "ref_top: " << endl;
		#else
			printf("ref_top:\n");
		#endif
	    for(a = 0; a < width*2+1;a++)
	    {
			int value = refs.ref.top[a];
			
			#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
			cout << std::hex << "0x" << value << ", ";
			#else
			printf("0x%x, ",refs.ref.top[a]);
			#endif
	    }
	    #if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
			cout  << "ref_left: " << endl;
		#else
			printf("ref_left:\n");
		#endif
	    for(b = 0; b < width*2+1;b++)
	    {
			int value = refs.ref.left[b];
			#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
			cout << std::hex << "0x" << value << ", ";
			#else
			printf("0x%x, ",refs.ref.left[b]);
			#endif
	    }
		cout << endl;*/
	   
	    /*kvz_intra_predict(&refs, log2_width, modes[best_mode_i], COLOR_Y, pred);
	    
		#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
		cout << endl << "pred: " << endl;
		#else
		printf("pred: ");
		#endif
	    for(a = 0; a < width;a++)
	    {
			for(b = 0; b < width;b++)
			{
				int value = pred[a*width+b];
				#if defined(SIMULATION_UNTIMED) || defined(EXPLORATION_HW)
				cout << std::hex << "0x" << value << ", ";
				#else
				printf("0x%x, ",pred[a*width+b]);
				#endif
			}
			cout << endl;
	    }*/
	//}
    }
// If IP_DEBUG_ALL defined prints all results gotten
#ifdef IP_DEBUG_ALL
    else
    {
		printf("     ");
		#ifdef IP_ACC
		printf("Thread %d, ",lcu->thread);
		#endif
		printf("Width %2d, X %2d, Y %2d : SW mode %2d SW cost %6d : HW mode %2d HW cost %6d\n",cu_width,lcu_px.x,lcu_px.y, modes[best_mode_i], (int)costs[best_mode_i], hw_mode, (int)hw_cost);
    }
#endif
// If CU_LIMIT defined, executes the encoder after determined number of LCUs
#ifdef CU_LIMIT
    {
	static int cu_limit = 0;
	if(cu_limit >= CU_LIMIT-1)
	{
	    exit(0);
	}
	cu_limit++;
    }
#endif
#endif
// Return the right value
#if defined(IP_DEBUG) || defined(EXPLORATION_SW) || !(defined(IP_ACC) && defined(SIMULATION_UNTIMED) && defined(EXPLORATION_HW))
    return costs[best_mode_i];
#else
	return hw_cost;
#endif
#endif
}
