#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00004 -A ku_00004
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Awk_400
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e pcanagsd_test.err
##PBS -o pcangsd.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes, ppn = number of cpus
#PBS -l nodes=1:ppn=10:thinnode
### Requesting time - 720 hours
#PBS -l walltime=02:00:00
#PBS -l mem=128gb

### Here follows the user commands:
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
# NPROCS will be set to 196, not sure if it used here for anything.
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
  
module load   tools parallel/20210722  htslib/1.13 angsd/0.935
 
#export OMP_NUM_THREADS=12
# Using 192 cores for MPI threads leaving 4 cores for overhead, '--mca btl_tcp_if_include ib0' forces InfiniBand interconnect for improved latency
#mpirun -np 12 $mdrun   -deffnm md-DTU -dlb yes -cpi md-DTU -append --mca btl_tcp_if_include ib0

dir=$(pwd)
folder=$(echo $(pwd) | sed -e 's/.*folder\(.*\)_out.*/\1/')

head -n 1 /home/projects/ku_00004/data/James/mapped_bam_files/Tjaerby_gwas/folder1_out/Beagle/contig.aa.beagle > Beagle/beagle_cat && awk 'FNR>1' Beagle/contig.* >> Beagle/beagle_cat
cat Plink_out/Prune_in/* > Plink_out/Prune_in/prune_in_cat
head -n 1 /home/projects/ku_00004/data/James/mapped_bam_files/Tjaerby_gwas/folder1_out/Beagle/contig.aa.beagle > cat_pruned.beagle

awk 'NR==FNR{SNPs[$1]=$1; next} $1 in SNPs' Plink_out/Prune_in/prune_in_cat Beagle/beagle_cat >> cat_pruned.beagle


qstat -f -1 $PBS_JOBID


