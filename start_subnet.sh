
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

# SETUP SCRIPT ENV

cd subtenosr

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

if conda info --envs | grep -q "\b$bittensor_env\b"; then
    print "Conda environment '$bittensor_env' already exists."
else
    print "Creating conda environment $bittensor_env ..."
    conda create -n $bittensor_env python=3.10

    git clone git@github.com:opentensor/bittensor.git
    python3 -m pip install -e bittensor/
fi

print "Activate conda env $bittensor_env ..."
conda activate $bittensor_env
print "current env is $CONDA_DEFAULT_ENV"

if [ "$CONDA_DEFAULT_ENV" != "$bittensor_env" ]; then
    print "Conda did not activate correct enviroment. Exiting."
    exit 1 
fi

main(){
    
    if [ -z "$COLD_KEY_PASS" ]; then
        echo "Environment variable not found. Exiting..."
        exit 1
    fi

    # 4. Setup rust https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#4-setup-rust
    print "Setup rust script"
    ./scripts/init.sh

    # 5. initalize https://github.com/opentensor/bittensor-subnet-template/blob/main/docs/running_on_staging.md#5-initialize
    print "initalize subtensor"
    cargo build --release --features pow-faucet

    BUILD_BINARY=0 ./scripts/localnet.sh 

    while [ $counter -lt 4 ]; do
        btcli wallet faucet --wallet.name cold-mine-1 --subtensor.chain_endpoint ws://127.0.0.1:9946 
        if [ $? -eq 0 ]; then
            break
        fi
        # SKEETCHY
        sleep 15
        COLD_KEY_PASS
        sleep 15
        counter=$((counter+1))
    done
    
}

main 