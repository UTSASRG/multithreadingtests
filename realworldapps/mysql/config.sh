#!/bin/bash

#==============================================================================
# Benchmark config zone (changes not recommended)
#==============================================================================

source ../../config.sh

#If no pre build script, pass null
export PRE_BUILD_SCRIPT="NULL"


#This script will be called to process commandline arguments. 
#Please consult  ./testlibs/addExtraArgProcessor.py about how to write commandline parsing processor.
#This path have to be absolute path
export BUILD_ARG_PROCESS_SCRIPT="NULL"

#If no after build script, pass null
export AFTER_BUILD_SCRIPT="NULL"

#==============================================================================
# User config zone (Please override settings here)
#==============================================================================

export BUILD_ARG_PROCESS_SCRIPT="`pwd`/myscripts/addExtraArgProcessorBasedOnArg.py"


