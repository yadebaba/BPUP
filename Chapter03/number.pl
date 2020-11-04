#!/usr/bin/perl

use v5.10;

# Numbers in different numeral systems can be used literally in Perl
my $bin = 0b11111010;		# 250 in binary form
my $oct = 0372;				# 250 in	octal form
my $dec = -250;				# -250 in decimal form
my $hex = 0xfa;				# 250 in hexadecimal form
my $Hex = 0XfA;				# also 250 in hexadecimal form
my $sum = $bin + $oct + $hex + $Hex + 1;
say "\$sum = $sum #Four ${hex}s plus 1, you get $sum!";
say $sum.$dec."\n";			#Automatic convert numbers to strings.

# Be careful when big numbers and small numbers are used together  
say "9e11 + 5.12 - 9e11 = ".(9e11 + 5.12 - 9e11);	#5.1199951171875
say "9e12 + 5.12 - 9e12 = ".(9e12 + 5.12 - 9e12);	#5.119140625
say "9e13 + 5.12 - 9e13 = ".(9e13 + 5.12 - 9e13);	#5.125
say "9e14 + 5.12 - 9e14 = ".(9e14 + 5.12 - 9e14);	#5.125
say "9e15 + 5.12 - 9e15 = ".(9e15 + 5.12 - 9e15);	#5
say "9e16 + 5.12 - 9e16 = ".(9e16 + 5.12 - 9e16);	#0
say "9e16 + 2020 - 9e16 = ", 9e22 + 2020 - 9e22;	#0
say ("9e16 - 9e16 + 2020 = ", 9e22 - 9e22 + 2020);	#2020
