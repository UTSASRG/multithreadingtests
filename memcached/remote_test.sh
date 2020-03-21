#!/bin/bash
set -x
for allocator in {"pthread","numalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"scalloc",}
do
  for i in `seq 1`
  do
    echo "begin build $allocator"
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/memcached;./build.sh $allocator" > /dev/null
    echo "begin test $allocator---$i:" >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/memcached;./memcached.sh start $allocator" &
    sleep 5
    /usr/bin/time -a -o 'test.out' ./run.py
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/memcached;./memcached.sh stop $allocator" >> 'test.out'
  done
done
