#!/bin/bash
cd apache
mv test.out test.out.bk
./remote_test.sh
cd ..

cd memcached
mv test.out test.out.bk
./remote_test.sh
cd ..

cd mysql
mv test.out test.out.bk
./remote_test.sh
cd ..
