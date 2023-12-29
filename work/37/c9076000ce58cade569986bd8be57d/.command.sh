#!/bin/bash -ue
check_samplesheet.py \
    --input samplesheet.csv \
    --output $(dirname samplesheet.csv)/samplesheet.valid.csv

cat <<-END_VERSIONS > versions.yml
"NANOSEQ:INPUT_CHECK:SAMPLESHEET_CHECK":
    python: $(python --version | sed 's/Python //g')
END_VERSIONS
