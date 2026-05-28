#!/usr/bin/bash -l 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=1 
#SBATCH --mem=16GB 
#SBATCH --time=12:00:00 
#SBATCH -o /scratch/smacbr/ButlerSetup/out/register_visits.out
#SBATCH -e /scratch/smacbr/ButlerSetup/err/register_visits.err 
source ~/.bashrc
module load miniforge3; source /shares/soares-santos.physik.uzh/envs/lsst_stack/loadLSST_uzh.sh; conda activate /shares/soares-santos.physik.uzh/envs/lsst_stack/lsst-scipipe-10.1.0;setup lsst_distrib -c
REPO=/shares/soares-santos.physik.uzh/ButlerProjects/DESGW/; LOGFILE=$REPO/logs/define_visits.log; 
date | tee $LOGFILE; 
butler define-visits $REPO lsst.obs.decam.DarkEnergyCamera 
2>&1 | tee -a $LOGFILE; 
date | tee -a $LOGFILE
