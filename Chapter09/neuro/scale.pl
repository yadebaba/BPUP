#!/user/bin/perl
use strict;
use Getopt::Long;
use List::Util qw(max min);

USAGE() if not @ARGV;
my ($lower,$upper,$rangefile,$savefile,$infile);
GetOptions('l=s'=>\$lower,
			'u=s'=>\$upper,
			'r=s'=>\$rangefile,
			's=s'=>\$savefile,
			'i=s'=>\$infile,
			"help|h" =>\&USAGE,) || USAGE();
if($lower eq ""){$lower=-1}
if($upper eq ""){$upper=1}

my @data=();
my @range=();

USAGE() if not $infile;
open (FILE,"<$infile") || die "cannot open $infile\n";
while (<FILE>) {
  push @data, [ split ];
}
close (FILE);

if($savefile && !$rangefile){ 
	Extrem();
}
elsif($rangefile && !$savefile){
	Restore();
}
else {
  print "Error: cannot use -r and -s simultaneously.\n";
  USAGE();
}

for $a(0..$#data){
	print $data[$a][0]." ";
	for $b(1..$#{$data[$a]}){
		my $max_min=$range[$b-1][2] - $range[$b-1][1];
		my $scale;
		if ($max_min){
			$scale=$lower+($upper-$lower)*($data[$a][$b] - $range[$b-1][1])/$max_min;
		}else{
			$scale=0;
		}
		print $scale." ";
	}
	print "\n";
}

sub Extrem{ # compute extreme value of each column and save to range file
	my $clonum=$#{$data[1]}+1;
	my $rownum=$#data+1;
	for(my $x=1;$x<$clonum;$x++){
		my ($max,$min);
		my @new=(); 
		for(my $starty=my $y=0;$y<$rownum;$y++){  
			$new[$y-$starty]=$data[$y][$x];  
		}     
		($max,$min)=(max(@new),min(@new));
		$range[$x-1]=[$x,$min,$max];
	} 

	open (SAVE,">$savefile") || die "cannot open $savefile\n";
	print SAVE"x\n$lower $upper\n";
	foreach (@range){
		print SAVE join(' ', @$_), "\n";
	}
	close (SAVE);
} 

sub Restore{	# restore according to range file
	open (LOAD,"<$rangefile") || die "cannot open $rangefile\n";
	my $flag=0;
	while(<LOAD>) {
    	chomp;
		if ($flag==0){$flag++;next;}
    	elsif ($flag==1){($lower,$upper)=split;}
    	elsif($flag>1){push @range, [ split ]; }
    	$flag++;
	}
	close(LOAD);
}  

sub USAGE {
	my $usage=<<USAGE;
Usage:
Example: perl scale.pl -l 0 -u 1 -s rangefile -i infile 
-l lower : x scaling lower limit <default -1>
-u upper : x scaling upper limit <default +1>
-s range_file : save scaling parameters to range_file
-r restore_file : restore scaling parameters from restore_file
-i infile : filename that need to be scaled
Notice : cannot use -r and -s simultaneously
USAGE
	print $usage;
	exit;
} 
