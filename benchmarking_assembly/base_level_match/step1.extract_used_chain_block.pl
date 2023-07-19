#!/usr/bin/perl

use strict;
use warnings; 

my $in_all_chain = shift; #all.chain
my $in_Building_block = shift; #Building.Blocks.target (manually extracted)

my %cblocks = ();
my $str = "";
my @cid = ();
open F,"$in_all_chain";
while(<F>){
	chomp;
	if($_ =~ /^#/){
#print "$_\n";
	}elsif($_ eq ""){
		$cblocks{$cid[-1]} = $str;	
		@cid = ();
		$str = "";
	}else{
		if($_ =~ /^chain/){
			@cid = split(/\s+/,$_);
		}
		$str .= "$_\n";
	}
}
close F;

open F,"$in_Building_block";
while(<F>){
	chomp;
	next if /^#/;
	my @t = split(/\D+/);
	if(exists $cblocks{$t[-1]}){
		print "$cblocks{$t[-1]}\n";
		delete $cblocks{$t[-1]};
	}
}
close F;
