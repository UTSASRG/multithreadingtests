include ../defines.mk


#THREADS = $(NCORES)
THREADS = $(shell echo $(NCORES)-1 | bc)
TEST_NAME = swaptions
TEST_FILES = CumNormalInv MaxFunction RanUnif icdf HJM_SimPath_Forward_Blocking HJM HJM_Swaption_Blocking HJM_Securities nr_routines
TEST_ARGS = -ns 128 -sm 50000 -nt $(THREADS)

CFLAGS = -DENABLE_THREADS -fstrict-aliasing -fkeep-inline-functions
LIBS = -lm -lstdc++ 

include $(HOME)/Default.mk

