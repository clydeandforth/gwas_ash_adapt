#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00004 -A ku_00004
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N eagle3
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e pcanagsd_test.err
##PBS -o pcangsd.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes, ppn = number of cpus
#PBS -l nodes=1:ppn=20:thinnode
### Requesting time - 720 hours
#PBS -l walltime=01:00:00
#PBS -l mem=128gb

### Here follows the user commands:
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
# NPROCS will be set to 196, not sure if it used here for anything.
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

module purge
module load tools parallel/20210722  java/1.8.0
 
#export OMP_NUM_THREADS=12
# Using 192 cores for MPI threads leaving 4 cores for overhead, '--mca btl_tcp_if_include ib0' forces InfiniBand interconnect for improved latency
#mpirun -np 12 $mdrun   -deffnm md-DTU -dlb yes -cpi md-DTU -append --mca btl_tcp_if_include ib0

dir=$(pwd)
folder=$(echo $(pwd) | sed -e 's/.*folder\(.*\)_out.*/\1/')
REF="/home/projects/ku_00004/data/James/mapped_bam_files/Genome_bat/BATG-0.5-CLCbioSSPACE.fa"
FAI="/home/projects/ku_00004/data/James/mapped_bam_files/Genome_bat/BATG-0.5-CLCbioSSPACE.fa.fai"
#chrom="/home/projects/ku_00004/data/mapped_bam_files/Genome_bat/chroms2.txt"

#split -l 25 /home/projects/ku_00004/data/mapped_bam_files/Genome_bat/chroms2.txt SPLIT_RF_25/

#ls /home/projects/ku_00004/data/James/mapped_bam_files/Tjaerby_gwas/folder"$folder"_out/Beagle/* | parallel -j 16 "java -Xmx188g  -jar /home/projects/ku_00004/data/James/beagle.jar like={}  out="$dir"/Beagle_out_"$folder"/assoc_ready_.{/}"

#java -Xmx340g  -jar /home/projects/ku_00004/data/beagle.jar like=cat_pruned.beagle  out=assoc_ready_."$folder"
#java -Xmx640g  -jar /home/projects/ku_00004/data/James/beagle.jar like=Beagle/beagle_cat  out=beagle_out_"$folder"_no_plink
java -jar /home/projects/ku_00004/data/James/beagle.jar unphased=folder1_out/Beagle_out_1/assoc_ready_.contig.aa.beagle.gz.contig.aa.beagle.gz.phased.gz missing=? out=test

