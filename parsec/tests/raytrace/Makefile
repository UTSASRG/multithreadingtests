include ../defines.mk

TEST_NAME = raytrace

#SRCS = Testing/testglut \
			 \
			 RTTL/BVH/BVH \
			 RTTL/BVH/Builder/Builder \
			 RTTL/BVH/Builder/Sweep \
			 RTTL/BVH/Builder/BinnedAllDims \
			 RTTL/BVH/Builder/BinnedAllDimsSaveSpace \
			 RTTL/BVH/Builder/OnDemandBuilder \
			 RTTL/common/RTThread \
			 RTTL/common/MapOptions \
			 RTTL/API/ISG \
			 \
			 RTTL/test/TestOptions/TestOptions \
			 \
			 RTTL/test/api_newmesh/newmesh \
			 \
			 RTTL/test/TestRTVec/TestRTVec \
			 \
			 RTTL/test/api_vertex_conversion/vertex_conversion \
			 \
			 LRT/Init \
			 LRT/FrameBuffer \
			 LRT/FrameBuffer/PBOFrameBuffer \
			 LRT/FrameBuffer/GLTextureFB \
			 LRT/render \
			 \
			 LRT/test/api_static_cube/static_cube \
			 \
			 MiniView/rtview \
			 RTTL/common/MapOptions

SRCS = RTTL/BVH/BVH \
			 RTTL/BVH/Builder/Builder \
			 RTTL/BVH/Builder/Sweep \
			 RTTL/BVH/Builder/BinnedAllDims \
			 RTTL/BVH/Builder/BinnedAllDimsSaveSpace \
			 RTTL/BVH/Builder/OnDemandBuilder \
			 RTTL/common/RTThread \
			 RTTL/common/MapOptions \
			 RTTL/API/ISG \
			 \
			 LRT/Init \
			 LRT/FrameBuffer \
			 LRT/FrameBuffer/PBOFrameBuffer \
			 LRT/FrameBuffer/GLTextureFB \
			 LRT/render \
			 \
			 MiniView/rtview

TEST_FILES = $(SRCS)

#THREADS = $(NCORES)
THREADS = $(shell echo $(NCORES)-1 | bc)

HAVE_DIR = 1

ifeq ($(DATASET), native)
	TEST_ARGS = $(DATASET_HOME)/raytrace/thai_statue.obj -nodisplay -automove -nthreads ${THREADS} -frames 200 -res 1920 1080
else ifeq ($(DATASET), large)
	TEST_ARGS = $(DATASET_HOME)/raytrace/happy_buddha.obj -nodisplay -automove -nthreads ${THREADS} -frames 3 -res 1920 1080
endif

CFLAGS = -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions -static-libgcc -Wl,--hash-style=both,--as-needed -DPARSEC_VERSION=2.1 -fexceptions -fno-strict-aliasing -fno-align-labels -DNDEBUG -D_MM_NO_ALIGN_CHECK -fPIC -I./mesa/include -I. -I./RTTL -I./RTTL/common -I./RTTL/BVH -I./SG -I./LRT/include -I./LRT

LIBS = -L./mesa/lib -L./lib -lLRT -lRTTL -lglut -lGLU -lGL -lXmu -lXext -lX11

SRC_SUFFIX=.cxx

.dir:
	mkdir -p obj/RTTL/BVH obj/RTTL/BVH/Builder obj/RTTL/common obj/RTTL/API obj/LRT obj/LRT/FrameBuffer obj/MiniView

include $(HOME)/Default.mk
