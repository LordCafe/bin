#!/usr/bin/env bats

load helpers/test_helper

setup() {
    setup_test_env
    create_test_entry "test" "20241205120001" "@test-entry" "Test content line 1\nTest content line 2"
    create_test_entry "test" "20241205120002" "@another-test" "Another test entry"
}

teardown() {
    teardown_test_env
}

@test "kb show displays entry by full ID" {
    # Temporarily replace HOME/.env with test .env
    if [[ -f "$HOME/bin/.env" ]]; then
        mv "$HOME/bin/.env" "$HOME/bin/.env.backup"
    fi
    cp "$TEST_ENV_FILE" "$HOME/bin/.env"
    
    run $CHEAT_COMMANDS_DIR/show 20241205120001
    
    # Restore original .env
    rm "$HOME/bin/.env"
    if [[ -f "$HOME/bin/.env.backup" ]]; then
        mv "$HOME/bin/.env.backup" "$HOME/bin/.env"
    fi
    
    assert_success
    assert_contains "test • 12:00 • #120001"
    assert_contains "Test content line 1"
}

@test "kb show displays entry by short ID" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/show 120001
    assert_success
    assert_contains "test • 12:00 • #120001"
    assert_contains "Test content line 1"
}

@test "kb show displays recent entries from file" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/show test
    assert_success
    assert_contains "Mostrando las últimas"
    assert_contains "@test-entry"
    assert_contains "@another-test"
}

@test "kb show displays specific number of entries" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/show test 1
    assert_success
    assert_contains "Mostrando las últimas 1"
    assert_contains "@another-test"
    assert_not_contains "@test-entry"
}

@test "kb show fails with non-existent ID" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/show 999999
    assert_failure
    assert_contains "Nota con ID 999999 no encontrada"
}

@test "kb show handles empty input" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/show
    assert_failure
    assert_contains "Uso:"
}