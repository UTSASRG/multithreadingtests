#!/bin/bash
currdir=`dirname $0`;

if [ "$#" -lt 1 ]; then
	echo "Usage:"
	echo "   $0 [--runs] <logfile>"
	echo
	exit
fi

if [ $1 == "--runs" ]; then
	egrep "^[[:digit:]]+\.[[:digit:]]+user|/usr/bin/time |^time " $2 | sed -n -r -f $currdir/cooklog.sed
else
	egrep "^[[:digit:]]+\.[[:digit:]]+user|/usr/bin/time |^time " $1 | sed -n -r -f $currdir/cooklog.sed | awk -f $currdir/cooklog.awk
fi
