include ../defines.mk


TEST_NAME = fluidanimate
TEST_FILES = pthreads parsec_barrier 

CFLAGS = -DENABLE_THREADS -DPARALLEL 
#-DENABLE_SPIN_BARRIER
LIBS = -lm -lstdc++

THREADS = $(shell echo $(NCORES)-1 | bc)
#THREADS = $(NCORES)
TEST_ARGS = $(THREADS) 8 $(DATASET_HOME)/fluidanimate/in_300K.fluid out.fluid

include $(HOME)/Default.mk

