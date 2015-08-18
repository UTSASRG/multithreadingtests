HOME = ../..

TEST_NAME = pbzip2
TEST_FILES = pbzip2 BZ2StreamScanner ErrorContext

TEST_ARGS = -p16 -r -5 ../../datasets/pbzip2/gcc-3.3.tar

CFLAGS = -DPBZIP_DEBUG -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_POSIX_PTHREAD_SEMANTICS -DUSE_STACKSIZE_CUSTOMIZATION
LIBS = -lstdc++ -lbz2 -lpthread

include $(HOME)/Default.mk

