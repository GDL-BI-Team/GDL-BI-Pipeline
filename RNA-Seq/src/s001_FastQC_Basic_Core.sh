#!/bin/bash

#-----------------------------------------------
# FastQC Basic, Core File v2
# maintainer: jinhokim.07@cau.ac.kr
# Last Update: 2023.10.23
#-----------------------------------------------

#SBATCH -J FastQC
#SBATCH -o ./log/L001_FastQC_Basic.%j.out
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb
#SBATCH --partition=compute

source ~/.bashrc
conda activate FASTQCv2

# ARG1: LOAD FASTQ ROUTE and CHANGE ABS FASTQ ROUTE
[ ! -f ${1} ] && { echo "[$(date +%T)] GDL-LOG: ${1} not found."; }
FASTQ_ABS_ROUTE=$(realpath ${1})

# ARG2: OUTPUT ROUTE and CHANGE ABS OUTPUT ROUTE
[ ! -d ${2} ] && { mkdir -p ${2}; echo "[$(date +%T)] GDL-LOG: ${2} is created."; }
OUTPUT_ABS_ROUTE=$(realpath ${2})

SBATCH_CMD="fastqc -o ${OUTPUT_ABS_ROUTE} ${FASTQ_ABS_ROUTE}"
${SBATCH_CMD}