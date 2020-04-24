include ../defines.mk

TEST_NAME = facesim
TEST_FILES = FACE_DRIVER FACE_LANDMARK_OPTIMIZATION_GOAL FACE_OPTIMIZATION LANDMARK_PROXIMITY_OPTIMIZATION main taskQ

ifeq ($(NCORES), 128)
  THREADS := 128
else ifeq ($(NCORES), 64)
  THREADS := 64
else ifeq ($(NCORES), 40)
  THREADS := 32
else ifeq ($(NCORES), 32)
  THREADS := 32
else ifeq ($(NCORES), 16)
  THREADS := 16
else ifeq ($(NCORES), 8)
  THREADS := 8
else
  THREADS := 1
endif

ifeq ($(DATASET), native)
        TEST_ARGS = -timing -threads $(THREADS) -lastframe 200
else ifeq ($(DATASET), large)
        TEST_ARGS = -timing -threads $(THREADS) 
endif


CFLAGS = -DMYBUG -fexceptions -DENABLE_PTHREADS -DUSE_THREADS -DPARALLEL -DHAVE_LIBPTHREAD -I./ -I./FlexImageLib/  -fpermissive -DTASKQ_DIST_FIXED
#LIBS = -lm -lstdc++ -Llib -lflex -lthreads
LIBS = -lm -lstdc++ -Llib -lPhysBAM #mejbah

include $(HOME)/Default.mk

