'nextflow.enable=dsl2'

params.seq = "/home/yemi_codes/DamienGenotyper/sra_data/sample_*.fastq_{1,2}"
params.script_trim_sample = "/home/yemi_codes/DamienGenotyper/templates/trim_sample.sh"
params.adapters = "/home/yemi_codes/DamienGenotyper/trim_adaptars/NexteraPE-PE.fa"
params.script_gen_align = "/home/yemi_codes/DamienGenotyper/templates/gen_align.sh"
params.reference = "/home/yemi_codes/DamienGenotyper/reference_data/h37rv.fasta"



process align_reads_to_ref {
    
    input:
    val script_gen_align
    tuple val(pair_id), path(reads)  
    val reference 
    

    output:
    path "aligned_${pair_id}_sam" 

    script:
    """
    bash ${script_gen_align} ${reads[0]} ${reads[1]} ${reference} ${pair_id} "aligned_${pair_id}_sam"
   
    """
}


workflow receives_unfiltered_reads {
    take:
        trim_sample_script
        unfiltered_reads
        adapter
        gen_align_script
        reference
        
        
    main:
        align_reads_to_ref(gen_align_script, trimmed_reads, reference)
    emit:
       align_reads_to_ref.out
    
}

        