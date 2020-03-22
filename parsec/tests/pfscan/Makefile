HOME = ../..
include ../defines.mk
TEST_NAME = pfscan
TEST_FILES = pfscan bm pqueue version

TEST_ARGS = -n$(NCORES) "mtest" ../../datasets/pfscan/key_file_500MB.txt

LIBS = -lm -lstdc++ -lnsl

DMP_O_GRAN = 6
DMP_O_QUANTUM = 100000

DMP_B_GRAN = 6
DMP_B_QUANTUM = 100000

include $(HOME)/Default.mk

