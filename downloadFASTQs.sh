#!/bin/bash

# Usage: ./download_fastqs_paired.sh input.tsv

INPUT_FILE="$1"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Input file not found: $INPUT_FILE"
    exit 1
fi

OUTDIR=$1"_fastq_downloads"
mkdir -p "$OUTDIR"

tail -n +2 "$INPUT_FILE" | while IFS=$'\t' read -r internal_id customer_label read1 read2; do
    read1_clean=$(echo "$read1" | tr -d '\r' | xargs)
    read2_clean=$(echo "$read2" | tr -d '\r' | xargs)

    if [[ -n "$read1_clean" ]]; then
        echo "Downloading ${internal_id}_R1.fastq.gz..."
        curl -L "$read1_clean" -o "${OUTDIR}/${internal_id}_R1.fastq.gz"
    else
        echo "Missing read1 for $internal_id"
    fi

    if [[ -n "$read2_clean" ]]; then
        echo "Downloading ${internal_id}_R2.fastq.gz..."
        curl -L "$read2_clean" -o "${OUTDIR}/${internal_id}_R2.fastq.gz"
    else
        echo "Missing read2 for $internal_id"
    fi

done

echo "All downloads complete. Files saved in $OUTDIR/"
