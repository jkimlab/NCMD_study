#!/usr/bin/perl

use strict;
use warnings;

my $in_sub_axt = shift;

my %overlap_check_r = ();
my %overlap_check_t = ();
open F,"$in_sub_axt";
while(<F>){
	chomp;
	if($_ =~ /^\d+/){
		my $aln_pos = 1;
		my ($n,$rID,$rSTR,$rEND,$tID,$tSTR,$tEND,$strand,$score) = split(/\s+/,$_);
		my $ref_seq = <F>; chomp($ref_seq);
		my $tar_seq = <F>; chomp($tar_seq);

		my $aln_len = length($ref_seq);
		print ">$_\n";
		for(my $i = 0; $i < $aln_len; $i++){
			my $rbase = substr($ref_seq,$i,1);
			my $tbase = substr($tar_seq,$i,1);
			if($rbase =~ /$tbase/i){
				print "$aln_pos\t$rID\t$rSTR\t$rbase\t$tID\t$tSTR\t$tbase\tMATCH\n";
				$rSTR++;
				$tSTR++;
				$aln_pos++;
			}else{
				if($rbase eq "-"){
					print "$aln_pos\t$rID\tN\t$rbase\t$tID\t$tSTR\t$tbase\tREFGAP\n";
					$aln_pos++;
					$tSTR++;
				}elsif($tbase eq "-"){
					print "$aln_pos\t$rID\t$rSTR\t$rbase\t$tID\tN\t$tbase\tTARGAP\n";
					$aln_pos++;
					$rSTR++;
				}else{
					print "$aln_pos\t$rID\t$rSTR\t$rbase\t$tID\t$tSTR\t$tbase\tMISMATCH\n";
					$overlap_check_r{"$rID-$rSTR"}++;
					$overlap_check_t{"$tID-$tSTR"}++;
					$aln_pos++;
					$rSTR++;
					$tSTR++;
				}
			}

		}
	}elsif($_ eq ""){
		next;
	}
}
close F;
