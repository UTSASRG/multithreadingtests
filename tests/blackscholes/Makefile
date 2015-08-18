include ../defines.mk

TEST_NAME = blackscholes
TEST_FILES = blackscholes
TEST_ARGS = 8 $(DATASET_HOME)/blackscholes/in_1M.txt prices.txt

CFLAGS = -DENABLE_THREADS -DPARALLEL -DNCO=2 -DN=960
PTHREAD_LIBS = -lm -lstdc++
LOCKPERF_LIBS = -lm -lstdc++
SRC_SUFFIX=.cpp


include $(HOME)/Default.mk

