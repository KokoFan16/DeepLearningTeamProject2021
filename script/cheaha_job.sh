#!/bin/bash
#
#SBATCH --job-name=NLP_CNER
#SBATCH --output=jupyter-log-pascal-%J.txt
#SBATCH --nodes=1
#SBATCH --partition=pascalnodes
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G


export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

echo "Name of the cluster on which the job is executing." $SLURM_CLUSTER_NAME
echo "Number of tasks to be initiated on each node." $SLURM_TASKS_PER_NODE
echo "Number of cpus requested per task." $SLURM_CPUS_PER_TASK
echo "Number of CPUS on the allocated node." $SLURM_CPUS_ON_NODE
echo "Total number of processes in the current job." $SLURM_NTASKS
echo "List of nodes allocated to the job" $SLURM_NODELIST
echo "Total number of nodes in the job's resource allocation." $SLURM_NNODES
echo "List of allocated GPUs." $CUDA_VISIBLE_DEVICES

cd $USER_DATA
module load Anaconda3/5.3.1
module load cuda10.0/toolkit
module load NCCL/2.2.13-CUDA-9.2.148.1
module load cuDNN/7.6.2.24-CUDA-10.1.243


## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)

## print tunneling instructions to jupyter-log-{jobid}.txt
echo -e "\n\n   Copy/Paste this in your local terminal to ssh tunnel with remote  "
echo        "   ------------------------------------------------------------------"
echo        "   ssh -L $ipnport:$ipnip:$ipnport $USER@cheaha.rc.uab.edu           "
echo        "   ------------------------------------------------------------------"
echo -e "\n\n   Then open a browser on your local machine to the following address"
echo        "   ------------------------------------------------------------------"
echo        "   localhost:$ipnport                                                "
echo -e     "   ------------------------------------------------------------------\n\n"
sleep 1

## start an ipcluster instance and launch jupyter server
jupyter-notebook --no-browser --port=$ipnport --ip=$ipnip

