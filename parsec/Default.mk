# FIXME: these two lines that need to be changed correspondingly. Another file is 
# tests/config.mk if you want to change the number of threads or input set (native | large)
MYLIB_WITH_DIR = /home/sam/Memoryallocators/DieHard-old/src/libdieharder.so
MYLIB = dieharder
CC = gcc 
CXX = g++ 
CFLAGS += -g -O2 -fno-omit-frame-pointer -ldl

CONFIGS = pthread $(MYLIB)
PROGS = $(addprefix $(TEST_NAME)-, $(CONFIGS))

ifeq ($(strip $(SRC_SUFFIX)), .cpp)
		SRC_SUFFIX =
endif

.PHONY: default all clean

default: all
all: $(PROGS)
clean:
	find . -type f -executable -name "*-pthread" -or -name "*-$(MYLIB)" -delete
	find ./obj -name "*.o" -type f -delete
	rm -f $(PROGS) #obj/*
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

