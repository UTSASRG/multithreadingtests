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

memoryAllocatorsLibPath = {"tcmalloc": "tcmalloc.so",
                           "jemalloc": "jemalloc.so"}
                           
#Map memory allocator with the first argument. I susppose there are only one argument. And it must be the name of an allocator
if(not (len(argV) == 2 and argV[1] in memoryAllocatorsLibPath)):
    print("You need to pass one and only one allocator name to build.sh", file=sys.stderr)
    print("Configured allocators:\n" + memoryAllocatorsLibPath, file=sys.stderr)
    sys.exit(-1)

print('Finding CFLAGS in makefile',file=sys.stderr)

buildArgList = []

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

print("Adding my libraries",file=sys.stderr)
buildArgList.append('-rdynamic ')
buildArgList.append(memoryAllocatorsLibPath[argV[1]]+" ")


buildArgList.insert(0,'CFLAGS= ')
buildArgList.append('\n')
buildCommand[cflagsLineId]=''.join(buildArgList)

for line in buildCommand:
    print(line,end='')


