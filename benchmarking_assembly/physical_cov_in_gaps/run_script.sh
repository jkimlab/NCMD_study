#!/bin/bash

## Requirements: samtools, bedtools

## Inut: (i) assembly fasta file, (ii) assembly size, (iii) mapping file 
assembly_fa=$1;
assembly_size=$2;
bam=$3;
mapq=$4;

## Identify coordinates of gap regions
perl step1.find_gap.pl $assembly_fa > gap.bed

## Calculate a physical coverage for each base
perl step2.calc_phycov_per_base.pl $bam $assembly_size $mapq

## Calculate a genome-wide average of physical coverage
perl step3.calc_avg.pl $assemby_size phycov.txt > phycov.genome_avg.txt

## Calculate physical coverages in gap regions
perl step4.extract_phycov.pl gap.bed phycov.txt > phycov.inGap.txt
