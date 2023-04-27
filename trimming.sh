#!/bin/bash

source activate paml_env

# Function to extract forward and reverse reads
extract_reads() {
  input_file="$1"
  forward_file="$2"
  reverse_file="$3"

  awk 'NR % 8 == 1 || NR % 8 == 2 || NR % 8 == 3 || NR % 8 == 4 {print}' "${input_file}" > "${forward_file}"
  awk 'NR % 8 == 5 || NR % 8 == 6 || NR % 8 == 7 || NR % 8 == 0 {print}' "${input_file}" > "${reverse_file}"
}

for input_file in *_paired.fastq; do
  echo "Processing ${input_file}"

  base_name="${input_file%_paired.fastq}"
  forward_file="${base_name}_forward.fastq"
  reverse_file="${base_name}_reverse.fastq"

  extract_reads "${input_file}" "${forward_file}" "${reverse_file}"

  trimmomatic PE -phred33 \
    "${forward_file}" \
    "${reverse_file}" \
    "${base_name}_forward_paired.fastq" \
    "${base_name}_forward_unpaired.fastq" \
    "${base_name}_reverse_paired.fastq" \
    "${base_name}_reverse_unpaired.fastq" \
    SLIDINGWINDOW:4:20 MINLEN:36
done

echo "Trimmomatic processing complete"

