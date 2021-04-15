#!/bin/bash

#Print commands and their arguments while this script is executed(-x)
#Exit if there's any error (-e)
#set -x

echo "Loading benchmark configuration"
source config.sh $@


#We don't check parameter here. Arg parser script will check parameters

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $TEST_ROOT_DIR

#Remove binaries
echo "Remove previous build at $INSTALLATION_FOLDER"
rm -rf $INSTALLATION_FOLDER
mkdir -p $INSTALLATION_FOLDER

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    $PRE_BUILD_SCRIPT $@
    funcExitIfErr
fi

cd src
make clean >/dev/null 2>/dev/null
cd ..

echo "Copying apr apr-util to srclib folder"
cp -r $TEST_ROOT_DIR/libs/apr ./src/srclib
cp -r $TEST_ROOT_DIR/libs/apr-util ./src/srclib

echo "Use buildconf to generate build configure (log prefix apachebuildconf_$BUILD_TIMESTAMP.log)"
cd src
./buildconf  >> "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apachebuildconf_$BUILD_TIMESTAMP.err" $?

echo "Use configure to generate (log prefix apacheconfigure_$BUILD_TIMESTAMP.log)"
./configure --prefix=$INSTALLATION_FOLDER >> "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apacheconfigure_$BUILD_TIMESTAMP.err" $?

echo "Use configure to generate (log prefix apacheconfigure_$BUILD_TIMESTAMP.log)"

#build.sh will pass all it's arguments to environment variable
if [ $BUILD_ARG_PROCESS_SCRIPT != "NULL" ]; then
    echo "Processing build command with your argument parser \"$BUILD_ARG_PROCESS_SCRIPT\""
    cp ./build/config_vars.mk ./build/config_vars.mk.bk
    cat ./build/config_vars.mk.bk | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > ./build/config_vars.mk
    funcExitIfErr
fi

echo "Start compiling apache using $MAKE_JOB_NUMBER jobs  (log prefix: apachemake_$BUILD_TIMESTAMP)"
make -j $MAKE_JOB_NUMBER >> "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apachemake_$BUILD_TIMESTAMP.err" $?

echo "Start installing apache  (log prefix: apacheinstall_$BUILD_TIMESTAMP)"
make install  >> "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apacheinstall_$BUILD_TIMESTAMP.err" $?

echo "Writing apache activation script to installation folder"
echo "export PATH=$TEST_ROOT_DIR/bin:\$PATH" >  $TEST_ROOT_DIR/tools/sysbench/src/benchmarkEnv.sh
echo "export LD_LIBRARY_PATH=$TEST_ROOT_DIR/lib:\$LD_LIBRARY_PATH" >>  $TEST_ROOT_DIR/tools/sysbench/src/benchmarkEnv.sh


cd $TEST_ROOT_DIR

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    $AFTER_BUILD_SCRIPT $@
    funcExitIfErr
fi