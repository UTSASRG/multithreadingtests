#!/bin/bash

#Print commands and their arguments while this script is executed
# set -x

echo "Checking parameters"

if [ "$#" -ne 1 ]
then
  echo "Usage: AfterBuild_install BUILD_NAME (This BUILD_NAME is passed to all scripts. And we'll install compiled binaries under $BUILD_NAME folder"
  exit 1
fi

cd $INSTALLATION_FOLDER

echo "Changing listening ip and port to $APACHE_LISTENING_IP:$APACHE_LISTENING_PORT as instructed"
cp ./conf/httpd.conf ./conf/httpd.conf.bkp
cat ./conf/httpd.conf.bkp | sed "s/^Listen 80/Listen $APACHE_LISTENING_IP:$APACHE_LISTENING_PORT/" > ./conf/httpd.conf