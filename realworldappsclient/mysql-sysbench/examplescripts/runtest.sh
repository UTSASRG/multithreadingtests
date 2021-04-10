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
  echo "Usage: ./runtest.sh No extra paramters needed"
  exit 1
fi

cd $SYSBENCH_BENCHMARK_ROOT_DIR

echo "Loading environment variable"
source $SYSBENCH_BENCHMARK_ROOT_DIR/src/benchmarkEnv.sh

cd $SYSBENCH_BENCHMARK_ROOT_DIR/src/src/lua
./oltp_read_only.lua --mysql-port=$MYSQL_SERVER_PORT --mysql-host=$MYSQL_SERVER_IP --mysql-user=root --mysql-password=2oiegrji23rjk1kuh12kj --threads=128 --table_size=10000  run
