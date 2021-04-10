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
if [ "$#" -ne 1 ]
then
  echo "Usage: ./build.sh BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under $BUILD_NAME folder)"
  exit 1
fi


#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $MEMCACHED_BENCHMARK_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $PRE_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi

echo "Build memcached (log prefix: memcachedbuild_$BUILD_TIMESTAMP)"
cd src

rm -rf install
mkdir install

./autogen.sh  >> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err" $?

./configure --prefix=`pwd`/install/$1 --with-libevent >> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err" $?

#Backup old build command
cp Makefile Makefile.bkp

#build.sh will pass all it's arguments to environment variable
export SCRIPT_EXEC_ARG=$@
if [ $BUILD_ARG_PROCESS_SCRIPT != "NULL" ]; then
    echo "Processing build command with your argument parser \"$BUILD_ARG_PROCESS_SCRIPT\""
    cat ./Makefile.bkp | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > ./Makefile
fi


echo "Start compiling memcached using $MAKE_JOB_NUMBER jobs  (log prefix: memcachedmake_$BUILD_TIMESTAMP)"
make -j $MAKE_JOB_NUMBER >> "$BUILD_LOG_FOLDER/memcachedmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedmake_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/memcachedmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedmake_$BUILD_TIMESTAMP.err" $?

echo "Start installing memcached to local folder  (log prefix: memcachedinstall_$BUILD_TIMESTAMP)"
make install  >> "$BUILD_LOG_FOLDER/memcachedinstall_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedinstall_$BUILD_TIMESTAMP.err"

funcCheckLog "$BUILD_LOG_FOLDER/memcachedinstall_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedinstall_$BUILD_TIMESTAMP.err" $?

echo "Writing memcached activation script to installation folder"
echo "export PS1=\"(benchmark-memcached) \$PS1\"" > `pwd`/install/$1/benchmarkEnv.sh
echo "export PATH=`pwd`/install/$1/bin:\$PATH" >>  `pwd`/install/$1/benchmarkEnv.sh

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi