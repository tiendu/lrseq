include { INPUT_CHECK } from '../subworkflows/input_check'
include { QCFASTQ_NANOPLOT_FASTQC } from '../subworkflows/qcfastq_nanoplot_fastqc'

workflow NANOSEQ { 
    INPUT_CHECK ( params.input )
        .set { ch_sample }
    ch_sample
        .map { it -> [ it[0], it[2] ] }
        .set { ch_fastq }
    QCFASTQ_NANOPLOT_FASTQC ( ch_fastq )
}
