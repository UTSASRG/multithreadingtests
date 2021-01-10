#default build suggestion of MPI + OPENMP with gcc on Livermore machines you might have to change the compiler name
TEST_DEF = -DP1094=${P1094} -DP1095=${P1095} -DP1096=${P1096} -DP1029=${P1029} -DP1030=${P1030} -DP1031=${P1031} -DP543=${P543} -DP544=${P544} -DP545=${P545} -DP2251=${P2251} -DP2252=${P2252} -DP2253=${P2253} -DP2254=${P2254} -DP2255=${P2255} -DP2256=${P2256} -DP2257=${P2257} -DP2258=${P2258} -DP2259=${P2259} -DP2260=${P2260} -DP2261=${P2261} -DP2262=${P2262}
SHELL = /bin/sh
.SUFFIXES: .cc .o

LULESH_EXEC = lulesh2.0

MPI_INC = /opt/local/include/openmpi
MPI_LIB = /opt/local/lib

MPICXX = mpicxx -DUSE_MPI=1
SERCXX = g++ -DUSE_MPI=0
NUMA_PERF_CLANG = /home/tpliu/xinzhao/llvm-project-10.0.0/build/bin/clang++ -ldl -DUSE_MPI=1 -I/home/tpliu/xinzhao/openmp/build/runtime/src -I/usr/include/x86_64-linux-gnu/mpich/ -lpthread -lmpi -lnuma
#NUMA_PERF_CLANG = /home/tpliu/xinzhao/llvm-project-10.0.0/build/bin/clang++ -ldl -DUSE_MPI=1 -I/home/tpliu/xinzhao/openmp/build/runtime/src -I/usr/include/x86_64-linux-gnu/mpich/ -lpthread -lmpi -lnuma ${TEST_DEF}
#NUMA_PERF_CLANG = /home/tpliu/xinzhao/llvm-project-10.0.0/build/bin/clang++ -ldl -finstrumenter -DUSE_MPI=1 -I/home/tpliu/xinzhao/openmp/build/runtime/src -I/usr/include/x86_64-linux-gnu/mpich/ -rdynamic /home/tpliu/xinzhao/NumaPerf/source/libnumaperf.so -lpthread -lmpi

#CXX = $(MPICXX)
CXX = $(NUMA_PERF_CLANG)

SOURCES2.0 = \
	lulesh.cc \
	lulesh-comm.cc \
	lulesh-viz.cc \
	lulesh-util.cc \
	lulesh-init.cc
OBJECTS2.0 = $(SOURCES2.0:.cc=.o)

#OMPT_LIBPATH=/home/johnmc/pkgs-src/openmp/INSTALL/lib
OMPT_LIBPATH=/home/tpliu/xinzhao/openmp/build/runtime/src
OMPT=-L$(OMPT_LIBPATH) -Wl,-rpath=$(OMPT_LIBPATH) -lomp
#Default build suggestions with OpenMP for g++
CXXFLAGS = -g -O3 -fopenmp -I. -Wall
LDFLAGS = -g -O3 -fopenmp $(OMPT)

#Below are reasonable default flags for a serial build
#CXXFLAGS = -g -O3 -I. -Wall
#LDFLAGS = -g -O3 

#common places you might find silo on the Livermore machines.
#SILO_INCDIR = /opt/local/include
#SILO_LIBDIR = /opt/local/lib
#SILO_INCDIR = ./silo/4.9/1.8.10.1/include
#SILO_LIBDIR = ./silo/4.9/1.8.10.1/lib

#If you do not have silo and visit you can get them at:
#silo:  https://wci.llnl.gov/codes/silo/downloads.html
#visit: https://wci.llnl.gov/codes/visit/download.html

#below is and example of how to make with silo, hdf5 to get vizulization by default all this is turned off.  All paths are Livermore specific.
#CXXFLAGS = -g -DVIZ_MESH -I${SILO_INCDIR} -Wall -Wno-pragmas
#LDFLAGS = -g -L${SILO_LIBDIR} -Wl,-rpath -Wl,${SILO_LIBDIR} -lsiloh5 -lhdf5

.cc.o: lulesh.h
	@echo "Building $<"
	$(CXX) -c $(CXXFLAGS) -o $@  $<

all: $(LULESH_EXEC)

lulesh2.0: $(OBJECTS2.0)
	@echo "Linking"
	$(CXX) $(OBJECTS2.0) $(LDFLAGS) -lm -o $@

clean:
	/bin/rm -f *.o *~ $(OBJECTS) $(LULESH_EXEC)
	/bin/rm -rf *.dSYM

tar: clean
	cd .. ; tar cvf lulesh-2.0.tar LULESH-2.0 ; mv lulesh-2.0.tar LULESH-2.0

