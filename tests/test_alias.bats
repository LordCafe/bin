#!/usr/bin/env bats

load helpers/test_helper

setup() {
    setup_test_env
    # Crear datos de prueba
    create_test_entry "test" "20241205120001" "@test-alias" "This is a test entry"
    create_test_entry "docker" "20241205120002" "@docker-setup" "Docker installation steps"
    create_test_entry "docker" "20241205120003" "@docker-config" "Docker configuration"
}

teardown() {
    teardown_test_env
}

@test "kb alias finds exact match" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias test-alias
    assert_success
    assert_contains "Encontrado con alias '@test-alias'"
    assert_contains "This is a test entry"
}

@test "kb alias shows partial matches when no exact match" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias docker
    assert_success
    assert_contains "No se encontró alias exacto '@docker'"
    assert_contains "Aliases que contienen 'docker'"
    assert_contains "@docker-setup"
    assert_contains "@docker-config"
}

@test "kb alias with file namespace works" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias docker:docker-setup
    assert_success
    assert_contains "Encontrado con alias '@docker-setup'"
    assert_contains "Docker installation steps"
}

@test "kb alias fails with non-existent alias" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias non-existent
    assert_failure
    assert_contains "No se encontró"
}

@test "kb alias with suggestions flag shows suggestions" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias -s non-existent
    assert_failure
    assert_contains "¿Quisiste decir"
}

@test "kb alias handles empty input" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/alias
    assert_failure
    assert_contains "Uso:"
}