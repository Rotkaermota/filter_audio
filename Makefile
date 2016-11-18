# Makefile for jpeg
# (C) 2016 Rotkaermota

LIBNAME = filter_audio

CC=gcc
CFLAGS=-O3
#CFLAGS=-O3  -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN
#CFLAGS=-O -DMAX_WBITS=14 -DMAX_MEM_LEVEL=7
#CFLAGS=-g -DDEBUG
#CFLAGS=-O3 -Wall -Wwrite-strings -Wpointer-arith -Wconversion \
#           -Wstrict-prototypes -Wmissing-prototypes

LDFLAGS= 
LDSHARED=gcc
CPP=gcc -E

AR=ar
ARFLAGS=rc
RANLIB=ranlib
SHELL=/bin/sh

garbage =$(GARBAGE)/__garbage/$(LIBNAME)
libdir =$(GARBAGE)/__libs

libs = $(LIBNAME).a

srcs0 = filter_audio.c
#aec
srcs1 = aec_core.c aec_core_sse2.c aec_rdft.c aec_rdft_sse2.c aec_resampler.c echo_cancellation.c
#agc
srcs2 = analog_agc.c digital_agc.c
#ns
srcs3 = noise_suppression.c noise_suppression_x.c nsx_core.c nsx_core_c.c ns_core.c
#other
srcs4 = complex_bit_reverse.c complex_fft.c copy_set_operations.c cross_correlation.c delay_estimator.c delay_estimator_wrapper.c \
division_operations.c dot_product_with_scale.c downsample_fast.c energy.c fft4g.c float_util.c get_scaling_square.c \
high_pass_filter.c min_max_operations.c randomization_functions.c real_fft.c resample_48khz.c resample_by_2.c resample_by_2_internal.c \
resample_fractional.c ring_buffer.c speex_resampler.c splitting_filter.c spl_init.c spl_sqrt.c spl_sqrt_floor.c vector_scaling_operations.c
#vad
srcs5 = vad_core.c vad_filterbank.c vad_gmm.c vad_sp.c webrtc_vad.c
#zam
srcs6 = filters.c

objs0 = $(srcs0:.c=.o)
objs1 = $(srcs1:.c=.o)
objs2 = $(srcs2:.c=.o)
objs3 = $(srcs3:.c=.o)
objs4 = $(srcs4:.c=.o)
objs5 = $(srcs5:.c=.o)
objs6 = $(srcs6:.c=.o)

fsrcs0 = $(srcs0)
fsrcs1 = $(addprefix ./aec/, $(srcs1))
fsrcs2 = $(addprefix ./agc/, $(srcs2))
fsrcs3 = $(addprefix ./ns/, $(srcs3))
fsrcs4 = $(addprefix ./other/, $(srcs4))
fsrcs5 = $(addprefix ./vad/, $(srcs5))
fsrcs6 = $(addprefix ./zam/, $(srcs6))

objs = $(objs0) $(objs1) $(objs2) $(objs3) $(objs4) $(objs5) $(objs6)

all: mkdirs static

static: $(libs)

$(LIBNAME).a: $(objs)
	$(AR) $(ARFLAGS) $(libdir)/$@ $(addprefix $(garbage)/, $(objs))
	-@ ($(RANLIB) $@ || true) >/dev/null 2>&1

mkdirs:
	mkdir -p $(garbage)
	mkdir -p $(libdir)

$(objs0): $(fsrcs0)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./$(@:.o=.c)

$(objs1): $(fsrcs1)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./aec/$(@:.o=.c) -I.

$(objs2): $(fsrcs2)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./agc/$(@:.o=.c) -I.

$(objs3): $(fsrcs3)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./ns/$(@:.o=.c) -I.

$(objs4): $(fsrcs4)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./other/$(@:.o=.c) -I.

$(objs5): $(fsrcs5)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./vad/$(@:.o=.c) -I.

$(objs6): $(fsrcs6)
	$(CC) -o $(garbage)/$@ -c $(CFLAGS) ./zam/$(@:.o=.c) -I.

clean:
	rm -f $(libdir)/$(LIBNAME).a
	rm -r -f $(garbage)/$(LIBNAME)


