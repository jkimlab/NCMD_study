#!/usr/bin/perl

use strict;
use warnings;

my $size_f = shift;

my $length = 0;
open(RF, $size_f);
while(<RF>){
	chomp;
	my ($chr, $size) = split(/\s+/);
	$length += $size;
}
close RF;

my $sum = 0;
foreach my $file(@ARGV){
	open(RF, $file);
	while(<RF>){
		chomp;

		my ($chr, $pos, $cov) = split(/\s+/);
		$sum += $cov;
	}
	close RF;
}

print ($sum/$length)."\n";
