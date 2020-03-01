HOME = ../..

include $(HOME)/tests/defines.mk
TEST_NAME = sqlite3
TEST_FILES = sqlite3 test_multiplex threadtest3

#TEST_ARGS = -f -n $(NCORES) http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.38.tar.gz
#TEST_ARGS = -f -n 8 http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.xz
TEST_ARGS = walthread1
#TEST_ARGS = -f -n $(NCORES) http://gnu.mirrors.hoobly.com/gnu/gcc/gcc-3.3.tar.gz
#TEST_ARGS = -f -n 8 http://mirror.csclub.uwaterloo.ca/gnu/gcc/gcc-2.95.1.tar.gzz
#http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.38.tar.gz

CFLAGS = 
LIBS = -ldl -lm

include $(HOME)/Default.mk

