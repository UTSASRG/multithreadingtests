# FIXME: these two lines that need to be changed correspondingly. Another file is 
# tests/config.mk if you want to change the number of threads or input set (native | large)
MYLIB_WITH_DIR = /home/sam/LockAnalyzer/ref/dimmunix/trunk/pthreads/src/libdimmunix.so
MYLIB = dimmunix
CC = gcc 
CXX = g++ 
CFLAGS += -g -O2 -fno-omit-frame-pointer

CONFIGS = pthread $(MYLIB)
PROGS = $(addprefix $(TEST_NAME)-, $(CONFIGS))

.PHONY: default all clean

default: all
all: $(PROGS)
clean:
	find ./obj -name "*.o" -type f -delete
	rm -f $(PROGS) #obj/*

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

$(TEST_NAME)-pthread: $(PTHREAD_OBJS)
	$(CXX) $(PTHREAD_CFLAGS) -o $@ $(PTHREAD_OBJS) $(PTHREAD_LIBS)

eval-pthread: $(TEST_NAME)-pthread
	time ./$(TEST_NAME)-pthread $(TEST_ARGS)
#time ./$(TEST_NAME)-pthread $(TEST_ARGS) &> /dev/null

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

### FIXME, put the 
$(TEST_NAME)-$(MYLIB): $(MYLIB_OBJS) $(MYLIB_WITH_DIR)
	$(CXX) $(MYLIB_CFLAGS) -o $@ $(MYLIB_OBJS) $(MYLIB_LIBS)

eval-$(MYLIB): $(TEST_NAME)-$(MYLIB)
	time ./$(TEST_NAME)-$(MYLIB) $(TEST_ARGS)

