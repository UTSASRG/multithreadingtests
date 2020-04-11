include ../defines.mk

TEST_NAME = cache-thrash

TEST_FILES = cache-thrash.cpp

THREADS = $(NCORES)

CFLAGS = -g -O3 -DNDEBUG -I./common

LIBS = -lpthread
 
TEST_ARGS = $(THREADS) 100000 8 100000

include $(HOME)/Default.mk
