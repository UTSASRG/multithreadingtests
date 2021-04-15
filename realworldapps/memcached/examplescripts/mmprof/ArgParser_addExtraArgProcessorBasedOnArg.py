#!/usr/bin/python3

#This script is an add $EXTRA_BUILD_ARGS to the end of build command.
#But the library added is specified by build script arguments

import sys
import os

print('Reading inputs', file=sys.stderr)
buildCommand = []
for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    buildCommand.append(line)

print("Checking parameters", file=sys.stderr)
#Split build arguments by space
argV = sys.argv

MY_ARTIFECTS_DIR=os.environ['BENCHMARK_ROOT_DIR']+'/myartifects'
memoryAllocatorsLibPath = {"hoard": MY_ARTIFECTS_DIR+"/libhoard.so",
                           "libc221": MY_ARTIFECTS_DIR+"/libmalloc221.so",
                           "libc228": MY_ARTIFECTS_DIR+"/libmalloc228.so",
                           "tcmalloc": MY_ARTIFECTS_DIR+"/libtcmalloc_minimal.so",
                           "jemalloc": MY_ARTIFECTS_DIR+"/libjemalloc.so"}

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

print('Finding CFLAGS in makefile',file=sys.stderr)

buildArgList = []

print("Adding my libraries",file=sys.stderr)

if (len(argV) ==3):
   if(argV[2].startswith("mmprof_NOUTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_noutil.so"
      buildArgList.insert('-rdynamic ')
      buildArgList.append(mmprofPath+" ")
    elif (argV[2].startswith("mmprof_UTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_util.so"
      buildArgList.append('-rdynamic ')
      buildArgList.append(mmprofPath+" ")
    elif (argV[2].startswith("mmprof_MALLOCNUM")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_mallocnum.so"
      buildArgList.append('-rdynamic ')
      buildArgList.append(mmprofPath+" ")
    else:
      print("mmprof has two versions: mmprof_UTIL and mmprof_NOUTIL", file=sys.stderr)
      sys.exit(-1)

print("Adding memory allocators",file=sys.stderr)


buildArgList.append('-rdynamic ')
buildArgList.append(memoryAllocatorsLibPath[argV[1]]+" ")

print("Removing -Werror", file=sys.stderr)

cflagsLineId = 0
for id, line in enumerate(buildCommand):
    if(line.strip().startswith("CFLAGS")):
        cflagsLineId = id
        startPosi = line.find('=')
        for arg in line[startPosi+1:].strip().split(' '):
            if arg != '-Werror':
                buildArgList.append(arg)
                buildArgList.append(' ')

buildArgList.insert(0,'CFLAGS= ')
buildArgList.append('\n')
print("Final Build args "+str(buildArgList),file=sys.stderr)

buildCommand[cflagsLineId]=''.join(buildArgList)

for line in buildCommand:
    print(line,end='')