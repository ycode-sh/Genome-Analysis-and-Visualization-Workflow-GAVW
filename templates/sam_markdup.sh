#!/bin/bash

# This script marks duplicates in  alignement file. It takes alined sam file as input. Since coordsortidx.sh \
# script also takes similar input, we can fork a channel to supply both processes the input. By creating an array, we
# can control the output that will be released for downstream analysis.  aligned.sam=$1

samtools view -b $1 | samtools sort -n -o namesort_${1}.bam
samtools fixmate -m namesort_${1}.bam fixmate_${1}.bam
samtools sort -o positionsort_${1}.bam fixmate_${1}.bam
samtools markdup positionsort_${1}.bam markedup_${1}.bam