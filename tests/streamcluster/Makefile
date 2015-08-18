include ../defines.mk

THREADS = $(NCORES)
TEST_NAME = streamcluster
TEST_FILES = streamcluster
TEST_ARGS = 10 20 128 16384 16384 1000 none output.txt $(THREADS)

CFLAGS = -DENABLE_THREADS
LIBS = -lm -lstdc++ 

include $(HOME)/Default.mk

