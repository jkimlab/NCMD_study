#!/bin/bash

## Requirement: bedtools

## Inut: Program outpus in bed format
rfam_out=$1;
rnammer_out=$2;
trnascan_out=$3;

## Identify intersections among outputs
bedtools intersect -f 0.5 -wa -wb -a $rfam_out -b $rnammer_out -b $trnascan_out > intersect_out.txt

## Make a non-redundant result in gff format
perl make_nrout.pl intersect_out.txt $rfam_out $rnammer_out $trnascan_out > nr_ncRNA.gff
