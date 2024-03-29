#!/usr/bin/perl
use v5.10;
use File::Copy;
use File::Copy::Recursive qw (dircopy dirmove);
use File::Path;
use Cwd;

say cwd();
mkdir "toy" or die "$!\n";
chdir "toy" or die "$!\n";
say cwd();
mkdir "decoy" or die "$!\n";
`ls -al >dir.txt`; system ("tree");

open (STDOUT, "| tee -ai log.txt" ) or die "$!\n";
my $dir = getcwd;
opendir(my $dh, $dir) or die "$!\n";
say ("\nPosition before read: ", telldir($dh) );
my $counter =1;
while(readdir $dh) {  
	say ("Position at read $counter: ", telldir($dh), "\t$_"); 
	$counter++;    
}
rewinddir $dh;
say ("Position after rewind: ", telldir($dh), "\n"); 
closedir $dh; 
       
rename "decoy", "yot" or die "$!\n"; system ("tree");
move "dir.txt", "./yot/ls.txt" or die "$!\n"; system ("tree");
dircopy "yot", "decoy" or die "$!\n"; system ("tree");
unlink "./decoy/ls.txt" or die "$!\n"; system ("tree");
rmdir "decoy" or die "$!\n"; system ("tree");
chdir ".."; rmtree ("toy");
