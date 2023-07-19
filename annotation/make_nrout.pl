#!/usr/bin/perl

use strict;
use warnings;

my $intersect_f = shift;
my $rfam_f = shift;
my $rnammer_f = shift;
my $trnascan_f = shift;

my %intersect = ();
open(RF, $intersect_f);
while(<RF>){
	chomp;

	my ($chr1, $beg1, $end1, $out1, $info1, $tool, $chr2, $beg2, $end2, $out2, $info2) = split(/\s+/);
	my $beg = ($beg1 < $beg2)? $beg2 : $beg1;
	my $end = ($end1 < $end2)? $end2 : $end1;

	$intersect{$out1} = "$chr1\t$beg\t$end\t$info1:$info2";	
	$intersect{$out2} = 1;	
}
close RF;

open(RF, $rfam_f);
while(<RF>){
	if($_ =~ /^#/){ next; }
	
	my @col = split(/\s+/);
	my @info = split(/:/, $col[-1]);
	if(! exists $intersect{$col[3]}){
		print "$col[0]\tRfam\tncRNA_gene\t".($col[1]+1)."\t$col[2]\t.\t$info[-1]\t.\tbiotype=$info[1];description=$info[2]\n";
	}else{
		my @old_col = @col;
		@col = split(/\s+/, $intersect{$col[3]});
		@info = split(/:/, $col[-1]);

		my $dir = "";
		if($info[3] eq $info[7]){
			$dir = $info[3];
		}
		my $comb = "";
		$comb = "$info[0],$info[4]";

		print "$col[0]\t$comb\tncRNA_gene\t".($col[1]+1)."\t$col[2]\t.\t$dir\t.\tbiotype=$info[1];description=$info[2]\n";
	}
}
close RF;

open(RF, $rnammer_f);
while(<RF>){
	chomp;
	if($_ =~ /^#/){ next; }
	
	my @col = split(/\s+/);
	my @info = split(/:/, $col[-1]);
	if(! exists $intersect{$col[3]}){
		print "$col[0]\tRNAmmer\tncRNA_gene\t".($col[1]+1)."\t$col[2]\t.\t$info[-1]\t.\tbiotype=$info[1];Name=$info[2]\n";
	}
}
close RF;

open(RF, $trnascan_f);
while(<RF>){
	chomp;

	my @col = split(/\s+/);
	my @info = split(/:/, $col[-1]);
	if(! exists $intersect{$col[3]}){
		print "$col[0]\ttRNAscan\tncRNA_gene\t".($col[1]+1)."\t$col[2]\t.\t$info[-1]\t.\tbiotype=$info[1]\n";
	}
}
close RF;
