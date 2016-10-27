include ../defines.mk

TEST_NAME = kmeans
TEST_FILES = kmeans

ifeq ($(DATASET), native)
	TEST_ARGS = -d 3 -c 100000 -p 100000 -s 20000 $(NCORES)
else ifeq ($(DATASET), large)
	TEST_ARGS = -d 3 -c 10000 -p 100000 -s 10000 $(NCORES)
endif


include $(HOME)/Default.mk

