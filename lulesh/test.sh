#!/usr/bin/bash

listDefine='P1094 P1095 P1096 P1029 P1030 P1031 P543 P544 P545 P2251 P2252 P2253 P2254 P2255 P2256 P2257 P2258 P2259 P2260 P2261 P2262'
runningList=$listDefine
#runningList='P2258 P2254 P2255 P1030 P1096'
for j in $listDefine
do
  export $j=0
done
make clean
make
echo "===========run original one"
./run.sh
echo "===========finish run original one"

for i in $runningList
do
  for j in $listDefine
  do
    export $j=0
  done

  export $i=1
  make clean
  make
  echo "===========run $i"
  ./run.sh
  echo "===========finish running $i"
done

