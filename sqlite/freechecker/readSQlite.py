#!/usr/bin/python

import sys
import re

logname=sys.argv[1]

result=[]

if __name__ == "__main__":
    with open(logname,'r') as f:
        for line in f:
            m = re.search('.* ([0-9]+):([0-9]+)[\.|:]([0-9]+)elapsed .* ([0-9]+)maxresident.*', line)
            if m!=None:
                result.append(int(m.group(4)))

    counter = 1
    mean = 0
    for val in result:
        if counter == 10:
            mean += val
            print "mean ", mean/10
            mean = 0
            counter = 1
        else:
            mean += val
            counter += 1
