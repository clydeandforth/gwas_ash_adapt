#!/bin/bash

#SBATCH -o wa.o.%J
#SBATCH -J BWA
##SBATCH --exclusive
#SBATCH -e wa.e.%J
#SBATCH -N 1
##SBATCH --ntasks=40
#must be at least 40
##SBATCH --ntasks-per-node=40
#SBATCH --cpus-per-task=40
##SBATCH -t 0-06:00
#SBATCH -p highmem


ls -1 clean_* | grep '_1'  |  sed -e 's/_1\.fastq$//' > filelist.txt
ls -1 clean_* | grep '_1' > filelist1.txt
ls -1 clean_* | grep '_2' > filelist2.txt


while IFS=$'\t' read -r f1 f2 f3
do
  /scratch/x.j.d.01/bwa/bwa mem /scratch/x.j.d.01/Ash_adapt/BATG-0.5-CLCbioSSPACE.fa.gz "$f2" "$f3" -t 40 > sample"$f1".sam
done < <(paste filelist.txt filelist1.txt filelist2.txt)

