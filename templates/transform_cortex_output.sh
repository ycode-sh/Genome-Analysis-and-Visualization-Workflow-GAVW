#!/bin/bash

# data = $1 sample_ID = $2

mv ${2}/vcfs/bubbles.joint.links.k31.geno.vcf.gz .
mv bubbles.joint.links.k31.geno.vcf.gz ${1}_sam_bam.vcf.gz
gunzip -f ${1}_sam_bam.vcf.gz