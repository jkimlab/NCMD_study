#!/bin/bash

## Requirement: freebayes

## Inut: (i) assembly fasta file, (ii) mapping file 
assembly_fa=$1;
bam=$2;

## Calculate QV score
freebayes  -C 2 -0 -O -q 20 -z 0.10 -E 0 -X -u -p 2 -F 0.75 -b $bam -v freebayes.vcf -f $assembly_fa >& freebayes.log
perl QV_estimation.pl freebayes.vcf $bam > assembly.qv
