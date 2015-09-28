include ../defines.mk

TEST_NAME = blackscholes
TEST_FILES = blackscholes

ifeq ($(DATASET), native)
	TEST_ARGS = $(NCORES) $(DATASET_HOME)/blackscholes/in_10M.txt prices.txt	
else ifeq ($(DATASET), large)
	TEST_ARGS = $(NCORES) $(DATASET_HOME)/blackscholes/in_1M.txt prices.txt
endif

CFLAGS = -DENABLE_THREADS -DPARALLEL -DNCO=2 -DN=960
#PTHREAD_LIBS = -lm -lstdc++
#LOCKPERF_LIBS = -lm -lstdc++
LIBS = -lm -lstdc++

SRC_SUFFIX=.cpp


include $(HOME)/Default.mk

