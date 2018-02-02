include ../defines.mk

TEST_NAME = facesim
TEST_FILES = FACE_DRIVER FACE_LANDMARK_OPTIMIZATION_GOAL FACE_OPTIMIZATION LANDMARK_PROXIMITY_OPTIMIZATION main TaskQ


NTHREADS = $(NCORES)
ifeq ($(DATASET), native)
	TEST_ARGS = -timing -threads $(NTHREADS) -lastframe 100
else ifeq ($(DATASET), large)
	TEST_ARGS = -timing -threads $(NTHREADS) 
endif


CFLAGS = -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=3.0-beta-20150206 -fexceptions -DENABLE_PTHREADS -I./TaskQ/include -DUSE_ALAMERE_TASKQ -DTASKQ_DIST_FIXED -DNDEBUG 
#CFLAGS = -DMYBUG -fexceptions -DENABLE_PTHREADS -DUSE_THREADS -DPARALLEL -DHAVE_LIBPTHREAD -I./ -I./FlexImageLib/  -fpermissive -DTASKQ_DIST_FIXED
#LIBS = -lm -lstdc++ -Llib -lflex -lthreads
LIBS = -lm -lstdc++ -Llib -lPhysBAM 

include $(HOME)/Default.mk
