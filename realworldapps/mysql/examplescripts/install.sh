#Change directory to root directory
cd $MYSQL_BENCHMARK_ROOT_DIR

#Assume the first argument is the name of allocator

cd src/build
make install DESTDIR="../install/$1"
cd ../..

# Initialize database 

cd src/install
./bin/mysqld --initialize-insecure --user=$USER --datadir="`pwd`/src/install" --basedir="`pwd`/src/install/$1/usr/local/mysql"
 cd "src/install/$1/usr/local/mysql"

 #Use sysbench to 

