#!/bin/env/bash

#This scripts contains code to check the quality of reads, trim adapters and low quality reads, and then 
# recheck the reads' quality post-trimming using fastqc, trimmomatic, and fastqc respectively.

# Preprocessing: run fastqc and trimmomatic simultaneously
# inputs: fastq reads
# positional parameters: $1=sequence reads 1; $2 = sequence reads 2; $3 = name of output dir; $4 = adapter file


    trimmomatic PE -trimlog trimlogfile $1 $2 \
    "filtered_$3_1P.fastq" "filtered_$3_1U.fastq" "filtered_$3_2P.fastq" "filtered_$3_2U.fastq" \
    ILLUMINACLIP:$4:2:30:10:1:True SLIDINGWINDOW:30:20 MAXINFO:170:0.5 MINLEN:150


