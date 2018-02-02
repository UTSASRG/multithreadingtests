include ../defines.mk

TEST_NAME = ferret
#TEST_FILES = ferret arena assign bench bitmap cass cass_dist cass_reg cuckoo_hash dataset dist emd env error hash hash_table heap import map matrix raw stat table timer topk tp tpool util edge extract image srm local LSH LSH_query_batch LSH_query perturb recall queue 

#SRCS = lsh/local lsh/LSH lsh/LSH_query_batch lsh/LSH_query lsh/perturb lsh/recall image/cass_img_extract image/edge  image/extract image/image image/srm
SRCS = lsh/local lsh/LSH lsh/LSH_query_batch lsh/LSH_query lsh/perturb lsh/recall image/edge  image/extract image/image image/srm
SRCCLI = ferret-pthreads arena assign bench bitmap cass cass_dist cass_reg cuckoo_hash dataset dist emd env error hash hash_table heap import map matrix queue raw stat table timer topk tp tpool util 

TEST_FILES = $(SRCCLI) $(SRCS)

ifeq ($(NCORES), 32)
  THREADS := 8
else ifeq ($(NCORES), 16)
  THREADS := 4
else ifeq ($(NCORES), 8)
  THREADS := 2
else
  THREADS := 1
endif

ifeq ($(DATASET), native)
	TEST_ARGS = $(DATASET_HOME)/ferret/corel lsh $(DATASET_HOME)/ferret/queries 50 20 $(THREADS) output.txt
else ifeq ($(DATASET), large)
	TEST_ARGS = $(DATASET_HOME)/ferret/corel lsh $(DATASET_HOME)/ferret/queries 10 20 $(THREADS) output.txt
endif


CFLAGS = -Iinclude -Iimage
#LIBS += -Llib -lrt -lm  -lgsl -lgslcblas -ljpeg -lstdc++
LIBS += -Llib -lrt -lm -lcass -lgsl -lgslcblas -ljpeg -lstdc++
#LIBS = -Llib -lrt -lm -lgsl -lgslcblas -lMagick -ljpeg
#LIBS += -lrt -lm -lcass -lgsl -lgslcblas -ljpeg -lstdc++


include $(HOME)/Default.mk

