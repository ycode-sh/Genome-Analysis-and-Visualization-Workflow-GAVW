#!/bin/bash

# This scripts create sample file to be used to create the samplefile necessary for mccortex job creation. 
# The sample name read-files type are supplied as positional arguments on process command line. A dircetory to keep the output files
# must be created and specified on the run.
# sample_name = $4, read1=$2, read2=$3 all specified as string; fastafile=$1

{ echo "#sample_name    SE_Files    PE_Files    Interleaved_files"; echo "$4 .   $2:$3   ."; } > ${4}_file.txt

mkdir ${4}_mc_calls
/home/yemi_codes/templates/make-pipeline.pl -r $1 --ploidy 2 31 markedup_aligned_${4}_mc_calls ${4}_file.txt > ${4}_job.mk

make -f ${4}_job.mk CTXDIR=/home/yemi_codes/miniconda3/pkgs/mccortex-1.0-h9a82719_4 MEM=3GB NKMERS=30M bub-geno-vcf

