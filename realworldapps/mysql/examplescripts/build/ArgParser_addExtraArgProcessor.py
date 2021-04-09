#!/usr/bin/python3

#This script simply add $EXTRA_BUILD_ARGS to the end of build command

import sys
import os

#Reading inputs
buildCommand=[]
for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    buildCommand.append(line)

#Check input
if(len(buildCommand)!=1):
    print("The input should have only one line", file=sys.stderr)
    sys.exit(-1)

buildCommand=buildCommand[0].strip()

#Parse arguments
extraBuildArgs=os.environ['EXTRA_BUILD_ARGS']

if(extraBuildArgs!="NULL"):
    buildCommand=buildCommand+" "+extraBuildArgs

# Put final command to stdout. You shouldn't print anything else to stdout.
# Otherwide after I/O redirection you will get wrong result. 
print(buildCommand)