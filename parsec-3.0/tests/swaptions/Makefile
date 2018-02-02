include ../defines.mk


THREADS = $(NCORES)
TEST_NAME = swaptions

#TEST_FILES = CumNormalInv MaxFunction RanUnif nr_routines icdf HJM_SimPath_Forward_Blocking HJM HJM_Swaption_Blocking HJM_Securities

TEST_FILES = CumNormalInv MaxFunction RanUnif nr_routines icdf HJM_SimPath_Forward_Blocking HJM HJM_Swaption_Blocking HJM_Securities

ifeq ($(DATASET), native)
	TEST_ARGS = -ns 128 -sm 1000000 -nt $(THREADS)
else ifeq ($(DATASET), large)
	TEST_ARGS = -ns 64 -sm 40000 -nt $(THREADS)
endif

CFLAGS = -DENABLE_THREADS -fstrict-aliasing -fkeep-inline-functions
#CFLAGS = -DUSE_PTHREAD 
#LIBS = -lm -lstdc++ 
LIBS =

include $(HOME)/Default.mk

