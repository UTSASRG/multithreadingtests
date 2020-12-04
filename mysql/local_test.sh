#!/bin/bash
source ../home_var.sh

for allocator in {"pthread","numalloc","tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc","libmi"}
#for allocator in {"tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"numalloc",}
do
  echo "begin build $allocator"
  ./build.sh $allocator > /dev/null
  for i in `seq 5`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ./mysqld.sh start $allocator &
    sleep 10
    ./sysbench/sysbench/sysbench --num-threads=128 --max-requests=100000 --test=./sysbench/sysbench/tests/db/oltp.lua --oltp-table-size=10000  --oltp-read-only --mysql-user=root --mysql-host=$local_ip --mysql-port=3306 --mysql-password=11 run >> 'test.out'
    ./mysqld.sh stop $allocator >> 'test.out' &
    sleep 10
  done
done

