#!/bin/bash
set -x
source ../home_var.sh

#for allocator in {"pthread","numalloc","numaaware-tcmalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
for allocator in {"numaaware-tcmalloc",}
do
  echo "begin build $allocator"
  export LD_LIBRARY_PATH=${preload_map[$allocator]}
  ./build.sh $allocator
  for i in `seq 1`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ./httpd.sh start $allocator
    sleep 5
    ./httpd-2.4.23/install/bin/ab -n 1000000 -c 500 http://$local_ip:1978/ >> 'test.out'
    #/usr/bin/time -a -o 'test.out' ./httpd-2.4.35/install/bin/ab -n 1000000 -c 500 http://$local_ip:1978/
    ./httpd.sh stop $allocator >> 'test.out'
    sleep 5
  done
done

