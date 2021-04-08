#!/bin/bash
set -x

source config.sh

  if [ $# != 0 ] && [ ! -n "${lib_with_path_map[$1]}" ]; then
    echo "unknown allocators: $1"
    exit 1
  fi
  
  if [ $# != 0 ]; then
    export LD_LIBRARY_PATH=${preload_map[$1]}
  fi

  rm -rf 'mysql-5.7.15/'
  rm -rf 'sysbench'
  
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

  if [ $# != 0 ] && [ "${lib_with_path_map[$1]}" != "NULL" ]; then
    mv "$home/mysql/mysql-5.7.15/sql/CMakeFiles/mysqld.dir/link.txt" "$home/mysql/mysql-5.7.15/sql/CMakeFiles/mysqld.dir/link.txt.bk"
    cat "$home/mysql/mysql-5.7.15/sql/CMakeFiles/mysqld.dir/link.txt.bk" | sed "s;\-lpthread;-rdynamic ${lib_with_path_map[$1]} -lpthread;g" > "$home/mysql/mysql-5.7.15/sql/CMakeFiles/mysqld.dir/link.txt"
  fi

  make
  make install DESTDIR="$home/mysql/mysql-5.7.15/install"


  # inite mysql 
  cd "$home/mysql/mysql-5.7.15/install/usr/local/mysql/"
  ./bin/mysqld --initialize --user=tpliu --datadir="$home/mysql/mysql-5.7.15/install/usr/local/mysql/data" --basedir="$home/mysql/mysql-5.7.15/install/usr/local/mysql"


  #create test databases & inite test data
  bin/mysqld_safe --user=$user &
  sleep 5
  mysql -u root -p11 -S /tmp/mysql.sock < "$home/mysql/create_database.sql"
  $home/mysql/sysbench/sysbench/sysbench --test=$home/mysql/sysbench/sysbench/tests/db/oltp.lua --oltp-table-size=10000 --mysql-socket=/tmp/mysql.sock --mysql-user=root --mysql-password=11 prepare
  bin/mysqladmin shutdown -u root -p11 -S/tmp/mysql.sock &
  sleep 5
