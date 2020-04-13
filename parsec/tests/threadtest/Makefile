include ../defines.mk

TEST_NAME = threadtest
TEST_FILES = threadtest.cpp
THREADS = $(NCORES)

CFLAGS = -std=c++14 -g -O3 -DNDEBUG -I./common/

LIBS = -lpthread

TEST_ARGS = $(THREADS) 100 1280000 0 64

include $(HOME)/Default.mk
