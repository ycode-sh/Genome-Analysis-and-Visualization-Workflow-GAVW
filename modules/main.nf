'nextflow.enable=dsl2'
//include {receives_unfiltered_reads as gen_align} from "/home/yemi_codes/DamienGenotyper2/modules/gen_align_with_filtered_reads.nf"
include {bcftools_receives_filtered_aligned_sam as bcf_call} from "/home/yemi_codes/DamienGenotyper2/modules/bcf_call_var.nf"
include {gatk_receives_filtered_aligned_sam as gatk_call} from "/home/yemi_codes/DamienGenotyper2/modules/gatk_call_var.nf"
include {minos_receives_raw_variants as minos_adjudicate} from "/home/yemi_codes/DamienGenotyper2/modules/minos_call_var2.nf"
//include {minos_receives_adj_vcfs as minos_joint_geno} from "/home/yemi_codes/DamienGenotyper2/modules/joint_genotype_calls.nf"

params.reference = "/home/yemi_codes/DamienGenotyper2/reference_data/h37rv.fasta"
params.seq = "/home/yemi_codes/DamienGenotyper2/sra_data/sample_*.fastq_{1,2}"
params.script_trim_sample = "/home/yemi_codes/DamienGenotyper2/templates/trim_sample.sh"
params.adapters = "/home/yemi_codes/DamienGenotyper2/trim_adaptars/NexteraPE-PE.fa"
params.gen_align_script = "/home/yemi_codes/DamienGenotyper2/templates/gen_align.sh"
params.sam_markdup_script = "/home/yemi_codes/DamienGenotyper2/templates/sam_markdup.sh"
params.bcf_call_script = "/home/yemi_codes/DamienGenotyper2/templates/bcf_call.sh"
params.coordsortidx_bam_script = "/home/yemi_codes/DamienGenotyper2/templates/coordsortidx_bam.sh"
params.gatk_markdup_script = "/home/yemi_codes/DamienGenotyper2/templates/gatk_markdup.sh"
params.gatk_call_script = "/home/yemi_codes/DamienGenotyper2/templates/gatk_call_var.sh"
params.var_adj_script = "/home/yemi_codes/DamienGenotyper2/templates/var_adj.sh"
params.prepare_manifest_script = "/home/yemi_codes/DamienGenotyper2/templates/prepare_manifest.sh"
params.joint_geno_script = "/home/yemi_codes/DamienGenotyper2/templates/joint_genotype.sh"

process trim_fastq {    
    
    input:
    val(script_trim_sample)
    tuple val(pair_id), path(reads)
    val(adapter) 
   

    output:
    path "filtered_sample_*.fastq", emit: trim_out

    script:
    
    """
    bash ${script_trim_sample} ${reads[0]} ${reads[1]} ${pair_id} ${adapter}
    """
}

process align_reads_to_ref {
    
    input:
    val script_gen_align
    tuple val(pair_id), path(reads)  
    val reference 
    

    output:
    path "aligned_${pair_id}_sam", emit: align_out

    script:
    """
    bash ${script_gen_align} ${reads[0]} ${reads[1]} ${reference} ${pair_id} "aligned_${pair_id}_sam"
   
    """
}

process coordsortidx_aligned_sam {
  
    input:
    val coordsortidx_bam_script 
    path aligned_sam 
    
    output:
    path "${aligned_sam}.bam", emit: sorted_bam
    
    script:
    """
    bash ${coordsortidx_bam_script } ${aligned_sam} "${aligned_sam}.bam" 
    """
   
}

workflow from_raw_reads_to_genotped_vcf{
    take:
        trim_sample_script
        take_reads
        take_adapters
        gen_align_script
        reference_fa
        script_sam_markdup
        script_bcf_call
        script_coordsortidx_bam
        gatk_mark_dup_script
        gatk_call_var_script
        script_var_adj
        //script_prepare_manifest
        //script_joint_geno

    main:
        // Trim sample reads
        trim_fastq(trim_sample_script, take_reads, take_adapters)
        trimmed_reads = trim_fastq.out | flatten | filter { it =~/P.fastq/ } | map { [it.name - ~/_[12]P.fastq/, it] } | groupTuple 
        // Align reads to referenc genome
        align_reads_to_ref(gen_align_script, trimmed_reads, reference_fa)
        // sort and and convert sam to  baam 
        bamfiles = coordsortidx_aligned_sam(script_coordsortidx_bam, align_reads_to_ref.out)
        // call variants
        bcf_call(script_sam_markdup, align_reads_to_ref.out, script_bcf_call, reference_fa)
        gatk_call(gatk_mark_dup_script, bamfiles, gatk_call_var_script, reference_fa)
        // adjudicate variants
        minos_adjudicate(bcf_call.out, gatk_call.out, script_var_adj, trimmed_reads, reference_fa)
        // Prepare for joint genotyping
        //vcf_list = adjudicate_output | collect    
        //bam_lists = bamfiles | collect
        //joint_geno_sample_id = bamfiles | map { [it.name - ~/_sam.bam/, it] } | filter { it =~/aligned_filtered_sample_[15]/ } | collectFile (name: 'namefile', sort: true, newLine: true, storeDir: 'collection3') | collect
        // joint genotype samples
        //minos_joint_geno(script_prepare_manifest, joint_geno_sample_id, vcf_list, bam_lists, script_joint_geno, reference_fa)
        emit:
           minos_adjudicate.out
    }


workflow  {
    pipeline_output = from_raw_reads_to_genotped_vcf(Channel.value(params.script_trim_sample), Channel.fromFilePairs(params.seq),
                                    Channel.value(params.adapters), Channel.value(params.gen_align_script),
                                    Channel.value(params.reference), Channel.value(params.sam_markdup_script),
                                    Channel.value(params.bcf_call_script), Channel.value(params.coordsortidx_bam_script),
                                    Channel.value(params.gatk_markdup_script), Channel.value(params.gatk_call_script),
                                    Channel.value(params.var_adj_script))
    pipeline_output | collect | view

}



// | filter { it =~/aligned_filtered_sample_[0-9]/ }
// | collectFile (name: 'vcffile', sort: true, newLine: true, storeDir: 'collection1')
// | collectFile (name: 'bamfile', sort: true, newLine: true, storeDir: 'collection2')