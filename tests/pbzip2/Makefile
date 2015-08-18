HOME = ../..

TEST_NAME = pbzip2
TEST_FILES = pbzip2 BZ2StreamScanner ErrorContext

#TEST_ARGS = -f -n $(NCORES) http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.38.tar.gz
#TEST_ARGS = -f -n 8 http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.xz
TEST_ARGS = -p4 -r -5 gcc-3.3.tar
#TEST_ARGS = -f -n 8 http://mirror.csclub.uwaterloo.ca/gnu/gcc/gcc-2.95.1.tar.gzz
#http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.38.tar.gz

CFLAGS = -DPBZIP_DEBUG -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_POSIX_PTHREAD_SEMANTICS -DUSE_STACKSIZE_CUSTOMIZATION
LIBS = -lbz2 -lpthread

include $(HOME)/Default.mk

