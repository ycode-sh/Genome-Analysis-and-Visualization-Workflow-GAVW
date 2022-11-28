#!/bin/bash

# This comand takes input vcf files, fastq files, and fasta reference and output result in a specified outdir
# read1= $1 read2= $2 fastafile = $3 vcf_1 = $4 vcf_2 = $5 samplename = $6

mv $4 calls1.vcf 
mv $5 calls2.vcf
minos adjudicate --reads $1 --reads $2 ${6}_minos_adj_run $3 calls1.vcf calls2.vcf 
cd ${6}_minos_adj_run
mv final.vcf "aligned_${6}_adj_vcf"
mv "aligned_${6}_adj_vcf" ../