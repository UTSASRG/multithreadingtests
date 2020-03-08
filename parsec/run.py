#!/usr/bin/python

import os
import sys
import subprocess
import re

#all_benchmarks = ['bodytrack', 'blackscholes', 'fluidanimate']
#all_benchmarks = ['raytrace']
#all_benchmarks = ['blackscholes', 'bodytrack', 'canneal', 'dedup', 'facesim', 'ferret', 'fluidanimate', 'raytrace', 'streamcluster', 'swaptions', 'vips', 'x264']
all_benchmarks = ['blackscholes', 'bodytrack', 'canneal', 'dedup', 'ferret', 'fluidanimate', 'raytrace', 'streamcluster', 'swaptions', 'vips', 'x264']
all_configs = ['numalloc']
runs = 1

if len(sys.argv) == 1:
	print 'Usage: '+sys.argv[0]+' <benchmark names> <config names> <runs>'
	print 'Configs:'
	for c in all_configs:
		print '  '+c
	print 'Benchmarks:'
	for b in all_benchmarks:
		print '  '+b
#	sys.exit(1)

#print 'cores: ' + cores
benchmarks = []
configs = []

for p in sys.argv:
	if p in all_benchmarks:
		benchmarks.append(p)
	elif p in all_configs:
		configs.append(p)
	elif re.match('^[0-9]+$', p):
		runs = int(p)

if len(benchmarks) == 0:
	benchmarks = all_benchmarks

if len(configs) == 0:
	configs = all_configs

# Adjust cores. We can change the number of cores dynamically on Linux
if runs < 4:
        print 'Warning: with fewer than 4 runs per benchmark, all runs are averaged. Request at least 4 runs to discard the min and max runs from the average.'

data = {}
try:
	for benchmark in benchmarks:
		data[benchmark] = {}
		for config in configs:
			data[benchmark][config] = []
	
			for n in range(0, runs):
				print 'Running '+benchmark+'.'+config
				os.chdir('tests/'+benchmark)
				start_time = os.times()[4]
				
				p = subprocess.Popen(['make', 'eval-'+config])
			#	p = subprocess.Popen(['make', 'eval-'+config, 'NCORES='+str(cores)], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
				p.wait()
				
				time = os.times()[4] - start_time
				data[benchmark][config].append(time)
	
				os.chdir('../..')

except:
	print 'Aborted!'
	
print 'benchmark',
for config in configs:
	print '\t'+config,
print

for benchmark in benchmarks:
	print benchmark,
	for config in configs:
		if benchmark in data and config in data[benchmark] and len(data[benchmark][config]) == runs:
#			if len(data[benchmark][config]) >= 4:
#				mean = (sum(data[benchmark][config])-max(data[benchmark][config])-min(data[benchmark][config]))/(runs-2)
#			else:
			mean = sum(data[benchmark][config])/runs
			print '\t'+str(mean),
		else:
			print '\tNOT RUN',
	print
