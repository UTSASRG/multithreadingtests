#!/bin/bash

  rm -rf 'mysql-5.7.15/'
  rm -rf 'sysbench'
  
#  config_vars=config_vars.mk

  #if [ $# == 1 ]; then
  #  config_vars=$config_vars.$1
  #fi

  #if [ ! -f $config_vars ]; then
  #  echo "$config_vars does not exists" 
  #  exit 1
  #fi

  # install sysbench
  tar -xvf sysbench.tar.gz
  cd sysbench
  ./configure
  make
  cd ../
  # install mysql
  tar zxvf mysql-boost-5.7.15.tar.gz
  cd mysql-5.7.15/
  cmake -DWITH_BOOST=boost .
  make
  make install DESTDIR='/home/tpliu/xinzhao/multithreadingtests/mysql/mysql-5.7.15/install'
  # inite mysql 
  cd /home/tpliu/xinzhao/multithreadingtests/mysql/mysql-5.7.15/install/usr/local/mysql/
  ./bin/mysqld --initialize --user=tpliu --datadir='/home/tpliu/xinzhao/multithreadingtests/mysql/mysql-5.7.15/install/usr/local/mysql/data' --basedir='/home/tpliu/xinzhao/multithreadingtests/mysql/mysql-5.7.15/install/usr/local/mysql'
  #create test databases & inite test data
  bin/mysqld_safe --user=tpliu &
  mysql -u root -p11 -S /tmp/mysql.sock < /home/tpliu/xinzhao/multithreadingtests/mysql/create_database.sql

