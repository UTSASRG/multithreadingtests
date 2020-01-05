#!/usr/bin/python

import os
import sys
import subprocess
import re

all_benchmarks = ['blackscholes', 'bodytrack', 'canneal', 'dedup', 'facesim', 'ferret', 'fluidanimate', 'raytrace', 'streamcluster', 'swaptions', 'vips', 'x264']
#all_benchmarks = ['raytrace', 'vips']
all_configs = ['numalloc']

for benchmark in all_benchmarks:
    os.chdir('tests/'+benchmark)
    os.system('make clean')
    for config in all_configs:
        p = subprocess.Popen(['make', 'eval-'+config])
        p.wait()
    os.chdir('../..')
