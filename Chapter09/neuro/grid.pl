#!/usr/bin/perl
use Getopt::Long;
use Algorithm::SVM::DataSet;
use Algorithm::SVM;

#pass parameters
USAGE() if not @ARGV;
my (@log2c,@log2g,$n,$infile);
GetOptions('log2c=i{3}'=>\@log2c,
          'log2g=i{3}'=>\@log2g,
           'v=s'=>\$n,
           'i=s'=>\$infile,
           "help|h" =>\&USAGE,)or USAGE();
USAGE() if not $infile;

#set default parameters
if(!@log2c){@log2c=(-5,15,2)}
if(!@log2g){@log2g=(3,-15,-2)}
if(!$n){$n=5}

#GRID search
open (OUT,">>GridResult.txt") || die "can't open GridResult.txt\n";
my ($best_c,$best_g,$best_acc);
for (my $c1=$log2c[0];$c1<=$log2c[1];$c1=$c1+$log2c[2]){
   for (my $g1=$log2g[0];$g1>=$log2g[1];$g1=$g1+$log2g[2]){
        my $c=2**$c1;
        my $g=2**$g1;
        my $acc=Train($g,$c,$n,$infile);
        if (($acc > $best_acc) or  ($acc==$best_acc and $g==$best_g and $c<$best_c)){
            $best_acc = $acc;
            $best_c=$c;
            $best_g=$g;
        }
   }
}
print OUT $infile.":\tBest_C=$best_c\tBest_gamma=$best_g\tBest_accuracy=$best_acc%\n";

#train model with passed parameters and return accuracy of cross-validation
sub Train{
   my($gamma,$cost,$cv,$infile)=@_;
   my $svm = new Algorithm::SVM(Type   => "C-SVC",
                                 Kernel => "radial",
                                 Gamma => $gamma,
                                 C      => $cost);
   my @TrainDataSet;
   open (FILE,"<$infile") || die "cannot open the file:$infile\n";
   while(<FILE>){
        my @data=split(/\s/);
        my $TrainData = new Algorithm::SVM::DataSet(Label => $data[0]);
        $TrainData->attribute($_, $data[$_]) for(1..$#data);
        push(@TrainDataSet,$TrainData);
   }
   $svm->train(@TrainDataSet);
   $accuracy=$svm->validate($cv);
   if ($modelfile){$svm->save($modelfile)}
   return($accuracy);
}

# USAGE of the script
sub USAGE {
my $usage=<<USAGE;
Usage:
Example: perl grid.pl -i infile

-i infile   		- Necessary. The feature set of training data, 
                	  the row number is the size of training sets.  
                	  Each row is "lable feature1 feature2 ...".
              
-log2g begin end step   - Sets the begin, end, step of log2gamma.
                          Default is 3,-15,-2
                          
-log2c begin end step   - Sets the begin, end, step of log2cost.
                          Default is -5,15,2

-v n   			- n-fold cross validation.  Default is 5.

USAGE
   print $usage;
   exit;
}
