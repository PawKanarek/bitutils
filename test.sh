#!/bin/bash
repo_dir='finetuning-subnet'
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


### Clone the subtensor repo 
if [ ! -d "$subtensor_dir" ]; then
    print 'cloning the subtensor repo'
    git clone git@github.com:opentensor/subtensor.git
fi

print 'cd $subtensor_dir'
cd "$subtensor_dir"
docker compose up --detach

# install rust https://docs.substrate.io/install/linux/
# print install rust dependencies

# sudo apt install build-essential
# clang curl git make
# sudo apt install --assume-yes git clang curl libssl-dev protobuf-compiler
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source $HOME/.cargo/env

# print verify
# rustc --version

# print configure latest Rust toolchain
# rustup default stable
# rustup update

# print add nightly 
# rustup update nightly
# rustup target add wasm32-unknown-unknown --toolchain nightly

# print verify
# rustup show
# rustup +nightly show

# https://docs.docker.com/desktop/install/ubuntu/
# DOCKER
# print "uninstall old docker"
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# sudo apt install gnome-terminal

# print "add docker keys docker"

# # Add Docker's official GPG key:
# sudo apt-get update
# sudo apt-get install ca-certificates curl
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# # Add the repository to Apt sources:
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update


# wget -O ./docker-desktop-4.27.2-amd64.deb https://desktop.docker.com/linux/main/amd64/137060/docker-desktop-4.27.2-amd64.deb
# sudo apt-get update
# sudo apt-get install ./docker-desktop-4.27.2-amd64.deb

# systemctl --user start docker-desktop

# # install Docker Compose 
# sudo apt-get update
# sudo apt-get install docker-compose-plugin
# print "verify docker compose"
# docker compose version