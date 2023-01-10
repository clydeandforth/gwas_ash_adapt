#!/bin/bash

#SBATCH -o amtools.o.%J
#SBATCH -J Samtools
##SBATCH --exclusive
#SBATCH -e amtools.e.%J
#SBATCH -N 1
##SBATCH --ntasks=40
#must be at least 40
##SBATCH --ntasks-per-node=40
##SBATCH --cpus-per-task=40
##SBATCH -t 0-03:00
#SBATCH -p dev

module load samtools/1.10

#ls *.bam | sed -e 's/\.bam//' > file.txt
#ls *.bam > file1.txt


#while IFS=$'\t' read -r f1 f2
#do

 # samtools view -S -b "$f2" > "$f1".bam
 # samtools sort "$f1".bam -o "$f1"_sorted.bam
 # samtools index "$f1"_sorted.bam
#  samtools view -b -F 4 "$f1"_sorted.bam  -o "$f1"_mapped_reads_only.bam
  #samtools view -L /scratch/x.j.d.01/Ash_adapt/target_contigs.bed   "$f1"_mapped_reads_only.bam -o "$f1"_no_cp_mt.bam
  #samtools view -L /scratch/x.j.d.01/Ash_adapt/map_to_bacteriea_etc/Mt_Cp_Frax.bed FK"$i"_mapped_reads_only.bam -o FK"$i"_only_cp_mt.bam
 # samtools view -L /scratch/x.j.d.01/Ash_adapt/contig_length.bed "$f1"_mapped_reads_only.bam -o "$f1"_only_cp_mt_contig_length.bam
  samtools depth sampleclean_FAM3_only_cp_mt_contig_length.bam   |  awk '{sum+=$3} END { print  "Average = ",sum/NR}' >> FAM3coverage.txt
 # echo "$f1" >> FAMcov_names.txt

  #paste -d"\t"  cov_names.txt coverage.txt >> covCH.txt
  #rm cov_names.txt coverage.txt

#done < <(paste file.txt file1.txt)


