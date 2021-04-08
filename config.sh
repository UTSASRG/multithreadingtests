#!/bin/bash
# Benchmark config zone (changes not recommended)

export MAKE_JOB_NUMBER=$((`grep -c ^processor /proc/cpuinfo`-1))

# User config zone (Please override settings here)