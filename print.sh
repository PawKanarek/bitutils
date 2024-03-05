#!/bin/bash

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