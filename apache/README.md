Overview:
This is a load test for apache Server using the "ab" tool that comes with the server. The "ab" application can perform various load tests for appache server and this document/folder provides a basic setup of the test environment.

Included files:
httpd-2.4.23.tar.gz - Apache Server source install
apachetest.sh - Test script

Test Setup:

1. Install Apache server from source
 http://mirror.cc.columbia.edu/pub/software/apache//httpd/httpd-2.4.23.tar.gz
  - tar xvfz httpd-2.4.23.tar.gz //extract tar ball
  - "./configure --prefix=install_path" //put custom install path here.   If you do not have apr, you can install it with 'sudo apt-get install libapr1-dev libaprutil1-dev'
  - At this point, if you need to link a dynamic library, edit the following file: "build/config_vars.mk". Add your "-rdynamic" statement to the line begining with: "AP_LIBS ="
  - make
  - make install

2. Perform Apache Initial Configuration
  - edit the following file in the apache install directory: "conf/httpd.conf"
  - Line 52: set the server to listen on a custom port ex: "Listen 1978"
  - Line 161: set server to run with specific user account. ex: "User corey"
  - Line 162: set server to run with specific group. ex: "Group corey"
  - Line 192: set server name and port. ex: "ServerName 192.168.1.2:1978"

3. Start Server
  - "./apache2/bin/httpd -k start"
  - you may need to adjust the path to httpd
  - note that "httpd" will fork 3 processes to service requests, insure your test can handle these "fork()" calls.

4. Load Test Server with 'ab' tool
  - https://httpd.apache.org/docs/2.4/programs/ab.html
  - "./apache2/bin/ab -n 100000 -c 100 http://192.168.1.2:1978/"
  - the command above runs a simple load test using the 'ab' tool built in to appache. For more complex tests, see documentation. Running the 'ab' application with no arguments yields a list of options. Note that if you linked a library in step 1, you linked that library to the 'ab' tool and all the executables in the "bin/" directory

5. Stop Server
  - "./apache2/bin/httpd -k stop"

6. Scripted Test
  - The file "apachetest.sh" file will run the commands from steps 3, 4 and 5 in succession.
