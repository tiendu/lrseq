#!/usr/bin/env python
import os
import sys
import argparse
import logging
from typing import Optional

logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)

def check_extension(read: str) -> bool:
    extensions = {".fastq.gz", ".fq.gz", ".bam"}
    return read.endswith(tuple(extensions))

def validate_samplesheet_header(header: list) -> None:
    HEADER = ["sample", "read1", "read2", "metadata"]
    if header != HEADER:
        logger.error(f"Invalid samplesheet header -> {','.join(header)} != {','.join(HEADER)}")
        sys.exit(1)

def validate_sample_line(lspl: list) -> tuple:
    sample, read1, read2, metadata = lspl

    if " " in read1 or ("read2" in lspl and " " in read2):
        logger.error(f"Input file contains spaces!\nLine: {lspl}")
        sys.exit(1)

    if not check_extension(read1) or ("read2" in lspl and not check_extension(read2)):
        logger.error(f"Invalid file extension!\nLine: {lspl}")
        sys.exit(1)

    if not os.path.exists(read1):
        logger.error(f"Read1 does not exist: {read1}\nLine: {lspl}")
        sys.exit(1)

    if read2 and not os.path.exists(read2):
        logger.error(f"Read2 does not exist: {read2}\nLine: {lspl}")
        sys.exit(1)

    return sample, read1, read2, metadata

def check_samplesheet(file_in: str, file_out: str) -> None:
    input_extensions = set()
    sample_info_list = []

    with open(file_in, "r") as fin:
        header = fin.readline().strip().split(",")
        validate_samplesheet_header(header)

        for line in fin:
            lspl = [x.strip() for x in line.strip().split(",")]

            if len(lspl) < len(header):
                logger.error(f"Invalid number of columns (minimum = {len(header)})!\nLine: {lspl}")
                sys.exit(1)

            sample, read1, read2, metadata = validate_sample_line(lspl)

            input_extensions.add(os.path.splitext(read1)[1])
            if read2:
                input_extensions.add(os.path.splitext(read2)[1])

            if read2:
                sample_info_list.append((f"{sample}_R1", sample, read1, metadata))
                sample_info_list.append((f"{sample}_R2", sample, read2, metadata))
            else:
                sample_info_list.append((f"{sample}_R1", sample, read1, metadata))

    if len(set(input_extensions)) > 1:
        logger.error(f"All input files must have the same extension!\nMultiple extensions found: {', '.join(input_extensions)}")
        sys.exit(1)

    if sample_info_list:
        out_dir = os.path.dirname(file_out)
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)

        with open(file_out, "w") as fout:
            fout.write(",".join(["id", "sample", "read", "metadata"]) + "\n")
            for entry in sample_info_list:
                fout.write(",".join(map(str, entry)) + "\n")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True, help="Path to the input samplesheet.")
    parser.add_argument("-o", "--output", required=True, help="Path to the output samplesheet.")
    args = parser.parse_args()

    check_samplesheet(args.input, args.output)

if __name__ == "__main__":
    main()

