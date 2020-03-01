Overview:
This is a load test for memcached Server using a python script to simulate load. This document/folder provides a basic setup of the test environment.

Included files:
memcached-1.4.25.tar - memcached Server source install
libevent-2.0.22-stable.tar.gz - Prerequisite Library
memcache.py - Python script to load server
run.py - Python script to launch multiple instances of load script above

Test Setup:

1. Install memcached prerequisites

  - "tar xvfz libevent-2.0.22-stable.tar.gz" //extract tar ball
  - recommend to use a newer version. This one is too old to be compatible.
  - "cd libevent-2.0.22-stable/"
  - "./configure --prefix=install_path" //custom install path here
  - "make"
  - "make install"

2. Install memcached server
  - "tar xvf memcached-1.4.25.tar" //extract tar ball
  - "cd memcached-1.4.25/"
  - "./configure --prefix=memcached_install_path --enable-64bit --with-libevent=libevent_install_path"
  - If you need to link a dynamic library, edit "Makefile" and add "-rdynamic" statement to "CFLAGS" line
  - "make"
  - "make install"

3. Start Server
  - "memcached -l 192.168.1.2 -p 11211 &" //include path to memcached, proper IP address and port
  - add "-vv" flag if you need to verify the server is running

4. Load Test
  - Edit the python script: "./memcache.py". On lines 1485 and 1710, insert the proper server ip and port where the memcached server is currently running
  - "./memcache.py"

5. Multiprocess load test
  - "run.py" contains a simple script to launch the above script multiple times to place a simultaneous load on the memcached server.
  - modify the "runs" variable for the number of simultaneous instances of the script from step 4 to execute. 
  - "./run.py"

6. Stop Server
  - "killall memcached"
