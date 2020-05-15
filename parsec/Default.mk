# tests/config.mk if you want to change the number of threads or input set (native | large)
#MYLIB_WITH_DIR = /media/umass/datasystem/xin/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc-0.1base/source/libnumalloc.so
MYLIB_WITH_DIR = /media/umass/datasystem/xin/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-fullinterleaved/libnumalloc.so
#MYLIB_WITH_DIR = /home/tpliu/xinzhao/numalloc/source/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-fasterthantcmalloc-raytrace/libnumalloc.so
#MYLIB_WITH_DIR = /media/umass/datasystem/tongping/numalloc/source-48-class-size/libnumalloc.so
MYLIB = numalloc
TCMALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/gperftools-2.7/.libs/libtcmalloc.so
#TCMALLOC_LIB_WITH_DIR = /media/umass/datasystem/tongping/Memoryallocators/NUMA-aware_TCMalloc/.libs/libtcmalloc.so
#TCMALLOC_LIB_WITH_DIR = /home/tpliu/xinzhao/allocaters/gperftools-2.7/.libs/libtcmalloc.so
TCMALLOC_LIB = tcmalloc
NUMA_AWARE_TCMALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/NUMA-aware_TCMalloc/.libs/libtcmalloc.so
#NUMA_AWARE_TCMALLOC_LIB_WITH_DIR = /home/tpliu/xinzhao/Memoryallocators/NUMA-aware_TCMalloc/.libs/libtcmalloc.so
NUMA_AWARE_TCMALLOC_LIB = numaaware-tcmalloc
JEMALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/jemalloc-5.2.1/lib/libjemalloc.so
#JEMALLOC_LIB_WITH_DIR = /home/tpliu/xinzhao/allocaters/jemalloc-5.2.1/lib/libjemalloc.so
JEMALLOC_LIB = jemalloc
SCALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/scalloc-1.0.0/out/Release/lib.target/libscalloc.so
#SCALLOC_LIB_WITH_DIR = /home/tpliu/xinzhao/allocaters/scalloc-1.0.0/out/Release/lib.target/libscalloc.so
SCALLOC_LIB = scalloc
TBB_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc7.4.0_libc2.27_kernel5.0.0_release/libtbb.so.2
#TBB_MALLOC_LIB_WITH_DIR = /home/tpliu/xinzhao/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc8.3.0_libc2.28_kernel4.19.0_release/libtbb.so.2
TBB_MALLOC_LIB = tbbmalloc
LIBC_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/libc-2.28/libmalloc.so
LIBC_MALLOC_LIB = libcmalloc

HOARD_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/Hoard/src/libhoard.so
HOARD_MALLOC_LIB = hoard

OPENBSD_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/OpenBSD-6.0/libomalloc.so
OPENBSD_MALLOC_LIB = openbsd

DIEHARD_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/DieHard/src/libdieharder.so
DIEHARD_MALLOC_LIB = dieharder


LIBC221_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/libc-2.21/libmalloc.so
LIBC221_MALLOC_LIB = libc221

#LIBC228_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/libc-2.28/libmalloc.so
LIBC228_MALLOC_LIB_WITH_DIR = /media/umass/datasystem/xin/Memoryallocators/libc-2.28-final/libmalloc.so
LIBC228_MALLOC_LIB = libc228


#MYLIB_WITH_DIR = /home/tliu/light/source/liblight.so
#MYLIB_WITH_DIR = /home/tliu/light/source/liblight.so
#MYLIB = light
#CC = clang
#CXX = clang++ 
CC = gcc
CXX = g++ 
#CFLAGS += -g -O0 -fno-omit-frame-pointer -ldl
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
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-pthread $(TEST_ARGS)

############ $(MYLIB) builders ############

MYLIB_CFLAGS = $(CFLAGS) -DNDEBUG
MY_DY_LIB_LIBS =  
#MY_DY_LIB_LIBS += -rdynamic $(MALLOC_PROF_LIB_WITH_DIR) 
MY_DY_LIB_LIBS += -rdynamic $(MYLIB_WITH_DIR) 
MYLIB_LIBS += $(LIBS) -lpthread -ldl


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
	$(CXX) $(MYLIB_CFLAGS) $(MY_DY_LIB_LIBS)  -o $@ $(MYLIB_OBJS) $(MYLIB_LIBS)

eval-$(MYLIB): $(TEST_NAME)-$(MYLIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(MYLIB) $(TEST_ARGS)

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

eval-$(TCMALLOC_LIB): export LD_LIBRARY_PATH=/home/tpliu/xinzhao/allocaters/gperftools-2.7/.libs/

eval-$(TCMALLOC_LIB): $(TEST_NAME)-$(TCMALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(TCMALLOC_LIB) $(TEST_ARGS)


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

#eval-$(SCALLOC_LIB): export LD_LIBRARY_PATH=/home/tpliu/xinzhao/allocaters/scalloc-1.0.0/out/Release/lib.target/
eval-$(SCALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/allocaters/scalloc-1.0.0/out/Release/lib.target/
eval-$(SCALLOC_LIB): $(TEST_NAME)-$(SCALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(SCALLOC_LIB) $(TEST_ARGS)




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

eval-$(JEMALLOC_LIB): export LD_LIBRARY_PATH=/home/tpliu/xinzhao/allocaters/jemalloc-5.2.1/lib/

eval-$(JEMALLOC_LIB): $(TEST_NAME)-$(JEMALLOC_LIB)
	/usr/bin/time -f "real:%e,	user:%U,	sys:%S,	mem(Kb):%M" ./$(TEST_NAME)-$(JEMALLOC_LIB) $(TEST_ARGS)



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

#eval-$(TBB_MALLOC_LIB): export LD_LIBRARY_PATH=/home/tpliu/xinzhao/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc8.3.0_libc2.28_kernel4.19.0_release/
eval-$(TBB_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc7.4.0_libc2.27_kernel5.0.0_release/

eval-$(TBB_MALLOC_LIB): $(TEST_NAME)-$(TBB_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(TBB_MALLOC_LIB) $(TEST_ARGS)


############ $(NUMA_AWARE_TCMALLOC_LIB) builders ############

NUMA_AWARE_TCMALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
NUMA_AWARE_TCMALLOC_LIB_LIBS += -rdynamic $(NUMA_AWARE_TCMALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


NUMA_AWARE_TCMALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(NUMA_AWARE_TCMALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(NUMA_AWARE_TCMALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(NUMA_AWARE_TCMALLOC_LIB): $(NUMA_AWARE_TCMALLOC_LIB_OBJS) $(NUMA_AWARE_TCMALLOC_LIB_WITH_DIR)
	$(CXX) $(NUMA_AWARE_TCMALLOC_LIB_CFLAGS) -o $@ $(NUMA_AWARE_TCMALLOC_LIB_OBJS) $(NUMA_AWARE_TCMALLOC_LIB_LIBS)

#eval-$(NUMA_AWARE_TCMALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/tongping/Memoryallocators/NUMA-aware_TCMalloc/.libs/
eval-$(NUMA_AWARE_TCMALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/NUMA-aware_TCMalloc/.libs/
#eval-$(NUMA_AWARE_TCMALLOC_LIB): export LD_LIBRARY_PATH=/home/tpliu/xinzhao/Memoryallocators/NUMA-aware_TCMalloc/.libs/

eval-$(NUMA_AWARE_TCMALLOC_LIB): $(TEST_NAME)-$(NUMA_AWARE_TCMALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(NUMA_AWARE_TCMALLOC_LIB) $(TEST_ARGS)
	#/usr/bin/time ./$(TEST_NAME)-$(NUMA_AWARE_TCMALLOC_LIB) $(TEST_ARGS)


############ ${LIBC_MALLOC_LIB) builders ############

LIBC_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
LIBC_MALLOC_LIB_LIBS += -rdynamic $(LIBC_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


LIBC_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(LIBC_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(LIBC_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(LIBC_MALLOC_LIB): $(LIBC_MALLOC_LIB_OBJS) $(LIBC_MALLOC_LIB_WITH_DIR)
	$(CXX) $(LIBC_MALLOC_LIB_CFLAGS) -o $@ $(LIBC_MALLOC_LIB_OBJS) $(LIBC_MALLOC_LIB_LIBS)

eval-$(LIBC_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(LIBC_MALLOC_LIB): $(TEST_NAME)-$(LIBC_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(LIBC_MALLOC_LIB) $(TEST_ARGS)



############ ${HOARD_MALLOC_LIB) builders ############

HOARD_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
HOARD_MALLOC_LIB_LIBS += -rdynamic $(HOARD_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


HOARD_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(HOARD_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(HOARD_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(HOARD_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(HOARD_MALLOC_LIB): $(HOARD_MALLOC_LIB_OBJS) $(HOARD_MALLOC_LIB_WITH_DIR)
	$(CXX) $(HOARD_MALLOC_LIB_CFLAGS) -o $@ $(HOARD_MALLOC_LIB_OBJS) $(HOARD_MALLOC_LIB_LIBS)

eval-$(HOARD_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(HOARD_MALLOC_LIB): $(TEST_NAME)-$(HOARD_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(HOARD_MALLOC_LIB) $(TEST_ARGS)





############ ${OPENBSD_MALLOC_LIB) builders ############

OPENBSD_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
OPENBSD_MALLOC_LIB_LIBS += -rdynamic $(OPENBSD_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


OPENBSD_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(OPENBSD_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(OPENBSD_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OPENBSD_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(OPENBSD_MALLOC_LIB): $(OPENBSD_MALLOC_LIB_OBJS) $(OPENBSD_MALLOC_LIB_WITH_DIR)
	$(CXX) $(OPENBSD_MALLOC_LIB_CFLAGS) -o $@ $(OPENBSD_MALLOC_LIB_OBJS) $(OPENBSD_MALLOC_LIB_LIBS)

eval-$(OPENBSD_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(OPENBSD_MALLOC_LIB): $(TEST_NAME)-$(OPENBSD_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(OPENBSD_MALLOC_LIB) $(TEST_ARGS)



############ ${DIEHARD_MALLOC_LIB) builders ############

DIEHARD_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
DIEHARD_MALLOC_LIB_LIBS += -rdynamic $(DIEHARD_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


DIEHARD_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(DIEHARD_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(DIEHARD_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(DIEHARD_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(DIEHARD_MALLOC_LIB): $(DIEHARD_MALLOC_LIB_OBJS) $(DIEHARD_MALLOC_LIB_WITH_DIR)
	$(CXX) $(DIEHARD_MALLOC_LIB_CFLAGS) -o $@ $(DIEHARD_MALLOC_LIB_OBJS) $(DIEHARD_MALLOC_LIB_LIBS)

eval-$(DIEHARD_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(DIEHARD_MALLOC_LIB): $(TEST_NAME)-$(DIEHARD_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(DIEHARD_MALLOC_LIB) $(TEST_ARGS)



############ ${LIBC221_MALLOC_LIB) builders ############

LIBC221_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
LIBC221_MALLOC_LIB_LIBS += -rdynamic $(LIBC221_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


LIBC221_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(LIBC221_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(LIBC221_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC221_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(LIBC221_MALLOC_LIB): $(LIBC221_MALLOC_LIB_OBJS) $(LIBC221_MALLOC_LIB_WITH_DIR)
	$(CXX) $(LIBC221_MALLOC_LIB_CFLAGS) -o $@ $(LIBC221_MALLOC_LIB_OBJS) $(LIBC221_MALLOC_LIB_LIBS)

eval-$(LIBC221_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(LIBC221_MALLOC_LIB): $(TEST_NAME)-$(LIBC221_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(LIBC221_MALLOC_LIB) $(TEST_ARGS)




############ ${LIBC228_MALLOC_LIB) builders ############

LIBC228_MALLOC_LIB_CFLAGS = $(CFLAGS) -DNDEBUG
LIBC228_MALLOC_LIB_LIBS += -rdynamic $(LIBC228_MALLOC_LIB_WITH_DIR) $(LIBS) -lpthread -ldl


LIBC228_MALLOC_LIB_OBJS = $(addprefix obj/, $(addsuffix -$(LIBC228_MALLOC_LIB).o, $(TEST_FILES)))

obj/%-$(LIBC228_MALLOC_LIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %.c
	mkdir -p obj
	$(CC) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %.cc
	mkdir -p obj
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(LIBC228_MALLOC_LIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the
$(TEST_NAME)-$(LIBC228_MALLOC_LIB): $(LIBC228_MALLOC_LIB_OBJS) $(LIBC228_MALLOC_LIB_WITH_DIR)
	$(CXX) $(LIBC228_MALLOC_LIB_CFLAGS) -o $@ $(LIBC228_MALLOC_LIB_OBJS) $(LIBC228_MALLOC_LIB_LIBS)

eval-$(LIBC228_MALLOC_LIB): export LD_LIBRARY_PATH=/media/umass/datasystem/xin/Memoryallocators/libc-2.28/

eval-$(LIBC228_MALLOC_LIB): $(TEST_NAME)-$(LIBC228_MALLOC_LIB)
	/usr/bin/time -f "real:%e,  user:%U,  sys:%S, mem(Kb):%M" ./$(TEST_NAME)-$(LIBC228_MALLOC_LIB) $(TEST_ARGS)
