#!/usr/bin/python3

import subprocess
import os

runs = 900 
p = []
operation = 'memcache.py'
FNULL = open(os.devnull, 'w')

for n in range(0, runs):
	print("Creating subprocesses #", n+1, end='\r');
	p.append(subprocess.Popen(["python3", operation], stdout=FNULL, stderr=subprocess.STDOUT))
	
for n in range(0, runs):
	print("Waiting for subprocess to finish", n+1, end='\r');
	p[n].wait()
