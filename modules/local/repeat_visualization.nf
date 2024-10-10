process REPEAT_VIEW {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/repeatmasker:4.1.5--pl5321hdfd78af_0' :
        'biocontainers/repeatmasker:4.1.5--pl5321hdfd78af_0' }"

    input:
    tuple val(meta), path(align)
    tuple val(meta), path(twoBit)


    output:
    tuple val(meta), path("*html"), emit: out

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    /usr/local/share/RepeatMasker/util/calcDivergenceFromAlign.pl \\
        -s ${prefix} \\
        $align

    /usr/local/share/RepeatMasker/util/createRepeatLandscape.pl \\
        -div ${prefix} \\
        -twoBit $twoBit > ${prefix}.html

    """
}
