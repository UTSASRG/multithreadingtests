#!/bin/bash

count=0;

while true
do
	echo "$count" > ./testlog
	./streamcluster-lockperf 10 20 128 16384 16384 1000 none output.txt 8	
	let "count+=1"
done
