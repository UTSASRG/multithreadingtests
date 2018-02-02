include ../defines.mk

TEST_NAME = blackscholes
TEST_FILES = blackscholes.m4 

ifeq ($(DATASET), native)
	TEST_ARGS = $(NCORES) $(DATASET_HOME)/blackscholes/in_10M.txt prices.txt	
else ifeq ($(DATASET), large)
	TEST_ARGS = $(NCORES) $(DATASET_HOME)/blackscholes/in_1M.txt prices.txt
endif

CFLAGS =  -pthread -DENABLE_THREADS -DNCO=4 -DN=960
#CFLAGS = -pthread -DENABLE_OPENMP -DNCO=4 -DN=960


#CFLAGS =  -DNCO=4
#PTHREAD_LIBS = -lm -lstdc++
#LOCKPERF_LIBS = -lm -lstdc++
LIBS = -lm -lstdc++

SRC_SUFFIX=.cpp
#SRC_SUFFIX=blackscholes.cpp blackscholes.c


include $(HOME)/Default.mk

