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

#include "filter.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "config.h"
#include "bitstream.h"
#include "videoframe.h"
#include "cabac.h"
#include "transform.h"

//////////////////////////////////////////////////////////////////////////
// INITIALIZATIONS
uint8_t kvz_g_tc_table_8x8[54] =
{
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,
   1,  1,  1,  1,  1,  1,  1,  2,  2,  2,
   2,  3,  3,  3,  3,  4,  4,  4,  5,  5,
   6,  6,  7,  8,  9, 10, 11, 13, 14, 16,
  18, 20, 22, 24
};

uint8_t kvz_g_beta_table_8x8[52] =
{
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
   0,  0,  0,  0,  0,  0,  6,  7,  8,  9,
  10, 11, 12, 13, 14, 15, 16, 17, 18, 20,
  22, 24, 26, 28, 30, 32, 34, 36, 38, 40,
  42, 44, 46, 48, 50, 52, 54, 56, 58, 60,
  62, 64
};

int8_t kvz_g_luma_filter[4][8] =
{
  {  0, 0,   0, 64,  0,   0, 0,  0 },
  { -1, 4, -10, 58, 17,  -5, 1,  0 },
  { -1, 4, -11, 40, 40, -11, 4, -1 },
  {  0, 1,  -5, 17, 58, -10, 4, -1 }
};

int8_t kvz_g_chroma_filter[8][4] =
{
  {  0, 64,  0,  0 },
  { -2, 58, 10, -2 },
  { -4, 54, 16, -2 },
  { -6, 46, 28, -4 },
  { -4, 36, 36, -4 },
  { -4, 28, 46, -6 },
  { -2, 16, 54, -4 },
  { -2, 10, 58, -2 }
};

//////////////////////////////////////////////////////////////////////////
// FUNCTIONS

/**
 * \brief
 */
INLINE void kvz_filter_deblock_luma(const encoder_control_t * const encoder, kvz_pixel *src, int32_t offset,
                                int32_t tc, int8_t sw,
                                int8_t part_P_nofilter, int8_t part_Q_nofilter,
                                int32_t thr_cut,
                                int8_t filter_second_P, int8_t filter_second_Q)
{
  int32_t delta;

  int16_t m0 = src[-offset * 4];
  int16_t m1 = src[-offset * 3];
  int16_t m2 = src[-offset * 2];
  int16_t m3 = src[-offset];
  int16_t m4 = src[0];
  int16_t m5 = src[offset];
  int16_t m6 = src[offset * 2];
  int16_t m7 = src[offset * 3];

  if (sw) {
    src[-offset * 3] = CLIP(m1 - 2*tc, m1 + 2*tc, (2*m0 + 3*m1 +   m2 +   m3 +   m4 + 4) >> 3);
    src[-offset * 2] = CLIP(m2 - 2*tc, m2 + 2*tc, (  m1 +   m2 +   m3 +   m4        + 2) >> 2);
    src[-offset]     = CLIP(m3 - 2*tc, m3 + 2*tc, (  m1 + 2*m2 + 2*m3 + 2*m4 +   m5 + 4) >> 3);
    src[0]           = CLIP(m4 - 2*tc, m4 + 2*tc, (  m2 + 2*m3 + 2*m4 + 2*m5 +   m6 + 4) >> 3);
    src[offset]      = CLIP(m5 - 2*tc, m5 + 2*tc, (  m3 +   m4 +   m5 +   m6        + 2) >> 2);
    src[offset * 2]  = CLIP(m6 - 2*tc, m6 + 2*tc, (  m3 +   m4 +   m5 + 3*m6 + 2*m7 + 4) >> 3);
  } else {
    // Weak filter
    delta = (9*(m4 - m3) - 3*(m5 - m2) + 8) >> 4;

    if (abs(delta) < thr_cut) {
      int32_t tc2  = tc >> 1;
      delta        = CLIP(-tc, tc, delta);
      src[-offset] = CLIP(0, (1 << encoder->bitdepth) - 1, (m3 + delta));
      src[0]       = CLIP(0, (1 << encoder->bitdepth) - 1, (m4 - delta));

      if(filter_second_P) {
        int32_t delta1   = CLIP(-tc2, tc2, (((m1 + m3 + 1) >> 1) - m2 + delta) >> 1);
        src[-offset * 2] = CLIP(0, (1 << encoder->bitdepth) - 1, m2 + delta1);
      }
      if(filter_second_Q) {
        int32_t delta2 = CLIP(-tc2, tc2, (((m6 + m4 + 1) >> 1) - m5 - delta) >> 1);
        src[offset]    = CLIP(0, (1 << encoder->bitdepth) - 1, m5 + delta2);
      }
    }
  }

  if(part_P_nofilter) {
    src[-offset]     = (kvz_pixel)m3;
    src[-offset * 2] = (kvz_pixel)m2;
    src[-offset * 3] = (kvz_pixel)m1;
  }
  if(part_Q_nofilter) {
    src[0]          = (kvz_pixel)m4;
    src[offset]     = (kvz_pixel)m5;
    src[offset * 2] = (kvz_pixel)m6;
  }
}

/**
 * \brief
 */
INLINE void kvz_filter_deblock_chroma(const encoder_control_t * const encoder, kvz_pixel *src, int32_t offset, int32_t tc,
                                  int8_t part_P_nofilter, int8_t part_Q_nofilter)
{
  int32_t delta;
  int16_t m2 = src[-offset * 2];
  int16_t m3 = src[-offset];
  int16_t m4 = src[0];
  int16_t m5 = src[offset];

  delta = CLIP(-tc,tc, (((m4 - m3) << 2) + m2 - m5 + 4 ) >> 3);
  if(!part_P_nofilter) {
    src[-offset] = CLIP(0, (1 << encoder->bitdepth) - 1, m3 + delta);
  }
  if(!part_Q_nofilter) {
    src[0] = CLIP(0, (1 << encoder->bitdepth) - 1, m4 - delta);
  }
}

/**
 * \brief
 */
void kvz_filter_deblock_edge_luma(encoder_state_t * const state,
                              int32_t xpos, int32_t ypos,
                              int8_t depth, int8_t dir)
{
  videoframe_t * const frame = state->tile->frame;
  const encoder_control_t * const encoder = state->encoder_control;
  
  cu_info_t *cu_q = kvz_videoframe_get_cu(frame, xpos >> MIN_SIZE, ypos >> MIN_SIZE);

  {
    // Return if called with a coordinate which is not at CU or TU boundary.
    // TODO: Add handling for asymmetric inter CU boundaries which do not coincide
    // with transform boundaries.
    const int tu_width = LCU_WIDTH >> cu_q->tr_depth;
    if (dir == EDGE_HOR && (ypos & (tu_width - 1))) return;
    if (dir == EDGE_VER && (xpos & (tu_width - 1))) return;
  }

  {
    int32_t stride = frame->rec->stride;
    int32_t offset = stride;
    int32_t beta_offset_div2 = encoder->beta_offset_div2;
    int32_t tc_offset_div2   = encoder->tc_offset_div2;
    // TODO: support 10+bits
    kvz_pixel *orig_src = &frame->rec->y[xpos + ypos*stride];
    kvz_pixel *src = orig_src;
    int32_t step = 1;
    cu_info_t *cu_p = NULL;
    int16_t x_cu = xpos>>MIN_SIZE,y_cu = ypos>>MIN_SIZE;
    int8_t strength = 0;

    int32_t qp              = state->global->QP;
    int32_t bitdepth_scale  = 1 << (encoder->bitdepth - 8);
    int32_t b_index         = CLIP(0, 51, qp + (beta_offset_div2 << 1));
    int32_t beta            = kvz_g_beta_table_8x8[b_index] * bitdepth_scale;
    int32_t side_threshold  = (beta + (beta >>1 )) >> 3;
    uint32_t blocks_in_part = (LCU_WIDTH >> depth) / 4;
    uint32_t block_idx;
    int32_t tc_index,tc,thr_cut;

    if (dir == EDGE_VER) {
      offset = 1;
      step = stride;
    }

    // TODO: add CU based QP calculation

    // For each 4-pixel part in the edge
    for (block_idx = 0; block_idx < blocks_in_part; ++block_idx) {
      int32_t dp0, dq0, dp3, dq3, d0, d3, dp, dq, d;

      {
        vector2d_t px = {
          (dir == EDGE_HOR ? (int8_t)(xpos + block_idx * 4) : (int8_t)xpos),
          (dir == EDGE_VER ? (int8_t)(ypos + block_idx * 4) : (int8_t)ypos)
        };

        // Don't deblock the last 4x4 block of the LCU. This will be deblocked
        // when processing the next LCU.
        if (block_idx > 0 && dir == EDGE_HOR && (px.x + 4) % 64 == 0 && (px.x + 4 != frame->width)) {
          continue;
        }

        // CU in the side we are filtering, update every 8-pixels
        cu_p = kvz_videoframe_get_cu(frame, x_cu - (dir == EDGE_VER) + (dir == EDGE_HOR ? block_idx>>1 : 0), y_cu - (dir == EDGE_HOR) + (dir == EDGE_VER ? block_idx>>1 : 0));

        // Filter strength
        strength = 0;
        if(cu_q->type == CU_INTRA || cu_p->type == CU_INTRA) {
          strength = 2;
        } else if(cbf_is_set(cu_q->cbf.y, cu_q->tr_depth) || cbf_is_set(cu_p->cbf.y, cu_p->tr_depth)) {
          // Non-zero residual/coeffs and transform boundary
          // Neither CU is intra so tr_depth <= MAX_DEPTH.
          strength = 1;       
        } else if (cu_p->inter.mv_dir != 3 && cu_q->inter.mv_dir != 3 && ((abs(cu_q->inter.mv[cu_q->inter.mv_dir - 1][0] - cu_p->inter.mv[cu_p->inter.mv_dir - 1][0]) >= 4) || (abs(cu_q->inter.mv[cu_q->inter.mv_dir - 1][1] - cu_p->inter.mv[cu_p->inter.mv_dir - 1][1]) >= 4))) {
          // Absolute motion vector diff between blocks >= 1 (Integer pixel)
          strength = 1;
        } else if (cu_p->inter.mv_dir != 3 && cu_q->inter.mv_dir != 3 && cu_q->inter.mv_ref[cu_q->inter.mv_dir - 1] != cu_p->inter.mv_ref[cu_p->inter.mv_dir - 1]) {
          strength = 1;
        }
        
        // B-slice related checks
        if(!strength && state->global->slicetype == KVZ_SLICE_B) {

          // Zero all undefined motion vectors for easier usage
          if(!(cu_q->inter.mv_dir & 1)) {
            cu_q->inter.mv[0][0] = 0;
            cu_q->inter.mv[0][1] = 0;
          }
          if(!(cu_q->inter.mv_dir & 2)) {
            cu_q->inter.mv[1][0] = 0;
            cu_q->inter.mv[1][1] = 0;
          }

          if(!(cu_p->inter.mv_dir & 1)) {
            cu_p->inter.mv[0][0] = 0;
            cu_p->inter.mv[0][1] = 0;
          }
          if(!(cu_p->inter.mv_dir & 2)) {
            cu_p->inter.mv[1][0] = 0;
            cu_p->inter.mv[1][1] = 0;
          }
          const int refP0 = (cu_p->inter.mv_dir & 1) ? cu_p->inter.mv_ref[0] : -1;
          const int refP1 = (cu_p->inter.mv_dir & 2) ? cu_p->inter.mv_ref[1] : -1;
          const int refQ0 = (cu_q->inter.mv_dir & 1) ? cu_q->inter.mv_ref[0] : -1;
          const int refQ1 = (cu_q->inter.mv_dir & 2) ? cu_q->inter.mv_ref[1] : -1;
          const int16_t* mvQ0 = cu_q->inter.mv[0];
          const int16_t* mvQ1 = cu_q->inter.mv[1];

          const int16_t* mvP0 = cu_p->inter.mv[0];
          const int16_t* mvP1 = cu_p->inter.mv[1];

          if(( refP0 == refQ0 &&  refP1 == refQ1 ) || ( refP0 == refQ1 && refP1==refQ0 ))
          {
            // Different L0 & L1
            if ( refP0 != refP1 ) {          
              if ( refP0 == refQ0 ) {
                strength  = ((abs(mvQ0[0] - mvP0[0]) >= 4) ||
                             (abs(mvQ0[1] - mvP0[1]) >= 4) ||
                             (abs(mvQ1[0] - mvP1[0]) >= 4) ||
                             (abs(mvQ1[1] - mvP1[1]) >= 4)) ? 1 : 0;
              } else {
                strength  = ((abs(mvQ1[0] - mvP0[0]) >= 4) ||
                             (abs(mvQ1[1] - mvP0[1]) >= 4) ||
                             (abs(mvQ0[0] - mvP1[0]) >= 4) ||
                             (abs(mvQ0[1] - mvP1[1]) >= 4)) ? 1 : 0;
              }
            // Same L0 & L1
            } else {  
              strength  = ((abs(mvQ0[0] - mvP0[0]) >= 4) ||
                           (abs(mvQ0[1] - mvP0[1]) >= 4) ||
                           (abs(mvQ1[0] - mvP1[0]) >= 4) ||
                           (abs(mvQ1[1] - mvP1[1]) >= 4)) &&
                          ((abs(mvQ1[0] - mvP0[0]) >= 4) ||
                           (abs(mvQ1[1] - mvP0[1]) >= 4) ||
                           (abs(mvQ0[0] - mvP1[0]) >= 4) ||
                           (abs(mvQ0[1] - mvP1[1]) >= 4)) ? 1 : 0;
            }
          } else {
            strength = 1;
          }
        }

        tc_index        = CLIP(0, 51 + 2, (int32_t)(qp + 2*(strength - 1) + (tc_offset_div2 << 1)));
        tc              = kvz_g_tc_table_8x8[tc_index] * bitdepth_scale;
        thr_cut         = tc * 10;
      }
      if(!strength) continue;
      // Check conditions for filtering
      // TODO: Get rid of these inline defines.
      #define calc_DP(s,o) abs( (int16_t)s[-o*3] - (int16_t)2*s[-o*2] + (int16_t)s[-o] )
      #define calc_DQ(s,o) abs( (int16_t)s[0]    - (int16_t)2*s[o]    + (int16_t)s[o*2] )

      dp0 = calc_DP((src+step*(block_idx*4+0)), offset);
      dq0 = calc_DQ((src+step*(block_idx*4+0)), offset);
      dp3 = calc_DP((src+step*(block_idx*4+3)), offset);
      dq3 = calc_DQ((src+step*(block_idx*4+3)), offset);
      d0 = dp0 + dq0;
      d3 = dp3 + dq3;
      dp = dp0 + dp3;
      dq = dq0 + dq3;
      d  =  d0 + d3;

      #if ENABLE_PCM
      // TODO: add PCM deblocking
      #endif

      if (d < beta) {
        int8_t filter_P = (dp < side_threshold) ? 1 : 0;
        int8_t filter_Q = (dq < side_threshold) ? 1 : 0;

        // Strong filtering flag checking
        #define useStrongFiltering(o,d,s) ( ((abs(s[-o*4]-s[-o]) + abs(s[o*3]-s[0])) < (beta>>3)) && (d<(beta>>2)) && ( abs(s[-o]-s[0]) < ((tc*5+1)>>1)) )
        int8_t sw = useStrongFiltering(offset, 2*d0, (src+step*(block_idx*4+0))) &&
                    useStrongFiltering(offset, 2*d3, (src+step*(block_idx*4+3)));

        // Filter four rows/columns
        kvz_filter_deblock_luma(encoder, src + step * (4*block_idx + 0), offset, tc, sw, 0, 0, thr_cut, filter_P, filter_Q);
        kvz_filter_deblock_luma(encoder, src + step * (4*block_idx + 1), offset, tc, sw, 0, 0, thr_cut, filter_P, filter_Q);
        kvz_filter_deblock_luma(encoder, src + step * (4*block_idx + 2), offset, tc, sw, 0, 0, thr_cut, filter_P, filter_Q);
        kvz_filter_deblock_luma(encoder, src + step * (4*block_idx + 3), offset, tc, sw, 0, 0, thr_cut, filter_P, filter_Q);
      }
    }
  }
}

/**
 * \brief
 */
void kvz_filter_deblock_edge_chroma(encoder_state_t * const state,
                                int32_t x, int32_t y,
                                int8_t depth, int8_t dir)
{
  const encoder_control_t * const encoder = state->encoder_control;
  const videoframe_t * const frame = state->tile->frame;
  const cu_info_t *cu_q = kvz_videoframe_get_cu_const(frame, x >> (MIN_SIZE - 1), y >> (MIN_SIZE - 1));
  
  // Chroma edges that do not lay on a 8x8 grid are not deblocked.
  if (depth >= MAX_DEPTH) {
    if (dir == EDGE_HOR && (y & (8 - 1))) return;
    if (dir == EDGE_VER && (x & (8 - 1))) return;
  }

  {
    // Return if called with a coordinate which is not at CU or TU boundary.
    // TODO: Add handling for asymmetric inter CU boundaries which do not coincide
    // with transform boundaries.
    const int tu_width = (LCU_WIDTH / 2) >> cu_q->tr_depth;
    if (dir == EDGE_HOR && (y & (tu_width - 1))) return;
    if (dir == EDGE_VER && (x & (tu_width - 1))) return;
  }

  // For each subpart
  {
    int32_t stride = frame->rec->stride >> 1;
    int32_t tc_offset_div2 = encoder->tc_offset_div2;
    // TODO: support 10+bits
    kvz_pixel *src_u = &frame->rec->u[x + y*stride];
    kvz_pixel *src_v = &frame->rec->v[x + y*stride];
    // Init offset and step to EDGE_HOR
    int32_t offset = stride;
    int32_t step = 1;
    const cu_info_t *cu_p = NULL;
    int16_t x_cu = x>>(MIN_SIZE-1),y_cu = y>>(MIN_SIZE-1);
    int8_t strength = 2;

    int32_t QP             = kvz_g_chroma_scale[state->global->QP];
    int32_t bitdepth_scale = 1 << (encoder->bitdepth-8);
    int32_t TC_index       = CLIP(0, 51+2, (int32_t)(QP + 2*(strength-1) + (tc_offset_div2 << 1)));
    int32_t Tc             = kvz_g_tc_table_8x8[TC_index]*bitdepth_scale;

    // Special handling for depth 4. It's meaning is that we want to bypass
    // last block in LCU check in order to deblock just that block.
    uint32_t blocks_in_part= (LCU_WIDTH>>(depth == 4 ? depth : depth + 1)) / 4;
    uint32_t blk_idx;

    if(dir == EDGE_VER) {
      offset = 1;
      step = stride;
    }

    for (blk_idx = 0; blk_idx < blocks_in_part; ++blk_idx)
    {
      vector2d_t px = {
        (dir == EDGE_HOR ? (int8_t)(x + blk_idx * 4) : (int8_t)x),
        (dir == EDGE_VER ? (int8_t)(y + blk_idx * 4) : (int8_t)y)
      };
      cu_p = kvz_videoframe_get_cu_const(frame, x_cu - (dir == EDGE_VER) + (dir == EDGE_HOR ? blk_idx : 0), y_cu - (dir == EDGE_HOR) + (dir == EDGE_VER ? blk_idx : 0));

      // Don't deblock the last 4x4 block of the LCU. This will be deblocked
      // when processing the next LCU.
      if (depth != 4 && dir == EDGE_HOR && (px.x + 4) % 32 == 0 && (px.x + 4 != frame->width / 2)) {
        continue;
      }

      // Only filter when strenght == 2 (one of the blocks is intra coded)
      if (cu_q->type == CU_INTRA || cu_p->type == CU_INTRA) {
        // Chroma U
        kvz_filter_deblock_chroma(encoder, src_u + step * (4*blk_idx + 0), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_u + step * (4*blk_idx + 1), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_u + step * (4*blk_idx + 2), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_u + step * (4*blk_idx + 3), offset, Tc, 0, 0);
        // Chroma V
        kvz_filter_deblock_chroma(encoder, src_v + step * (4*blk_idx + 0), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_v + step * (4*blk_idx + 1), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_v + step * (4*blk_idx + 2), offset, Tc, 0, 0);
        kvz_filter_deblock_chroma(encoder, src_v + step * (4*blk_idx + 3), offset, Tc, 0, 0);
      }
    }
  }
}

/**
 * \brief function to split LCU into smaller CU blocks
 * \param encoder the encoder info structure
 * \param xCtb block x-position (as SCU)
 * \param yCtb block y-position (as SCU)
 * \param depth block depth
 * \param edge which edge we are filtering
 *
 * This function takes (SCU) block position as input and splits the block
 * until the coded block size has been achived. Calls luma and chroma filtering
 * functions for each coded CU size.
 */
void kvz_filter_deblock_cu(encoder_state_t * const state, int32_t x, int32_t y, int8_t depth, int32_t edge)
{
  const videoframe_t * const frame = state->tile->frame;
  const cu_info_t *cur_cu = kvz_videoframe_get_cu_const(frame, x, y);
  uint8_t split_flag = (cur_cu->depth > depth) ? 1 : 0;
  uint8_t tr_split = (cur_cu->tr_depth > depth) ? 1 : 0;
  uint8_t border_x = (frame->width  < x*(LCU_WIDTH >> MAX_DEPTH) + (LCU_WIDTH >> depth)) ? 1 : 0;
  uint8_t border_y = (frame->height < y*(LCU_WIDTH >> MAX_DEPTH) + (LCU_WIDTH >> depth)) ? 1 : 0;
  uint8_t border_split_x = (frame->width  < ((x + 1) * (LCU_WIDTH >> MAX_DEPTH)) + (LCU_WIDTH >> (depth + 1))) ? 0 : 1;
  uint8_t border_split_y = (frame->height < ((y + 1) * (LCU_WIDTH >> MAX_DEPTH)) + (LCU_WIDTH >> (depth + 1))) ? 0 : 1;

  uint8_t border = border_x | border_y; // are we in any border CU?

  // split 64x64, on split flag and on border
  if (depth < MAX_DEPTH && (depth == 0 || split_flag || border || tr_split)) {
    // Split the four sub-blocks of this block recursively.
    uint8_t change;
    assert(depth >= 0);  // for clang-analyzer
    change = 1 << (MAX_DEPTH - 1 - depth);

    kvz_filter_deblock_cu(state, x, y, depth + 1, edge);
    if(!border_x || border_split_x) {
      kvz_filter_deblock_cu(state, x + change, y, depth + 1, edge);
    }
    if(!border_y || border_split_y) {
      kvz_filter_deblock_cu(state, x , y + change, depth + 1, edge);
    }
    if((!border_x && !border_y) || (border_split_x && border_split_y)) {
      kvz_filter_deblock_cu(state, x + change, y + change, depth + 1, edge);
    }
    return;
  }

  // no filtering on borders (where filter would use pixels outside the picture)
  if ((x == 0 && edge == EDGE_VER) || (y == 0 && edge == EDGE_HOR)) return;

  // do the filtering for block edge
  kvz_filter_deblock_edge_luma(state,   x*(LCU_WIDTH >> MAX_DEPTH),       y*(LCU_WIDTH >> MAX_DEPTH),       depth, edge);
  kvz_filter_deblock_edge_chroma(state, x*(LCU_WIDTH >> (MAX_DEPTH + 1)), y*(LCU_WIDTH >> (MAX_DEPTH + 1)), depth, edge);
}


/**
 * \brief Deblock a single LCU without using data from right or down.
 *
 * Filter all the following edges:
 * - All edges within the LCU, except for the last 4 pixels on the right when
 *   using horizontal filtering.
 * - Left edge and top edge.
 * - After vertical filtering the left edge, filter the last 4 pixels of
 *   horizontal edges in the LCU to the left.
 */
void kvz_filter_deblock_lcu(encoder_state_t * const state, int x_px, int y_px)
{
  const vector2d_t lcu = { x_px / LCU_WIDTH, y_px / LCU_WIDTH };

  kvz_filter_deblock_cu(state, lcu.x << MAX_DEPTH, lcu.y << MAX_DEPTH, 0, EDGE_VER);

  // Filter rightmost 4 pixels from last LCU now that they have been
  // finally deblocked vertically.
  if (lcu.x > 0) {
    int y;
    for (y = 0; y < 64; y += 8) {
      if (lcu.y + y == 0) continue;
      kvz_filter_deblock_edge_luma(state, lcu.x * 64 - 4, lcu.y * 64 + y, 4, EDGE_HOR);
    }
    for (y = 0; y < 32; y += 8) {
      if (lcu.y + y == 0) continue;
      kvz_filter_deblock_edge_chroma(state, lcu.x * 32 - 4, lcu.y * 32 + y, 4, EDGE_HOR);
    }
  }

  kvz_filter_deblock_cu(state, lcu.x << MAX_DEPTH, lcu.y << MAX_DEPTH, 0, EDGE_HOR);
}

