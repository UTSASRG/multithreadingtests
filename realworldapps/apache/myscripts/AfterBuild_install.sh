#!/bin/bash

#Print commands and their arguments while this script is executed
#set -x

funcCheckLog () {
    #logName,errorLogName,retValue

    if [ $3 -eq 0 ]; then
        echo "Log sneakpeek: "| sed 's/^/  /'
        tail -n3 $1 | sed 's/^/  /'
    else
        echo "Error sneakpeek: "| sed 's/^/  /'
        tail -n3 $2 | sed 's/^/  /'
        exit -1
    fi
}


echo "Checking parameters"

if [ "$#" -ne 1 ]
then
  echo "Usage: AfterBuild_install BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under $BUILD_NAME folder"
  exit 1
fi

cd $APACHE_BENCHMARK_ROOT_DIR/src/install/$1/conf

echo "Changing listening ip and port to $APACHE_LISTENING_IP:$APACHE_LISTENING_PORT as instructed"
cp ./httpd.conf ./httpd.conf.bkp
cat ./httpd.conf.bkp | sed "s/^Listen 80/Listen $APACHE_LISTENING_IP:$APACHE_LISTENING_PORT/" > ./httpd.conf