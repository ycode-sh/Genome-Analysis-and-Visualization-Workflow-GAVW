'nextflow.enable=dsl2'

process prepare_manifest {
    input:
    val script_manifest
    path sample_id
    path vcf_list
    path sorted_bamlist

    output:
    path "manifest.tsv"

    script:
    """
    bash ${script_manifest} ${sample_id[0]} ${sample_id[1]} ${vcf_list[0]} ${vcf_list[1]} ${sorted_bamlist[0]} ${sorted_bamlist[1]}

    """

}

process joint_genotype {
    input:
        path script_joint_geno
        val reference
        path manifest

    output:
        path "joint_geno_result"

    script:
        """
        bash ${script_joint_geno} ${reference} ${manifest}
        """
}

workflow minos_receives_adj_vcfs {
    take:
        manifest_script
        sample_ids
        vcf_lists
        bam_lists
        joint_geno_script
        reference_fa

    main:
        prepare_manifest(manifest_script, sample_ids, vcf_lists, bam_lists)
        joint_genotype(joint_geno_script, reference_fa, prepare_manifest.out)


    emit:
        joint_genotype.out

}
