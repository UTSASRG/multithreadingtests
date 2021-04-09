#!/bin/bash

#Print commands and their arguments while this script is executed
set -x

echo "====> Load configuration" > /dev/null
source config.sh

if [ $1 == "start" ]; then
  if [ $PRE_TEST_SCRIPT != "NULL" ]; then
      echo "====> Executing pre test script $PRE_TEST_SCRIPT" > /dev/null
      #build.sh will pass all it's arguments to environment variable
      $PRE_TEST_SCRIPT $@
  fi

  echo "====> Executing pre test script $PRE_TEST_SCRIPT" > /dev/null

  bin/mysqld_safe --user=$user &
  sleep 5
fi

if [ $1 == "stop" ]; then
  echo "====> Getting process pid" > /dev/null
  netstat -lptn | grep mysqld
  pid=`netstat -lptn 2> /dev/null | grep mysqld | grep -o -e [0-9]*\/mysqld | grep -o -e [0-9]*`

  echo "====> Collecting performance results" > /dev/null
  _result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
  if [[ "$_result" != "" ]];then
    result=$_result
  fi

  if [ $AFTER_TEST_SCRIPT != "NULL" ]; then
      echo "====> Executing pre test script $PRE_TEST_SCRIPT" > /dev/null
      #build.sh will pass all it's arguments to environment variable
      _result | $AFTER_TEST_SCRIPT $@
  fi


  bin/mysqladmin shutdown -u root -p11 -S/tmp/mysql.sock &
  sleep 5
fi
