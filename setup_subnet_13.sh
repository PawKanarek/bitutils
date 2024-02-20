#!/bin/bash
REPO_DIR='data-universe'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print() {
    echo -e "${GREEN}--- $1${NC}"
}

if [ ! -d "$REPO_DIR" ]; then
    print 'cloning the github repo'
    git clone git@github.com:RusticLuftig/data-universe.git
fi

cd "$REPO_DIR"

if command -v conda &> /dev/null; then
    print "Conda is installed."
else
    print "Conda is not installed. Installing..."
    # Download and install Miniconda
    mkdir -p $HOME/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda3/miniconda.sh
    bash $HOME/miniconda3/miniconda.sh -b -u -p $HOME/miniconda3/
    rm $HOME/miniconda3/miniconda.sh
    $HOME/miniconda3/bin/conda init bash
    print "Conda is installed. Run this script again..."
    exit 1
fi

print "Create conda environment $REPO_DIR ..."
conda create -n $REPO_DIR python=3.10

print "Activate conda env $REPO_DIR ..."
conda activate $REPO_DIR

print "Instaling required dependencies"
pip install -r requirements.txt

