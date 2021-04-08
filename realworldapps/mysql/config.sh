#!/bin/bash

#==============================================================================
# Benchmark config zone (changes not recommended)
#==============================================================================

source ../../config.sh

# This command will be added to build command
export EXTRA_BUILD_ARGS=""

#If no pre build script, pass null
export PRE_BUILD_SCRIPT="NULL"


#This script will be called to process commandline arguments. 
#By default, it will add $EXTRA_BUILD_ARGS to the command line
#You could change this argument to use your own script to custommized build behavior.
#Please consult  ./testlibs/addExtraArgProcessor.py about how to write commandline parsing processor.
#This path have to be absolute path
export BUILD_ARG_PROCESS_SCRIPT="`pwd`/myscripts/addExtraArgProcessor.py"

#If no after build script, pass null
export AFTER_BUILD_SCRIPT="NULL"

#==============================================================================
# User config zone (Please override settings here)
#==============================================================================

export BUILD_ARG_PROCESS_SCRIPT="`pwd`/myscripts/addExtraArgProcessorBasedOnArg.py"


