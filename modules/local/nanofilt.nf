process NANOFILT {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "bioconda::nanofilt=2.8.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/nanofilt:2.8.0--py_0':
        'quay.io/biocontainers/nanofilt:2.8.0--py_0' }"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.fastq.gz"), emit: reads
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    gunzip -c $reads | NanoFilt $args | gzip > ${prefix}.filtered.fastq.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nanofilt: \$( NanoFilt --version | sed -e "s/NanoFilt //g" )
    END_VERSIONS
    """
}
