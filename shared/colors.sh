#!/bin/bash
# Shared colors for Docker scripts

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}Error:${NC} $*" >&2
}

success() {
    echo -e "${GREEN}$*${NC}"
}

info() {
    echo -e "${BLUE}$*${NC}"
}

warning() {
    echo -e "${YELLOW}$*${NC}"
}