home=/home/tpliu/xinzhao/multithreadingtests
#local_ip=192.168.1.24
local_ip=10.242.129.222

#user=xin
user=tpliu


declare -A preload_map
#preload_map["tcmalloc"]="/media/umass/datasystem/xin/allocaters/gperftools-2.7/.libs"
#preload_map["numaaware-tcmalloc"]="/media/umass/datasystem/xin/Memoryallocators/NUMA-aware_TCMalloc/.libs"
#preload_map["jemalloc"]="/media/umass/datasystem/xin/allocaters/jemalloc-5.2.1/lib"
#preload_map["scalloc"]="/media/umass/datasystem/xin/allocaters/scalloc-1.0.0/out/Release/lib.target"
#preload_map["tbbmalloc"]="/media/umass/datasystem/xin/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc7.4.0_libc2.27_kernel5.0.0_release"
preload_map["tcmalloc"]="/home/tpliu/xinzhao/allocaters/gperftools-2.7/.libs/"
preload_map["numaaware-tcmalloc"]="/home/tpliu/xinzhao/Memoryallocators/NUMA-aware_TCMalloc/.libs/"
preload_map["jemalloc"]="/home/tpliu/xinzhao/allocaters/jemalloc-5.2.1/lib/"
preload_map["scalloc"]="/home/tpliu/xinzhao/allocaters/scalloc-1.0.0/out/Release/lib.target/"
preload_map["tbbmalloc"]="/home/tpliu/xinzhao/allocaters/tbb-2020.1/build/linux_intel64_gcc_cc8.3.0_libc2.28_kernel4.19.0_release/"
preload_map["pthread"]=""
preload_map["numalloc"]="/home/tpliu/xinzhao/numalloc/source/"
preload_map["libmi"]="/home/tpliu/xinzhao/mimalloc/build/"


declare -A lib_with_path_map
lib_with_path_map["tcmalloc"]="${preload_map["tcmalloc"]}/libtcmalloc.so.4.5.3"
lib_with_path_map["numaaware-tcmalloc"]="${preload_map["numaaware-tcmalloc"]}/libtcmalloc.so"
lib_with_path_map["jemalloc"]="${preload_map["jemalloc"]}/libjemalloc.so"
lib_with_path_map["scalloc"]="${preload_map["scalloc"]}/libscalloc.so"
lib_with_path_map["tbbmalloc"]="${preload_map["tbbmalloc"]}/libtbb.so.2"
lib_with_path_map["pthread"]="NULL"
lib_with_path_map["numalloc"]="${preload_map["numalloc"]}/libnumalloc.so"
lib_with_path_map["libmi"]="${preload_map["libmi"]}/libmimalloc.so"
