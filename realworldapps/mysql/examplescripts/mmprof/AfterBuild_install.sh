#!/bin/bash

#Print commands and their arguments while this script is executed
#set -x

echo "Checking parameters"

if (( $# < 1 ))
then
  echo "This installation script is for mmprof. So a memory allocator name should be passed as the first parameter!"
  exit 1
fi


cd $TEST_ROOT_DIR
# Initialize database 

echo "Initialize mysql datadir"

echo "Making mysql datadir"
cd $INSTALLATION_FOLDER/usr/local/mysql
rm -rf "data"
mkdir "data"

if [ -f "/tmp/mysql.sock" ]; then
    echo "Mysql socket exists, please kill it manually."
    echo "After that, you need to do the following to continue (Or you could also build again):"
    echo "    cd $TEST_ROOT_DIR"
    echo "    bash"
    echo "    source config.sh"
    echo "    source ABSOLUTE_PATH_OF_THIS_SCRIPT $1"
    exit 0
fi

echo "Initialize mysql datadir  (log prefix: mysqlinitialize_$BUILD_TIMESTAMP)"
cd $INSTALLATION_FOLDER/usr/local/mysql
./bin/mysqld --initialize-insecure --user=$USER --datadir="`pwd`/data">> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err"

if [ $? -eq 0 ]; then
    echo "Log sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
else
    echo "Error sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
    exit -1
fi

echo "Initialize database (log prefix: mysqlinitialize_$BUILD_TIMESTAMP)"
#create test databases & inite test data
cd $INSTALLATION_FOLDER/usr/local/mysql
./bin/mysqld_safe --user=$USER --socket=/tmp/mysql.sock >> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err" &
sleep 5
./bin/mysql -u root -S /tmp/mysql.sock < "$TEST_ROOT_DIR/artifects/create_database.sql" >> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err"
./bin/mysqladmin -u root password 2oiegrji23rjk1kuh12kj >> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err"

if [ $? -eq 0 ]; then
    echo "Log sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
else
    echo "Error sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
    exit -1
fi

echo "Initialize sysbench database (log prefix: sysbenchinitialize_$BUILD_TIMESTAMP)"

#Benchmark 
source $INSTALLATION_FOLDER/benchmarkEnv.sh
export SYSBENCH_DIR=$TEST_ROOT_DIR/tools/sysbench/src
source $SYSBENCH_DIR/benchmarkEnv.sh
cd $SYSBENCH_DIR/lua 

./oltp_read_write.lua --mysql-socket=/tmp/mysql.sock --mysql-user=root --mysql-password=2oiegrji23rjk1kuh12kj prepare >> "$BUILD_LOG_FOLDER/sysbenchinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/sysbenchinitialize_$BUILD_TIMESTAMP.err"

if [ $? -eq 0 ]; then
    echo "Log sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/sysbenchinitialize_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
else
    echo "Error sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/sysbenchinitialize_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
    exit -1
fi

sleep 5
echo "Turn off mysql (log prefix: mysqlshutdown_$BUILD_TIMESTAMP)"
cd $INSTALLATION_FOLDER
./bin/mysqladmin shutdown -u root -p2oiegrji23rjk1kuh12kj -S /tmp/mysql.sock >> "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.err" & 
if [ $? -eq 0 ]; then
    echo "Log sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
else
    echo "Error sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
    exit -1
fi

cd $TEST_ROOT_DIR