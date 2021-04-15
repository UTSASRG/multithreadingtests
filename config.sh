#!/bin/bash

#==============================================================================
# Common Functions
#==============================================================================


concatenateArgs (){
    string=""
    for a in "$@" # Loop over arguments
    do
        if [[ "${a:0:1}" != "-" ]] # Ignore flags (first character is -)
        then
            if [[ "$string" != "" ]]
            then
                string+="_" # Delimeter
            fi
            string+="$a"
        fi
    done
    echo "$string"
}

funcExitIfErr(){
    retVal=$?
    if [ $retVal -ne 0 ]; then
        exit -1
    fi
}

funcCheckLog () {
    #logName,errorLogName,retValue

    if [ $3 -eq 0 ]; then
        echo "Log sneakpeek: "| sed 's/^/  /'
        tail -n3 $1 | sed 's/^/  /'
    else
        echo "Error sneakpeek: "| sed 's/^/  /'
        tail -n3 $2 | sed 's/^/  /'
        exit -1
    fi
}

#==============================================================================
# Benchmark config zone (changes not recommended)
#==============================================================================

export MAKE_JOB_NUMBER=$((`grep -c ^processor /proc/cpuinfo`-1))

# The folder of root directory. (do not change)
export BENCHMARK_ROOT_DIR=`dirname $(realpath ${BASH_SOURCE})`

#==============================================================================
# User config zone (Please override settings here)
#==============================================================================

