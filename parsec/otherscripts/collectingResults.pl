#!/usr/bin/perl -w


opendir(DIR, 'benchmarksOutput') or die "Could not open directory, $!";

while($file = readdir(DIR)) {

  # Use a regular expression to ignore files beginning with a period
  next if ($file =~ m/^\./);

  ($num) = $file =~ /(\d+)/;

  #print "$num, $file\n";
  open(FILE, "tail --lines=8 benchmarksOutput/$file |") or die "Could not open file, $!";

  #$iter = 0;

  print "$num";

  while(<FILE>) {

    chomp $_;

    @line = split /\s+/, $_;
    print ", $line[1]";
  }

  close(FILE);
  print "\n";
}

close(DIR);

