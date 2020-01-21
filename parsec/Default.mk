# FIXME: these two lines that need to be changed correspondingly. Another file is 
# tests/config.mk if you want to change the number of threads or input set (native | large)
MYLIB_WITH_DIR = /home/tliu/numalloc/source/libnumalloc.so
MYLIB = numalloc
OTHLIB_WITH_DIR = /home/tliu/numalloc/source/libnumalloc.so
OTHLIB = numalloc
#MYLIB_WITH_DIR = /home/tliu/light/source/liblight.so
#MYLIB = light
#CC = clang
#CXX = clang++ 
CC = gcc
CXX = g++ 
CFLAGS += -g -O2 -fno-omit-frame-pointer -ldl

CONFIGS = pthread $(MYLIB) $(OTHLIB)
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

############ $(OTHLIB) builders ############

OTHLIB_CFLAGS = $(CFLAGS) -DNDEBUG
OTHLIB_LIBS += -rdynamic $(OTHLIB_WITH_DIR) $(LIBS) -lpthread -ldl


OTHLIB_OBJS = $(addprefix obj/, $(addsuffix -$(OTHLIB).o, $(TEST_FILES)))

obj/%-$(OTHLIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %.c
	mkdir -p obj
	$(CC) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %.cxx
	mkdir -p obj
	$(CXX) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %.cc
	mkdir -p obj
	$(CXX) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(OTHLIB).o: %$(SRC_SUFFIX)
	mkdir -p obj
	$(CXX) $(OTHLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the 
$(TEST_NAME)-$(OTHLIB): $(OTHLIB_OBJS) $(OTHLIB_WITH_DIR)
	$(CXX) $(OTHLIB_CFLAGS) -o $@ $(OTHLIB_OBJS) $(OTHLIB_LIBS)

eval-$(OTHLIB): $(TEST_NAME)-$(OTHLIB)
	/usr/bin/time ./$(TEST_NAME)-$(OTHLIB) $(TEST_ARGS)