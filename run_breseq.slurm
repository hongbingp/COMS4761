#!/bin/bash
#SBATCH --job-name=c_bre
#SBATCH --partition=pe2
#SBATCH --nodes=1
#SBATCH --mem=20G
#SBATCH --time=12:00:00
#SBATCH --output=/commons/groups/gursoy_lab/nhayes/4761/control/breseq_job_outfiles/%j.out

source activate paml_env


# Set the reference genome filename
reference_genome="REL606.fasta"

# Function to run breseq for paired-end files
run_breseq_paired() {
  base_name="$1"
  forward_file="${base_name}_forward_paired.fastq"
  reverse_file="${base_name}_reverse_paired.fastq"
  output_dir="breseq_output_${base_name}"

  breseq -j 8 -r "${reference_genome}" -o "${output_dir}" "${forward_file}" "${reverse_file}"
}

# Function to run breseq for single-end files
run_breseq_single() {
  base_name="$1"
  single_file="${base_name}_trimmed.fastq"
  output_dir="breseq_output_${base_name}"

  breseq -j 8 -r "${reference_genome}" -o "${output_dir}" "${single_file}"
}

# Run breseq for each set of paired-end files
for forward_paired_file in *_forward_paired.fastq; do
  base_name="${forward_paired_file%_forward_paired.fastq}"
  echo "Running breseq for paired-end sample: ${base_name}"
  run_breseq_paired "${base_name}"
done

# Run breseq for each single-end file
for trimmed_single_file in *_trimmed.fastq; do
  base_name="${trimmed_single_file%_trimmed.fastq}"
  echo "Running breseq for single-end sample: ${base_name}"
  run_breseq_single "${base_name}"
done

echo "Breseq analysis complete."

