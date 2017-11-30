#!/bin/bash
#SBATCH --cpus-per-task 1

R CMD BATCH --no-save LineagePulse.R LineagePulse.out
