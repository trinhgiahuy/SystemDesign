#ifndef SEARCH_SUPPLEMENT_H_
#define SEARCH_SUPPLEMENT_H_

#include "cu.h"
#include "videoframe.h"

// used for sending the orig block to the accelerator, used in search.c
extern void pre_search(const videoframe_t * const frame, lcu_t* work_tree, const int x, const int y);

// used for handling thread locks, not used in simulation
extern void post_search(lcu_t* work_tree);

#endif // SEARCH_SUPPLEMENT_H_