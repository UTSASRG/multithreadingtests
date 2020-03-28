#!/bin/bash
  set -x
  source ../home_var.sh

  rm -rf 'httpd-2.4.23'

  tar -xvf httpd-2.4.23.tar.gz
  tar -xvf apr-1.7.0.tar.gz
  tar -xvf apr-util-1.6.1.tar.gz
  mv apr-util-1.6.1 httpd-2.4.23/srclib/apr-util
  mv apr-1.7.0 httpd-2.4.23/srclib/apr
 # mv httpd-2.4.23 httpd-2.4.23.$i
  cd httpd-2.4.23
  ./configure --with-included-apr --prefix=$home/apache/httpd-2.4.23/install
 # cp ../$config_vars ./build/config_vars.mk
  if [ $# != 0 ] && [ "${lib_with_path_map[$1]}" != "NULL" ]; then
    mv ./build/config_vars.mk ./build/config_vars.mk.bk
    cat ./build/config_vars.mk.bk | sed "s;\-pthread;-rdynamic ${lib_with_path_map[$1]} -pthread;" > ./build/config_vars.mk
  fi
  make
  make install
  #cp ../httpd.conf install/conf/
