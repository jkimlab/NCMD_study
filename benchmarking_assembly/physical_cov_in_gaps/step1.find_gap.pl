#!/usr/bin/perl

use strict;
use warnings;

my $fa_f = shift;

my $chr = "";
my $curpos = 0;
my $gap = 0;

open(RF, $fa_f);
while(<RF>){
	chomp;
	
	if($_ =~ /^>/){
		$chr = substr($_, 1);
		$curpos = 0;

		if($gap){
			print "$curpos\n";
		}
		$gap = 0;
	}else{
		my @bases = split(//, $_);
		foreach my $base (@bases){
			if($base eq "N" || $base eq "n"){
				if(!$gap){
					print "$chr\t$curpos\t";
				}

				$gap = 1;
			}else{
				if($gap){
					print "$curpos\n";
				}
				$gap = 0;
			}

			++$curpos;
		}
	}
}
close RF;

if($gap){
	print "$curpos\n";
}
