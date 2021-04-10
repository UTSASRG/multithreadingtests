#!/bin/bash

#Print commands and their arguments while this script is executed(-x)
#Exit if there's any error (-e)
#set -x

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

echo "Loading benchmark configuration"
source config.sh

#Check parameters
if [ "$#" -ne 0 ]
then
  echo "Usage: ./build.sh No extra paramters needed"
  exit 1
fi


#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $SYSBENCH_BENCHMARK_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $PRE_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi

echo "Remove previous build (log prefix: sysbenchmake_$BUILD_TIMESTAMP)"
#Remove binaries
cd src
make clean

cd $SYSBENCH_BENCHMARK_ROOT_DIR

cd src
echo "sysbench autogen.sh"
./autogen.sh  >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"
echo "sysbench configure"
./configure  >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"
echo "sysbench make"
make -j $MAKE_JOB_NUMBER   >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"

funcCheckLog "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err" $?

echo "Writing sysbench activation script to installation folder"
echo "export PATH=$SYSBENCH_BENCHMARK_ROOT_DIR/src/src:\$PATH" >  $SYSBENCH_BENCHMARK_ROOT_DIR/src/benchmarkEnv.sh

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi