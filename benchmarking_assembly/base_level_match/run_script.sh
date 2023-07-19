#!/bin/bash

## requirement: chainToAxt

## inputs: (i) chain, (ii) building.blooks, (iii) 2bit file for reference, (iv) 2bit file for target
chain=$1;
block=$2;
r2bit=$3;
t2bit=$4;

perl step1.extract_used_chain_block.pl $chain $block > used.chain

chainToAxt used.chain $r2bit $t2bit used.axt

perl step2.axt2base.pl used.axt > used.base

perl step3.ovlp_obsv.pl used.axt used.base > overlapped_region.info.txt

perl step4.match_mismatch_stats.pl used.base overlapped_region.info.txt > match_mismatch_stats.txt
