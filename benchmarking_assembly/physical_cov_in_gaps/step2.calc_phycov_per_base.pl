#!/usr/bin/perl

use strict;
use warnings;

my $map_f = shift;		# sam or bam file
my $size_f = shift;
my $min_mapq = shift;

open(O, ">map.bed");
open(F, "samtools view -F 0xF0C -q $min_mapq $map_f |");
while(<F>) {
	chomp;
	if ($_ =~ /^@/) { next; }
	my ($qname, $flag, $rname, $pos, $mapq, $cigar, $rnext, $pnext, $tlen) = split(/\s+/);
	if ($flag & 0x80 || $flag & 0x4 || $flag & 0x8) { next; }

	my ($dir1, $dir2) = ("+", "+");
	if ($flag & 0x10) { $dir1 = "-"; }
	if ($flag & 0x20) { $dir2 = "-"; }
	
	my ($rname1, $rname2) = ($rname, $rnext);
	if ($rname2 eq "=") { $rname2 = $rname1; }
	
	if ($rname1 ne $rname2) { next;	}
    if ($pos == $pnext) { next;	}

	my $final_scf = $rname1;
	my ($final_start, $final_end) = (-1, -1);
	my $local_ot = "";

	if ($dir1 eq "+" && $dir2 eq "-") {
		if ($pos < $pnext) {
			($final_start, $final_end) = ($pos, $pos + abs($tlen) - 1);
		 } else {
			($final_start, $final_end) = ($pnext, $pnext + abs($tlen) - 1);
	     }
	} elsif ($dir1 eq "-" && $dir2 eq "+") {
		if ($pos > $pnext) {
			($final_start, $final_end) = ($pnext, $pnext + abs($tlen) - 1);
        } else {
			($final_start, $final_end) = ($pos, $pos + abs($tlen) - 1);
        }
	} 
	
	if($final_start != -1 && $final_end != -1){
		print O "$final_scf\t$final_start\t$final_end\n"; 
	}
}
close(F);
close(O);

print STDERR "Sorting bed files...\n";
`cat map.bed | sort -k1,1 -k2n,2 -k3n,3 -u > map.sort.bed`;

print STDERR "Computing physical coverage...\n";
`bedtools genomecov -i map.sort.bed -d -g $size_f > phycov.txt`;
