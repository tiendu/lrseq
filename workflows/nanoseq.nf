include { INPUT_CHECK } from '../subworkflows/input_check'
include { QCFASTQ_NANOPLOT_FASTQC } from '../subworkflows/qcfastq_nanoplot_fastqc'
include { NANOPORE_TRIMMING } from '../subworkflows/nanopore_trimming'

workflow NANOSEQ { 
    INPUT_CHECK ( params.input )
        .set { ch_sample }
    QCFASTQ_NANOPLOT_FASTQC ( ch_sample )
    NANOPORE_TRIMMING ( ch_sample )
}
