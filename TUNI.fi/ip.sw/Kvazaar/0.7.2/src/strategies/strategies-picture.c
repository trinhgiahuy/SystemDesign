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

#include "strategies-picture.h"
#include "strategyselector.h"

// Define function pointers.
reg_sad_func * kvz_reg_sad = 0;

cost_pixel_nxn_func * kvz_sad_4x4 = 0;
cost_pixel_nxn_func * kvz_sad_8x8 = 0;
cost_pixel_nxn_func * kvz_sad_16x16 = 0;
cost_pixel_nxn_func * kvz_sad_32x32 = 0;
cost_pixel_nxn_func * kvz_sad_64x64 = 0;

cost_pixel_nxn_func * kvz_satd_4x4 = 0;
cost_pixel_nxn_func * kvz_satd_8x8 = 0;
cost_pixel_nxn_func * kvz_satd_16x16 = 0;
cost_pixel_nxn_func * kvz_satd_32x32 = 0;
cost_pixel_nxn_func * kvz_satd_64x64 = 0;


// Headers for platform optimizations.
#include "generic/picture-generic.h"
#include "sse2/picture-sse2.h"
#include "sse41/picture-sse41.h"
#include "avx2/picture-avx2.h"
#include "altivec/picture-altivec.h"
#include "x86_asm/picture-x86-asm.h"


int kvz_strategy_register_picture(void* opaque, uint8_t bitdepth) {
  bool success = true;

  success &= kvz_strategy_register_picture_generic(opaque, bitdepth);

  if (kvz_g_hardware_flags.intel_flags.sse2) {
    success &= kvz_strategy_register_picture_sse2(opaque, bitdepth);
  }
  if (kvz_g_hardware_flags.intel_flags.sse41) {
    success &= kvz_strategy_register_picture_sse41(opaque, bitdepth);
  }
  if (kvz_g_hardware_flags.intel_flags.avx) {
    success &= kvz_strategy_register_picture_x86_asm_avx(opaque, bitdepth);
  }
  if (kvz_g_hardware_flags.intel_flags.avx2) {
    success &= kvz_strategy_register_picture_avx2(opaque, bitdepth);
  }
  if (kvz_g_hardware_flags.powerpc_flags.altivec) {
    success &= kvz_strategy_register_picture_altivec(opaque, bitdepth);
  }

  return success;
}


/**
* \brief  Get a function that calculates SATD for NxN block.
*
* \param n  Width of the region for which SATD is calculated.
*
* \returns  Pointer to cost_16bit_nxn_func.
*/
cost_pixel_nxn_func * kvz_pixels_get_satd_func(unsigned n)
{
  switch (n) {
  case 4:
    return kvz_satd_4x4;
  case 8:
    return kvz_satd_8x8;
  case 16:
    return kvz_satd_16x16;
  case 32:
    return kvz_satd_32x32;
  case 64:
    return kvz_satd_64x64;
  default:
    return NULL;
  }
}


/**
* \brief  Get a function that calculates SAD for NxN block.
*
* \param n  Width of the region for which SAD is calculated.
*
* \returns  Pointer to cost_16bit_nxn_func.
*/
cost_pixel_nxn_func * kvz_pixels_get_sad_func(unsigned n)
{
  switch (n) {
  case 4:
    return kvz_sad_4x4;
  case 8:
    return kvz_sad_8x8;
  case 16:
    return kvz_sad_16x16;
  case 32:
    return kvz_sad_32x32;
  case 64:
    return kvz_sad_64x64;
  default:
    return NULL;
  }
}
