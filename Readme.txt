#### data analyse steps for Doonan et al 2023
1. Sost sequencing begin data analyse with BBduk.q

2. Map reads with BWA.q

3. Sort bamfiles etc with samtools.q

4. Now ready to start calling genotype likelihoods with Angsd 

5. After getting likelihoods imputation can begin in Beagle.sh. At the same time linked SNPs can be found using Plink.sh and Awk.sh to create pruned genotype likelihoods. The pruned likelihoods can be used for PCAs using Pcangsd_job.sh

6. The assssssociation can then be run using Angsd with Association_job.sh
