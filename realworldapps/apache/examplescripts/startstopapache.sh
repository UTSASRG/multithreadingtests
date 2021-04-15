#!/bin/bash

#Print commands and their arguments while this script is executed
#set -x

echo "Load configuration"
source config.sh ${@:2} # Skip start/stop parameter

if (( $# < 2 )); then
  echo "Usage: ./startstopapache.sh start BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under \$BUILD_NAME folder)"
  exit -1
fi

mkdir -p $BUILD_LOG_FOLDER

cd $TEST_ROOT_DIR

if [ ! -d "$INSTALLATION_FOLDER" ]; then
    echo "Folder $INSTALLATION_FOLDER not exist"
    exit -1;
fi


if [ $1 == "start" ]; then
  if [ $PRE_TEST_SCRIPT != "NULL" ]; then
      echo "Executing your pre-test script $PRE_TEST_SCRIPT"
      #build.sh will pass all it's arguments to environment variable
      $PRE_TEST_SCRIPT $@ 
  fi
  
  echo "Starting apache server"
  cd $INSTALLATION_FOLDER
  

  echo "Starting apache server (log prefix: apachestart_$BUILD_TIMESTAMP) [Async]"
  (./bin/httpd -X -k start  >> "$BUILD_LOG_FOLDER/apachestart_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/apachestart_$BUILD_TIMESTAMP.err" && funcCheckLog "$BUILD_LOG_FOLDER/apachestart_$BUILD_TIMESTAMP.log" "$BUILD_LOG_FOLDER/apachestart_$BUILD_TIMESTAMP.err" $? ) &

  exit 0
fi

if [ $1 == "stop" ]; then
  echo "Getting process pid"
  
  pid=`pgrep httpd --exact`
  
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

  cd $INSTALLATION_FOLDER
  ./bin/httpd -k stop
 
  exit 0
fi


echo "The first parameter has to be either start or stop"
exit -1