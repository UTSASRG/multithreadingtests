#!/bin/sh

num=81
cur=80

while [ $num -lt 129 ]
do
  sed -i -e s/$cur/$num/g tests/defines.mk

  ./run_benchmarks.py > benchmarksOutput/output$num.txt

  num=`expr $num + 1`
  cur=`expr $cur + 1`
done

