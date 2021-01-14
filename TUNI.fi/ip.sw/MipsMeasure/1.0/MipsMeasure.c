#include <stdint.h>
#include <stdio.h>
#include <time.h>

#define NANOS_IN_SECOND 1000000000

#ifndef ARM
#define MILLION_NUMBER_INSTRUCTIONS 1300
#else
#define MILLION_NUMBER_INSTRUCTIONS 1300
#endif

int main()
{
	//Force the process to core zero.
	char mask = 0;
	sched_setaffinity( 0, sizeof(char), &mask );
	
	//Time when measurement started and ended
	struct timespec t_start, t_end;
	
	//Check the time stamp here, as it would cause malfunction if called after
	//the initialization. On the other hand, the initialization will amortize.
	clock_gettime( CLOCK_MONOTONIC, &t_start );
	
	#ifndef ARM
	//Initialization: move the desired amount of iterations to the register
	asm("mov $100000000, %ecx");
	
	//The functional part of the loop: 10 multiplication commands
	asm("loop_start:");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx");
	asm("mul %bx"); //Takes 3*10 cycles
	
	//The mandatory part of the loop: Iterate and branch back if not ready yet.
	asm("dec %ecx"); //Takes 1 cycle
	asm("cmp $0, %ecx"); //Takes 1 cycle
	asm("jnz loop_start"); //Takes 1 cycle
	
	//TOTAL: 33 cycles per iterations
	//Grand total of 3 300 000 000 instructions
	
	#else
	//Initialization: move the desired amount of iterations to the register
	asm("ldr r3, =100000000");
	
	//The functional part of the loop: 10 multiplication commands
	asm("loop_start:");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2");
	asm("mul r0, r1, r2"); //Takes 2*10 cycles
	
	//The mandatory part of the loop: Iterate and branch back if not ready yet.
	asm("sub     r3, #1"); //Takes 1 cycle
    asm("cmp     r3, #0"); //Takes 1 cycle
    asm("bne loop_start"); //Takes 3 cycles
	
	//TOTAL: 25 cycles per iterations
	//Grand total of 2 500 000 000 instructions
	#endif
	
	//...and the measurement is concluded
	clock_gettime( CLOCK_MONOTONIC, &t_end );
	
	//See how long it took, how many iterations, how high transfer rate.
	double diff =  (double)( t_end.tv_nsec - t_start.tv_nsec ) / NANOS_IN_SECOND;
	diff +=  (double)( t_end.tv_sec - t_start.tv_sec );
	
	//Finally, print how long it took, passed iterations and Mops
	printf("duration %f s MIPS %f\n", diff, MILLION_NUMBER_INSTRUCTIONS / diff );
	
	return 0;
}