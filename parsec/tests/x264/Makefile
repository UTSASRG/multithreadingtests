include ../defines.mk

TEST_NAME = x264

SRCS = common/mc common/predict common/pixel common/macroblock \
       common/frame common/dct common/cpu common/cabac \
       common/common common/mdate common/set \
       common/quant common/vlc \
       encoder/analyse encoder/me encoder/ratecontrol \
       encoder/set encoder/macroblock encoder/cabac \
       encoder/cavlc encoder/encoder

#TEST_FILES = matroska muxers x264 $(SRCS)
#SOURCE_DIRS = common encoder extras

#SOURCES := $(wildcard *.c) $(wildcard */*.c)
#TEST_FILES = $(SOURCES:%.c=%)
SRCCLI = x264 matroska muxers
TEST_FILES = $(SRCS) $(SRCCLI)

THREADS = $(NCORES)
#THREADS = 40
#THREADS = $(shell echo $(NCORES)-1 | bc)

ifeq ($(DATASET), native)
	TEST_ARGS = --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads ${THREADS} -o eledream.264 $(DATASET_HOME)/x264/eledream_1920x1080_512.y4m 
else ifeq ($(DATASET), large)
	TEST_ARGS = --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads $(THREADS) -o eledream.264 $(DATASET_HOME)/x264/eledream_640x360_128.y4m
endif

#CFLAGS = -g -ffast-math -O3 -funroll-loops -fprefetch-loop-arrays -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=2.1 -Wall -I. -O3 -funroll-loops -fprefetch-loop-arrays -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=2.1 -DHAVE_MALLOC_H -DHAVE_MMX -DARCH_X86_64 -DSYS_LINUX -DHAVE_PTHREAD -s -fomit-frame-pointer
CFLAGS = -g -fno-omit-frame-pointer -fPIC -ffast-math -funroll-loops -fprefetch-loop-arrays -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=2.1 -Wall -I. -funroll-loops -fprefetch-loop-arrays -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=2.1 -DHAVE_MALLOC_H -DARCH_X86_64 -DSYS_LINUX -DHAVE_PTHREAD -s -fomit-frame-pointer
LIBS = -lm -lstdc++ -Llib -lx264 -lm

HAVE_DIR = 1

.dir:
	mkdir -p obj/common obj/encoder

include $(HOME)/Default.mk

