#!/bin/bash
source ../home_var.sh

for allocator in {"pthread","numalloc","tcmalloc","numaaware-tcmalloc","jemalloc","tbbmalloc","scalloc"}
#for allocator in {"scalloc",}
do
  echo "begin build $allocator"
  ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/apache;./build.sh $allocator" > /dev/null
  for i in `seq 5`
  do
    echo "begin test $allocator---$i:" >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/apache;./httpd.sh start $allocator"
    sleep 5
    #/usr/bin/time -a -o 'test.out' ./httpd-2.4.23/install/bin/ab -n 1000000 -c 1000 http://10.242.129.222:1978/
    ./httpd-2.4.23/install/bin/ab -n 1000000 -c 1000 http://$local_ip:1978/ >> 'test.out'
    ssh tpliu@dynaoptimal950.cs.utsa.edu "cd $home/apache;./httpd.sh stop $allocator" >> 'test.out'
    sleep 5
  done
done
