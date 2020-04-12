#!/bin/bash
declare -A throughput_map
allocators=("pthread" "numalloc" "tcmalloc" "numaaware-tcmalloc" "jemalloc" "tbbmalloc" "scalloc")
#allocators=("pthread" "numalloc")
run_num=10
for allocator in ${allocators[@]} 
do
  throughput_map[$allocator]=0
  for i in `seq $run_num`:
  do
    throughput=`make eval-$allocator | tee -a out | grep Throughput | grep -o '[0-9]*'`
    echo "throughput of $allocator is $throughput"
    throughput_map[$allocator]=`expr ${throughput_map[$allocator]} + $throughput`
  done
done
echo ""
echo ""
echo ""
echo ""
echo ""
for allocator in ${allocators[@]}
do
  echo -n "$allocator    "
done

echo ""

for allocator in ${allocators[@]}
do
  echo -n `expr ${throughput_map[$allocator]} / $run_num`
  echo -n "    "
done

echo ""
