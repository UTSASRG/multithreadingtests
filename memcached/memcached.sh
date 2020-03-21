#!/bin/bash


declare -A preload_map
preload_map["tcmalloc"]="/home/tpliu/xinzhao/allocaters/gperftools-2.7/.libs/"
preload_map["numaaware-tcmalloc"]="/home/tpliu/xinzhao/Memoryallocators/NUMA-aware_TCMalloc/.libs/"
preload_map["jemalloc"]="/home/tpliu/xinzhao/allocaters/jemalloc-5.2.1/lib/"
preload_map["scalloc"]="/home/tpliu/xinzhao/allocaters/scalloc-1.0.0/out/Release/lib.target/"
preload_map["tbbmalloc"]="/home/tpliu/xinzhao/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc8.3.0_libc2.28_kernel4.19.0_release/"
if [ $# == 2 ] && [ $2 != "pthread" ] && [ $2 != "numalloc" ]; then
  if [ "" == "${preload_map[$2]}" ]; then
    echo "this lib does not exist:${preload_map[$2]}"
    exit 1
  fi
  export LD_LIBRARY_PATH=${preload_map[$2]}
fi

if [ $1 == "start" ]; then
  /home/tpliu/xinzhao/multithreadingtests/memcached/memcached-1.4.25/install/bin/memcached -l 10.242.129.222 -p 11211 &
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
