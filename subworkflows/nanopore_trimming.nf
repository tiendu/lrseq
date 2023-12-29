include { CHOPPER } from '../modules/chopper'

workflow NANOPORE_TRIMMING {
    take:
    ch_sample

    main:
    ch_sample
        .map { ch -> [ ch[0], ch[2] ] }
        .set { ch_fastq }

    CHOPPER ( ch_fastq )

    emit:
    CHOPPER.out.fastq
    CHOPPER.out.versions
}
