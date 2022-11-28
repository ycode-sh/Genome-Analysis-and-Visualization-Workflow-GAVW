'nextflow.enable=dsl2'
params.sam_markdup_script = "/home/yemi_codes/DamienGenotyper/templates/sam_markdup.sh"
params.bcf_call_script = "/home/yemi_codes/DamienGenotyper/templates/bcf_call.sh"
params.reference = "/home/yemi_codes/DamienGenotyper/reference_data/h37rv.fasta"


process sam_markdup {
    input: 
    val sam_markdup_script 
    path aligned_sam 
    
    output:
    path "markedup_${aligned_sam}.bam" 


    script:
    """
    bash ${sam_markdup_script} ${aligned_sam}

    """

}

process bcf_call_variants {

    input:
    val bcf_call_script 
    val reference 
    path sam_markedup 
    
    output:
    path "${sam_markedup}.vcf" 
    script:
    """
    bash ${bcf_call_script} ${reference}  ${sam_markedup}

    """
}


workflow bcftools_receives_filtered_aligned_sam {
    take:
        script_sam_markdup  
        aligned_sam
        script_bcf_call 
        reference_fa
    main:
        sam_markdup(script_sam_markdup, aligned_sam)
        bcf_call_variants(script_bcf_call, reference_fa, sam_markdup.out)

    emit:
        bcf_call_variants.out
}

