#!/bin/bash

# Test runner for KB Terminal

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}KB Terminal - Test Suite${NC}"
echo "=========================="
echo

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: BATS is not installed${NC}"
    echo "Install with: sudo apt install bats"
    echo "Or: brew install bats-core"
    exit 1
fi

# Set test directory
TEST_DIR="$(dirname "$0")"
cd "$TEST_DIR"

# Run tests
echo -e "${YELLOW}Running tests...${NC}"
echo

FAILED=0

for test_file in test_*.bats; do
    if [[ -f "$test_file" ]]; then
        echo -e "${BLUE}Running $test_file${NC}"
        if bats "$test_file"; then
            echo -e "${GREEN}✓ $test_file passed${NC}"
        else
            echo -e "${RED}✗ $test_file failed${NC}"
            FAILED=1
        fi
        echo
    fi
done

# Summary
echo "=========================="
if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed! ❌${NC}"
    exit 1
fi