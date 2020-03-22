#!/bin/bash

for allocator in {"pthread","numalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"scalloc",}
do
  echo "begin build $allocator"
  ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./build.sh $allocator" > /dev/null
  for i in `seq 1`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./httpd.sh start $allocator"
    /usr/bin/time -a -o 'test.out' ./httpd-2.4.23/install/bin/ab -n 1000000 -c 1000 http://10.242.129.222:1978/
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd /home/tpliu/xinzhao/multithreadingtests/apache;./httpd.sh stop $allocator" >> 'test.out'
  done
done
