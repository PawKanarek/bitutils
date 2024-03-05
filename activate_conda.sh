#!/bin/bash
source print.sh

activate_conda() {
    conda_env="$1"
    if [ -z "$1" ]; then
        print_error "Error: No envrionment name. Call this function with envrionment name" >&2
        exit 1
    fi
    
    if ! command -v conda &> /dev/null; then
        print "Conda is not installed. Installing..."
        mkdir -p $HOME/miniconda3
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda3/miniconda.sh
        bash $HOME/miniconda3/miniconda.sh -b -u -p $HOME/miniconda3/
        rm $HOME/miniconda3/miniconda.sh
        $HOME/miniconda3/bin/conda init bash
        print "Conda is installed."
        print "Restart bash with command source ~/.bashrc, and run this script again"
        exec bash
        exit 1
    fi

    if ! command -v conda &> /dev/null; then
        print_error "Cannot find conda. If problem persist, install conda manually."
        exit 1
    fi

    print "Conda init" 
    eval "$($HOME/miniconda3/bin/conda shell.bash hook)" # without this I get strange errors when activating conda envs
    print "Current conda env is ($CONDA_DEFAULT_ENV)"

    if conda info --envs | grep -q "\b$conda_env\b"; then
        print "Conda environment '$conda_env' already exists."
    else
        print "Creating conda environment $conda_env ..."
        conda create -n $conda_env python=3.10

        git clone git@github.com:opentensor/bittensor.git
        python -m pip install -e bittensor/
    fi

    print "Activate conda env $conda_env ..."
    conda activate $conda_env
    print "current env is $CONDA_DEFAULT_ENV"

    if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
        print "Conda did not activate correct enviroment. Exiting."
        exit 1 
    fi
}
