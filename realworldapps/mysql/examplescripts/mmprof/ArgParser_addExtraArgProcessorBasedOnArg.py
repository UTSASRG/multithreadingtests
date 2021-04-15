#!/usr/bin/python3

#This script is an add $EXTRA_BUILD_ARGS to the end of build command.
#But the library added is specified by build script arguments

import sys
import os

#Reading inputs
buildCommand = []
for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    buildCommand.append(line)

#Check input
if(len(buildCommand) != 1):
    print("The input should have only one line, got %d" %
          (len(buildCommand)), file=sys.stderr)
    sys.exit(-1)

buildCommand = buildCommand[0].strip()

#Split build arguments by space
argV = sys.argv

MY_ARTIFECTS_DIR=os.environ['BENCHMARK_ROOT_DIR']+'/myartifects'
memoryAllocatorsLibPath = {"hoard": MY_ARTIFECTS_DIR+"/libhoard.so",
                           "libc221": MY_ARTIFECTS_DIR+"/libmalloc221.so",
                           "libc228":MY_ARTIFECTS_DIR+"/libmalloc228.so",
                           "tcmalloc":MY_ARTIFECTS_DIR+"/libtcmalloc_minimal.so",
                           "jemalloc":MY_ARTIFECTS_DIR+"/libjemalloc.so"}

if (len(argV) ==3):
   if(argV[2].startswith("mmprof_NOUTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_noutil.so"
   elif (argV[2].startswith("mmprof_UTIL")):
      mmprofPath=MY_ARTIFECTS_DIR+"/libmallocprof_util.so"
   else:
      print("mmprof has two versions: mmprof_UTIL and mmprof_NOUTIL", file=sys.stderr)
      sys.exit(-1)

#Map memory allocator with the first argument. I susppose there are only one argument. And it must be the name of an allocator
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

#Dynamically select build arg
extraBuildArgs = None
if(sys.argv[-1].startswith('mmprof')):
    extraBuildArgs = " -rdynamic "+mmprofPath+" -rdynamic " + memoryAllocatorsLibPath[argV[1]]
else:
    extraBuildArgs = " -rdynamic "+memoryAllocatorsLibPath[argV[1]]

buildCommand = buildCommand+" "+extraBuildArgs

# Put final command to stdout. You shouldn't print anything else to stdout.
# Otherwide after I/O redirection you will get wrong result.
print(buildCommand)
