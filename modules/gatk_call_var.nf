'nextflow.enable=dsl2'

process gatk_mark_dup {
        input:
        val gatk_markdup_script 
        path coord_sort_aln 
        
         
        
        output:
        path "markedup_${coord_sort_aln}" 
        
       
        
        script:
        """
        bash ${gatk_markdup_script} ${coord_sort_aln} 
        """
}

process gatk_call_variant {
    input:
    val gatk_call_script
    val reference
    path marked_bam
    
    
    output:
    path "${marked_bam}.vcf" 

    script:
    """
    bash ${gatk_call_script} ${reference} ${marked_bam} 
    """
}

workflow gatk_receives_filtered_aligned_sam {
    take:
        script_gatk_markdup
        sorted_bam
        script_gatk_call
        reference_fa

    main:
        gatk_mark_dup (script_gatk_markdup, sorted_bam)
        gatk_call_variant (script_gatk_call, reference_fa, gatk_mark_dup.out)

    emit:
        gatk_call_variant.out

}
