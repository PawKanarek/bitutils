#!/bin/bash
source print.sh
source activate_conda.sh

# bit tensor docs https://github.com/opentensor/bittensor#install
subtensor_dir='subtensor'
conda_env='bittensor'
activate_conda $conda_env

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