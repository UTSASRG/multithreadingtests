topsrcdir=../..

include ../../make.defs

INCPATH += -I../../CMG_CLEAN/src -I.

# Our locally built libs that need to be linked in
LIBS += -lcmgp -lc2k

all: libc2k.$(LIB_EXT)

LIB_SOURCES =   C2K-CMG.c C2K-KC_Geom.c C2K-KC_API.c  C2K-Lists.c  C2K-Storage.c C2K-KC_Alter.c \
		C2K-KC_Create.c     C2K-KC_SubDivide.c  C2K-Storage.c C2K-KC_API.c  \
		C2K-KC_Check.c  C2K-KC_CutZone.c  C2K-KC_Info.c  C2K-Lists.c 

LIB_OBJECTS := $(LIB_SOURCES:.c=.o)

ifeq ($(STATIC_LINK),on)

libc2k.$(LIB_EXT): $(LIB_OBJECTS) 
	echo 333
	$(LD) $(LDFLAGS) $@ $^ $(LIBPATH)
	echo 3333

else # shared libs

ifeq ($(CLASS),aix)
LIBPATH += -L../../CMG_CLEAN/src

libc2k.$(LIB_EXT): $(LIB_OBJECTS) 
	$(LD) $(LDFLAGS) -o $@  $^ $(LIBPATH) -lcmgp $(MPI_LIB_PATH) $(MPI_LIBS)
	echo 1111

else  # not aix

libc2k.$(LIB_EXT): $(LIB_OBJECTS) 
	$(LD) $(LDFLAGS) -o $@  $^ $(LIBPATH) $(TAU_MPI_FLIB) $(TAU_SHAREDLIB) $(TAU_MPI_LIB) $(TAU_CXXLIBS_INTEL)
	echo 2222

endif # end of aix/not aix case

endif # end of static/shared case
clean:
	rm -f *.o test libc2k.*

veryclean:clean
