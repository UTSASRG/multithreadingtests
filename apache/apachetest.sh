#!/bin/bash
./apache2/bin/httpd -k start
./apache2/bin/ab -n 100000 -c 100 http://192.168.1.2:1978/
./apache2/bin/httpd -k stop