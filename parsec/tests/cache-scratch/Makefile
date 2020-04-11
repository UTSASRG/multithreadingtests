include ../defines.mk

TEST_NAME = cache-scratch

TEST_FILES = cache-scratch.cpp

THREADS = $(NCORES)

CFLAGS = -g -O3 -DNDEBUG -I./common

LIBS = -lpthread
 
TEST_ARGS = $(THREADS) 10000 8 100000

include $(HOME)/Default.mk
