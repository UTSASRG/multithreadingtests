include ../defines.mk


TEST_NAME = fluidanimate
TEST_FILES = pthreads parsec_barrier 

CFLAGS = -g -O2 -fno-omit-frame-pointer -DENABLE_THREADS -DPARALLEL #-DENABLE_SPIN_BARRIER

LIBS = -lm -lstdc++

#THREADS = $(shell echo $(NCORES)-1 | bc)
THREADS = $(NCORES)
#THREADS = 1

ifeq ($(DATASET), native)
	TEST_ARGS = $(THREADS) 500 $(DATASET_HOME)/fluidanimate/in_500K.fluid out.fluid
else ifeq ($(DATASET), large)
	TEST_ARGS = $(THREADS) 5 $(DATASET_HOME)/fluidanimate/in_300K.fluid out.fluid
endif

include $(HOME)/Default.mk

