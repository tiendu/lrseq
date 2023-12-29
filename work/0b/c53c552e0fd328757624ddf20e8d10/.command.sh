#!/bin/bash -ue
zcat \
     \
    merged_SRR20752610.fastq.gz | \
chopper \
    --threads 6 \
     | \
gzip \
     > trimmed_SRR20752610_R1.fastq.gz

cat <<-END_VERSIONS > versions.yml
"NANOSEQ:NANOPORE_TRIMMING:CHOPPER":
    chopper: $(chopper --version 2>&1 | cut -d ' ' -f 2)
END_VERSIONS
