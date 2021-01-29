_INCLUDES= ../../../../../ip.sw/Kvazaar/0.7.2/src ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2 ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic ../../../../../ip.sw/Kvazaar/0.7.2/src/extras ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/altivec ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse2 ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse41 ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/x86_asm ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies
INCLUDES=$(patsubst %, -I%, $(_INCLUDES))

DEPS= Kvazaar_0.mak

ENAME= Kvazaar_0
EFLAGS= $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/"
EBUILDER= gcc
_OBJ= bitstream.c.o cabac.c.o checkpoint.c.o cli.c.o config.c.o context.c.o cu.c.o dct-avx2.c.o dct-generic.c.o encmain.c.o encoder_state-bitstream.c.o encoder_state-ctors_dtors.c.o encoder_state-geometry.c.o encoder.c.o encoderstate.c.o filter.c.o getopt.c.o image.c.o imagelist.c.o input_frame_buffer.c.o inter.c.o interface_main.c.o intra-avx2.c.o intra-generic.c.o intra.c.o ipol-avx2.c.o ipol-generic.c.o kvazaar.c.o nal-generic.c.o nal.c.o picture-altivec.c.o picture-avx2.c.o picture-generic.c.o picture-sse2.c.o picture-sse41.c.o picture-x86-asm.c.o quant-avx2.c.o quant-generic.c.o rate_control.c.o rdo.c.o sao.c.o scalinglist.c.o search_inter.c.o search_intra.c.o search.c.o strategies-dct.c.o strategies-intra.c.o strategies-ipol.c.o strategies-nal.c.o strategies-picture.c.o strategies-quant.c.o strategyselector.c.o tables.c.o threadqueue.c.o transform.c.o videoframe.c.o yuv_io.c.o
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

$(ODIR)/bitstream.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/bitstream.c
	gcc -MMD -MP -c -o $(ODIR)/bitstream.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/bitstream.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/cabac.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/cabac.c
	gcc -MMD -MP -c -o $(ODIR)/cabac.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/cabac.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/checkpoint.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/checkpoint.c
	gcc -MMD -MP -c -o $(ODIR)/checkpoint.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/checkpoint.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/cli.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/cli.c
	gcc -MMD -MP -c -o $(ODIR)/cli.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/cli.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/config.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/config.c
	gcc -MMD -MP -c -o $(ODIR)/config.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/config.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/context.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/context.c
	gcc -MMD -MP -c -o $(ODIR)/context.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/context.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/cu.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/cu.c
	gcc -MMD -MP -c -o $(ODIR)/cu.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/cu.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/dct-avx2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/dct-avx2.c
	gcc -MMD -MP -c -o $(ODIR)/dct-avx2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/dct-avx2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/dct-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/dct-generic.c
	gcc -MMD -MP -c -o $(ODIR)/dct-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/dct-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encmain.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encmain.c
	gcc -MMD -MP -c -o $(ODIR)/encmain.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encmain.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encoder_state-bitstream.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-bitstream.c
	gcc -MMD -MP -c -o $(ODIR)/encoder_state-bitstream.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-bitstream.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encoder_state-ctors_dtors.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-ctors_dtors.c
	gcc -MMD -MP -c -o $(ODIR)/encoder_state-ctors_dtors.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-ctors_dtors.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encoder_state-geometry.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-geometry.c
	gcc -MMD -MP -c -o $(ODIR)/encoder_state-geometry.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder_state-geometry.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encoder.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder.c
	gcc -MMD -MP -c -o $(ODIR)/encoder.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encoder.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/encoderstate.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/encoderstate.c
	gcc -MMD -MP -c -o $(ODIR)/encoderstate.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/encoderstate.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/filter.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/filter.c
	gcc -MMD -MP -c -o $(ODIR)/filter.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/filter.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/getopt.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/extras/getopt.c
	gcc -MMD -MP -c -o $(ODIR)/getopt.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/extras/getopt.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/image.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/image.c
	gcc -MMD -MP -c -o $(ODIR)/image.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/image.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/imagelist.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/imagelist.c
	gcc -MMD -MP -c -o $(ODIR)/imagelist.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/imagelist.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/input_frame_buffer.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/input_frame_buffer.c
	gcc -MMD -MP -c -o $(ODIR)/input_frame_buffer.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/input_frame_buffer.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/inter.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/inter.c
	gcc -MMD -MP -c -o $(ODIR)/inter.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/inter.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/interface_main.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/interface_main.c
	gcc -MMD -MP -c -o $(ODIR)/interface_main.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/interface_main.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/intra-avx2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/intra-avx2.c
	gcc -MMD -MP -c -o $(ODIR)/intra-avx2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/intra-avx2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/intra-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/intra-generic.c
	gcc -MMD -MP -c -o $(ODIR)/intra-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/intra-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/intra.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/intra.c
	gcc -MMD -MP -c -o $(ODIR)/intra.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/intra.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/ipol-avx2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/ipol-avx2.c
	gcc -MMD -MP -c -o $(ODIR)/ipol-avx2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/ipol-avx2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/ipol-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/ipol-generic.c
	gcc -MMD -MP -c -o $(ODIR)/ipol-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/ipol-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/kvazaar.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/kvazaar.c
	gcc -MMD -MP -c -o $(ODIR)/kvazaar.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/kvazaar.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/nal-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/nal-generic.c
	gcc -MMD -MP -c -o $(ODIR)/nal-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/nal-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/nal.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/nal.c
	gcc -MMD -MP -c -o $(ODIR)/nal.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/nal.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-altivec.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/altivec/picture-altivec.c
	gcc -MMD -MP -c -o $(ODIR)/picture-altivec.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/altivec/picture-altivec.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-avx2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/picture-avx2.c
	gcc -MMD -MP -c -o $(ODIR)/picture-avx2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/picture-avx2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/picture-generic.c
	gcc -MMD -MP -c -o $(ODIR)/picture-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/picture-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-sse2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse2/picture-sse2.c
	gcc -MMD -MP -c -o $(ODIR)/picture-sse2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse2/picture-sse2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-sse41.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse41/picture-sse41.c
	gcc -MMD -MP -c -o $(ODIR)/picture-sse41.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/sse41/picture-sse41.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/picture-x86-asm.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/x86_asm/picture-x86-asm.c
	gcc -MMD -MP -c -o $(ODIR)/picture-x86-asm.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/x86_asm/picture-x86-asm.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/quant-avx2.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/quant-avx2.c
	gcc -MMD -MP -c -o $(ODIR)/quant-avx2.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/avx2/quant-avx2.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/quant-generic.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/quant-generic.c
	gcc -MMD -MP -c -o $(ODIR)/quant-generic.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/generic/quant-generic.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/rate_control.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/rate_control.c
	gcc -MMD -MP -c -o $(ODIR)/rate_control.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/rate_control.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/rdo.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/rdo.c
	gcc -MMD -MP -c -o $(ODIR)/rdo.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/rdo.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/sao.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/sao.c
	gcc -MMD -MP -c -o $(ODIR)/sao.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/sao.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/scalinglist.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/scalinglist.c
	gcc -MMD -MP -c -o $(ODIR)/scalinglist.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/scalinglist.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/search_inter.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/search_inter.c
	gcc -MMD -MP -c -o $(ODIR)/search_inter.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/search_inter.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/search_intra.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/search_intra.c
	gcc -MMD -MP -c -o $(ODIR)/search_intra.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/search_intra.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/search.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/search.c
	gcc -MMD -MP -c -o $(ODIR)/search.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/search.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-dct.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-dct.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-dct.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-dct.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-intra.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-intra.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-intra.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-intra.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-ipol.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-ipol.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-ipol.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-ipol.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-nal.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-nal.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-nal.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-nal.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-picture.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-picture.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-picture.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-picture.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategies-quant.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-quant.c
	gcc -MMD -MP -c -o $(ODIR)/strategies-quant.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategies/strategies-quant.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/strategyselector.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/strategyselector.c
	gcc -MMD -MP -c -o $(ODIR)/strategyselector.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/strategyselector.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/tables.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/tables.c
	gcc -MMD -MP -c -o $(ODIR)/tables.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/tables.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/threadqueue.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/threadqueue.c
	gcc -MMD -MP -c -o $(ODIR)/threadqueue.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/threadqueue.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/transform.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/transform.c
	gcc -MMD -MP -c -o $(ODIR)/transform.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/transform.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/videoframe.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/videoframe.c
	gcc -MMD -MP -c -o $(ODIR)/videoframe.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/videoframe.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 

$(ODIR)/yuv_io.c.o: $(DEPS) ../../../../../ip.sw/Kvazaar/0.7.2/src/yuv_io.c
	gcc -MMD -MP -c -o $(ODIR)/yuv_io.c.o ../../../../../ip.sw/Kvazaar/0.7.2/src/yuv_io.c $(INCLUDES) $(DEBUG_FLAGS) $(PROFILE_FLAGS)  -Werror -Wall -Wtype-limits -Wvla  -std=gnu99  -lrt -lm -pthread -O2 -O3 -I"src/strategies" -I"src/extras" -I"src/" 