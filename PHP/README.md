Overview:
This is a load test for PHP 7 using a simple script to test basic PHP functionalities. This document/folder provides a basic setup of the test environment.

Included files:
php-7.0.12.tar.gz - PHP 7 source install
bench-class.php - PHP script to Load Test PHP interpreter

Test Setup:

1. Install PHP 7
  - "tar xvfz php-7.0.12.tar.gz" //extract tar ball
  - "cd php-7.0.12/"
  - "./configure --prefix=install_path" //custom install path here
  - If you need to link a dynamic library, edit "Makefile" and add "-rdynamic" statement to "CFLAGS_CLEAN" line 79.
  - "make"
  - "make install"

2. Run Test Script
  - Run the test file bench-class.php. There are count variables in all the test functions. Change these values to add or subtract load on the PHP interpreter
  - the PHP interpreter can be found in the "bin" folder in your install path from step 1.
  - "/install_path/bin/php ./bench-class.php"
