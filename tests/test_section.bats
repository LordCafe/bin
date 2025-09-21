#!/usr/bin/env bats

load helpers/test_helper

setup() {
    setup_test_env
    # Crear datos de prueba con secciones
    create_test_section "docker" "20241205120001" "
# Docker Guide

## Installation
Steps to install Docker:

\`\`\`bash
sudo apt install docker.io
\`\`\`

## Configuration
Docker configuration:

### Basic Config
Basic setup instructions.

### Advanced Config
Advanced configuration options.

## Usage
How to use Docker:

\`\`\`bash
docker run hello-world
\`\`\`
"
}

teardown() {
    teardown_test_env
}

@test "kb section finds simple section" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section docker:installation
    assert_success
    assert_contains "Sección encontrada"
    assert_contains "## Installation"
    assert_contains "sudo apt install docker.io"
}

@test "kb section finds nested section" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section docker:configuration/basic
    assert_success
    assert_contains "Sección encontrada"
    assert_contains "### Basic Config"
    assert_contains "Basic setup instructions"
}

@test "kb section global search works" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section installation
    assert_success
    assert_contains "Sección encontrada"
    assert_contains "## Installation"
}

@test "kb section fails with non-existent section" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section docker:non-existent
    assert_failure
    assert_contains "No se encontró la sección 'non-existent'"
}

@test "kb section fails with non-existent file" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section nonexistent:section
    assert_failure
    assert_contains "Archivo 'nonexistent.md' no encontrado"
}

@test "kb section handles empty input" {
    export CHEAT_SHEETS_DIR="$TEST_DIR/cheat-sheets"
    run $CHEAT_COMMANDS_DIR/section
    assert_failure
    assert_contains "Uso:"
}