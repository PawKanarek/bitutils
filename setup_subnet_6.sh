#!/bin/bash

# first you should have the local subnet running with the ./run_subnet_locally.sh
# miner subnet 6 docs https://github.com/NousResearch/finetuning-subnet/blob/5a5b581dd171206933b4e887cfd9685fa16adb42/docs/miner.md

repo_dir='finetuning-subnet'
bittensor_env='bittensor'

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print() {
    echo -e "${CYAN}--- $1${NC}"
}

print_error() {
    echo -e "${RED}--- $1${NC}"
}

if ! command -v conda &> /dev/null; then
    print_error "Cannot find conda. Please run the ./run_subnet_locally.sh"
    exit 1
fi

# Conda stuff
print "Conda init" 
eval "$($HOME/miniconda3/bin/conda shell.bash hook)" # without this I get strange errors when activating conda envs
print "Current conda env is ($CONDA_DEFAULT_ENV)"

if conda info --envs | grep -q "\b$bittensor_env\b"; then
    print "Conda environment '$bittensor_env' already exists."
else
    print_error "There is no conda environment $bittensor_env. Please run the ./run_subnet.locally.sh"
    exit 1
fi


if [ "$CONDA_DEFAULT_ENV" != "$bittensor_env" ]; then
    print "Conda did not activate correct enviroment. Exiting."
    exit 1 
fi

### Clone the repo 

if [ ! -d "$repo_dir" ]; then
    print 'cloning the github repo'
    git clone git@github.com:NousResearch/finetuning-subnet.git
fi

print "cd ${repo_dir}"
cd "$repo_dir"

print "git pull"
git pull

print "install modules python -m pip install -e ." 
python -m pip install -e .


# python neurons/miner.py --offline --load_best --hf_repo_id=0x0dad0/nous_nous_v7_5 --subtensor.network local

