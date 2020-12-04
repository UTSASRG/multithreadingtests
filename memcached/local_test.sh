#!/bin/bash
set -x                         
for allocator in {"pthread","numalloc","numaaware-tcmalloc","tcmalloc","jemalloc","tbbmalloc","scalloc","libmi"}
#for allocator in {"numaaware-tcmalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"numalloc",}
do
  echo "begin build $allocator"
  ./build.sh $allocator > /dev/null
  for i in `seq 5`             
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ./memcached.sh start $allocator &
    sleep 5                    
    /usr/bin/time -a -o 'test.out' ./run.py
    ./memcached.sh stop $allocator >> 'test.out'
    sleep 5                    
  done
done
