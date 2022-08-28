#!/usr/bin/perl
use Algorithm::SVM::DataSet;
use Algorithm::SVM;
use Getopt::Long;

USAGE() if not @ARGV;

#Part I: pass parameters
my ($type, $kernel, $degree, $gamma, $cost, $coef0, $nu, $epsilon, $n, $infile, $modelfile);
GetOptions('t=s'=>\$type,
           'k=s'=>\$kernel,
           'd=s'=>\$degree,
           'g=s'=>\$gamma,
           'c=s'=>\$cost,
           's=s'=>\$coef0,
           'n=s'=>\$nu,
           'e=s'=>\$epsilon,
           'v=s'=>\$n,
           'i=s'=>\$infile,
           'o:s'=>\$modelfile,
           "help|h" =>\&USAGE,)or USAGE();

#Part II: default parameters
if(!$type){$type="C-SVC"}
if(!$kernel){$kernel="radial"}
if(!$degree){$degree=3}
if(!$cost){$cost=1}
if(!$coef0){$cost=0}
if(!$nu){$nu=0.5}
if(!$epsilon){$epsilon=0.1}
if(!$n){$n=5}

#Part III: construct new Algorithm::SVM object
my $svm = new Algorithm::SVM(Type   => $type,
                             Kernel => $kernel,
                             Degree => $degree,
                             Gamma => $gamma,
                             C      => $cost,
                             Coef0 => $coef0,
                             Nu    => $nu,
                             Epsilon=> $epsilon);

#Part IV: construct new Algorithm::SVM::DataSet object
my (@TrainDataSet,$datanum);
USAGE() if not $infile;
open (FILE,"<$infile") || die "cannot open $infile\n";
while(<FILE>){
   $datanum++;
   my @data=split(/\s/);
   my $TrainData = new Algorithm::SVM::DataSet(Label => $data[0]);
   $TrainData->attribute($_, $data[$_]) for(1..$#data);
   push(@TrainDataSet,$TrainData);
}
   
#Part V: train the model
if(!$gamma){$gamma=1/$datanum} 
$svm->gamma($gamma);
$svm->train(@TrainDataSet);
$accuracy=$svm->validate($n);
if ($modelfile){$svm->save($modelfile)}
printf("\nThe accuracy of the current model is: %.2f%\n\n", $accuracy);

#Part VI: the USAGE of the script
sub USAGE {
my $usage=<<USAGE;
Usage:
Example: perl train.pl -i infile -o model -g 8.0 -c 2.0 -v 5
-i Infile  - Necessary. The feature set of training data, the row
             number is the number of training sets. Each row is 
             "lable feature1 feature2 ...".
             
-o Model   - Optional. If given, the model file will be saved.

-t Type    - The type of SVM that should be created.  Possible 
             values are: '', 'nu-SVC', 'one-class', 'epsilon-SVR' 
             and 'nu-SVR'.  Default is 'C-SVC'.

-k Kernel  - The type of kernel to be used in the SVM.  Possible 
             values are: 'linear', 'polynomial', 'radial' and 
             'sigmoid'. Default is 'radial'.

-d Degree  - Sets the degree in the kernel function.  Default is 3.
 
-g Gamma   - Sets the gamme in the kernel function.  Default is 1/k,
             where k is the number of training sets.

-c cost    - Sets the penalty coefficient for C-SVC SVM's, epsilon
             -SVR SVM's and nu-SVR SVM's.  Default is 1.
             
-s Coef0   - Sets the Coef0 in the kernel function.  Default is 0.

-n Nu      - Sets the nu parameter for nu-SVC SVM's, one-class SVM's
             and nu-SVR SVM's.  Default is 0.5.

-e Epsilon - Sets the epsilon in the loss function of epsilon-SVR's.
             Default is 0.1.
             
-v n       - n-fold cross validation. Default is 5.
USAGE

print $usage;
exit;
} 
