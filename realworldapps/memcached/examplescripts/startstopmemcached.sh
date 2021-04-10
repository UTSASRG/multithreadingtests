#!/bin/bash

#Print commands and their arguments while this script is executed
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


echo "Load configuration"
source config.sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./startstopmemcached.sh start BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under \$BUILD_NAME folder)"
  exit -1
fi

cd $MEMCACHED_BENCHMARK_ROOT_DIR
export MEMCACHED_INSTALLATION_FOLDER=$MEMCACHED_BENCHMARK_ROOT_DIR/src/install/$2

if [ ! -d "$MEMCACHED_INSTALLATION_FOLDER" ]; then
    echo "Install with name $2 not found"
    echo "Folder $MEMCACHED_INSTALLATION_FOLDER not exist"
    exit -1;
fi


if [ $1 == "start" ]; then
  if [ $PRE_TEST_SCRIPT != "NULL" ]; then
      echo "Executing your pre-test script $PRE_TEST_SCRIPT"
      #build.sh will pass all it's arguments to environment variable
      $PRE_TEST_SCRIPT $@ 
  fi
  
  echo "Starting memcached server (log prefix: memcachedstart_$BUILD_TIMESTAMP) [Async]"
  cd $MEMCACHED_INSTALLATION_FOLDER/bin
  (./memcached -l 0.0.0.0 -p 11211  >> "$BUILD_LOG_FOLDER/memcachedstart_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/memcachedstart_$BUILD_TIMESTAMP.err" && funcCheckLog "$BUILD_LOG_FOLDER/memcachedstart_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/memcachedstart_$BUILD_TIMESTAMP.err" $? ) &
  sleep 5
  exit 0
fi

if [ $1 == "stop" ]; then
  echo "Getting process pid"
  
  pid=`pgrep memcached --exact`
  
  echo "Collecting performance results from /proc/$pid/status"
  _result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
  if [[ "$_result" != "" ]];then
    result=$_result
  fi

  if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
      echo "Executing your after-test script $PRE_TEST_SCRIPT" > /dev/null
      #build.sh will pass all it's arguments to environment variable
      echo $_result | $AFTER_TEST_SCRIPT $@
  fi

  if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
      echo "Executing your after-test script $PRE_TEST_SCRIPT" > /dev/null
      #build.sh will pass all it's arguments to environment variable
      echo $_result | $AFTER_TEST_SCRIPT $@
  fi

  killall memcached
 
  exit 0
fi


echo "The first parameter has to be either start or stop"
exit -1