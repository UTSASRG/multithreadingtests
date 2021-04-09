#!/bin/bash

#Print commands and their arguments while this script is executed
set -x

pkill mysqld
pkill mysqld_safe

cd $MYSQL_BENCHMARK_ROOT_DIR
# Initialize database 
export BUILD_DIR=$MYSQL_BENCHMARK_ROOT_DIR/src/install/$1/usr/local/mysql

echo "Making mysql datadir" > /dev/null
cd $BUILD_DIR
rm -rf "data"
mkdir "data"

echo "Initialize mysql datadir" > /dev/null
./bin/mysqld --initialize-insecure --user=$USER --datadir="`pwd`/data"



echo "====> Initialize database, change password"> /dev/null
#create test databases & inite test data
$BUILD_DIR/bin/mysqld_safe --user=$USER --socket=/tmp/mysql.sock &
sleep 5
$BUILD_DIR/bin/mysql -u root -S /tmp/mysql.sock < "$MYSQL_BENCHMARK_ROOT_DIR/artifects/create_database.sql"
$BUILD_DIR/bin/mysqladmin -u root password 2oiegrji23rjk1kuh12kj

echo "====> Initialize sysbench database"> /dev/null
#Benchmark 
cd $MYSQL_BENCHMARK_ROOT_DIR
export LD_LIBRARY_PATH=$BUILD_DIR/lib
export SYSBENCH_DIR=$MYSQL_BENCHMARK_ROOT_DIR/tools/sysbench/src
export PATH=$PATH:$SYSBENCH_DIR

cd $SYSBENCH_DIR/lua 
./oltp_read_write.lua --mysql-socket=/tmp/mysql.sock --mysql-user=root --mysql-password=2oiegrji23rjk1kuh12kj prepare

echo "====> Turn off mysql"> /dev/null
cd $BUILD_DIR
./bin/mysqladmin shutdown -u root -p2oiegrji23rjk1kuh12kj -S /tmp/mysql.sock &

cd $MYSQL_BENCHMARK_ROOT_DIR