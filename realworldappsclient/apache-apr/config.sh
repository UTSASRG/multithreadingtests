#!/bin/bash

#==============================================================================
# Common functions
#==============================================================================

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

#==============================================================================
# Benchmark config zone (changes not recommended)
#==============================================================================

export APACHE_BENCHMARK_ROOT_DIR=`dirname $(realpath ${BASH_SOURCE})`
cd $APACHE_BENCHMARK_ROOT_DIR
source ../../config.sh

#If no pre build script, pass null
export PRE_BUILD_SCRIPT="NULL"

#This script will be called to process commandline arguments. 
#Please consult  ./testlibs/addExtraArgProcessor.py about how to write commandline parsing processor.
#This path have to be absolute path
export BUILD_ARG_PROCESS_SCRIPT="NULL"

#If no after build script, pass null
export AFTER_BUILD_SCRIPT="NULL"


export PRE_TEST_SCRIPT="NULL"

export AFTER_TEST_SCRIPT="NULL"

export BUILD_LOG_FOLDER="$APACHE_BENCHMARK_ROOT_DIR/logs/build"

export TEST_RESULT_LOG_FOLDER="$APACHE_BENCHMARK_ROOT_DIR/logs/testresult"

#Make sure timestamp is consistent
if [[ -z "${BUILD_TIMESTAMP}" ]]; then
    export BUILD_TIMESTAMP=`date "+%Y%m%d%H%M%S"`
fi

export APACHE_LISTENING_IP=127.0.0.1

export APACHE_LISTENING_PORT=1976

#==============================================================================
# User config zone (Please override settings here)
#==============================================================================

export AFTER_TEST_SCRIPT="$APACHE_BENCHMARK_ROOT_DIR/myscripts/AfterTest_Printresult.sh"

export PRE_TEST_SCRIPT="$APACHE_BENCHMARK_ROOT_DIR/myscripts/PreBuildTest_SetEnv.sh"

export PRE_BUILD_SCRIPT="$APACHE_BENCHMARK_ROOT_DIR/myscripts/PreBuildTest_SetEnv.sh"