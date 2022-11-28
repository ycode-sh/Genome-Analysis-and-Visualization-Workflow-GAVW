#!/bin/bash

 
 # This command takes two inputs: reference.fasta and _input.bam (recalibrated or simply marked). The reference.dict, and all input indexes
 # must be supplied. The script emits a single output; reference.fasta = $1; input.bam = $2 output = $3

 samtools index $2
 gatk HaplotypeCaller \
    --reference $1 \
    --input $2 \
    --sample-ploidy 2 \
    --output "${2}.vcf"
    

    # samtools faidx $1 --output h37rv.fai
 #gatk CreateSequenceDictionary \
  #      --REFERENCE $1 
   #     --OUTPUT h37rv.dict

#mv  /home/opeyemi/mtb_file/workspace/Data/h37rv.fai /home/opeyemi/mtb_file/workspace/Data/h37rv.dict .