#!/usr/bin/python3

#This script is an add $EXTRA_BUILD_ARGS to the end of build command.
#But the library added is specified by build script arguments

import sys
import os
import re

print('Reading inputs', file=sys.stderr)
buildCommand = []
for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    buildCommand.append(line)

print("Checking parameters", file=sys.stderr)
#Split build arguments by space
argV = sys.argv

MY_ARTIFECTS_DIR = os.environ['BENCHMARK_ROOT_DIR']+"/myartifects"
memoryAllocatorsLibPath = {"hoard": MY_ARTIFECTS_DIR+"/libhoard.so",
                           "libc221": MY_ARTIFECTS_DIR+"/libmalloc221.so",
                           "libc228": MY_ARTIFECTS_DIR+"/libmalloc228.so",
                           "tcmalloc": MY_ARTIFECTS_DIR+"/libtcmalloc_minimal.so",
                           "jemalloc": MY_ARTIFECTS_DIR+"/libjemalloc.so"}

if (len(argV) ==3):
   if(argV[2].startswith("mmprof_NOUTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_noutil.so"
   elif (argV[2].startswith("mmprof_UTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_util.so"
   elif (argV[2].startswith("mmprof_MALLOCNUM")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_mallocnum.so"
   else:
      print("mmprof has three versions: mmprof_UTIL, mmprof_NOUTIL, and mmprof_MALLOCNUM", file=sys.stderr)
      sys.exit(-1)

#Map memory allocator with the first argument. I susppose there are only one argument. And it must be the name of an allocator
if(len(argV) == 2 and (not argV[1] in memoryAllocatorsLibPath)):
    print("You need to pass one and only one allocator name to build.sh", file=sys.stderr)
    print("Configured allocators:\n" + str(memoryAllocatorsLibPath), file=sys.stderr)
    print("Current Arguments:\n" + str(sys.argv), file=sys.stderr)
    sys.exit(-1)
elif (len(argV) ==3 and not( argV[2].startswith("mmprof"))):
   print("If you to link mmprof. The third parameter would have to be mmprof", file=sys.stderr)
   print("Current Arguments:\n" + str(sys.argv), file=sys.stderr)
   sys.exit(-1)
elif len(argV) > 3:
   print("Your arugment number doesn't look right", file=sys.stderr)
   print("Usage1: ./build.sh ALLOCATOR_NAME", file=sys.stderr)
   print("Usage2: ./build.sh ALLOCATOR_NAME mmprof", file=sys.stderr)
   sys.exit(-1)


print('Replacing -pthread with -rdynamic *.so -pthread',file=sys.stderr)
pthreadPattern= re.compile('\-pthread')
for lid,line in enumerate(buildCommand):
   if(sys.argv[-1].startswith('mmprof')):
      buildCommand[lid]= re.sub(pthreadPattern,' -rdynamic '+ mmprofPath+' -rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -pthread',line) 
   else:
      buildCommand[lid]= re.sub(pthreadPattern,' -rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -pthread',line) 

print('Replacing -lpthread with -rdynamic *.so -lpthread',file=sys.stderr)
pthreadPattern= re.compile('\-lpthread')
for lid,line in enumerate(buildCommand):
   if(sys.argv[-1].startswith('mmprof')):
      buildCommand[lid]= re.sub(pthreadPattern,' -rdynamic '+ mmprofPath+' -rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -lpthread',line) 
   else:
      buildCommand[lid]= re.sub(pthreadPattern,' -rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -lpthread',line) 

print('Replacing CPPFLAGS = with CPPFLAGS = -Wl,--no-as-needed',file=sys.stderr)
pthreadPattern= re.compile('^CPPFLAGS =')
for lid,line in enumerate(buildCommand):
   buildCommand[lid]= re.sub(pthreadPattern,'CPPFLAGS = -Wl,--no-as-needed',line) 

print('Replacing CFLAGS = with CFLAGS = -Wl,--no-as-needed',file=sys.stderr)
pthreadPattern= re.compile('^CFLAGS =')
for lid,line in enumerate(buildCommand):
   buildCommand[lid]= re.sub(pthreadPattern,'CFLAGS = -Wl,--no-as-needed',line) 

for line in buildCommand:
   print(line,end='')


