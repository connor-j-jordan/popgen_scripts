#!/bin/bash

#SBATCH --job-name="Parse VCFs"
#SBATCH --mail-user=connor_jordan@brown.edu
#SBATCH --mail-type=ALL

#SBATCH --time=24:00:00
#SBATCH --output=vcf_parsing-%A.out
#SBATCH --error=vcf_parsing-%A.err

# Load Python3/Anaconda, activate conda env
module load python/3.7.4
module load anaconda/2020.02
source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh
conda activate vcf_env

# Load modules necessary for parsing
module load bcftools/1.10.2 gsl/2.5 gcc/8.3 perl/5.24.1

echo "Parsing VCF files in ${PWD}..."

# Run separate jobs for each VCF file in working directory
for VCF in *.vcf.gz; do

echo "Removing polyallelic sites for ${VCF}..."
srun bcftools view -m2 -M2 -v snps -Oz -o biallelic_${VCF} ${VCF}
echo "Done!"

done
