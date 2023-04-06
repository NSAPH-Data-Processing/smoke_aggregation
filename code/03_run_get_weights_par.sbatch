#!/bin/bash
#
#SBATCH -p fasse # partition (queue)
#SBATCH -c 48 # number of cores
#SBATCH --mem 100GB # memory pool for all cores
#SBATCH -t 1-12:00 # time (D-HH:MM)


singularity exec $HOME/singularity_images/smoke_weights_v0.sif Rscript 03_run_get_weights_par.R -y 2010 -c 40
