#!/bin/bash

#Print commands and their arguments while this script is executed
set -xe

echo "====> Load configuration" > /dev/null
source config.sh

#Change directory to root directory
cd $MYSQL_BENCHMARK_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    echo "====> Executing pre build script $PRE_BUILD_SCRIPT" > /dev/null
    #build.sh will pass all it's arguments to environment variable
    export SCRIPT_EXEC_ARG=$@
    $PRE_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi


echo "====> Remove previous build" > /dev/null
rm -rf src/build

# Let cmake generate makefile
mkdir -p src/build
cd src/build
cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=..
cd ../..

echo "====> Adding custom build option to mysqld makefile" > /dev/null
#Backup old build command
mv src/build/sql/CMakeFiles/mysqld.dir/link.txt src/build/sql/CMakeFiles/mysqld.dir/link.txt.bkp

#build.sh will pass all it's arguments to environment variable
export SCRIPT_EXEC_ARG=$@
echo "====> Processing build command with script \"$BUILD_ARG_PROCESS_SCRIPT\"" > /dev/null
cat "src/build/sql/CMakeFiles/mysqld.dir/link.txt.bkp" | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > "src/build/sql/CMakeFiles/mysqld.dir/link.txt"
#Unset env variable
unset SCRIPT_EXEC_ARG

echo "====> Start compiling mysql"> /dev/null

cd src/build
make -j $MAKE_JOB_NUMBER
cd ../..

#Assume the first argument is the name of allocator

cd src/build
make install DESTDIR="`realpath ../install/$1`"
cd ../..

echo "====> Building sysbench (A tool that send requests)"> /dev/null

cd $MYSQL_BENCHMARK_ROOT_DIR
export PATH=$PATH:`realpath ./src/install/$1/usr/local/mysql/bin`
cd tools/sysbench
./autogen.sh
./configure

make -j $MAKE_JOB_NUMBER


if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "====> Executing after build script $AFTER_BUILD_SCRIPT" > /dev/null
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi
