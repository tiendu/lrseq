#!/bin/bash -ue
NanoPlot \
     \
    -t 2 \
    --fastq merged_SRR20752596.fastq.gz

cat <<-END_VERSIONS > versions.yml
"NANOSEQ:QCFASTQ_NANOPLOT_FASTQC:NANOPLOT":
    nanoplot: $(echo $(NanoPlot --version 2>&1) | sed 's/^.*NanoPlot //; s/ .*$//')
END_VERSIONS
