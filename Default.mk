LOCKPERFS_HOME = ../../..

CC = gcc 
CXX = g++ 
CFLAGS += -O2 -lm

CONFIGS = pthread lockperf
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
	$(CC) $(PTHREAD_CFLAGS) -o $@ $(PTHREAD_OBJS) $(PTHREAD_LIBS)

eval-pthread: $(TEST_NAME)-pthread
	time ./$(TEST_NAME)-pthread $(TEST_ARGS)
#time ./$(TEST_NAME)-pthread $(TEST_ARGS) &> /dev/null

############ lockperf builders ############

LOCKPERF_CFLAGS = $(CFLAGS) -DNDEBUG
#LOCKPERF_LIBS += -rdynamic $(LOCKPERFS_HOME)/src/liblockperf.so -ldl -lpthread $(LIBS)
LOCKPERF_LIBS += $(LIBS) -rdynamic $(LOCKPERFS_HOME)/src/liblockperf.so -lpthread -ldl

LOCKPERF_OBJS = $(addprefix obj/, $(addsuffix -lockperf.o, $(TEST_FILES)))

obj/%-lockperf.o: %-pthread.c
	mkdir -p obj
	$(CC) $(LOCKPERF_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-lockperf.o: %.c
	mkdir -p obj
	$(CC) $(LOCKPERF_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-lockperf.o: %-pthread.cpp
	mkdir -p obj
	$(CC) $(LOCKPERF_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-lockperf.o: %.cpp
	mkdir -p obj
	$(CXX) $(LOCKPERF_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the 
$(TEST_NAME)-lockperf: $(LOCKPERF_OBJS) $(LOCKPERFS_HOME)/src/liblockperf.so
	$(CC) $(LOCKPERF_CFLAGS) -o $@ $(LOCKPERF_OBJS) $(LOCKPERF_LIBS)

eval-lockperf: $(TEST_NAME)-lockperf
	time ./$(TEST_NAME)-lockperf $(TEST_ARGS)
#	time ./$(TEST_NAME)-lockperf $(TEST_ARGS) &> /dev/null

