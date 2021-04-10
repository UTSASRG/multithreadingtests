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

#make sure there are arguemtns
if('SCRIPT_EXEC_ARG' not in os.environ):
    print("Shell script error. build.sh should pass all its arguemnts to SCRIPT_EXEC_ARG", file=sys.stderr)
    sys.exit(-1)

#Split build arguments by space
argV = list(os.environ['SCRIPT_EXEC_ARG'].split(' '))



memoryAllocatorsLibPath = {"tcmalloc": "tcmalloc.so",
                           "jemalloc": "jemalloc.so"}

#Map memory allocator with the first argument. I susppose there are only one argument. And it must be the name of an allocator
if(not (len(argV) == 1 and argV[0] in memoryAllocatorsLibPath)):
    print("You need to pass one and only one allocator name to build.sh" %(len()), file=sys.stderr)
    print("Configured allocators:\n" +memoryAllocatorsLibPath, file=sys.stderr)
    sys.exit(-1)

#Dynamically select build arg
extraBuildArgs = "-rdynamic "+memoryAllocatorsLibPath[argV[0]]

buildCommand = buildCommand+" "+extraBuildArgs

# Put final command to stdout. You shouldn't print anything else to stdout.
# Otherwide after I/O redirection you will get wrong result.
print(buildCommand)