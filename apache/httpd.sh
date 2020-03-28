#!/bin/bash
source ../home_var.sh

if [ $# == 2 ] ; then
  export LD_LIBRARY_PATH=${preload_map[$2]}
fi

if [ $1 == "start" ]; then
  ./httpd-2.4.23/install/bin/httpd -k $1
fi


netstat -lptn | grep httpd

pid=`netstat -lptn 2> /dev/null | grep httpd | grep -o -e [0-9]*\/\.\/httpd | grep -o -e [0-9]*`

_result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
  if [[ "$_result" != "" ]];then
    result=$_result
  fi
echo $result

if [ $1 == "stop" ]; then
  ./httpd-2.4.23/install/bin/httpd -k $1
fi
