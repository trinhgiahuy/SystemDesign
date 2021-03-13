_INCLUDES=
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= ARM_FPGA_memory_benchmarker_0.mak

ENAME= ARM_FPGA_memory_benchmarker_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -std=gnu99 -O2 -lm -pthread -lrt
EBUILDER= arm-linux-gnueabihf-gcc
_OBJ= benchmark.c.o
ODIR= obj
OBJ= $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ENAME): $(OBJ)
	$(EBUILDER) -o $(ENAME) $(OBJ) $(EFLAGS)

clean:
	rm -f $(OBJ:%.o=%.d);
	rm -f $(OBJ);

all: $(OBJ)

$(OBJ): | $(ODIR)

$(ODIR):
	mkdir -p $(ODIR)

DEBUG_FLAGS +=
debug: DEBUG_FLAGS += -ggdb -fno-omit-frame-pointer -fno-inline-functions -fno-inline-functions-called-once -fno-optimize-sibling-calls
debug: $(ENAME)

PROFILE_FLAGS +=
profile: PROFILE_FLAGS += -pg -fno-omit-frame-pointer -fno-inline-functions -fno-inline-functions-called-once -fno-optimize-sibling-calls
profile: $(ENAME)

-include $(OBJ:%.o=%.d)

$(ODIR)/benchmark.c.o: $(DEPS) ../../../../../ip.sw/ARM_FPGA_memory_benchmarker/1.0_student/src/benchmark.c
	arm-linux-gnueabihf-gcc -MMD -MP -c -o $(ODIR)/benchmark.c.o ../../../../../ip.sw/ARM_FPGA_memory_benchmarker/1.0_student/src/benchmark.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -std=gnu99 -O2 -lm -pthread -lrt 