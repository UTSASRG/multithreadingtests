#!/usr/bin/python

# use python 3.x print() function
from __future__ import print_function # Python 2.x
# to launch processes
import subprocess
# to redirect stderr to NULL
import os

# launch MySQL server and let it run
servLaunchCmd = ["/usr/local/mysql/bin/mysqld_safe"]
serverProc = subprocess.Popen(servLaunchCmd)

# long command for Sysbench
testCmd = ["sysbench", "--num-threads=16", "--max-requests=100000", "--test=/home/corey/sysbench/sysbench/tests/db/oltp.lua", "--oltp-table-size=10000", "--mysql-socket=/tmp/mysql.sock", "--oltp-read-only", "--mysql-user=root", "--mysql-password=root45$%", "run"]
FNULL = open(os.devnull, 'w') # OS dumpster

print ("Running SysBench, Please Wait for Output below")
# keep running the test program until it returns with no error
# reason is, it will run a few times before the server starts up
while True:
    try:
        testOutput = subprocess.check_output(testCmd, stderr=FNULL)
    except subprocess.CalledProcessError as e:
        continue
    break

# print the output of SysBench
print (testOutput)

# Run this command to shut down MySQL Server
servStopCmd = ["/usr/local/mysql/bin/mysqladmin", "shutdown", "-u", "root", "-proot45$%"]
subprocess.call(servStopCmd)

# wait for the server to shutdown
return_code = serverProc.wait()
if return_code != 0:
    raise subprocess.CalledProcessError(return_code, servLaunchCmd)
