#!/usr/bin/perl
use Getopt::Long;

#pass parameters
USAGE() if not @ARGV;
my ($infile,$sortfile,$n);
GetOptions('s=s'=>\$sortfile,	#file of sorted features
           'i=s'=>\$infile,		#file with features of training data sets
           'v=s'=>\$n,			#n-fold cross-validation
           "help|h" =>\&USAGE,) or USAGE();
USAGE() if not ($infile and $sortfile);

if(!$n){$n=5}	#n-fold cross validation.  Default is 5
print $sortfile."\n".$infile."\n";
open (IN, "<$sortfile") or die "Can't open $sortfile due to: $!\n";
open (FILE, "<$infile") or die "Can't open $infile due to: $!\n";
my @sorted=(<IN>);
my @feature=(<FILE>);
close IN;
close FILE;

#create feature set one by one and
#return optimum parameters's accuracy of n-fold cross-validation
for (my $i=0; $i<=$#sorted; $i++){
	my $tmp=$i+1;
	chomp($sorted[$i]);
	if (!$i){
		open (OUT, ">Feature1.txt") or die "Can't open Feature1.txt due to: $!\n";
    	for (my $j=0; $j<=$#feature; $j++){
			my @eachfeature=split(/\t/,$feature[$j]);
			print OUT $eachfeature[0]."\t".$eachfeature[$sorted[0]]."\n";
		}
	}else{
		open (TEMP,"<Feature$i.txt") or die "Can't open Feature$i.txt due to: $!\n";
		open (OUT, ">Feature$tmp.txt") or die "Can't open Feature$tmp.txt due to: $!\n";
		my $flag=0;
		while(<TEMP>){
			chomp;
			my @eachfeature=split(/\t/,$feature[$flag]);
			print OUT $_."\t".$eachfeature[$sorted[$i]]."\n";
			$flag++;
		}
		close TEMP;
		close OUT;
		unlink ("Feature$i.txt");
		unlink ("Feature$i.scale");
		unlink ("Feature$i.range");    
	} 
	$command1="perl scale.pl -i Feature$tmp.txt -s Feature$tmp.range > Feature$tmp.scale";
	$command2="perl grid.pl -i Feature$tmp.scale -v $n";
	system ($command1);
	system ($command2);
}
    
sub USAGE {
my $usage=<<USAGE;
Usage:perl FindBestFeatureSet.pl -i infile -s sortfile -v 5
Example: perl FindBestFeatureSet.pl -i SAA.txt -s sort.txt

-i infile   - Necessary. The feature file of training data,
			  the row number is the size of training sets.
			  Each row is "lable feature1 feature2 ...".
-s sortfile - Necessary. Each row contains one number，
			  which stands for the order of feature.
			  The rows <= the total number of feature.
-v n   - n-fold cross validation.  Default is 5.
USAGE
	print $usage;
	exit;
}
