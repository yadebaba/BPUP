#!/usr/bin/perl
# save a 9x9 times table in @AoA
for $x (0..8){
	for $y (0..8){
		$AoA[$x][$y] = ($x+1)*($y+1);
	}
}
# print the 9x9 times table 
print map {join("\t", @$_)."\n"} @AoA;
