#!/bin/bash
source ../home_var.sh

for allocator in {"pthread","numalloc","tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc","libmi"}
#for allocator in {"pthread","tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"numalloc",}
do
  echo "begin build $allocator"
  ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/mysql/;./build.sh $allocator"
  for i in `seq 5`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/mysql/;./mysqld.sh start $allocator" &
    sleep 5
    ./sysbench/sysbench/sysbench --num-threads=128 --max-requests=100000 --test=./sysbench/sysbench/tests/db/oltp.lua --oltp-table-size=10000  --oltp-read-only --mysql-user=root --mysql-host=$local_ip --mysql-port=3306 --mysql-password=11 run >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/mysql/;./mysqld.sh stop $allocator" >> 'test.out' &
    sleep 5
  done
done
