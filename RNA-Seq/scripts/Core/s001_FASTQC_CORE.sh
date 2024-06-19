#!/bin/bash

# This script takes two arguments as input and runs the FASTQC Core Script.
# Usage
# - Input: Single FASTQ file, FACTQC Directory
# - Output: Run FASTQC Core Script(Module)
# Mainternance: 
# - Yujeong Hwangbo (hwangbo@cau.ac.kr), Manager
# - Jinho Kim (jinhokim07@cau.ac.kr), Director
# Last Update: 240619

#SBATCH -J FastQC
#SBATCH -o ./log/L001_FastQC_Basic.%j.out
#SBATCH --cpus-per-task=1
#SBATCH --partition=computesub

helpFunction()
{
    echo ""
    echo "##### GDL-FASTQC Runner Script #####"
    echo ""
    echo "usage: $0 [options] <-i INPUT_FILE> <-o OUTPUT_DIR>"
    echo ""
    echo "[REQUIRED option specification]"
    echo ""
    echo "   -i (Required) single FASTQ file"
    echo "   -o (Required) ex) ./001_FastQC/"
    echo "      Write all output files into directory."
    echo "      If folder does not exist, this script will attempt to create it first."
    echo ""
    echo "[Optional]"
    echo "   -p (optional) number of cores (default, 8 for GDLwulf)"
    echo "      BI Comment: Based on experience, setting more than 8 cores does not provide significant performance improvements."
    echo "   -D (optional) DEBUG MODE (default, FALSE)"
    echo "   -h show helps"
    echo ""
    echo ""
    exit 1;
}

# Default Parameters
CORES=8;
RUN_MODE=true;

# No Arg. Exception
if [ $# -eq 0 ]; then
    helpFunction;
fi

while getopts i:o:p:hD flag
do
    case ${flag} in 
        i) INPUT_FILE=${OPTARG};;
        o) OUTPUT_DIR=${OPTARG};;
        p) CORES=${OPTARG};;
        D) RUN_MODE=false;;
        h) helpFunction;
            exit 1;;
        ?) echo "";
        echo "############################################################################################";
        echo "[$(date +%T)] GDL-ERROR(1/1): Invalid arguments: no parameter included with argument $OPTARG";
        echo "############################################################################################";
        helpFunction;
        exit 1;;
    esac
done

if [ -z ${INPUT_FILE} ] || [ -z ${OUTPUT_DIR} ]; then
        echo "[$(date +%T)] GDL-ERROR(1/1): Missing -i or -o";
        helpFunction;
        exit 1;
fi

# Argument 1. check the existence of Input File 
#               and change route as absolute path
if [ ! -f ${INPUT_FILE} ]; then
    echo "[$(date +%T)] GDL-ERROR(1/2): ${INPUT_FILE} dose not exist.";
    echo "[$(date +%T)] GDL-ERROR(2/2): Cheking ${INPUT_FILE}";
    exit 1;
else
    INPUT_ABS_FILE=$(realpath ${INPUT_FILE});
fi

# Argumet 2. check the Result Directory
#               and make the res. dir.
if [ ! -d ${OUTPUT_DIR} ]; then
    echo "[$(date +%T)] GDL-LOG(1/2): ${OUTPUT_DIR} dose not exist.";
    echo "[$(date +%T)] GDL-LOG(2/2): ${OUTPUT_DIR} is created";
    mkdir -p ${OUTPUT_DIR};
fi
OUTPUT_ABS_DIR=$(realpath ${OUTPUT_DIR});


### ACTUAL CODE OPEARTION PART ###

# Conda activation 
source ~/.bashrc
conda activate FASTQCv2

FINAL_CMD="fastqc -t ${CORES} -o ${OUTPUT_ABS_DIR} ${INPUT_ABS_FILE}"
echo "[$(date +%T)] GDL-LOG(1/1): FASTQC CORE, RUN."
echo "[$(date +%T)] GDL-RUN:"
echo ">> ${FINAL_CMD}"

if $RUN_MODE; then
    ${FINAL_CMD}
fi
####################################
