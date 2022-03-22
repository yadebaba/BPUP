#!/usr/bin/perl
use v5.10;

# Read data from the script itself
# Demo of special literals
say "The script is called ", __FILE__;
say "We are in the package ", __PACKAGE__;
say "This is line ",__LINE__, " of the script";
while (<DATA>) {
	say "We are studying $_" if /Perl/;
}
__END__
MATLAB
R
Python
Perl
