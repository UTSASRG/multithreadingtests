#!/bin/bash

for allocator in {"pthread","numalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
do
  for i in `seq 1`
  do
    echo "begin build $allocator"
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./build.sh $allocator" > /dev/null
    echo "begin test $allocator---$i"
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./httpd.sh start $allocator"
    time ./httpd-2.4.23/install/bin/ab -n 1000000 -c 1000 http://10.242.129.222:1978/
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./httpd.sh stop $allocator"
  done
done
