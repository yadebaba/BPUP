#!/usr/bin/perl

use v5.10;

#range operator in scalar context
@base = qw (adenine cytosine guanine thymine uracil any);
foreach (@base) {  
	say "$r\t$_" if ( $r = /a/ .. /n/); 
}
say "";
foreach (@base) {  
	say "$r\t$_" if ( $r = /a/ ... /n/); 
}
