include ../defines.mk

TEST_NAME = dedup
TEST_FILES = binheap decoder dedup encoder hashtable queue rabin tree util mbuffer sha

ifeq ($(NCORES), 40)
  THREADS := 1
else ifeq ($(NCORES), 32)
  THREADS := 8
else ifeq ($(NCORES), 16)
  THREADS := 4
else ifeq ($(NCORES), 8)
  THREADS := 2
else
  THREADS := 1
endif

ifeq ($(DATASET), native)
	#TEST_ARGS = -c -p -f -t $(THREADS) -i $(DATASET_HOME)/dedup/FC-6-x86_64-disc1.iso -o output.dat.ddp
	TEST_ARGS = -c -p -t $(THREADS) -i $(DATASET_HOME)/dedup/FC-6-x86_64-disc1.iso -o output.dat.ddp
else ifeq ($(DATASET), large)
	#TEST_ARGS = -c -p -f -t $(THREADS) -i $(DATASET_HOME)/dedup/media.dat -o output.dat.ddp
	TEST_ARGS = -c -p -t $(THREADS) -i $(DATASET_HOME)/dedup/media.dat -o output.dat.ddp
endif


#CFLAGS = -D_XOPEN_SOURCE=600 -Iinclude -DENABLE_THREADS -DPARALLEL -std=gnu99 -D_XOPEN_SOURCE=600 -DMD32_REG_T=int -funroll-loops -fprefetch-loop-arrays -fstrict-aliasing -Wstrict-aliasing -O5 -fkeep-inline-functions -DOPENSSL_THREADS -D_REENTRANT -DL_ENDIAN -DTERMIO -DUSE_MMAP
#CFLAGS = -Iinclude -DENABLE_PTHREADS -DPARALLEL -std=gnu99 -DMD32_REG_T=int -D_REENTRANT -DL_ENDIAN -DUSE_MMAP -D_XOPEN_SOURCE=600
CFLAGS = -Iinclude -DENABLE_PTHREADS -std=gnu99 -DMD32_REG_T=int -D_REENTRANT -DL_ENDIAN -DUSE_MMAP -D_XOPEN_SOURCE=600
#LIBS = -Llib -lssl -lz -lcrypto
LIBS = -Llib -lssl -lcrypto

#Uncomment the following to enable gzip compression
CFLAGS += -DENABLE_GZIP_COMPRESSION
LIBS += -lz

#Uncomment the following to enable bzip2 compression
#CFLAGS += -DENABLE_BZIP2_COMPRESSION 
#LIBS += lbz2

include $(HOME)/Default.mk

