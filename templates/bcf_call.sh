#!/bin/bash

#Use the genotype likelihood results from bcfpileup to call variants for each genomic position ( there is need to have the 
# fasta index file available. The file may be compressed). Also, the --read-groups FILE option may be included. When dealing with group samples
# samples from different poputaion, the --group-samples option should be employed. A mini annotation can be employed \
# hear too using the bcf annotate  
# The --bam-list markedbam.txt option, where markedbam.txt is a file containg alignment files, one per line, can be used when one is handling 
# a large amount of files. But because I'm using nextflow, I don't need to use it. The same thing applies for --samples-file FILE,  where FILE
# is a file listing the sample names to include or exclude if prefixed with "^", one per line.
# I did not use the --variants-only and --keep-alts options (I want to see the effect)  [--ambiguous-reads inCAD]
# fastafile = $1; mardup_bam = $2 bai_index = $4 fasta_index = $5
   
   bcftools mpileup --full-BAQ \
   --fasta-ref $1 --min-BQ 10 --min-MQ 20 \
   --skip-any-set UNMAP,SECONDARY,QCFAIL,DUP  --tandem-qual 85 --indel-bias 2.0 \
   --output-type u $2 | bcftools call --ploidy 2 \
   --multiallelic-caller --variants-only --output ${2}.vcf
