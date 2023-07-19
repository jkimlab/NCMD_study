#!/usr/bin/perl

use strict;
use warnings;

my $gap_bed = shift;
my $phycov = shift;

my %gaps = ();
open(RF, $gap_bed);
while(<RF>){
	chomp;

	my ($chr, $start, $end) = split(/\s+/);
	$start += 1;
	$gaps{$chr}{$start}{$end} = 1;
}
close RF;

open(RF, $phycov);
while(<RF>){
	chomp;
	my ($chr, $pos, $phycov) = split(/\s+/);

	my $contain = 0;
	foreach my $gstart (keys %{$gaps{$chr}}){
		foreach my $gend (keys %{$gaps{$chr}{$gstart}}){
			if($contain){ last; }
			if($gstart <= $pos && $pos <= $gend){ 
				$contain = 1;
			}
		}
	}

	if($contain){
		print "$_\n";
	}
}
close RF;
