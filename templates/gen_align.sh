#!/bin/bash

# This script uses fastafile to generate bwa index of genome refrence, takes quality PE fastq files and maps them with
# a reference file to generate an alignment

# Explicit inputs: PE files, reference file
# Inputs that must be present in that directory: products of bwa index
# The read group information should be specified as a parameter file for process(s) that use(s) this script   
# fastafile=$1; filtered_fastq1=$2; filtered_fastq2=$3; sample_ID =$4 output.sam = $5



bwa index $3
bwa mem -R "@RG\tID:run_$4\tPL:ILLUMINA\tLB:paired_end\tSM:$4" $3 $1 $2 -o $5
