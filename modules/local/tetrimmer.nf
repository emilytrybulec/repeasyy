process TE_TRIMMER {
    tag "$meta.id"
    label 'process_high'

    container 'quay.io/biocontainers/tetrimmer:1.4.0--hdfd78af_0'

    input:
    tuple val(meta), path(curation_fasta)
    tuple val(meta), path(genome_fasta)
    val(cons_thr)

    output:
    path('TE*/TE*/Ann*/*.pdf')                           , emit: pdf
    tuple val(meta), path('TE*/TEtrimmer_consensus_merged.fasta')        , emit: fasta

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "te_${meta.id}"
    """   
    
    python ${projectDir}/assets/TEtrimmer/tetrimmer/TEtrimmer.py --input_file $curation_fasta \\
          --genome_file $genome_fasta \\
          --output_dir . \\
          --num_threads $task.cpus \\
          --classify_all   \\
          --dedup \\
          --min_blast_len 60 \\
         --cons_thr $cons_thr
    """
}
