#!/usr/bin/perl

while(my $dir = shift) {
		$dir =~ s/^(.*)\/$/\1/;
		print `ls -1 $dir | sed -r -e 's/\.[[:alnum:]]+\$//' | sed -r -e 's#^.*\$#\t\t\t $dir\/& \\\\#'`;
}
