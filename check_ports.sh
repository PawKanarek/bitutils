#!/bin/bash
source print.sh
source activate_conda.sh

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   print "This script must be run as root." 
   exit 1
fi

activate_conda "bittensor"

# Install UFW if it's not already installed
if ! command -v ufw &>/dev/null; then
    print "UFW not found. Installing UFW."
    apt-get update
    apt-get install -y ufw
fi

print "Setting up default outgoing traffic policy to ACCEPT and DENY incoming"
ufw default deny incoming
ufw default allow outgoing

print "9944 - Websocket. This port is used by bittensor. It only accepts connections from localhost."
ufw allow from 127.0.0.1 to any port 9944

print "30333 - p2p socket. This port accepts connections from other subtensor nodes."
ufw allow 30333/tcp

print "9933 - RPC. This port is opened, but not used"
ufw allow 9933/tcp

print "Allow ssh"
ufw allow ssh

print "Enable the firewall" 
ufw enable

print "Reload the firewall rules"
ufw reload

# Checks
print "Checking network configurations..."

# Check Internet connectivity
if ping -c 1 8.8.8.8 &>/dev/null; then
    print "Internet connectivity is available."
else
    print_error "Internet connectivity check failed."
    exit 1
fi

# Verify IPv4 is enabled (we'll just check if the system has IPv4 addresses)
if ip -4 addr show &>/dev/null; then
    print "IPv4 is enabled."
else
    print_error "IPv4 is not enabled. Please check your network configuration."
    exit 1
fi

# Check if ports are listening
check_port() {
    if ss -tuln | grep ":$1" &>/dev/null; then
        print "Port $1 is listening."
    else
        print_error "Port $1 is not listening."
    fi
}

check_port 9944
check_port 9933
check_port 30333

print "ufw status verbose"
ufw status verbose

print "Network checks completed."