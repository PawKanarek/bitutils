#!/bin/bash

# This is a simple script to verify network requirements for Subtensor.

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

# Check if port 9944 is listening on localhost only
if netstat -tuln | grep "127.0.0.1:9944" &>/dev/null; then
    echo "Port 9944 is listening on localhost."
else
    echo "Port 9944 is not listening on localhost or is not active."
fi

# Make sure port 9944 is firewalled off from the public domain
if sudo ufw status | grep "9944" | grep -w "REJECT" &>/dev/null; then
    echo "Port 9944 is firewalled from the public domain."
else
    echo "Port 9944 may be exposed to the public domain. Please check your firewall settings."
fi

# Check if port 9933 is open
if netstat -tuln | grep ":9933" &>/dev/null; then
    echo "Port 9933 is open."
else
    echo "Port 9933 is not open. Please check your network configuration."
fi

# Check if port 30333 accepts incoming connections
# This cannot be reliably automated as it depends on external nodes trying to connect.
# Instead, we only check if the port is listening.
if netstat -tuln | grep ":30333" &>/dev/null; then
    echo "Port 30333 is listening for incoming connections."
else
    echo "Port 30333 is not open for incoming connections. Please check your network configuration."
fi

# Verify outbound traffic to port 30333 is allowed
# This check assumes that the UFW (Uncomplicated Firewall) is used and the default policy is to ACCEPT.
# If a different firewall is used, this check must be adjusted accordingly.
if sudo ufw status verbose | grep "Anywhere" | grep "30333" | grep -wv "DENY" &>/dev/null; then
    echo "Outbound traffic to port 30333 is allowed."
else
    echo "Outbound traffic to port 30333 might be blocked. Please check your firewall settings."
fi

echo "Network checks completed."