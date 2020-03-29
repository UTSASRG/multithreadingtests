#!/bin/bash
  source ../home_var.sh

  set -x

  rm -rf memcached-1.4.25
  tar xvf memcached-1.4.25.tar
  cd memcached-1.4.25/
  ./configure --prefix=$home/memcached/memcached-1.4.25/install --enable-61bit --with-libevent=$home/memcached/libevent-2.1.8-stable/install/
  cat Makefile | sed 's/\-Werror\ //' > Makefile.bk
  cp Makefile.bk Makefile
  if [ $# != 0 ] && [ "${lib_with_path_map[$1]}" != "NULL" ]; then
    cat Makefile.bk | sed "s;\-pthread;-rdynamic ${lib_with_path_map[$1]} -pthread;" > Makefile
  fi
  #cp ../$config_vars ./Makefile
  make
  make install
