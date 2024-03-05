#!/bin/bash
source print.sh
source activate_conda.sh


conda_env='bittensor'
cd subtenosr
activate_conda $conda_env

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
        sleep 60
        COLD_KEY_PASS
        counter=$((counter+1))
        sleep 120
    done
    
}

main 