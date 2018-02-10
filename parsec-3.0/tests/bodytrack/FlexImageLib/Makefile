CC  = gcc
CXX = g++
AR = /usr/bin/ar cru
CFLAGS= -DHAVE_CONFIG_H -I. -I../ -I../.. -lpthread -O3 -g -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=3.0-beta-20150206 -fexceptions -Wall -Wno-unknown-pragmas  -fPIC -DPIC

LIB_FILES = FlexIO FlexImage 
LIB_OBJS = $(addprefix obj/, $(addsuffix .o, $(LIB_FILES)))

default: all
all: $(LIB_OBJS)
	$(AR) libflex.a $(LIB_OBJS)
	/usr/bin/ranlib ./libflex.a
#	g++  -g -O2 -Wall -Wno-unknown-pragmas   -o libflex.la   FlexImage.lo FlexIO.lo  -lpthread
	cp -f libflex.a ../lib

clean:
	find ./obj -name "*.o" -type f -delete
	rm -f libflex.a libflex.la 
	rm -f $(LIBRARY) #obj/*


obj/%.o: %.c
	mkdir -p obj
	$(CC) $(CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%.o: %.cpp
	mkdir -p obj
	$(CXX) $(CFLAGS) -c $< -o $@ -I$(HOME)/include

#libthread.a:$(LIB_OBJS)
#	$(CXX) $(CFLAGS) -o $@ $(LIB_OBJS) 
