_INCLUDES= ../../../../../ip.swp.stack/BlinkerTerminal/1.0
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= BlinkerApp_0.mak

ENAME= BlinkerApp_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt 
EBUILDER= gcc
_OBJ= BlinkerApp.c.o blinker_terminal.c.o
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
	gcc -MMD -MP -c -o $(ODIR)/BlinkerApp.c.o ../../../../../ip.sw/BlinkerApp/1.0_student/BlinkerApp.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -lrt 

$(ODIR)/blinker_terminal.c.o: $(DEPS) ../../../../../ip.swp.stack/BlinkerTerminal/1.0/blinker_terminal.c
	gcc -MMD -MP -c -o $(ODIR)/blinker_terminal.c.o ../../../../../ip.swp.stack/BlinkerTerminal/1.0/blinker_terminal.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)   