#ifndef ENCMAIN_SUPPLEMENT_H_
#define ENCMAIN_SUPPLEMENT_H_
#include "global_supplement.h"
#include "sc_kvazaar.h"

// Initialization function used in encmain.c
extern int initializator(int acc);

extern void start_exploration();
extern void end_exploration();
extern void inc_frame();

#endif // ENCMAIN_SUPPLEMENT_H_