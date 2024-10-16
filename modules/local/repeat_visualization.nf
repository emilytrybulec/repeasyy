process REPEAT_VIEW {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container 'library://etrybulec/te_tools/repeatmasker'

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
    /opt/RepeatMasker/util/calcDivergenceFromAlign.pl \\
        -s ${prefix} \\
        $align

    /opt/RepeatMasker/util/createRepeatLandscape.pl \\
        -div ${prefix} \\
        -twoBit $twoBit > ${prefix}.html

    """
}
