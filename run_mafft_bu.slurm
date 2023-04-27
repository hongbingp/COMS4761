#!/bin/bash
#SBATCH --job-name=bm_msa
#SBATCH --partition=bigmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=28
#SBATCH --mem=100G


# Activate the conda environment
source /gpfs/commons/home/wlounsberyscaife/anaconda3/etc/profile.d/conda.sh
conda activate paml_env

cat REL606.fasta consensus_*.fasta > all_sequences1.fasta


# Perform MSA using MAFFT with parallel processing
mafft --auto --thread 28 renamed_all_sequences1.fasta > renamed_all_sequences_aligned1.fasta


# Convert the MSA file to PHYLIP format using seqret
seqret -sequence renamed_all_sequences_aligned1.fasta -outseq renamed_all_sequences_aligned1.phylip -osformat phylip

echo "MSA complete and converted to PHYLIP format."
