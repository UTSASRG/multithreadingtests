include ../defines.mk

TEST_NAME = ferret
TEST_FILES = ferret arena assign bench bitmap cass cass_dist cass_reg cuckoo_hash dataset dist emd env error hash hash_table heap import map matrix raw stat table timer topk tp tpool util edge extract image srm local LSH LSH_query_batch LSH_query perturb recall
TEST_ARGS = $(DATASET_HOME)/ferret/corel lsh $(DATASET_HOME)/ferret/queries 10 20 1 output.txt

CFLAGS = -Iinclude
LIBS = -Llib -lrt -lm -lgsl -lgslcblas -lMagick -ljpeg


include $(HOME)/Default.mk

