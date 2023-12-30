include { INPUT_CHECK } from '../subworkflows/input_check'
include { QCFASTQ_NANOPLOT_FASTQC } from '../subworkflows/qcfastq_nanoplot_fastqc'
include { NANOPORE_TRIMMING } from '../subworkflows/nanopore_trimming'
include { FLYE } from '../modules/flye.nf'
include { QUAST } from '../modules/quast' 

workflow NANOSEQ { 
    INPUT_CHECK ( params.input )
        .set { ch_sample }

    QCFASTQ_NANOPLOT_FASTQC ( ch_sample )
    NANOPORE_TRIMMING ( ch_sample )

    mode = "--" + params.mode
    FLYE ( NANOPORE_TRIMMING.out.fastq, mode )
    
    reference = params.reference ?: ''
    gff = params.gff ?: ''
    
    QUAST ( FLYE.out.fasta, [], [] )
}
