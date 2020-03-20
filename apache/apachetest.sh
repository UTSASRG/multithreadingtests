#!/bin/bash
./httpd-2.4.23/install/bin/httpd -k start
#./apache2/bin/ab -n 100000 -c 100 http://192.168.1.2:1978/
./httpd-2.4.23/install/bin/ab -n 100000 -c 100 http://10.242.129.222:1978/
./httpd-2.4.23/install/bin/httpd -k stop
