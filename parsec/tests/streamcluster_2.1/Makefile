include ../defines.mk

THREADS = $(NCORES)
TEST_NAME = streamcluster

TEST_FILES = streamcluster parsec_barrier

ifeq ($(DATASET), native)
	TEST_ARGS = 10 20 128 1000000 200000 5000 none output.txt $(THREADS)
else ifeq ($(DATASET), large)
	TEST_ARGS = 10 20 128 16384 16384 1000 none output.txt $(THREADS)
endif
CFLAGS = -DENABLE_THREADS
LIBS = -lm -lstdc++ 

include $(HOME)/Default.mk

