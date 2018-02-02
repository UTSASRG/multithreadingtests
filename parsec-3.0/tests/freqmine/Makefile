include ../defines.mk

TEST_NAME = freqmine
#TEST_FILES = buffer data fpmax fp_node fp_tree fsout wtime
TEST_FILES = fpmax data fp_tree buffer fsout fp_node wtime
THREADS = $(NCORES)


ifeq ($(DATASET), native)
	TEST_ARGS = $(DATASET_HOME)/freqmine/webdocs_250k.dat 11000
else ifeq ($(DATASET), large)
	TEST_ARGS = $(DATASET_HOME)/freqmine/kosarak_990k.dat 790
endif



#CFLAGS = -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=3.0-beta-20120904 -fopenmp -Wno-deprecated
CFLAGS =  -O3 -g -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=3.0-beta-20150206 -fopenmp
LIBS = -lm -lstdc++

include $(HOME)/Default.mk

