include { SAMPLESHEET_CHECK } from '../modules/samplesheet_check'

workflow INPUT_CHECK {
    take:
    samplesheet

    main:
    SAMPLESHEET_CHECK (samplesheet)
        .csv
        .splitCsv (header: true, sep:',')
        .map { get_sample_info(it) }
        .map { it -> [ it[0], it[1], it[2], it[3] ] }
        .set { ch_sample }

    emit:
    ch_sample // ["id", "sample", "read", "metadata"]
}

def get_sample_info(LinkedHashMap sample) {
    def meta = [:]
    meta.id  = sample.id

    read = sample.read ? file(sample.read, checkIfExists: true) : null
    metadata = sample.metadata ? sample.metadata : null

    return [ meta, sample.sample, read, metadata ]
}
