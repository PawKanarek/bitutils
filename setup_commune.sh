#!/bin/bash
REPO_DIR='commune'
CONDA_ENV='commune'
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

### Clone the repo 
if [ ! -d "$REPO_DIR" ]; then
    print 'cloning the github repo'
    git clone git@github.com:commune-ai/commune.git
fi

cd "$REPO_DIR"
git submodule update --init --recursive --force


### Conda stuff 
if ! command -v conda &> /dev/null; then
    print "Conda is not installed. Installing..."
    # Download and install Miniconda
    mkdir -p $HOME/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda3/miniconda.sh
    bash $HOME/miniconda3/miniconda.sh -b -u -p $HOME/miniconda3/
    rm $HOME/miniconda3/miniconda.sh
    $HOME/miniconda3/bin/conda init bash
    print "Conda is installed."
    
    print "Restart bash with command source ~/.bashrc, and run this script again"
    exec bash
fi

if ! command -v conda &> /dev/null; then
    print_error "Cannot find conda. If problem persist, install conda manually."
    exit 1
fi

print "Conda init" 
eval "$($HOME/miniconda3/bin/conda shell.bash hook)" # without this I get strange errors when activating conda envs
print "Current conda env is ($CONDA_DEFAULT_ENV)"

if conda info --envs | grep -q "\b$CONDA_ENV\b"; then
    print "Conda environment '$CONDA_ENV' already exists."
else
    print "Creating conda environment $CONDA_ENV ..."
    conda create -n $CONDA_ENV python=3.10
fi

print "Activate conda env $CONDA_ENV ..."
conda activate $CONDA_ENV
print "current env is $CONDA_DEFAULT_ENV"

if [ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]; then
    print "Conda did not activate correct enviroment. Exiting."
    exit 1 
fi

pip install -e ./

chmod +x ./scripts/* # make sure the scripts are executable
sudo ./scripts/install_npm_env.sh # install npm and pm2 (sudo may not be required)
c modules