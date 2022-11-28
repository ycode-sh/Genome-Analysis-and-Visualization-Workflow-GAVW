'nextflow.enable=dsl2'
include {trim_fastq} from "/home/yemi_codes/DamienGenotyper/modules/gen_align_with_filtered_reads.nf"

params.script_run_mccortex = "/home/yemi_codes/DamienGenotyper/templates/run_mccortex.sh"
params.reference = "/home/yemi_codes/DamienGenotyper/reference_data/h37rv.fasta"
params.script_transform_output = "/home/yemi_codes/DamienGenotyper/templates/transform_cortex_output.sh"
params.seq = "/home/yemi_codes/DamienGenotyper/sra_data/sample_*.fastq_{1,2}"
params.script_trim_sample = "/home/yemi_codes/DamienGenotyper/templates/trim_sample.sh"
params.adapters = "/home/yemi_codes/DamienGenotyper/trim_adaptars/NexteraPE-PE.fa"

process mccortex_call_var {
    input:
    val mccortex_script
    val fastafile 
    tuple val(pair_id), path(reads) 

    output:
    path "markedup_aligned_${pair_id}_mc_calls" 


    script:
    """
    bash ${mccortex_script} ${fastafile} ${reads[0]} ${reads[1]} ${pair_id}
    """
}

process transform_mc_calls {
    input:
    val transform_mccortex_ouput
    tuple val(pair_id), path(vcf_folder)
    
    output:
    path "${pair_id}_sam_bam.vcf"

    script:
    """
    bash ${transform_mccortex_ouput} ${pair_id} ${vcf_folder}
    """
}

workflow handle_output {
    take:
        out_folder
        transform_mccortex_ouput_script
    main:
        mapped_output = out_folder | map { [it.name - ~/_mc_calls/, it] }
        transform_mc_calls(transform_mccortex_ouput_script, mapped_output)
    emit:
        transform_mc_calls.out
}

workflow receives_filtered_reads {
    take:
        filtered_reads
        script_mccortex
        reference_fa
    main:
        mccortex_call_var(script_mccortex, reference_fa, filtered_reads)
        handle_output(mccortex_call_var.out, Channel.value(params.script_transform_output))
    
    emit:
        handle_output.out
}

workflow mccortex_call_variant {
    trim_fastq(Channel.value(params.script_trim_sample), Channel.fromFilePairs(params.seq), Channel.value(params.adapters))
    trimmed_reads = trim_fastq.out | flatten | filter { it =~/P.fastq/ } | map { [it.name - ~/_[12]P.fastq/, it] } | groupTuple 
    receives_filtered_reads(trimmed_reads, Channel.value(params.script_run_mccortex), Channel.value(params.reference))
    emit:
        receives_filtered_reads.out
}
