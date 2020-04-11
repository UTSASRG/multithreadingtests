include ../defines.mk

all: larson larson-hoard

TEST_NAME = larson

TEST_FILES = larson.cpp

CFLAGS = -g -O3 -DNDEBUG -I./common

LIBS = -lpthread

THREADS = $(NCORES)

TEST_ARGS = 10 7 2048 1000 10000 1 $(THREADS)

include $(HOME)/Default.mk
