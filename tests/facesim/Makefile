include ../defines.mk

TEST_NAME = facesim
TEST_FILES = FACE_DRIVER FACE_LANDMARK_OPTIMIZATION_GOAL FACE_OPTIMIZATION LANDMARK_PROXIMITY_OPTIMIZATION main taskQ

ifeq ($(DATASET), native)
	TEST_ARGS = -timing -threads $(NCORES) -lastframe 100
else ifeq ($(DATASET), large)
	TEST_ARGS = -timing -threads $(NCORES) 
endif


CFLAGS = -fexceptions -DENABLE_PTHREADS -DUSE_THREADS -DPARALLEL -DHAVE_LIBPTHREAD -I./ -I./FlexImageLib/  -fpermissive -DTASKQ_DIST_FIXED
#LIBS = -lm -lstdc++ -Llib -lflex -lthreads
LIBS = -lm -lstdc++ -Llib -lPhysBAM #mejbah

include $(HOME)/Default.mk




