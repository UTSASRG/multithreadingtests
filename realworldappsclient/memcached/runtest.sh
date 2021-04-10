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

echo "Before running this test, please be sure to launch memcached server first and configure ip and port correctly in config.sh"

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

cd $MEMCACHED_BENCHMARK_ROOT_DIR

mkdir -p $TEST_RESULT_LOG_FOLDER

echo "Running benchmarks (log prefix: memcacheruntest_$BUILD_TIMESTAMP)"

cd libs


for i in `seq 5`             
  do
    echo "begin test ---$i:" >> "$TEST_RESULT_LOG_FOLDER/memcacheruntest_$BUILD_TIMESTAMP"
    /usr/bin/time -a -o "$TEST_RESULT_LOG_FOLDER/memcacheruntest_$BUILD_TIMESTAMP" ./run.py
    sleep 5                    
done


if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
    echo "Executing your after test script $AFTER_TEST_SCRIPT"
    cat $TEST_RESULT_LOG_FOLDER/memcacheruntest_$BUILD_TIMESTAMP | $AFTER_TEST_SCRIPT $@
fi


echo "These results are time on the client side. If you want to know server side metric you need to run startstopmemcached.sh stop BUILD_NAME"
