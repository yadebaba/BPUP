#!/usr/bin/perl
use v5.10;
use File::Copy;
use File::Copy::Recursive qw (dircopy dirmove);
use File::Path;
use Cwd;

say cwd();
mkdir "toy" or die $!;
chdir "toy" or die $!;
say cwd();
mkdir "decoy" or die $!;
`ls -al >dir.txt`; system ("tree");

open (STDOUT, "| tee -ai log.txt" ) or die $!;
my $dir = getcwd;
opendir(my $dh, $dir) or die $!;
say ("\nPosition before read: ", telldir($dh) );
my $counter =1;
while(readdir $dh) {  
	say ("Position at read $counter: ", telldir($dh), "\t$_"); 
	$counter++;    
}
rewinddir $dh;
say ("Position after rewind: ", telldir($dh), "\n"); 
closedir $dh; 
       
rename "decoy", "yot" or die $!; system ("tree");
move "dir.txt", "./yot/ls.txt" or die $!; system ("tree");
dircopy "yot", "decoy" or die $!; system ("tree");
unlink "./decoy/ls.txt" or die $!; system ("tree");
rmdir "decoy" or die $!; system ("tree");
chdir ".."; rmtree ("toy");