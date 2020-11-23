#!/bin/bash
RUN_TIME=5
count=0
average=0
for i in `cat test.out | grep -e 'Time per request:.*(mean)' | grep -o '[0-9]*\.[0-9]*'`
do
  #echo $i
  average=`echo "$average + $i" | bc`
  count=`echo "$count + 1" | bc`
  #if [ `echo "$count==5" | bc` ]
  if [ $count -eq 5 ]
  then
    echo "$average/$RUN_TIME" | bc -l
    count=0
    average=0
  fi
done
