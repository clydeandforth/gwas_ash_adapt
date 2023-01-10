#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00004 -A ku_00004
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N ngsd
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e pcanagsd_test.err
##PBS -o pcangsd.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes, ppn = number of cpus
#PBS -l nodes=1:ppn=40:thinnode
### Requesting time - 720 hours
#PBS -l walltime=28:00:00
#PBS -l mem=188gb

### Here follows the user commands:
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
# NPROCS will be set to 196, not sure if it used here for anything.
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
  
module load   tools parallel/20210722  htslib/1.13 angsd/0.940
 
#export OMP_NUM_THREADS=12
# Using 192 cores for MPI threads leaving 4 cores for overhead, '--mca btl_tcp_if_include ib0' forces InfiniBand interconnect for improved latency
#mpirun -np 12 $mdrun   -deffnm md-DTU -dlb yes -cpi md-DTU -append --mca btl_tcp_if_include ib0

dir=$(pwd)
folder=$(echo $(pwd) | sed -e 's/.*folder\(.*\)_out.*/\1/')
bams="/home/projects/ku_00004/data/James/bams/final_bamlist.txt "
REF="/home/projects/ku_00004/data/James/mapped_bam_files/Genome_bat/BATG-0.5-CLCbioSSPACE.fa"
FAI="/home/projects/ku_00004/data/James/mapped_bam_files/Genome_bat/BATG-0.5-CLCbioSSPACE.fa.fai"

#mkdir SPLIT_RF
# use contig_split.sh script to create multiple folders from all the contig files
#split -l 25 /home/projects/ku_00004/data/mapped_bam_files/Genome_bat/chroms2.txt SPLIT_RF_25/

# to output plink files the following commands are required; -doPlink 2 -doGeno 4  -doPost 1 
ls /home/projects/ku_00004/data/James/mapped_bam_files/SPLIT_RF_1_FRESH/folder"$folder"/* | parallel -j 2 "angsd -rf {} -P 2  -b "$bams" -gl 1 -doGlf 2 -doMaf 1 -minMaf 0.05     -doMajorMinor 1 -out "$dir"/contig.{/} -docounts 1 -SNP_pval 2e-6  -ref $REF -minInd 30 -uniqueOnly 1 -remove_bads 1 -doPlink 2  -doGeno 4  -doPost 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1   -minQ 20"

#bcf
#ls /home/projects/ku_00004/data/James/mapped_bam_files/SPLIT_RF_1_FRESH/folder"$folder"/* | parallel -j 2 "angsd -rf {} -P 2 -b "$bams"  -doBcf 1 -gl 1 -dopost 1 -domajorminor 1 -domaf 1 -minMaf 0.05 -SNP_pval 2e-6  --ignore-RG 0  -docounts 1 -ref $REF -minInd 30 -doGeno 4  -out "$dir"/vcfs_contig.{/} -baq 1 -minQ 20 -only_proper_pairs 1"



