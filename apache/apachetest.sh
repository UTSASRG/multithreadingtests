#!/bin/bash

for allocator in {"pthread","numalloc","tcmalloc","jemalloc","tbbmalloc","scalloc"}
do
  for i in `seq 1`
  do
    echo "begin build $allocator"
    rm -rf 'httpd-2.4.23'
    ./build.sh $allocator &> /dev/null
    echo "begin test $allocator---$i"
    ./httpd.sh start $allocator
    time ./httpd-2.4.23/install/bin/ab -n 100000 -c 100 http://10.242.129.222:1978/
    ./httpd.sh stop $allocator
  done
done




#./httpd-2.4.23/install/bin/httpd -k start
#./apache2/bin/ab -n 100000 -c 100 http://192.168.1.2:1978/
#./httpd-2.4.23/install/bin/ab -n 100000 -c 100 http://10.242.129.222:1978/
#./httpd-2.4.23/install/bin/httpd -k stop
