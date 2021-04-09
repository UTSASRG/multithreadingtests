#!/bin/bash

#Print commands and their arguments while this script is executed(-x)
#Exit if there's any error (-e)
set -e

echo "Loading benchmark configuration"
source config.sh

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

#Change directory to root directory
cd $MYSQL_BENCHMARK_ROOT_DIR

if [ $PRE_BUILD_SCRIPT != "NULL" ]; then
    #build.sh will pass all it's arguments to environment variable
    echo "Executing pre build script $PRE_BUILD_SCRIPT"
    export SCRIPT_EXEC_ARG=$@
    $PRE_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi

echo "Remove previous build"
#Remove binaries
rm -rf src/build
#Remove libraries
rm -f src/boost_*.tar.gz

echo "Use cmake to build mysql (log prefix: mysqlcmake_$BUILD_TIMESTAMP)"
mkdir -p src/build
cd src/build

cmake .. -DOWNLOAD_BOOST=1 -DWITH_BOOST=.. >> "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.err"

echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.err" | sed 's/^/  /'

cd ../..

echo "Backup cmake generated build scirpts"
#Backup old build command
mv src/build/sql/CMakeFiles/mysqld.dir/link.txt src/build/sql/CMakeFiles/mysqld.dir/link.txt.bkp

#build.sh will pass all it's arguments to environment variable
export SCRIPT_EXEC_ARG=$@
if [ $BUILD_ARG_PROCESS_SCRIPT != "NULL" ]; then
    echo "Processing build command with your argument parser \"$BUILD_ARG_PROCESS_SCRIPT\""
    cat "src/build/sql/CMakeFiles/mysqld.dir/link.txt.bkp" | ${BUILD_ARG_PROCESS_SCRIPT}  $@ > "src/build/sql/CMakeFiles/mysqld.dir/link.txt"
fi

echo "Start compiling mysql using $MAKE_JOB_NUMBER jobs  (log prefix: mysqlmake_$BUILD_TIMESTAMP)"
cd src/build

make -j $MAKE_JOB_NUMBER >> "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.err"

cd ../..
echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.err" | sed 's/^/  /'


#Assume the first argument is the name of allocator
echo "Start installing mysql to local folder  (log prefix: mysqlinstall_$BUILD_TIMESTAMP)"
cd src/build
make install DESTDIR="`realpath ../install/$1`"  >> "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.err"
export MYSQL_INSTALLATION_FOLDER=`realpath ../install/$1/usr/local/mysql`

echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
cd ../..
echo "Mysql installed at $MYSQL_INSTALLATION_FOLDER"

echo "Writing mysql activation script to installation folder"
echo "export PS1=\"(benchmark-mysql) \$PS1\"" > $MYSQL_INSTALLATION_FOLDER/bechmarkEnv.sh
echo "export LD_LIBRARY_PATH=$MYSQL_INSTALLATION_FOLDER/lib:$LD_LIBRARY_PATH" >> $MYSQL_INSTALLATION_FOLDER/bechmarkEnv.sh
echo "export PATH=$MYSQL_INSTALLATION_FOLDER/bin:$PATH" >>  $MYSQL_INSTALLATION_FOLDER/bechmarkEnv.sh 

echo "Building sysbench (A tool that send requests) (log prefix: sysbench(autogen/configure/make)_$BUILD_TIMESTAMP)"> /dev/null

cd $MYSQL_BENCHMARK_ROOT_DIR

cd tools/sysbench
echo "sysbench autogen.sh"
./autogen.sh  >> "$BUILD_LOG_FOLDER/sysbenchautogen_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchautogen_$BUILD_TIMESTAMP.err"

echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchautogen_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchautogen_$BUILD_TIMESTAMP.err" | sed 's/^/  /'

echo "sysbench configure"
./configure  >> "$BUILD_LOG_FOLDER/sysbenchconfigure_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchconfigure_$BUILD_TIMESTAMP.err"

echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchconfigure_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchconfigure_$BUILD_TIMESTAMP.err" | sed 's/^/  /'

echo "sysbench make"
make -j $MAKE_JOB_NUMBER   >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"

echo "Log sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
echo "Error sneakpeak: "| sed 's/^/  /'
tail -n3 "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err" | sed 's/^/  /'

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "====> Executing after build script $AFTER_BUILD_SCRIPT" > /dev/null
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi