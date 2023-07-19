#!/usr/bin/perl

use strict;
use warnings;

my $in_base = shift; #used.base
my $in_ovl = shift; #overlapped_region.info.txt

my %ovl_region = ();
open F,"$in_ovl";
while(<F>){
	chomp;
	if($_ =~ /^>/){
		my @t = split(/\s+/);
		$ovl_region{$t[0]} = "$t[3]-$t[4]";
	}
}
close F;

my %stats = ();
open F,"$in_base";
while(<F>){
	chomp;
	next if /^>/;
	my @t = split(/\s+/);
	if(exists $ovl_region{$t[4]}){
		my ($str,$end) = split(/-/,$ovl_region{$t[4]});
		if($t[5] < $str && $t[5] > $end){
			$stats{$t[1]}{$t[7]}++;
		}
	}else{
		$stats{$t[1]}{$t[7]}++;
	}
}
close F;

my ($m,$mm,$rg,$tg) = (0,0,0,0);
print "CHROM\tMATCH\tMISMATCH\tREFGAP\tTARGAP\n";;
foreach my $chr(keys %stats){
	print "$chr\t";
	print "$stats{$chr}{MATCH}\t$stats{$chr}{MISMATCH}\t$stats{$chr}{REFGAP}\t$stats{$chr}{TARGAP}\n";
	$m += $stats{$chr}{MATCH};
	$mm += $stats{$chr}{MISMATCH};
	$rg += $stats{$chr}{REFGAP};
	$tg += $stats{$chr}{TARGAP};
}
print "Total\t$m\t$mm\t$rg\t$tg\n";
