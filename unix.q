
#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00004 -A ku_00004
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N Unix
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e pcanagsd_test.err
##PBS -o pcangsd.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes, ppn = number of cpus
#PBS -l nodes=1:ppn=20:thinnode
### Requesting time - 720 hours
#PBS -l walltime=00:20:00
#PBS -l mem=128gb

### Here follows the user commands:
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
# NPROCS will be set to 196, not sure if it used here for anything.
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
  
module load   tools bedtools/2.30.0
RRBLUP="/home/projects/ku_00004/data/James/mapped_bam_files/fcgene_runs/gprobs_impute_unpruned_snpinfo_486_fixed.hap_hmp.txt"
# Order angsd results by p value 
#sort -t$'\t' -gk7 angsd_asso_results.lrt0.clean_unpruned_PDS.txt > ordered_angsd.txt
for i in 1000001; do head -n "$i" ordered_angsd.txt > ordered_angsd_"$i".txt && tail -n +2 -q ordered_angsd_"$i".txt | sed 's/_//g' | awk '{print $1"_"$2}' > ordered_angsd_"$i"_search.txt && sed  's/Contig/Contig /g' ordered_angsd_"$i"_search.txt | sed 's/_/ /g' | sort -nk2 -nk3   | sed 's/Contig /Contig/g' | sed 's/ /_/g'  > sorted_angsd_"$i"_search.txt && grep -Fwf sorted_angsd_"$i"_search.txt "$RRBLUP" > rrblup"$i".hap && cat header.txt rrblup"$i".hap > RF5_ready"$i".hap ; done
#sort -k 1 rrblup.hap > dbsorted.txt
#awk '{a[NR]=$1; delete a[NR-2]}; {if (a[NR-1]!=$1){print $0}}' dbsorted.txt > 1000000_pds_names.txt
#cat header.txt 1000000_pds_names.txt > 1000000_pds.txt

###
# this is to find and remove duplicates from a genotype probabiliteis file
#tail -n +2 -q /home/projects/ku_00004/scratch/James/complete_unpruned_gprobs.beagle | sort -k 1 > sorted.txt
#awk '{a[NR]=$1; delete a[NR-2]}; {if (a[NR-1]!=$1){print $0}}' sorted.txt > complete_unpruned_gprobs_nodups.beagle
#cat header complete_unpruned_gprobs_nodups.beagle > complete_unpruned_gprobs_nodups_header.beagle
#wc -l complete_unpruned_gprobs_nodups.beagle > nodups_count.txt
#wc -l /home/projects/ku_00004/scratch/James/complete_unpruned_gprobs.beagle >> nodups_count.txt
#awk '{$1147=$1148=$1149=""; print $0}' complete_unpruned_gprobs_nodups_header.beagle > complete_unpruned_gprobs_nodups_header_mod.beagle
###

######################################
#### get SNPs for VIP random forest

#grep -Fwf sorted_angsd_10000_search.txt "$RRBLUP" > rrblup.hap
#cat VIP_head.txt rrblup"$i".hap > rrblup_head"$i".hap
#cat header.txt rrblup"$i".hap > RF5_ready"$i".hap
####################
# Run VIP.R to get feature importance file
# add p value ranking to VIP file
# first remove negative and zero values from feature importance file
#awk -F ','  '$3 >=0' feature_importance.csv  | awk -F ',' '{print $1}' | sed 's/"//g' > postive_hits.txt
##gep -Fwf  postive_hits.txt rrblup_head.hap > rrblup_postive_hits.txt
##cat header.txt rrblup_postive_hits.txt > rrblup_postive_hits_head.txt 
# Then run RF_5.R and VIP.R again with only positve VIP SNPs

# Then move on to getting annotations of the top CPI SNPs
#sort -t, -gk3,3 feature_importance_pos.csv | tail  -n 100 | sort -t, -k3,3nr > top_100_from_conditon_pi.txt 
#awk -F ',' '{print $1}' top_100_from_conditon_pi.txt | sed 's/"//g' > hits_for_grep.txt
#awk 'FNR==NR{l[$0]=NR; next}; $0 in l{print $0, l[$0], FNR}' ordered_angsd_10000_search.txt hits_for_grep.txt | awk '{print $2}' > line_numbers.txt
#paste -d, top_100_from_conditon_pi.txt line_numbers.txt  > top_100_from_conditon_pi_line_numbers.txt  && cat feature_importance_header.txt top_100_from_conditon_pi_line_numbers.txt > top_100_from_conditon_pi_head.txt
#sed -i 's/"//g' top_100_from_conditon_pi_head.txt

### and get the CPI annotations
ANNO="/home/projects/ku_00004/data/James/bams/Fraxinus_excelsior_38873_TGAC_v2.gff3"
ANNO2="/home/projects/ku_00004/data/James/bams/Fraxinus_excelsior_38873_TGAC_v2.gff3.functional_annotation.tsv"

#sed 's/_/ /g' hits_for_grep.txt > 100_CPI.bed
#awk -v s=500 '{print $1, $2-s, $2+s}' 100_CPI.bed | sed 's/\([[:space:]]*\)-[0-9.e-]\{1,\}/\10/g' | sed 's/Contig//g'  | sort -k1 -n | sed 's/^/Contig/' |  awk '{print $1"\t"$2"\t"$3}' > file
#bedtools intersect -a "$ANNO" -b file > intersect_out.bed
#grep -o -P '.{0,10}_v2_.{0,11}' intersect_out.bed | sed 's/;[a-z]//g'  | sed 's/;[A-Z]//g' > filtered_hits.txt
#grep -Fwf filtered_hits.txt "$ANNO2" > filtered_hits2.txt

#awk '{print $1}' filtered_hits2.txt > filtered_hits3.txt
#grep -A 1 -Fwf  filtered_hits3.txt ../../../bams/Fraxinus_excelsior_38873_TGAC_v2.gff3.pep_single_line.fa > health_genes_CIP.fa
#grep -Fwf filtered_hits3.txt intersect_out.bed > filtered_hits4.txt
#awk '!seen[$1]++' filtered_hits4.txt > filtered_hits5.txt
#awk -v s=499 '{print $1, $4+s}' filtered_hits5.txt > filtered_hits6.txt

#grep -Fwf filtered_hits6.txt 100_CPI.bed > filtered_hits7.txt
#awk '{print $1"_"$2_}' filtered_hits7.txt > contig_pos.txt
#grep -o -P '(?<=ID=).*(?=;Parent)' filtered_hits5.txt > filtered_hits8.txt
#paste filtered_hits8.txt filtered_hits6.txt > filtered_hits9.txt

#zcat unpruned.lrt0.gz | awk '$5 > 0.01  {print ;}' > maf_more_than.txt
#zcat unpruned.lrt0.gz  | wc -l
#cat maf_more_than.txt | wc -l

