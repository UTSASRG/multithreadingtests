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

MY_ARTIFECTS_DIR = '/home/st/Projects/multithreadingtests/myartifects'
memoryAllocatorsLibPath = {"hoard": MY_ARTIFECTS_DIR+"/libhoard.so",
                           "libc221": MY_ARTIFECTS_DIR+"/libmalloc221.so",
                           "libc228": MY_ARTIFECTS_DIR+"/libmalloc228.so",
                           "tcmalloc": MY_ARTIFECTS_DIR+"/libtcmalloc_minimal.so",
                           "jemalloc": MY_ARTIFECTS_DIR+"/libjemalloc.so"}
                           
#Map memory allocator with the first argument. I susppose there are only one argument. And it must be the name of an allocator
if(not (len(argV) == 2 and argV[1] in memoryAllocatorsLibPath)):
    print("You need to pass one and only one allocator name to build.sh", file=sys.stderr)
    print("Configured allocators:\n" + str(memoryAllocatorsLibPath), file=sys.stderr)
    sys.exit(-1)

print('Replacing -pthread with -rdynamic *.so -pthread',file=sys.stderr)
pthreadPattern= re.compile('\-pthread')
for lid,line in enumerate(buildCommand):
   buildCommand[lid]= re.sub(pthreadPattern,'-rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -pthread',line) 

print('Replacing -lpthread with -rdynamic *.so -lpthread',file=sys.stderr)
pthreadPattern= re.compile('\-lpthread')
for lid,line in enumerate(buildCommand):
   buildCommand[lid]= re.sub(pthreadPattern,'-rdynamic '+memoryAllocatorsLibPath[sys.argv[1]]+' -lpthread',line) 

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


