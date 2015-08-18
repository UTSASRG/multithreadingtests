include ../defines.mk

TEST_NAME = canneal
TEST_FILES = annealer_thread rng netlist main netlist_elem
THREADS = $(shell echo $(NCORES)-1 | bc)

TEST_ARGS = $(THREADS) 15000 2000 $(DATASET_HOME)/canneal/400000.nets 128

CFLAGS = -DENABLE_THREADS 
LIBS = -lm -lstdc++

include $(HOME)/Default.mk


