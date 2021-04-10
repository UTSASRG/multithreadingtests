#!/bin/bash

#Print commands and their arguments while this script is executed
#set -x

echo "Checking parameters"

if [ "$#" -ne 1 ]
then
  echo "Usage: AfterBuild_install BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under $BUILD_NAME folder"
  exit 1
fi


cd $MYSQL_BENCHMARK_ROOT_DIR
# Initialize database 
export MYSQL_INSTALLATION_FOLDER=$MYSQL_BENCHMARK_ROOT_DIR/src/install/$1/usr/local/mysql

if [ ! -d "$MYSQL_INSTALLATION_FOLDER" ]; then
    echo "Install with name $1 not found"
    echo "Folder $MYSQL_INSTALLATION_FOLDER not exist"
    exit -1;
fi

echo "Initialize mysql datadir"

echo "Making mysql datadir"
cd $MYSQL_INSTALLATION_FOLDER
rm -rf "data"
mkdir "data"

if [ -f "/tmp/mysql.sock" ]; then
    echo "Mysql socket exists, please kill it manually."
    echo "After that, you need to do the following to continue (Or you could also build again):"
    echo "    cd $MYSQL_BENCHMARK_ROOT_DIR"
    echo "    bash"
    echo "    source config.sh"
    echo "    source ABSOLUTE_PATH_OF_THIS_SCRIPT $1"
    exit 0
fi

echo "Initialize mysql datadir  (log prefix: mysqlinitialize_$BUILD_TIMESTAMP)"
cd $MYSQL_INSTALLATION_FOLDER
./bin/mysqld --initialize-insecure --user=$USER --datadir="`pwd`/data">> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err"

if [ $? -eq 0 ]; then
    echo "Log sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" | sed 's/^/  /'
else
    echo "Error sneakpeek: "| sed 's/^/  /'
    tail -n3 "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err" | sed 's/^/  /'
    exit -1
fi

#create test databases & inite test data
cd $MYSQL_INSTALLATION_FOLDER
echo "Starting mysql server (log prefix: mysqlstartmysqlserver_$BUILD_TIMESTAMP) [Async]"

./bin/mysqld_safe --user=$USER --socket=/tmp/mysql.sock >> "$BUILD_LOG_FOLDER/mysqlstartmysqlserver_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlstartmysqlserver_$BUILD_TIMESTAMP.err" &
sleep 5

echo "Initialize database (log prefix: mysqlinitialize_$BUILD_TIMESTAMP) "

./bin/mysql -u root -S /tmp/mysql.sock < "$MYSQL_BENCHMARK_ROOT_DIR/artifects/create_database.sql" >> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlinitialize_$BUILD_TIMESTAMP.err"
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
source $MYSQL_INSTALLATION_FOLDER/benchmarkEnv.sh
export SYSBENCH_DIR=$MYSQL_BENCHMARK_ROOT_DIR/tools/sysbench/src
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

echo "Turn off mysql (log prefix: mysqlshutdown_$BUILD_TIMESTAMP) [Async]"> /dev/null
cd $MYSQL_INSTALLATION_FOLDER
./bin/mysqladmin shutdown -u root -p2oiegrji23rjk1kuh12kj -S /tmp/mysql.sock >> "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.log" 2>> "$BUILD_LOG_FOLDER/mysqlshutdown_$BUILD_TIMESTAMP.err" & 

cd $MYSQL_BENCHMARK_ROOT_DIR