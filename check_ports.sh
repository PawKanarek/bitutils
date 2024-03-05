#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi


# Install UFW if it's not already installed
if ! command -v ufw &>/dev/null; then
    echo "UFW not found. Installing UFW."
    apt-get update
    apt-get install -y ufw
fi

# Enable UFW if it's not already enabled
if ufw status | grep -q "inactive"; then
    echo "Enabling UFW."
    ufw --force enable
fi

# Setting up default rules
echo "Setting up default UFW rules."
ufw default deny incoming
ufw default allow outgoing

# Allow incoming traffic to 30333 (Subtensor p2p)
#   echo "Allowing incoming traffic on TCP port 30333."
# ufw allow 30333/tcp

# allow ssh
echo "Allow ssh"
sudo ufw allow ssh

# Block and then allow loopback to 9944 (Websocket)
# echo "Blocking public access to TCP port 9944."
# ufw deny in to any port 9944

# echo "Allowing loopback on TCP port 9944."
# ufw allow from 127.0.0.1 to any port 9944
# ufw allow from ::1 to any port 9944

# Add rules for RPC port 9933 if required to allow it on loopback
# echo "Allowing loopback on TCP port 9933."
# ufw allow from 127.0.0.1 to any port 9933
# ufw allow from ::1 to any port 9933

# sudo ufw allow from 127.0.0.1 to any port 9946
# sudo ufw allow from ::1 to any port 9946

# sudo ufw allow from 127.0.0.1 to any port 9947
# sudo ufw allow from ::1 to any port 9947

# Reload UFW to apply changes
ufw reload

# Checks
echo "Checking network configurations..."

# Check Internet connectivity
if ping -c 1 8.8.8.8 &>/dev/null; then
    echo "Internet connectivity is available."
else
    echo "Internet connectivity check failed."
    exit 1
fi

# Verify IPv4 is enabled (we'll just check if the system has IPv4 addresses)
if ip -4 addr show &>/dev/null; then
    echo "IPv4 is enabled."
else
    echo "IPv4 is not enabled. Please check your network configuration."
    exit 1
fi

# Check if ports are listening
check_port() {
    if ss -tuln | grep ":$1" &>/dev/null; then
        echo "Port $1 is listening."
    else
        echo "Port $1 is not listening."
    fi
}

check_port 9944
check_port 9933
check_port 30333

echo "Firewall status:"
ufw status verbose

echo "Network checks completed."
