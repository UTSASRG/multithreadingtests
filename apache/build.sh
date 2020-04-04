#!/bin/bash
  set -x
  source ../home_var.sh

  if [ $# != 0 ] && [ ! -n "${lib_with_path_map[$1]}" ]; then
    echo "unknown allocators: $1"
    exit 1
  fi

  if [ $# != 0 ]; then
    export LD_LIBRARY_PATH=${preload_map[$1]}
  fi

  rm -rf 'httpd-2.4.35'

  tar -xvf httpd-2.4.35.tar.gz
  tar -xvf apr-1.7.0.tar.gz
  tar -xvf apr-util-1.6.1.tar.gz
  mv apr-util-1.6.1 httpd-2.4.35/srclib/apr-util
  mv apr-1.7.0 httpd-2.4.35/srclib/apr
 # mv httpd-2.4.35 httpd-2.4.23.$i
  cd httpd-2.4.35
  ./configure --with-included-apr --prefix=$home/apache/httpd-2.4.35/install
 # cp ../$config_vars ./build/config_vars.mk
  if [ $# != 0 ] && [ "${lib_with_path_map[$1]}" != "NULL" ]; then
    mv ./build/config_vars.mk ./build/config_vars.mk.bk
    cat ./build/config_vars.mk.bk | sed "s;\-pthread;-rdynamic ${lib_with_path_map[$1]} -pthread;" | sed "s;\-lpthread;-rdynamic ${lib_with_path_map[$1]} -lpthread;" | sed 's/^CPPFLAGS =/CPPFLAGS = -Wl,--no-as-needed/' | sed 's/^CFLAGS =/CFLAGS = -Wl,--no-as-needed/' > ./build/config_vars.mk
  fi
  make
  make install
  cat ../httpd.conf | sed "s/#user#/$user/" | sed "s/#local_ip#/$local_ip/" | sed "s;#home#;$home;" > install/conf/httpd.conf
