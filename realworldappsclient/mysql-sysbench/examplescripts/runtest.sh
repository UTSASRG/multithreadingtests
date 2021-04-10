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

echo "Before running this test, please be sure to launch mysql server first and configure ip and port correctly in config.sh"

echo "Loading benchmark configuration"
source config.sh

#Check parameters
if [ "$#" -ne 0 ]
then
  echo "Usage: ./runtest.sh No extra paramters needed"
  exit 1
fi

#Making build log folder
mkdir -p $BUILD_LOG_FOLDER
echo "Logs will be placed at $BUILD_LOG_FOLDER with timestamp:$BUILD_TIMESTAMP"

cd $SYSBENCH_BENCHMARK_ROOT_DIR

echo "Loading environment variable"
source $SYSBENCH_BENCHMARK_ROOT_DIR/src/benchmarkEnv.sh

echo "Running benchmarks (log prefix: sysbenchruntest_$BUILD_TIMESTAMP)"
cd $SYSBENCH_BENCHMARK_ROOT_DIR/src/src/lua
./oltp_read_only.lua --mysql-port=$MYSQL_SERVER_PORT --mysql-host=$MYSQL_SERVER_IP --mysql-user=root --mysql-password=2oiegrji23rjk1kuh12kj --threads=128 --table_size=10000  run   >> "$BUILD_LOG_FOLDER/sysbenchruntest_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchruntest_$BUILD_TIMESTAMP.err"
funcCheckLog "$BUILD_LOG_FOLDER/sysbenchruntest_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/sysbenchruntest_$BUILD_TIMESTAMP.err" $?


if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
    echo "Executing your after test script $AFTER_TEST_SCRIPT"
    cat $BUILD_LOG_FOLDER/sysbenchruntest_$BUILD_TIMESTAMP.log | $AFTER_TEST_SCRIPT $@
fi

echo "Test complete, use startstopmysql.sh stop BUILD_NAME to see the memory consumption of benchmark result"
