#!/user/bin/perl
use Algorithm::SVM::DataSet;
use Algorithm::SVM;
use Getopt::Long;

USAGE() if not @ARGV;
my ($infile, $modelfile);
GetOptions( 'i=s'=>\$infile,
			'm=s'=>\$modelfile,
			'o=s'=>\$resultfile,
			"help|h" =>\&USAGE,) or USAGE();
USAGE() if not ($infile and $modelfile and $resultfile);

my $svm = new Algorithm::SVM (Model => $modelfile);
my @TestDataSet;
open (FILE,"<$infile") || die "cannot open $infile\n";
open (RESULT,">$resultfile") || die "cannot open $resultfile\n";
while(<FILE>){
	my @data=split(/\s/);
	my $TestData = new Algorithm::SVM::DataSet(Label => $data[0]);
	$TestData->attribute($_, $data[$_]) for(1..$#data);
	my $res1 = $svm->predict($TestData);
	my $res2 = $svm->predict_value($TestData);
	print RESULT "$data[0]\t$res1\t$res2\n";
  }
print "The result is saved as $resultfile in the current directory.\n";
close FILE;
close RESULT;

sub USAGE {
my $usage=<<USAGE;
Example: perl predict.pl -i Test.scale -m Best.model -o Test.result

-i Infile  - Necessary. The (scaled) feature set of testing data, 
	  the row number is the size of testing sets. 
	  Each row is "lable feature1 feature2 ...".
             
-m Model   - Necessary. The model file be loaded.

-o Resultfile - Necessary. Each row has three fileds: golden label,
	  predicting label, and the corresponding value of SVM 

USAGE
	print $usage;
	exit;
}
