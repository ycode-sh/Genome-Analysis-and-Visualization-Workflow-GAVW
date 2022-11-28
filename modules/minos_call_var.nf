'nextflow.enable=dsl2'

process adjudicate_var {
  
    input:
    val var_adj_script
    tuple val(pair_id), path(reads)
    val reference  
    tuple val(vcf_id), path(vcf_1, stageAs: 'calls1'), path(vcf_2)
    
    
    output:
    path  "aligned_${pair_id}_adj_vcf"

    script:
    """
    bash ${var_adj_script} ${reads[0]} ${reads[1]} ${reference} ${vcf_1} ${vcf_2} ${pair_id} 
    """
}

workflow minos_receives_raw_variants {
    take:
        bcf_vcf
        gatk_vcf
        script_adj_var
        filtered_reads
        reference_fa
        

    main:
        bcf_tuple = bcf_vcf | map { [it.name - ~/_sam.bam.vcf/, it] }
        gatk_tuple = gatk_vcf | map { [it.name - ~/_sam.bam.vcf/, it]}
        joined_vcfs = bcf_tuple.join(gatk_tuple)
        
    
        adjudicate_var(script_adj_var, filtered_reads, reference_fa, joined_vcfs)

        emit:
        adjudicate_var.out
}

