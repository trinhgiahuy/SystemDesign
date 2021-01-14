_INCLUDES= src
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= header.hh test_bench.hh

ENAME= Gajsky_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -L$(SYSTEMC_HOME)/lib -lsystemc -lrt
EBUILDER= g++
_OBJ= main.cpp.o test_bench.cpp.o
ODIR= obj
OBJ= $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ENAME): $(OBJ)
	$(EBUILDER) -o $(ENAME) $(OBJ) $(EFLAGS)

clean:
	rm -f $(OBJ);

all: $(OBJ)

$(OBJ): | $(ODIR)

$(ODIR):
	mkdir -p $(ODIR)

DEBUG_FLAGS +=
debug: DEBUG_FLAGS += -ggdb
debug: $(ENAME)

PROFILE_FLAGS +=
profile: PROFILE_FLAGS += -pg -fno-omit-frame-pointer -fno-inline-functions -fno-inline-functions-called-once -fno-optimize-sibling-calls
profile: $(ENAME)

$(ODIR)/main.cpp.o: $(DEPS) main.cpp
	g++ -c -o $(ODIR)/main.cpp.o main.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -std=c++11 -I$(SYSTEMC_HOME)/include -lsystemc -lrt -L$(SYSTEMC_HOME)/lib -lsystemc -lrt 

$(ODIR)/test_bench.cpp.o: $(DEPS) test_bench.cpp
	g++ -c -o $(ODIR)/test_bench.cpp.o test_bench.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -std=c++11 -I$(SYSTEMC_HOME)/include -lsystemc -lrt -L$(SYSTEMC_HOME)/lib -lsystemc -lrt 