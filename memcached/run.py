#!/usr/bin/python

from __future__ import print_function

import subprocess
import os

runs = 900 
p = []
operation = 'memcache.py'
FNULL = open(os.devnull, 'w')

for n in range(0, runs):
	print("Starting Script ", n+1, end='\r');
	p.append(subprocess.Popen(["python", operation], stdout=FNULL, stderr=subprocess.STDOUT))
	
for n in range(0, runs):
	print("Waiting for Script ", n+1, end='\r');
	p[n].wait()
