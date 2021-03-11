_INCLUDES= ../../../../../ip.swp.stack/BlinkerHAL/1.0_student ../../../../../../TUNI.fi/ip.swp.stack/FPGAHAL/1.0
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= BlinkerApp_0.mak

ENAME= BlinkerApp_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt
EBUILDER= arm-linux-gnueabihf-gcc
_OBJ= BlinkerApp.c.o blinker_hal.c.o fpga_map.c.o
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

$(ODIR)/BlinkerApp.c.o: $(DEPS) ../../../../../ip.sw/BlinkerApp/1.0_student/BlinkerApp.c
	arm-linux-gnueabihf-gcc -MMD -MP -c -o $(ODIR)/BlinkerApp.c.o ../../../../../ip.sw/BlinkerApp/1.0_student/BlinkerApp.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt 

$(ODIR)/blinker_hal.c.o: $(DEPS) ../../../../../ip.swp.stack/BlinkerHAL/1.0_student/blinker_hal.c
	arm-linux-gnueabihf-gcc -MMD -MP -c -o $(ODIR)/blinker_hal.c.o ../../../../../ip.swp.stack/BlinkerHAL/1.0_student/blinker_hal.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt 

$(ODIR)/fpga_map.c.o: $(DEPS) ../../../../../../TUNI.fi/ip.swp.stack/FPGAHAL/1.0/fpga_map.c
	arm-linux-gnueabihf-gcc -MMD -MP -c -o $(ODIR)/fpga_map.c.o ../../../../../../TUNI.fi/ip.swp.stack/FPGAHAL/1.0/fpga_map.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt 