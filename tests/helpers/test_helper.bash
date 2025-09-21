#!/bin/bash

# Test helper functions for KB Terminal

# Setup test environment
setup_test_env() {
    export TEST_DIR=$(mktemp -d)
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    export CHEAT_COMMANDS_DIR="$HOME/bin/Cheat-sheet"
    mkdir -p "$CHEAT_SHEETS_DIR"
    
    # Create temporary .env file for tests
    export TEST_ENV_FILE="$TEST_DIR/.env"
    echo "CHEAT_SHEETS_DIR=$CHEAT_SHEETS_DIR" > "$TEST_ENV_FILE"
}

# Cleanup test environment
teardown_test_env() {
    [[ -n "$TEST_DIR" ]] && rm -rf "$TEST_DIR"
}

# Create test data
create_test_entry() {
    local file="$1"
    local id="$2"
    local alias="$3"
    local content="$4"
    local date="${5:-2024-12-05 12:00}"
    
    cat >> "$CHEAT_SHEETS_DIR/$file.md" << EOF
<!-- cheat:start -->
id: $id
note: $alias
$content
date: $date
<!-- cheat:end -->

EOF
}

# Create test section data
create_test_section() {
    local file="$1"
    local id="$2"
    local content="$3"
    local date="${4:-2024-12-05 12:00}"
    
    cat >> "$CHEAT_SHEETS_DIR/$file.md" << EOF
<!-- cheat:start -->
id: $id
note: @$file-guide

$content
date: $date
<!-- cheat:end -->

EOF
}

# Assert functions
assert_success() {
    [[ "$status" -eq 0 ]] || {
        echo "Expected success but got status: $status"
        echo "Output: $output"
        return 1
    }
}

assert_failure() {
    [[ "$status" -ne 0 ]] || {
        echo "Expected failure but got success"
        echo "Output: $output"
        return 1
    }
}

assert_contains() {
    local expected="$1"
    [[ "$output" == *"$expected"* ]] || {
        echo "Expected output to contain: '$expected'"
        echo "Actual output: '$output'"
        return 1
    }
}

assert_not_contains() {
    local unexpected="$1"
    [[ "$output" != *"$unexpected"* ]] || {
        echo "Expected output to NOT contain: '$unexpected'"
        echo "Actual output: '$output'"
        return 1
    }
}

assert_line_count() {
    local expected="$1"
    local actual=$(echo "$output" | wc -l)
    [[ "$actual" -eq "$expected" ]] || {
        echo "Expected $expected lines but got $actual"
        echo "Output: '$output'"
        return 1
    }
}