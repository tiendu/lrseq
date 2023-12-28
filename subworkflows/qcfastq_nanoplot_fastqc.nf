include { NANOPLOT } from '../modules/nanoplot'
include { FASTQC } from '../modules/fastqc'

workflow QCFASTQ_NANOPLOT_FASTQC {
    take:
    ch_fastq

    main:
    ch_fastq
        .map { ch -> [ ch[0], ch[1] ] }
        .set { ch_fastq }

    // QC using NanoPlot
    NANOPLOT ( ch_fastq )
//    nanoplot_png = NANOPLOT.out.png // Optional
    nanoplot_html = NANOPLOT.out.html
    nanoplot_txt = NANOPLOT.out.txt
    nanoplot_log = NANOPLOT.out.log
    nanoplot_version = NANOPLOT.out.versions

    // QC using FastQC
    FASTQC ( ch_fastq )
    fastqc_zip = FASTQC.out.zip
    fastqc_html = FASTQC.out.html
    fastqc_version = FASTQC.out.versions

    emit:
//    nanoplot_png
    nanoplot_html
    nanoplot_txt
    nanoplot_log
    nanoplot_version

    fastqc_zip
    fastqc_html
    fastqc_version
//    fastqc_multiqc
}
