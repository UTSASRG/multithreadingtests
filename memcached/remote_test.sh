#!/bin/bash
source ../home_var.sh

set -x
#for allocator in {"pthread","numalloc","tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc"}
for allocator in {"numalloc",}
do
  echo "begin build $allocator"
  ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/memcached;./build.sh $allocator" > /dev/null
  for i in `seq 1`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/memcached;./memcached.sh start $allocator" &
    sleep 5
    /usr/bin/time -a -o 'test.out' ./run.py
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/memcached;./memcached.sh stop $allocator" >> 'test.out'
    sleep 5
  done
done
