#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00004 -A ku_00004
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N plink
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e beagle_fatnode.err
##PBS -o beagle_fatnode.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m bea
#PBS -M jd@ign.ku.dk
### Number of nodes, request 196 cores from 7 nodes
#PBS -l nodes=1:ppn=40:thinnode
### Requesting time - 720 hours
#PBS -l walltime=8:00:00
#PBS -l mem=188gb

 
### Here follows the user commands:
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
# NPROCS will be set to 196, not sure if it used here for anything.
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
  
module load tools parallel/20210722  plink2/1.90beta6.24

dir=$(pwd)
folder=$(echo $(pwd) | sed -e 's/.*folder\(.*\)_out.*/\1/')

ls /home/projects/ku_00004/data/James/mapped_bam_files/Tjaerby_gwas/folder"$folder"_out/Plink_files/* | cut -f1,2 -d'.' | parallel -j 16 "plink -indep-pairwise 50 5 0.5 --tfile {} -allow-extra-chr --out "$dir"/Plink_out/awk_ready_.{/}"

