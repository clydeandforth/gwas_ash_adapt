#!/bin/bash

#SBATCH -o bbduk.o.%J
#SBATCH -J BBduk
##SBATCH --exclusive
#SBATCH -e bbduk.e.%J
#SBATCH -N 1
##SBATCH --ntasks=40
#must be at least 40
##SBATCH --ntasks-per-node=40
##SBATCH --cpus-per-task=40
##SBATCH --mem 360gb
##SBATCH -t 0-06:00
##SBATCH -p dev
#SBATCH --mail-type=END
#SBATCH --mail-user=jd@ign.ku.dk

#for i in {5..5} {7..7} {22..22} {24..25} {27..27} {31..31} {33..33} {36..37} {88..88}; 
#do
#bbmerge.sh in1=Nova_lane1/IRE"$i"_1.fastq.gz in2=Nova_lane1/IRE"$i"_2.fastq.gz outa=adapters_"$i".fa
#bbduk.sh in1=Nova_lane1/IRE"$i"_1.fastq.gz in2=Nova_lane1/IRE"$i"_2.fastq.gz  out1=Nova_lane1/clean_IRE"$i"_1.fastq.gz out2=Nova_lane1/clean_IRE"$i"_2.fastq.gz  mink=11 qtrim=rl maq=20 minlen=50 ref=adapters_"$i".fa  tbo trimpolyg=0 ktrim=r k=23
#done

ls -1 *_1.fastq.gz | sed -e 's/_1\.fastq\.gz$//' > filelist.txt
ls *1.fastq.gz > filelist1.txt  
ls *2.fastq.gz > filelist2.txt 


while IFS=$'\t' read -r f1 f2 f3
do
  bbmerge.sh in1="$f2" in2="$f3" outa=adapters_"$f1".fa
  bbduk.sh in1="$f2" in2="$f3"   out1=clean_"$f1"_1.fastq out2=clean_"$f1"_2.fastq  mink=11 qtrim=rl maq=20 minlen=50 ref=adapters_"$f1".fa  tbo trimpolyg=0 ktrim=r k=23
done < <(paste filelist.txt filelist1.txt filelist2.txt)
