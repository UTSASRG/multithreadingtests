#!/bin/bash

#Print commands and their arguments while this script is executed(-x)
#Exit if there's any error (-e)
#set -x


echo "Loading benchmark configuration"
source config.sh

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $TEST_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $PRE_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi

echo "Build memcached (log prefix: memcachedbuild_$BUILD_TIMESTAMP)"
cd src

echo "Remove previous build at $INSTALLATION_FOLDER"
make clean

rm -rf $INSTALLATION_FOLDER
mkdir $INSTALLATION_FOLDER

./autogen.sh  >> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err" $?

./configure --prefix=$INSTALLATION_FOLDER --with-libevent >> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedbuild_$BUILD_TIMESTAMP.err"
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
echo "export PS1=\"(benchmark-memcached) \$PS1\"" > $INSTALLATION_FOLDER/benchmarkEnv.sh
echo "export PATH=$INSTALLATION_FOLDER/bin:\$PATH" >>  $INSTALLATION_FOLDER/benchmarkEnv.sh

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi
