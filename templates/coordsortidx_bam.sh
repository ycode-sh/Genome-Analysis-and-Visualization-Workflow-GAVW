#!/bin/bash
# This script takes aligned samfile, coordinate-sort it and convert it to bam. The bam file is both formed as 
# output and also used downstream as input for indexing. So two output are generated
# 2nd, it takes a refernce.fasta file, and index it. So in all, many index files and one sorted bam files are output
# aligned_sam=$1; reference.fasta = $2; sample_name_specified = $3  


samtools sort $1 | samtools view -b > $2

samtools index -b $2 > ${2}.bai


