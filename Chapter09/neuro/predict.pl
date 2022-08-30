#!/user/bin/perl
use Algorithm::SVM::DataSet;
use Algorithm::SVM;
use Getopt::Long;

USAGE() if not @ARGV;
my ($infile, $modelfile);
GetOptions( 'i=s'=>\$infile,
			'o=s'=>\$modelfile,
			"help|h" =>\&USAGE,) or USAGE();
USAGE() if not ($infile and $modelfile);

my $svm = new Algorithm::SVM (Model => $modelfile);
my @TestDataSet;
open (FILE,"<$infile") || die "cannot open $infile\n";
open (RESULT,">result.txt") || die "cannot open result.txt\n";
while(<FILE>){
	my @data=split(/\s/);
	my $TestData = new Algorithm::SVM::DataSet(Label => $data[0]);
	$TestData->attribute($_, $data[$_]) for(1..$#data);
	my $res1 = $svm->predict($TestData);
	my $res2 = $svm->predict_value($TestData);
	print RESULT "$data[0]\t$res1\t$res2\n";
}
print "The result is saved as result.txt in the current directory.\n";
close FILE;
close RESULT;

sub USAGE {
my $usage=<<USAGE;
Example: perl predict.pl -i Test.scale -o Best.model

-i Infile  - Necessary. The (scaled) feature set of testing data, 
       		 the row number is the size of testing sets. 
       		 Each row is "lable feature1 feature2 ...".
             
-o Model   - Necessary. The model file be loaded.

USAGE
	print $usage;
	exit;
}
