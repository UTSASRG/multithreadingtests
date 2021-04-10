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
rm -rf src/boost_*

echo "Use cmake to build mysql (log prefix: mysqlcmake_$BUILD_TIMESTAMP)"
mkdir -p src/build
mkdir -p src/install/$1/usr/local/mysql/data

cd src/build


cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=`realpath ..` -DMYSQL_DATADIR=`realpath ../install/$1/usr/local/mysql/data` >> "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.err"

funcCheckLog "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/mysqlcmake_$BUILD_TIMESTAMP.err" $?

exit 0

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

funcCheckLog "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/mysqlmake_$BUILD_TIMESTAMP.err" $?

cd ../..


#Assume the first argument is the name of allocator
echo "Start installing mysql to local folder  (log prefix: mysqlinstall_$BUILD_TIMESTAMP)"
cd src/build
make install DESTDIR="`realpath ../install/$1`"  >> "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.err"

funcCheckLog "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/mysqlinstall_$BUILD_TIMESTAMP.err" $?




export MYSQL_INSTALLATION_FOLDER=`realpath ../install/$1/usr/local/mysql`

cd ../..
echo "Mysql installed at $MYSQL_INSTALLATION_FOLDER"

echo "Writing mysql activation script to installation folder"
echo "export PS1=\"(benchmark-mysql) \$PS1\"" > $MYSQL_INSTALLATION_FOLDER/benchmarkEnv.sh
echo "export LD_LIBRARY_PATH=$MYSQL_INSTALLATION_FOLDER/lib:\$LD_LIBRARY_PATH" >> $MYSQL_INSTALLATION_FOLDER/benchmarkEnv.sh
echo "export PATH=$MYSQL_INSTALLATION_FOLDER/bin:\$PATH" >>  $MYSQL_INSTALLATION_FOLDER/benchmarkEnv.sh

echo "Building sysbench (A tool that send requests) (log prefix: sysbenchmake_$BUILD_TIMESTAMP)"> /dev/null

cd $MYSQL_BENCHMARK_ROOT_DIR

cd tools/sysbench
echo "sysbench autogen.sh"
./autogen.sh  >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"
echo "sysbench configure"
./configure  >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"
echo "sysbench make"
make -j $MAKE_JOB_NUMBER   >> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err"

funcCheckLog "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/sysbenchmake_$BUILD_TIMESTAMP.err" $?

echo "Writing sysbench activation script to installation folder"
echo "export PATH=$MYSQL_BENCHMARK_ROOT_DIR/tools/sysbench/src:\$PATH" >  $MYSQL_BENCHMARK_ROOT_DIR/tools/sysbench/src/benchmarkEnv.sh

if [ $AFTER_BUILD_SCRIPT != "NULL" ]; then
    echo "====> Executing after build script $AFTER_BUILD_SCRIPT" > /dev/null
    export SCRIPT_EXEC_ARG=$@
    $AFTER_BUILD_SCRIPT $@
    unset SCRIPT_EXEC_ARG
fi