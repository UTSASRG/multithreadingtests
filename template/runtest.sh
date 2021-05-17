#!/bin/bash


APP_NAME=template

#=========================================================================================
# Check parameters
#=========================================================================================

if (( $# < 2 )); then
  echo "Usage: ./test.sh start BUILD_NAME"
  exit -1
fi

#=========================================================================================
# Benchmark Initialization
#=========================================================================================

echo "Load configuration"
source config.sh ${@:2}

# Check installation

if [ ! -d "$INSTALLATION_FOLDER" ]; then
    echo "Install with name $2 not found"
    echo "Folder $INSTALLATION_FOLDER not exist"
    exit -1;
fi

#=========================================================================================
# Run Pre-test script
#=========================================================================================

if [ $1 == "start" ]; then
    if [ $PRE_TEST_SCRIPT != "NULL" ]; then
        echo "Executing your pre-test script $PRE_TEST_SCRIPT"
        #build.sh will pass all it's arguments to environment variable
        $PRE_TEST_SCRIPT $@ 
    fi

#=========================================================================================
# Load environment variable
#=========================================================================================

    echo "Starting ${APP_NAME} $PRE_TEST_SCRIPT (log prefix: ${APP_NAME}_$BUILD_TIMESTAMP) [Async]"
    cd $INSTALLATION_FOLDER
    source benchmarkEnv.sh

#=========================================================================================
# Run Pre-test script
#=========================================================================================
    mkdir -p $TEST_RESULT_LOG_FOLDER
    /usr/bin/time -f "{ 'real':%e, 'user':%U, 'sys':%S, 'mem(Kb)':%M }" -o $TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.json testapp >>"$TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.log"  2>> "$TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.err"
    funcCheckLog "$TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.log" "$TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.err" $?

    echo "Results placed in $TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.json"
    ln -T "$TEST_RESULT_LOG_FOLDER/${APP_NAME}_$BUILD_TIMESTAMP.json" $TEST_ROOT_DIR/result.json
    exit 0
fi

#This is for realworld applications
# if [ $1 == "start" ]; then
#   if [ $PRE_TEST_SCRIPT != "NULL" ]; then
#       echo "Executing your pre-test script $PRE_TEST_SCRIPT"
#       #build.sh will pass all it's arguments to environment variable
#       $PRE_TEST_SCRIPT $@ 
#   fi
  
#   echo "Starting ${APP_NAME} $PRE_TEST_SCRIPT (log prefix: ${APP_NAME}start_$BUILD_TIMESTAMP) [Async]"
#   cd $INSTALLATION_FOLDER
#   ...
#   sleep 5
#   exit 0
# fi

# if [ $1 == "stop" ]; then
#   echo "Getting process pid"
#   pid=`pgrep PROCESS_NAME --exact`
  
#   echo "Collecting performance results from /proc/$pid/status" > /dev/null
#   _result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
#   if [[ "$_result" != "" ]];then
#     result=$_result
#   fi

#   if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
#       echo "Executing your after-test script $PRE_TEST_SCRIPT" > /dev/null
#       #build.sh will pass all it's arguments to environment variable

#       echo $_result | $AFTER_TEST_SCRIPT $@
#   fi
#   cd $INSTALLATION_FOLDER

#   echo "Shutdown ${APP_NAME} (log prefix: ${APP_NAME}shutdown_$BUILD_TIMESTAMP) [Async]"
#   ...

#   sleep 5
#   exit 0
# fi

#echo "The first parameter has to be either start or stop"

echo "The first parameter has to be either start"
exit -1