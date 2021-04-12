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
  echo "Usage: ./build.sh"
  exit 1
fi

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $APACHE_BENCHMARK_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    $PRE_BUILD_SCRIPT $@
fi

echo "Remove previous build"
#Remove binaries
rm -rf src/install

mkdir -p src/install

echo "Use buildconf to generate build configure (log prefix apachebuildconf_$BUILD_TIMESTAMP.log)"
cd src
./buildconf --with-apr=`realpath ../libs/apr`>> "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.err" $?

echo "Use configure to generate (log prefix apacheconfigure_$BUILD_TIMESTAMP.log)"
./configure --with-included-apr --prefix=$APACHE_BENCHMARK_ROOT_DIR/src/install >> "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.err" $?

echo "Use configure to generate (log prefix apacheconfigure_$BUILD_TIMESTAMP.log)"

#build.sh will pass all it's arguments to environment variable (Normally we don't need to change anything here)
if [ $BUILD_ARG_PROCESS_SCRIPT != "NULL" ]; then
    echo "Processing build command with your argument parser \"$BUILD_ARG_PROCESS_SCRIPT\""
    cp ./build/config_vars.mk ./build/config_vars.mk.bk
    cat ./build/config_vars.mk.bk | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > ./build/config_vars.mk
fi

echo "Start compiling apache using $MAKE_JOB_NUMBER jobs  (log prefix: apachemake_$BUILD_TIMESTAMP)"
make -j $MAKE_JOB_NUMBER >> "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.err" $?

echo "Start installing apache  (log prefix: apacheinstall_$BUILD_TIMESTAMP)"
make install  >> "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.err" $?

cd $APACHE_BENCHMARK_ROOT_DIR

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi