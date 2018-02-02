include ../defines.mk


TEST_NAME = fluidanimate
TEST_FILES = pthreads cellpool parsec_barrier 

CFLAGS = -g -O2 -fno-omit-frame-pointer -DENABLE_THREADS #-DPARALLEL #-DENABLE_SPIN_BARRIER

LIBS = -lm -lstdc++

#THREADS = $(shell echo $(NCORES)-1 | bc)
THREADS = $(NCORES)

ifeq ($(DATASET), native)
	TEST_ARGS = $(THREADS) 500 $(DATASET_HOME)/fluidanimate/in_500K.fluid out.fluid
else ifeq ($(DATASET), large)
	TEST_ARGS = $(THREADS) 5 $(DATASET_HOME)/fluidanimate/in_300K.fluid out.fluid
endif

include $(HOME)/Default.mk

