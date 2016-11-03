# Use the following command to gather a "filtered" PARSEC log file suitable for use with this script:
# egrep "^[[:digit:]]+\.[[:digit:]]+user|^/usr/bin/time|^time" parsec-output.log > filtered.log
# Then, run using: sed -n -r -f cooklog.sed filtered.log

/\/usr\/bin\/time |^time / {
	s/^.*(\/usr\/bin\/time|^time) //;
	s/ .*$//;
	h;
	N;
}

/elapsed/ {
	#s/^.* ([[:digit:]]+:[[:digit:]]+\.[[:digit:]]+)elapsed .* ([[:digit:]]+)maxresident.*$/\1 \2/;
	s/^.* ([[:digit:]]+:[[:digit:]]+(\.|:)[[:digit:]]+)elapsed .* ([[:digit:]]+)maxresident.*$/\1 \3/;
	x;
	G;
	s/\n/ /;
	p;
}
