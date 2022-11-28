#!/bin/bash

# This command takes a coordinate-sorted bam file as a direct input.  All input must be indexed. The input bam must be coordinate-sorted  
# (A script in the with_samtools dir already performs indexing of the bam file and reference, and its output should supply this script)
# The reference.dict and fasta.fai files must be available;  coord_sorted_input.bam = $1

    gatk MarkDuplicates \
    --INPUT $1 \
    --METRICS_FILE marked_dup_metrics.txt \
    --OUTPUT "markedup_${1}"
