#!/bin/bash -ue
printf "%s %s\n" merged_SRR20752610.fastq.gz SRR20752610_R1.gz | while read old_name new_name; do
    [ -f "${new_name}" ] || ln -s $old_name $new_name
done

fastqc \
     \
    --threads 6 \
    SRR20752610_R1.gz

cat <<-END_VERSIONS > versions.yml
"NANOSEQ:QCFASTQ_NANOPLOT_FASTQC:FASTQC":
    fastqc: $( fastqc --version | sed '/FastQC v/!d; s/.*v//' )
END_VERSIONS
