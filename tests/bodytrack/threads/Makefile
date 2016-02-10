CC  = gcc
CXX = g++
AR = /usr/bin/ar cru
CFLAGS= -DHAVE_CONFIG_H -I. -I../.. -lpthread -O3 -g -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=3.0-beta-20150206 -fexceptions -Wall -Wno-unknown-pragmas  -fPIC -DPIC

TEST_NAME = 
TEST_FILES = Thread ThreadGroup WorkGroup Mutex Condition Barrier RWLock

all:
	$(CXX) $(CFLAGS) -c Thread.cpp -o Thread.o 
	$(CXX) $(CFLAGS) -c ThreadGroup.cpp -o ThreadGroup.o 
	$(CXX) $(CFLAGS) -c WorkerGroup.cpp -o WorkerGroup.o 
	$(CXX) $(CFLAGS) -c Mutex.cpp -o Mutex.o 
	$(CXX) $(CFLAGS) -c Condition.cpp -o Condition.o 
	$(CXX) $(CFLAGS) -c Barrier.cpp -o Barrier.o 
	$(CXX) $(CFLAGS) -c RWLock.cpp -o RWLock.o 
	$(AR) libthread.a Thread.o ThreadGroup.o WorkerGroup.o Mutex.o Condition.o Barrier.o RWLock.o 
	/usr/bin/ranlib ./libthread.a

Clean:
	rm 
