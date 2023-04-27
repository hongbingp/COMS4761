#!/bin/bash
#SBATCH --job-name=sp_msa0
#SBATCH --partition=pe2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=28
#SBATCH --mem=100G

# Activate the conda environment
source /gpfs/commons/home/wlounsberyscaife/anaconda3/etc/profile.d/conda.sh
conda activate paml_env

# Create a list of input fasta files
find . -name '*.fasta' > input_files.txt

# Use the FFT-NS-1 method for prioritizing speed and use all available CPUs
mafft --retree 1 --maxiterate 0 --thread 28 --multipair input_files.txt > aligned_genomes.fasta

