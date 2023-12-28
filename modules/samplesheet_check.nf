process SAMPLESHEET_CHECK {
    tag "$samplesheet"
    label 'process_single'

    conda "conda-forge::python=3.8.3"
    container "quay.io/biocontainers/python:3.8.3"

    input:
    path samplesheet

    output:
    path "*.csv", emit: csv
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when
    
    """
    check_samplesheet.py \\
        --input $samplesheet \\
        --output \$(dirname $samplesheet)/samplesheet.valid.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
