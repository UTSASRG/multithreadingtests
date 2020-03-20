#!/bin/bash

for i in {'pthread',}
do
  tar -xvf httpd-2.4.23.tar.gz
  tar -xvf apr-1.7.0.tar.gz
  tar -xvf apr-util-1.6.1.tar.gz
  mv apr-util-1.6.1 httpd-2.4.23/srclib/apr-util
  mv apr-1.7.0 httpd-2.4.23/srclib/apr
 # mv httpd-2.4.23 httpd-2.4.23.$i
  cd httpd-2.4.23
  ./configure --with-included-apr --prefix=/home/tpliu/xinzhao/multithreadingtests/apache/httpd-2.4.23/install
  make
  make install
  cp ../httpd.conf install/conf/
done
