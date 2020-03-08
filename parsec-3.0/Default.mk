# tests/config.mk if you want to change the number of threads or input set (native | large)
#MYLIB_WITH_DIR = /media/umass/datasystem/xin/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc-0.1base/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/xin/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-fullinterleaved/libnumalloc.so
MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-fasterthantcmalloc-raytrace/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-48-class-size/libnumalloc.so
MYLIB = numalloc
#TCMALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/gperftools-2.7/.libs/libtcmalloc.so
TCMALLOC_LIB_WITH_DIR = /media/umass/datasystem/tongping/Memoryallocators/NUMA-aware_TCMalloc/.libs/libtcmalloc.so
TCMALLOC_LIB = tcmalloc
JEMALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/jemalloc-5.2.1/lib/libjemalloc.so
JEMALLOC_LIB = jemalloc
SCALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/scalloc-1.0.0/out/Release/lib.target/libscalloc.so
SCALLOC_LIB = scalloc
TBB_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc7.4.0_libc2.27_kernel5.0.0_release/libtbb.so.2
TBB_MALLOC_LIB = tbbmalloc
#MYLIB_WITH_DIR = /home/tliu/light/source/liblight.so
#MYLIB = light
#CC = clang
#CXX = clang++ 
CC = gcc
CXX = g++ 
CFLAGS += -g -O3 -fno-omit-frame-pointer -ldl

CONFIGS = pthread $(MYLIB) $(TCMALLOC_LIB)
PROGS = $(addprefix $(TEST_NAME)-, $(CONFIGS))

ifeq ($(strip $(SRC_SUFFIX)), .cpp)
		SRC_SUFFIX =
endif

.PHONY: default all clean

default: all
all: $(PROGS)
clean:
	rm -f $(PROGS)
	rm -rf obj/*
	if test $(strip $(HAVE_DIR)) -eq 1; then \
    $(MAKE) .dir; \
  fi

eval: $(addprefix eval-, $(CONFIGS))

############ pthread builders ############

PTHREAD_CFLAGS = $(CFLAGS)
PTHREAD_LIBS += $(LIBS) -lpthread

PTHREAD_OBJS = $(addprefix obj/, $(addsuffix -pthread.o, $(TEST_FILES)))

obj/%-pthread.o: %-pthread.c
	mkdir -p obj
	$(CC) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.c
	mkdir -p obj
	$(CC) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.cpp
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.cxx
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.cc
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include
 

$(TEST_NAME)-pthread: $(PTHREAD_OBJS)
	$(CXX) $(PTHREAD_CFLAGS) -o $@ $(PTHREAD_OBJS) $(PTHREAD_LIBS)

eval-pthread: $(TEST_NAME)-pthread
	/usr/bin/time ./$(TEST_NAME)-pthread $(TEST_ARGS)

############ $(MYLIB) builders ############

MYLIB_CFLAGS = $(CFLAGS) -DNDEBUG
MYLIB_LIBS += -rdynamic $(MYLIB_WITH_DIR) $(LIBS) -lpthread -ldl


MYLIB_OBJS = $(addprefix obj/, $(addsuffix -$(MYLIB).o, $(TEST_FILES)))

obj/%-$(MYLIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.c
	mkdir -p obj
	$(CC) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.cc
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the 
$(TEST_NAME)-$(MYLIB): $(MYLIB_OBJS) $(MYLIB_WITH_DIR)
	$(CXX) $(MYLIB_CFLAGS) -o $@ $(MYLIB_OBJS) $(MYLIB_LIBS)

eval-$(MYLIB): $(TEST_NAME)-$(MYLIB)
	/usr/bin/time ./$(TEST_NAME)-$(MYLIB) $(TEST_ARGS)

############ $(TCMALLOC_LIB) builders ############

TCMALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
TCMALLOC_LIB_LIBS += -rdynamic $(TCMALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


TCMALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(TCMALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(TCMALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TCMALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the 
$(TEST_NAME)-$(TCMALLOC_LIB): $(TCMALLOC_LIB_OBJS) $(TCMALLOC_LIB_WITH_DIR)
	$(CXX) $(TCMALLOC_LIB_CFLAGS) -o $@ $(TCMALLOC_LIB_OBJS) $(TCMALLOC_LIB_LIBS)

eval-$(TCMALLOC_LIB): $(TEST_NAME)-$(TCMALLOC_LIB)
	/usr/bin/time ./$(TEST_NAME)-$(TCMALLOC_LIB) $(TEST_ARGS)



############ $(SCALLOC_LIB) builders ############

SCALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
SCALLOC_LIB_LIBS += -rdynamic $(SCALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


SCALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(SCALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(SCALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(SCALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(SCALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(SCALLOC_LIB): $(SCALLOC_LIB_OBJS) $(SCALLOC_LIB_WITH_DIR)
	$(CXX) $(SCALLOC_LIB_CFLAGS) -o $@ $(SCALLOC_LIB_OBJS) $(SCALLOC_LIB_LIBS)

eval-$(SCALLOC_LIB): $(TEST_NAME)-$(SCALLOC_LIB)
	/usr/bin/time ./$(TEST_NAME)-$(SCALLOC_LIB) $(TEST_ARGS)




############ $(JEMALLOC_LIB) builders ############

JEMALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
JEMALLOC_LIB_LIBS += -rdynamic $(JEMALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


JEMALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(JEMALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(JEMALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(JEMALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(JEMALLOC_LIB): $(JEMALLOC_LIB_OBJS) $(JEMALLOC_LIB_WITH_DIR)
	$(CXX) $(JEMALLOC_LIB_CFLAGS) -o $@ $(JEMALLOC_LIB_OBJS) $(JEMALLOC_LIB_LIBS)

eval-$(JEMALLOC_LIB): $(TEST_NAME)-$(JEMALLOC_LIB)
	/usr/bin/time ./$(TEST_NAME)-$(JEMALLOC_LIB) $(TEST_ARGS)



############ $(TBB_MALLOC_LIB) builders ############

TBB_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
TBB_MALLOC_LIB_LIBS += -rdynamic $(TBB_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


TBB_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(TBB_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(TBB_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(TBB_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(TBB_MALLOC_LIB): $(TBB_MALLOC_LIB_OBJS) $(TBB_MALLOC_LIB_WITH_DIR)
	$(CXX) $(TBB_MALLOC_LIB_CFLAGS) -o $@ $(TBB_MALLOC_LIB_OBJS) $(TBB_MALLOC_LIB_LIBS)

eval-$(TBB_MALLOC_LIB): $(TEST_NAME)-$(TBB_MALLOC_LIB)
	/usr/bin/time ./$(TEST_NAME)-$(TBB_MALLOC_LIB) $(TEST_ARGS)
