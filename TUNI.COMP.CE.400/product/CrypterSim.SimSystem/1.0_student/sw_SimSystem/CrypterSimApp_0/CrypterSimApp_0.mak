_INCLUDES= ../../../../../ip.sw/CrypterSimApp/1.0_student
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= CrypterSimApp_0.mak

ENAME= CrypterSimApp_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11
EBUILDER= g++
_OBJ= main.cpp.o process1.cpp.o process2.cpp.o process3.cpp.o process4.cpp.o test_bench.cpp.o value1.cpp.o
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

$(ODIR)/main.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/main.cpp
	g++ -MMD -MP -c -o $(ODIR)/main.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/main.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/process1.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/process1.cpp
	g++ -MMD -MP -c -o $(ODIR)/process1.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/process1.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/process2.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/process2.cpp
	g++ -MMD -MP -c -o $(ODIR)/process2.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/process2.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/process3.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/process3.cpp
	g++ -MMD -MP -c -o $(ODIR)/process3.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/process3.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/process4.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/process4.cpp
	g++ -MMD -MP -c -o $(ODIR)/process4.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/process4.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/test_bench.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/test_bench.cpp
	g++ -MMD -MP -c -o $(ODIR)/test_bench.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/test_bench.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 

$(ODIR)/value1.cpp.o: $(DEPS) ../../../../../ip.sw/CrypterSimApp/1.0_student/value1.cpp
	g++ -MMD -MP -c -o $(ODIR)/value1.cpp.o ../../../../../ip.sw/CrypterSimApp/1.0_student/value1.cpp $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib -lsystemc  -std=c++11 