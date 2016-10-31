Overview:
This is a load test for MySQL Server using the SysBench tool. SysBench can perform various load tests for MySQL server and this document/folder provide a basic setup of the test environment.

Included files:
sysbench.tar.gz - sysbench source install
mysql-boost-5.7.15.tar.gz - MySQL Server source install
mysqltest.py - python script to run test on single machine

Required Not Included: a mysql client application is required for initial configuration and database creation

Test Setup:

1. Install MySQL server from source

  - http://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html
  - "tar zxvf mysql-boost-5.7.15.tar.gz"
  - "cd mysql-5.7.15/"
  - "cmake ."
  - at this point, if you need to link a dynamic library to the server, you will need to modify this file: "/sql/CMakeFiles/mysqld.dir/link.txt" add your -rdynamic statement to the end of the file. For example: "-rdynamic /home/corey/MemCount/libcount.so"
  - "make"
  - specify your own destination directory for install with the command below
  - "make install DESTDIR="/opt/mysql""

2. Perform initial setup of MySQL server

  - if you followed the instructions from the link above, you will need to set up a "mysql" user account and group. I do not recommend this since the server is only for testing. I recommend you use your own user account. In either case, give the user you intend to run the server from appropriate permissions in the server folder you specified. If you installed the server somewhere in your home directory, you probably don't need to change any folder permisions.

  - "cd /usr/local/mysql" // or change to wherever you installed
  - "chown -R mysql ."  //only if you created mysql account and plan to use it
  - "chgrp -R mysql ."  //only if you created mysql group
  - "bin/mysqld --initialize --user=mysql"  //use the user account you plan to launch the server with here
  - when you run the command above, look carefully for the randomly generated password for the server's 'root' account. You will need that!

3. Create test database

  - start the server: "bin/mysqld_safe --user=mysql &"
  - the server is running in the background now. you do not need the "--user=" statement above if you are logged in to the account you want to run the server as
  - log on to the server with a mysql client. if you don't have one installed, you will need to do that first.
  - "mysql -u root -p -S /tmp/mysql.sock" // you will need the root password from the previous step to log on
  - once logged in to the server, create a test database
  - "CREATE DATABASE test" //type while logged in to the server through the client application
  - close the client application ex: "quit"

4. Install SysBench
  - https://github.com/akopytov/sysbench
  - "tar zxvf mysql-boost-5.7.15.tar.gz"
  - "cd sysbench/"
  - "./configure"
  - "make"
  - "sudo make install"

5. Prepare Test
  - If server is still running from step 3, the next step is not required.
  - "bin/mysqld_safe --user=mysql &" //launch the server
  - populate the test database with sysbench "prepare" command
  - "sysbench --test=/home/corey/sysbench/sysbench/tests/db/oltp.lua --oltp-table-size=10000 --mysql-socket=/tmp/mysql.sock --mysql-user=root --mysql-password=root45$% prepare" 
  -fill in proper info for oltp.lua path and root user password. This command places 10000 rows in the test table. Adjust accordingly. See sysbench documentation for more options

6. Run Test
  - Make sure the server is running and the "test" table is populated.
  - This test is read only on the "test" table, so there is no need to retore the table after running this test.
  - "sysbench --num-threads=16 --max-requests=100000 --test=/home/corey/sysbench/sysbench/tests/db/oltp.lua --oltp-table-size=10000 --mysql-socket=/tmp/mysql.sock --oltp-read-only --mysql-user=root --mysql-password=root45$% run"
  - fill in proper info for oltp.lua path and 'root' account password. Note: this is the mysql 'root' account, not the system root account. See sysbench documentation for more testing options.

7. Shut Down Server
  - When you are finished testing the server, shut it down
  - "/usr/local/mysql/bin/mysqladmin shutdown -u root -proot45$%"
  - you may need to adjust the path above for "mysqladmin"

8. Scripted Test
  - run the "mysqltest.py" script if you need a time sensetive test from a single server.
  - this script will start the server, run the test from step 6, and then immediatley shut down the server when the test completes.
  - make sure the "test" table is already prepared before running this script