#!/usr/bin/bash -l 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=1 
#SBATCH --mem=64GB 
#SBATCH --time=12:00:00 
#SBATCH -o /scratch/smacbr/ButlerSetup/out/link_science.out
#SBATCH -e /scratch/smacbr/ButlerSetup/err/link_science.err 
source ~/.bashrc
module load miniforge3; source /shares/soares-santos.physik.uzh/envs/lsst_stack/loadLSST_uzh.sh; conda activate /shares/soares-santos.physik.uzh/envs/lsst_stack/lsst-scipipe-10.1.0;setup lsst_distrib -c
REPO=/shares/soares-santos.physik.uzh/ButlerProjects/DESGW 
LOGFILE=$REPO/logs/desgw_pilot_ingest2.log
SCIFILES=/shares/soares-santos.physik.uzh/fitsFiles/desgw/single-epoch/*fits.fz; date | tee $LOGFILE
butler ingest-raws $REPO $SCIFILES --transfer link 2>&1 | tee -a $LOGFILE; 
date | tee -a $LOGFILE
