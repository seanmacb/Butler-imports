#!/usr/bin/bash -l 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=1 
#SBATCH --mem=16GB 
#SBATCH --time=12:00:00 
#SBATCH -o /scratch/smacbr/ButlerSetup/out/cp_bias.out
#SBATCH -e /scratch/smacbr/ButlerSetup/err/cp_bias.err 
source /home/smacbr/.bashrc
DESGW_CONFIG_PATH=/home/smacbr/Butler-imports/s3it_setup/DESGW_CONFIGS
source $DESGW_CONFIG_PATH
module load miniforge3; source /shares/soares-santos.physik.uzh/envs/lsst_stack/loadLSST_uzh.sh; conda activate /shares/soares-santos.physik.uzh/envs/lsst_stack/lsst-scipipe-10.1.0;setup lsst_distrib -c

BIASEXPS="(1249372, 1249373, 1258298, 1258299, 1278668, 1288161, 1288162, 1288163, 1298843, 1298844, 1300533, 1302332, 1302333, 1302685, 1302686, 1302687, 1302688, 1324835, 1324836, 1324837, 1343446, 1343447, 1343451, 1343452, 1343480, 1343481, 1343482, 1343986, 1343987, 1343988, 1344182, 1344183, 1344184, 1390552, 1390553, 1390700, 1390701, 1413071, 1413072, 1413073, 1439507, 1443176, 1443177)"
LOGFILE=$LOGDIR/pilot_cpBias.log; \
date | tee $LOGFILE; \
pipetask --long-log run --register-dataset-types -j 12 \
-b $REPO --instrument lsst.obs.decam.DarkEnergyCamera \
-i DECam/raw/all,DECam/calib/curated/19700101T000000Z,DECam/calib/unbounded \
-o DECam/calib/desgw_pilot/bias \
-p $CP_PIPE_DIR/pipelines/DECam/cpBias.yaml \
-d "instrument='DECam' AND exposure IN $BIASEXPS" \
2>&1 | tee -a $LOGFILE; \
date | tee -a $LOGFILE
