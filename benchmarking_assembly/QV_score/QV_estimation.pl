#!/usr/bin/perl

use warnings;
use strict;
use Cwd 'abs_path';
use File::Basename;

my $vcf = shift;
my $bam = shift;
$vcf = abs_path($vcf);
$bam = abs_path($bam);

my ($filename, $dir, $ext) = fileparse("$vcf", '\.[^.]*');

my $NUM_BP = 0;
`samtools depth $bam > $filename.vcf_depth`;

open(F, "$filename.vcf_depth");
while(<F>){
	chomp;
	my @s = split(/\t/, $_);
	if ( $s[2] >= 3 ) { 
		$NUM_BP++;
	}
}
close(F);

my $NUM_SNP = 0;

open(F1, "$vcf");
while(<F1>) {
	chomp;
	if ( $_ =~ /^#/ ) {
		next;
	}
	my @s = split(/\t/, $_);
	if ( $s[5] > 0 ) {
		if ( length($s[3]) == length($s[4]) ) {
			$NUM_SNP += length($s[3]);
		} elsif ( length($s[3]) < length($s[4]) ) {
			$NUM_SNP += length($s[4]) - length($s[3]);
		} else {
			$NUM_SNP += length($s[3]) - length($s[4]);
		}
	}
}

my $QV = (-10) * log($NUM_SNP/$NUM_BP) / log(10); 
print "QV\t$QV\n";
print "SNP\t$NUM_SNP\n";
print "base\t$NUM_BP\n";
