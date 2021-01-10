#!/usr/bin/bash

export OMP_PLACES=cores
export OMP_PROC_BIND=close
time=10
totalRunningTime=`echo 0 | bc -l`
maxRunningTime=0
minRunningTime=1000000000
for i in `seq $time`
do
  runningTime=`./amg2006 -r 20 20 20 | tee -a /dev/stderr | grep "wall clock time" | tail -n 1 | grep -o '[0-9]*\.[0-9]*' | bc -l`
  if [ `echo "$runningTime > $maxRunningTime" | bc` -eq 1 ]
  then
    maxRunningTime=$runningTime
  fi
  if [ `echo "$runningTime < $minRunningTime" | bc` -eq 1 ]
  then
    minRunningTime=$runningTime
  fi

  totalRunningTime=`echo "$runningTime + $totalRunningTime" | bc -l`
done

echo "minRunningTime:$minRunningTime"
echo "maxRunningTime:$maxRunningTime"
echo -n "average running time:"
echo "($totalRunningTime - $minRunningTime - $maxRunningTime)/ ($time - 2)" | bc -l
