#!/usr/bin/bash

#for i in {8,16,32,64,128}
#do
#  echo "start running cores:$i"
#  cat defines.mk | sed "s/NCORES := .*/NCORES := $i/" > tests/defines.mk
#  ./run_benchmarks.py pthread
#done

#exit 0
#1 node
#cat /home/tpliu/xinzhao/numalloc/binding/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=1/' > /home/tpliu/xinzhao/numalloc/binding/Makefile
#cd /home/tpliu/xinzhao/numalloc/binding/
#make clean
#make

cat /home/tpliu/xinzhao/numalloc/source-scalability/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=1/' > /home/tpliu/xinzhao/numalloc/source-scalability/Makefile
cd /home/tpliu/xinzhao/numalloc/source-scalability/
make clean
make
cd /home/tpliu/xinzhao/multithreadingtests/parsec
#for i in {8,16}
for i in {1,2,4,8,16}
do
  echo "start running cores:$i node:1"
  cat defines.mk | sed "s/NCORES := .*/NCORES := $i/" > tests/defines.mk
  #./run_benchmarks.py numalloc canneal raytrace
  #./run_benchmarks.py threadtest cache-scratch cache-thrash
  cd /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/
  /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/test.sh
done

#2 node
#cat /home/tpliu/xinzhao/numalloc/binding/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=2/' > /home/tpliu/xinzhao/numalloc/binding/Makefile
#cd /home/tpliu/xinzhao/numalloc/binding/
#make clean
#make

cat /home/tpliu/xinzhao/numalloc/source-scalability/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=2/' > /home/tpliu/xinzhao/numalloc/source-scalability/Makefile
cd /home/tpliu/xinzhao/numalloc/source-scalability/
make clean
make
cd /home/tpliu/xinzhao/multithreadingtests/parsec 
for i in {32,64}
do
  echo "start running cores:$i node:2"
  cat defines.mk | sed "s/NCORES := .*/NCORES := $i/" > tests/defines.mk
  #./run_benchmarks.py numalloc canneal raytrace
  #./run_benchmarks.py threadtest cache-scratch cache-thrash
  cd /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/
  /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/test.sh
done



#4 node
#cat /home/tpliu/xinzhao/numalloc/binding/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=4/' > /home/tpliu/xinzhao/numalloc/binding/Makefile
#cd /home/tpliu/xinzhao/numalloc/binding/
#make clean
#make

cat /home/tpliu/xinzhao/numalloc/source-scalability/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=4/' > /home/tpliu/xinzhao/numalloc/source-scalability/Makefile
cd /home/tpliu/xinzhao/numalloc/source-scalability/
make clean
make
cd /home/tpliu/xinzhao/multithreadingtests/parsec 
#for i in {32,64,128}
for i in {64,128}
do
  echo "start running cores:$i node:4"
  cat defines.mk | sed "s/NCORES := .*/NCORES := $i/" > tests/defines.mk
#  ./run_benchmarks.py numalloc canneal raytrace
  #./run_benchmarks.py threadtest cache-scratch cache-thrash
  cd /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/
  /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/test.sh
done







#8 node
#cat /home/tpliu/xinzhao/numalloc/binding/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=8/' > /home/tpliu/xinzhao/numalloc/binding/Makefile
#cd /home/tpliu/xinzhao/numalloc/binding/
#make clean
#make

cat /home/tpliu/xinzhao/numalloc/source-scalability/Makefile.bk | sed 's/-DMAX_USE_NODE=1/-DMAX_USE_NODE=8/' > /home/tpliu/xinzhao/numalloc/source-scalability/Makefile
cd /home/tpliu/xinzhao/numalloc/source-scalability/
make clean
make
cd /home/tpliu/xinzhao/multithreadingtests/parsec 
for i in {128,}
do
  echo "start running cores:$i node:8"
  cat defines.mk | sed "s/NCORES := .*/NCORES := $i/" > tests/defines.mk
  #./run_benchmarks.py numalloc canneal raytrace
  #./run_benchmarks.py threadtest cache-scratch cache-thrash
  cd /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/
  /home/tpliu/xinzhao/multithreadingtests/parsec/tests/larson/test.sh
done




