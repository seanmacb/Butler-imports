#!/usr/bin/bash -l 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=1 
#SBATCH --mem=16GB 
#SBATCH --time=24:00:00 
#SBATCH -o /scratch/smacbr/ButlerSetup/out/certify_flats.out
#SBATCH -e /scratch/smacbr/ButlerSetup/err/certify_flats.err 
source /home/smacbr/.bashrc
DESGW_CONFIG_PATH=/home/smacbr/Butler-imports/s3it_setup/DESGW_CONFIGS
source $DESGW_CONFIG_PATH
module load miniforge3; source /shares/soares-santos.physik.uzh/envs/lsst_stack/loadLSST_uzh.sh; conda activate /shares/soares-santos.physik.uzh/envs/lsst_stack/lsst-scipipe-10.1.0;setup lsst_distrib -c

butler certify-calibrations $REPO DECam/calib/desgw_pilot/flat DECam/calib/desgw_pilot flat --begin-date 2025-08-25T00:00:00 --end-date 2025-09-30T00:00:00

