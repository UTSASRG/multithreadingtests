#!/bin/bash
#==============================================================================
# Benchmark config zone (changes not recommended)
#==============================================================================

export MAKE_JOB_NUMBER=$((`grep -c ^processor /proc/cpuinfo`-1))

# The folder of root directory. (do not change)
export BENCHMARK_ROOT_DIR $(realpath ${BASH_SOURCE})


#==============================================================================
# User config zone (Please override settings here)
#==============================================================================
