# Use me by passing in a sed-cooked PARSEC log file on the command line.
# The full sequence of commands to use this script would be:
#
# egrep "^[[:digit:]]+\.[[:digit:]]+user|^/usr/bin/time|^time" parsec-output.log > filtered.log
# sed -n -r -f cooklog.sed filtered.log > cooked.log
# awk -f cooklog.awk cooked.log
#
# Alternatively, we could do all of these steps at once
# egrep "^[[:digit:]]+\.[[:digit:]]+user|^/usr/bin/time|^time" parsec-output.log | sed -n -r -f cooklog.sed | awk -f cooklog.awk
#
# - Sam
 
{
	key = gensub(/^\.\//, "", "", $1)
	if(split($2, timecomp, ":") > 2) {
		# very large time; specified in hours:minutes:seconds
		time = timecomp[1] * 60 + timecomp[2] * 60 + timecomp[3]
	} else {
		# normal time; specified in minutes:seconds
		time = timecomp[1] * 60 + timecomp[2]
	}
	times[key] += time
	mem[key] += $3
	count[key]++
}

END {
	#printf("%-30s %6s  %-s\n", "Test name", "Time", "Mem")
	#printf("-------------------------------------------------\n")
	for(key in times) {
		time_avg = times[key] / count[key]
		mem_avg = mem[key] / count[key]
		printf("%-30s %8.2f  %.0f\n", key, time_avg, mem_avg)
	}
}
