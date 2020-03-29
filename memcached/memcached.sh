#!/bin/bash
source ../home_var.sh

if [ $# == 2 ]; then
  export LD_LIBRARY_PATH=${preload_map[$2]}
fi

if [ $1 == "start" ]; then
  $home/memcached/memcached-1.4.25/install/bin/memcached -l $local_ip -p 11211 &
fi


netstat -lptn | grep memcached

pid=`netstat -lptn 2> /dev/null | grep memcached | grep -o -e [0-9]*\/memcached | grep -o -e [0-9]*`

_result=`cat /proc/$pid/status | grep -e [VH][mu][Hg][We][Mt]` 2> /dev/null
  if [[ "$_result" != "" ]];then
    result=$_result
  fi
echo $result

if [ $1 == "stop" ]; then
  killall memcached
fi
