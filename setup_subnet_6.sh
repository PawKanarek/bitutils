#!/bin/bash
# miner docs https://github.com/NousResearch/finetuning-subnet/blob/5a5b581dd171206933b4e887cfd9685fa16adb42/docs/miner.md

repo_dir='finetuning-subnet'
subtensor_dir='subtensor'
subnet_dir='bittensor-subnet-template'
conda_env='finetune'
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

# ---- Conda stuff 
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
fi

print "Activate conda env $conda_env ..."
conda activate $conda_env
print "current env is $CONDA_DEFAULT_ENV"

if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
    print "Conda did not activate correct enviroment. Exiting."
    exit 1 
fi




# https://docs.docker.com/desktop/install/ubuntu/
# ---- DOCKER
print "uninstall old docker"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt install gnome-terminal

print "add docker keys docker"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


wget -O ./docker-desktop-4.27.2-amd64.deb https://desktop.docker.com/linux/main/amd64/137060/docker-desktop-4.27.2-amd64.deb
sudo apt-get update
sudo apt-get install ./docker-desktop-4.27.2-amd64.deb

systemctl --user start docker-desktop

# install Docker Compose 
sudo apt-get update
sudo apt-get install docker-compose-plugin
print "verify docker compose"
docker compose version

# ---- RUST
# also:  https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md

# 1. instal substrate dependencies https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#1-install-substrate-dependencies
print "install rust dependencies"
sudo apt update 
sudo apt install build-essential
clang curl git make

# 2 install rust and cargo  https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#2-install-rust-and-cargo
sudo apt install --assume-yes git clang curl libssl-dev protobuf-compiler
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

print "verify"
rustc --version

print "configure latest Rust toolchain"
rustup default stable
rustup update

print "add nightly rust build"
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

print "verify rust build"
rustup show
rustup +nightly show

# 3 clone subtensor repository https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#3-clone-the-subtensor-repository
### Clone the subtensor repo 
if [ ! -d "$subtensor_dir" ]; then
    print 'cloning the subtensor repo'
    git clone git@github.com:opentensor/subtensor.git
fi

print "cd $subtensor_dir"
cd "$subtensor_dir"

# 4. Setup rust https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#4-setup-rust
print "Setup rust script"
./scripts/init.sh

# 5. initalize https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#5-initialize
print "initalize subtensor"
cargo build --release --features pow-faucet

BUILD_BINARY=0 ./scripts/localnet.sh 

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

