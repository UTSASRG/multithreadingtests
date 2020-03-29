#!/bin/bash

set -x
source ../home_var.sh

if [ $# == 2 ]; then
  export LD_LIBRARY_PATH=${preload_map[$2]}
fi

cd "$home/mysql/mysql-5.7.15/install/usr/local/mysql/"

if [ $1 == "start" ]; then
  bin/mysqld_safe --user=$user &
  sleep 5
fi


netstat -lptn | grep mysqld

pid=`netstat -lptn 2> /dev/null | grep mysqld | grep -o -e [0-9]*\/mysqld | grep -o -e [0-9]*`

_result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
  if [[ "$_result" != "" ]];then
    result=$_result
  fi
echo $result

if [ $1 == "stop" ]; then
  bin/mysqladmin shutdown -u root -p11 -S/tmp/mysql.sock &
  sleep 5
fi
