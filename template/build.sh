#!/bin/bash

APP_NAME=template

#=========================================================================================
# Check parameters
#=========================================================================================

if (( $# < 1 )); then
  echo "Usage: ./build.sh BUILD_NAME"
  exit -1
fi

#=========================================================================================
# Benchmark Initialization
#=========================================================================================

#Print commands and their arguments while this script is executed(-x)
#Exit if there's any error (-e)
#set -x

echo "Loading benchmark configuration"
source config.sh $@

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $TEST_ROOT_DIR


#=========================================================================================
# Run Pre-built script
#=========================================================================================

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    $PRE_BUILD_SCRIPT $@
    funcExitIfErr
fi

#=========================================================================================
# Remove old build
#=========================================================================================

echo "Remove previous build at $INSTALLATION_FOLDER"
#Remove binaries
/bin/rm -rf src/build
#Remove libraries
/bin/rm -rf src/boost_*
#Remove previnstall
/bin/rm -rf $INSTALLATION_FOLDER

#=========================================================================================
# Generate build scripts
#=========================================================================================

echo "Use cmake to build ${APP_NAME} (log prefix: ${APP_NAME}cmake_$BUILD_TIMESTAMP)"
mkdir -p src/build

cd src/build

echo "INSTALLATION_FOLDER=$INSTALLATION_FOLDER"

cmake .. -DBUILD_WITH_TEST_LIB=ON -DTEST_LIB_LOCATION=`realpath ../../lib` -DCMAKE_INSTALL_PREFIX=${INSTALLATION_FOLDER} >> "$BUILD_LOG_FOLDER/${APP_NAME}cmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/${APP_NAME}cmake_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/${APP_NAME}cmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/${APP_NAME}cmake_$BUILD_TIMESTAMP.err" $?


cd ../..

#=========================================================================================
# Run ArgParsing scripts
#=========================================================================================

echo "Backup cmake generated build scirpts"
#Backup old build command
cp src/build/CMakeFiles/testapp.dir/link.txt src/build/CMakeFiles/testapp.dir/link.txt.bkp

#build.sh will pass all it's arguments to environment variable
if [ $BUILD_ARG_PROCESS_SCRIPT != "NULL" ]; then
    echo "Processing build command with your argument parser script\"$BUILD_ARG_PROCESS_SCRIPT\""
    cat "src/build/CMakeFiles/testapp.dir/link.txt.bkp" | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > "src/build/CMakeFiles/testapp.dir/link.txt"
    funcExitIfErr
fi

#=========================================================================================
# Build current application
#=========================================================================================

echo "Start compiling ${APP_NAME} using $MAKE_JOB_NUMBER jobs  (log prefix: ${APP_NAME}make_$BUILD_TIMESTAMP)"
cd src/build

echo "# Ignore everything in this directory" > .gitignore
echo "*" >> .gitignore
echo "# Except this file" >> .gitignore
echo "!.gitignore" >> .gitignore


make -j $MAKE_JOB_NUMBER >> "$BUILD_LOG_FOLDER/${APP_NAME}make_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/${APP_NAME}make_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/${APP_NAME}make_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/${APP_NAME}make_$BUILD_TIMESTAMP.err" $?

cd ../..

#=========================================================================================
# Install current application
#=========================================================================================

#Assume the first argument is the name of allocator
echo "Start installing ${APP_NAME} to local folder  (log prefix: ${APP_NAME}install_$BUILD_TIMESTAMP)"
cd src/build
mkdir -p $INSTALLATION_FOLDER

echo "# Ignore everything in this directory" > $INSTALLATION_FOLDER/.gitignore
echo "*" >> $INSTALLATION_FOLDER/.gitignore
echo "# Except this file" >> $INSTALLATION_FOLDER/.gitignore
echo "!.gitignore" >> $INSTALLATION_FOLDER/.gitignore

make install >> "$BUILD_LOG_FOLDER/${APP_NAME}install_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/${APP_NAME}install_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/${APP_NAME}install_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/${APP_NAME}install_$BUILD_TIMESTAMP.err" $?

cd ../..
echo "${APP_NAME} was installed at $INSTALLATION_FOLDER"

#=========================================================================================
# Write activation script (If user executes, it will setup environment variables directly)
#=========================================================================================

echo "Writing ${APP_NAME} activation script to installation folder"
echo "export PS1=\"(benchmark-${APP_NAME}) \$PS1\"" > $INSTALLATION_FOLDER/benchmarkEnv.sh
echo "export LD_LIBRARY_PATH=$INSTALLATION_FOLDER/lib:\$LD_LIBRARY_PATH" >> $INSTALLATION_FOLDER/benchmarkEnv.sh
echo "export PATH=$INSTALLATION_FOLDER/bin:\$PATH" >>  $INSTALLATION_FOLDER/benchmarkEnv.sh

#=========================================================================================
# Run After-Build Scripts
#=========================================================================================


if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "Executing after build script $AFTER_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    funcExitIfErr
    unset SCRIPT_EXEC_ARG
fi
